from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import filters
from django.utils import timezone
from .models import Booking, CheckInRecord
from .serializers import BookingSerializer, BookingListSerializer, CheckInRecordSerializer, CheckInRecordDetailSerializer

class BookingViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['status', 'room', 'check_in_date']
    search_fields = ['room__room_number', 'contact_name', 'contact_phone']
    ordering_fields = ['check_in_date', 'created_at']
    ordering = ['-created_at']

    def get_queryset(self):
        user = self.request.user
        if user.is_admin:
            return Booking.objects.all()
        return Booking.objects.filter(user=user)

    def get_serializer_class(self):
        if self.action == 'list':
            return BookingListSerializer
        return BookingSerializer

    @action(detail=True, methods=['post'])
    def confirm(self, request, pk=None):
        booking = self.get_object()
        if booking.status != Booking.Status.PENDING:
            return Response({'error': '只能确认待确认的预订'}, status=400)
        booking.status = Booking.Status.CONFIRMED
        booking.save()
        return Response({'message': '预订已确认'})

    @action(detail=True, methods=['post'])
    def check_in(self, request, pk=None):
        booking = self.get_object()
        if booking.status != Booking.Status.CONFIRMED:
            return Response({'error': '只能办理已确认的预订入住'}, status=400)
        
        booking.status = Booking.Status.CHECKED_IN
        booking.room.status = booking.room.Status.OCCUPIED
        booking.room.save()
        booking.save()
        
        CheckInRecord.objects.create(booking=booking)
        return Response({'message': '入住成功'})

    @action(detail=True, methods=['post'])
    def check_out(self, request, pk=None):
        booking = self.get_object()
        if booking.status != Booking.Status.CHECKED_IN:
            return Response({'error': '只能办理已入住的预订退房'}, status=400)
        
        booking.status = Booking.Status.CHECKED_OUT
        booking.room.status = booking.room.Status.CLEANING
        booking.room.save()
        booking.save()
        
        record = booking.checkin_record
        record.actual_check_out = timezone.now()
        record.save()
        
        return Response({'message': '退房成功'})

    @action(detail=True, methods=['post'])
    def cancel(self, request, pk=None):
        booking = self.get_object()
        if booking.status not in [Booking.Status.PENDING, Booking.Status.CONFIRMED]:
            return Response({'error': '只能取消待确认或已确认的预订'}, status=400)
        booking.status = Booking.Status.CANCELLED
        booking.save()
        return Response({'message': '预订已取消'})

class CheckInRecordViewSet(viewsets.ModelViewSet):
    queryset = CheckInRecord.objects.all()
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ['deposit_returned']
    search_fields = ['booking__user__username', 'booking__room__room_number']

    def get_serializer_class(self):
        if self.action == 'retrieve':
            return CheckInRecordDetailSerializer
        return CheckInRecordSerializer

    @action(detail=True, methods=['post'])
    def return_deposit(self, request, pk=None):
        record = self.get_object()
        record.deposit_returned = True
        record.save()
        return Response({'message': '押金已退还'})

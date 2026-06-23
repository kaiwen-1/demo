from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.utils import timezone
from django.db import transaction
from .models import Payment
from .serializers import PaymentSerializer, PaymentCreateSerializer
from apps.bookings.models import Booking


class PaymentViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        user = self.request.user
        if user.is_admin:
            return Payment.objects.all()
        return Payment.objects.filter(user=user)
    
    def get_serializer_class(self):
        if self.action == 'create':
            return PaymentCreateSerializer
        return PaymentSerializer
    
    @transaction.atomic
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        booking = serializer.validated_data['booking']
        payment_method = serializer.validated_data.get('payment_method', Payment.PaymentMethod.ALIPAY)
        
        if booking.user != request.user:
            return Response({'error': '无权操作此预订'}, status=status.HTTP_403_FORBIDDEN)
        
        payment = Payment.objects.create(
            booking=booking,
            user=request.user,
            amount=booking.total_price,
            payment_method=payment_method
        )
        
        return Response(PaymentSerializer(payment).data, status=status.HTTP_201_CREATED)
    
    @action(detail=True, methods=['post'])
    def pay(self, request, pk=None):
        payment = self.get_object()
        
        if payment.status != Payment.Status.PENDING:
            return Response({'error': '该支付订单已处理'}, status=status.HTTP_400_BAD_REQUEST)
        
        if payment.user != request.user:
            return Response({'error': '无权操作此支付'}, status=status.HTTP_403_FORBIDDEN)
        
        with transaction.atomic():
            payment.status = Payment.Status.SUCCESS
            payment.transaction_id = f"TXN{timezone.now().strftime('%Y%m%d%H%M%S')}{payment.id}"
            payment.paid_at = timezone.now()
            payment.save()
            
            booking = payment.booking
            booking.status = Booking.Status.CONFIRMED
            booking.save()
        
        return Response({
            'message': '支付成功',
            'payment': PaymentSerializer(payment).data
        })
    
    @action(detail=True, methods=['post'])
    def cancel(self, request, pk=None):
        payment = self.get_object()
        
        if payment.status != Payment.Status.PENDING:
            return Response({'error': '只能取消待支付的订单'}, status=status.HTTP_400_BAD_REQUEST)
        
        if payment.user != request.user:
            return Response({'error': '无权操作此支付'}, status=status.HTTP_403_FORBIDDEN)
        
        payment.status = Payment.Status.FAILED
        payment.save()
        
        booking = payment.booking
        booking.status = Booking.Status.CANCELLED
        booking.save()
        
        return Response({'message': '支付已取消'})
    
    @action(detail=True, methods=['post'])
    def refund(self, request, pk=None):
        payment = self.get_object()
        
        if payment.status != Payment.Status.SUCCESS:
            return Response({'error': '只能退款已支付的订单'}, status=status.HTTP_400_BAD_REQUEST)
        
        if not request.user.is_admin:
            return Response({'error': '无权操作'}, status=status.HTTP_403_FORBIDDEN)
        
        with transaction.atomic():
            payment.status = Payment.Status.REFUNDED
            payment.save()
            
            booking = payment.booking
            if booking.status in [Booking.Status.CONFIRMED, Booking.Status.PENDING]:
                booking.status = Booking.Status.CANCELLED
                booking.save()
        
        return Response({'message': '退款成功'})

from rest_framework import viewsets, filters
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser, JSONParser
from django_filters.rest_framework import DjangoFilterBackend
from .models import RoomType, Room
from .serializers import RoomTypeSerializer, RoomSerializer, RoomListSerializer, RoomDetailSerializer

class RoomTypeViewSet(viewsets.ModelViewSet):
    queryset = RoomType.objects.filter(is_active=True)
    serializer_class = RoomTypeSerializer
    parser_classes = [MultiPartParser, FormParser, JSONParser]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    search_fields = ['name', 'description']
    
    def perform_destroy(self, instance):
        instance.is_active = False
        instance.save()

class RoomViewSet(viewsets.ModelViewSet):
    queryset = Room.objects.filter(is_active=True)
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['room_type', 'status', 'floor']
    search_fields = ['room_number', 'description']
    ordering_fields = ['room_number', 'floor', 'created_at']
    ordering = ['room_number']

    def get_serializer_class(self):
        if self.action == 'list':
            return RoomListSerializer
        elif self.action == 'retrieve':
            return RoomDetailSerializer
        return RoomSerializer

    @action(detail=False)
    def available(self, request):
        available_rooms = self.queryset.filter(status=Room.Status.AVAILABLE)
        serializer = self.get_serializer(available_rooms, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=['post'])
    def change_status(self, request, pk=None):
        room = self.get_object()
        new_status = request.data.get('status')
        if new_status not in dict(Room.Status.choices):
            return Response({'error': '无效的状态'}, status=400)
        room.status = new_status
        room.save()
        return Response({'message': '状态更新成功', 'status': room.status})

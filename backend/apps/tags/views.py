from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from django.shortcuts import get_object_or_404
from .models import Tag, RoomTypeTag
from .serializers import TagSerializer, RoomTypeTagSerializer, BatchTagSerializer


class TagViewSet(viewsets.ModelViewSet):
    queryset = Tag.objects.all()
    serializer_class = TagSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['is_active']
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        queryset = Tag.objects.all()
        if not self.request.user.is_admin:
            queryset = queryset.filter(is_active=True)
        return queryset

    @action(detail=True, methods=['get'])
    def room_types(self, request, pk=None):
        tag = self.get_object()
        room_type_tags = RoomTypeTag.objects.filter(tag=tag).select_related('room_type')
        serializer = RoomTypeTagSerializer(room_type_tags, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['post'])
    def batch_assign(self, request):
        serializer = BatchTagSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        room_type_id = serializer.validated_data['room_type_id']
        tag_ids = serializer.validated_data['tag_ids']
        
        RoomTypeTag.objects.filter(room_type_id=room_type_id).delete()
        
        room_type_tags = [
            RoomTypeTag(room_type_id=room_type_id, tag_id=tag_id)
            for tag_id in tag_ids
        ]
        RoomTypeTag.objects.bulk_create(room_type_tags)
        
        return Response({'message': '标签分配成功'})


class RoomTypeTagViewSet(viewsets.ModelViewSet):
    queryset = RoomTypeTag.objects.all()
    serializer_class = RoomTypeTagSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['room_type', 'tag']
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        queryset = RoomTypeTag.objects.all().select_related('room_type', 'tag')
        room_type_id = self.request.query_params.get('room_type_id')
        if room_type_id:
            queryset = queryset.filter(room_type_id=room_type_id)
        return queryset

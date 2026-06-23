from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from .models import Favorite
from .serializers import FavoriteSerializer


class FavoriteViewSet(viewsets.ModelViewSet):
    queryset = Favorite.objects.all()
    serializer_class = FavoriteSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['room_type']

    def get_queryset(self):
        return Favorite.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    @action(detail=False, methods=['post'])
    def toggle(self, request):
        room_type_id = request.data.get('room_type')
        if not room_type_id:
            return Response({'error': '缺少room_type参数'}, status=status.HTTP_400_BAD_REQUEST)
        
        favorite = Favorite.objects.filter(user=request.user, room_type_id=room_type_id).first()
        if favorite:
            favorite.delete()
            return Response({'status': 'removed', 'message': '已取消收藏'})
        else:
            favorite = Favorite.objects.create(user=request.user, room_type_id=room_type_id)
            serializer = self.get_serializer(favorite)
            return Response({'status': 'added', 'message': '已添加收藏', 'data': serializer.data})

    @action(detail=False, methods=['get'])
    def check(self, request):
        room_type_id = request.query_params.get('room_type')
        if not room_type_id:
            return Response({'error': '缺少room_type参数'}, status=status.HTTP_400_BAD_REQUEST)
        
        is_favorited = Favorite.objects.filter(user=request.user, room_type_id=room_type_id).exists()
        return Response({'is_favorited': is_favorited})

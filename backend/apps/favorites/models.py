from django.db import models
from django.conf import settings
from apps.rooms.models import RoomType


class Favorite(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='favorites', verbose_name='用户')
    room_type = models.ForeignKey(RoomType, on_delete=models.CASCADE, related_name='favorites', verbose_name='房型')
    created_at = models.DateTimeField('收藏时间', auto_now_add=True)

    class Meta:
        db_table = 'favorites'
        verbose_name = '收藏'
        verbose_name_plural = verbose_name
        ordering = ['-created_at']
        unique_together = ['user', 'room_type']

    def __str__(self):
        return f'{self.user.username} - {self.room_type.name}'

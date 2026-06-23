from django.db import models
from django.conf import settings
from apps.rooms.models import RoomType

class Review(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='reviews', verbose_name='用户')
    room_type = models.ForeignKey(RoomType, on_delete=models.CASCADE, related_name='reviews', verbose_name='房型')
    rating = models.PositiveIntegerField('评分', choices=[(i, f'{i}星') for i in range(1, 6)])
    title = models.CharField('标题', max_length=100)
    content = models.TextField('评论内容')
    images = models.JSONField('评论图片', default=list)
    is_visible = models.BooleanField('是否显示', default=True)
    created_at = models.DateTimeField('创建时间', auto_now_add=True)
    updated_at = models.DateTimeField('更新时间', auto_now=True)

    class Meta:
        db_table = 'reviews'
        verbose_name = '评论'
        verbose_name_plural = verbose_name
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.user.username} - {self.room_type.name} - {self.rating}星'

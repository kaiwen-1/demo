from django.db import models
from apps.rooms.models import RoomType


class Tag(models.Model):
    name = models.CharField('标签名称', max_length=50, unique=True)
    color = models.CharField('标签颜色', max_length=20, default='#409EFF')
    description = models.TextField('标签描述', blank=True)
    sort_order = models.PositiveIntegerField('排序', default=0)
    is_active = models.BooleanField('是否启用', default=True)
    created_at = models.DateTimeField('创建时间', auto_now_add=True)
    updated_at = models.DateTimeField('更新时间', auto_now=True)

    class Meta:
        db_table = 'tags'
        verbose_name = '标签'
        verbose_name_plural = verbose_name
        ordering = ['sort_order', '-created_at']

    def __str__(self):
        return self.name


class RoomTypeTag(models.Model):
    room_type = models.ForeignKey(RoomType, on_delete=models.CASCADE, related_name='room_tags', verbose_name='房型')
    tag = models.ForeignKey(Tag, on_delete=models.CASCADE, related_name='room_type_tags', verbose_name='标签')
    created_at = models.DateTimeField('创建时间', auto_now_add=True)

    class Meta:
        db_table = 'room_type_tags'
        verbose_name = '房型标签'
        verbose_name_plural = verbose_name
        unique_together = ['room_type', 'tag']

    def __str__(self):
        return f'{self.room_type.name} - {self.tag.name}'

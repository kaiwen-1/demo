from django.db import models

class RoomType(models.Model):
    name = models.CharField('房型名称', max_length=50)
    description = models.TextField('房型描述', blank=True)
    price = models.DecimalField('价格', max_digits=10, decimal_places=2)
    capacity = models.PositiveIntegerField('容纳人数', default=2)
    size = models.PositiveIntegerField('房间面积(平方米)', default=30)
    amenities = models.JSONField('设施', default=list, help_text='如WiFi、空调、电视等')
    image = models.ImageField('房型图片', upload_to='room_types/', blank=True, null=True)
    is_active = models.BooleanField('是否启用', default=True)
    created_at = models.DateTimeField('创建时间', auto_now_add=True)
    updated_at = models.DateTimeField('更新时间', auto_now=True)

    class Meta:
        db_table = 'room_types'
        verbose_name = '房型'
        verbose_name_plural = verbose_name
        ordering = ['price']

    def __str__(self):
        return self.name

class Room(models.Model):
    class Status(models.TextChoices):
        AVAILABLE = 'available', '空闲'
        OCCUPIED = 'occupied', '已入住'
        MAINTENANCE = 'maintenance', '维护中'
        CLEANING = 'cleaning', '清洁中'

    room_number = models.CharField('房间号', max_length=20, unique=True)
    floor = models.PositiveIntegerField('楼层')
    room_type = models.ForeignKey(RoomType, on_delete=models.CASCADE, related_name='rooms', verbose_name='房型')
    status = models.CharField('状态', max_length=20, choices=Status.choices, default=Status.AVAILABLE)
    description = models.TextField('房间描述', blank=True)
    images = models.JSONField('房间图片', default=list)
    is_active = models.BooleanField('是否启用', default=True)
    created_at = models.DateTimeField('创建时间', auto_now_add=True)
    updated_at = models.DateTimeField('更新时间', auto_now=True)

    class Meta:
        db_table = 'rooms'
        verbose_name = '房间'
        verbose_name_plural = verbose_name
        ordering = ['room_number']

    def __str__(self):
        return f'{self.room_number} - {self.room_type.name}'

    @property
    def is_available(self):
        return self.status == self.Status.AVAILABLE and self.is_active

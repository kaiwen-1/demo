from django.db import models
from django.conf import settings
from apps.rooms.models import Room

class Booking(models.Model):
    class Status(models.TextChoices):
        PENDING = 'pending', '待确认'
        CONFIRMED = 'confirmed', '已确认'
        CHECKED_IN = 'checked_in', '已入住'
        CHECKED_OUT = 'checked_out', '已退房'
        CANCELLED = 'cancelled', '已取消'

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='bookings', verbose_name='用户')
    room = models.ForeignKey(Room, on_delete=models.CASCADE, related_name='bookings', verbose_name='房间')
    check_in_date = models.DateField('入住日期')
    check_out_date = models.DateField('退房日期')
    guests = models.PositiveIntegerField('入住人数', default=1)
    total_price = models.DecimalField('总价', max_digits=10, decimal_places=2)
    status = models.CharField('状态', max_length=20, choices=Status.choices, default=Status.PENDING)
    special_requests = models.TextField('特殊要求', blank=True)
    contact_name = models.CharField('联系人姓名', max_length=50)
    contact_phone = models.CharField('联系电话', max_length=20)
    created_at = models.DateTimeField('创建时间', auto_now_add=True)
    updated_at = models.DateTimeField('更新时间', auto_now=True)

    class Meta:
        db_table = 'bookings'
        verbose_name = '预订'
        verbose_name_plural = verbose_name
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.user.username} - {self.room.room_number} - {self.check_in_date}'

    @property
    def nights(self):
        return (self.check_out_date - self.check_in_date).days

class CheckInRecord(models.Model):
    booking = models.OneToOneField(Booking, on_delete=models.CASCADE, related_name='checkin_record', verbose_name='预订')
    actual_check_in = models.DateTimeField('实际入住时间', auto_now_add=True)
    actual_check_out = models.DateTimeField('实际退房时间', null=True, blank=True)
    id_card_image = models.ImageField('身份证照片', upload_to='id_cards/', blank=True, null=True)
    deposit = models.DecimalField('押金', max_digits=10, decimal_places=2, default=0)
    deposit_returned = models.BooleanField('押金已退', default=False)
    notes = models.TextField('备注', blank=True)
    created_at = models.DateTimeField('创建时间', auto_now_add=True)

    class Meta:
        db_table = 'checkin_records'
        verbose_name = '入住记录'
        verbose_name_plural = verbose_name
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.booking.user.username} - {self.booking.room.room_number}'

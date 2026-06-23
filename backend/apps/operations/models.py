from django.db import models
from django.conf import settings
from apps.rooms.models import RoomType


class Banner(models.Model):
    title = models.CharField('标题', max_length=100)
    subtitle = models.CharField('副标题', max_length=200, blank=True)
    image = models.ImageField('图片', upload_to='banners/')
    link = models.CharField('链接', max_length=500, blank=True)
    sort_order = models.PositiveIntegerField('排序', default=0)
    is_active = models.BooleanField('是否启用', default=True)
    start_time = models.DateTimeField('开始时间', null=True, blank=True)
    end_time = models.DateTimeField('结束时间', null=True, blank=True)
    created_at = models.DateTimeField('创建时间', auto_now_add=True)
    updated_at = models.DateTimeField('更新时间', auto_now=True)

    class Meta:
        db_table = 'banners'
        verbose_name = '轮播图'
        verbose_name_plural = verbose_name
        ordering = ['sort_order', '-created_at']

    def __str__(self):
        return self.title


class Promotion(models.Model):
    class Status(models.TextChoices):
        DRAFT = 'draft', '草稿'
        ACTIVE = 'active', '进行中'
        PAUSED = 'paused', '已暂停'
        ENDED = 'ended', '已结束'

    title = models.CharField('活动标题', max_length=200)
    description = models.TextField('活动描述', blank=True)
    image = models.ImageField('活动图片', upload_to='promotions/', blank=True, null=True)
    discount_type = models.CharField('优惠类型', max_length=20, choices=[('percentage', '百分比折扣'), ('fixed', '固定金额'), ('special', '特价')], default='percentage')
    discount_value = models.DecimalField('优惠值', max_digits=10, decimal_places=2, help_text='百分比折扣填0-100，固定金额填具体金额')
    room_types = models.ManyToManyField(RoomType, blank=True, verbose_name='适用房型')
    start_time = models.DateTimeField('开始时间')
    end_time = models.DateTimeField('结束时间')
    status = models.CharField('状态', max_length=20, choices=Status.choices, default=Status.DRAFT)
    sort_order = models.PositiveIntegerField('排序', default=0)
    created_at = models.DateTimeField('创建时间', auto_now_add=True)
    updated_at = models.DateTimeField('更新时间', auto_now=True)

    class Meta:
        db_table = 'promotions'
        verbose_name = '促销活动'
        verbose_name_plural = verbose_name
        ordering = ['-sort_order', '-created_at']

    def __str__(self):
        return self.title


class Coupon(models.Model):
    class Type(models.TextChoices):
        FIXED = 'fixed', '固定金额'
        PERCENTAGE = 'percentage', '百分比折扣'

    code = models.CharField('优惠券码', max_length=50, unique=True)
    name = models.CharField('优惠券名称', max_length=100)
    coupon_type = models.CharField('类型', max_length=20, choices=Type.choices, default=Type.FIXED)
    discount_value = models.DecimalField('优惠值', max_digits=10, decimal_places=2, help_text='固定金额或百分比')
    min_amount = models.DecimalField('最低消费', max_digits=10, decimal_places=2, default=0)
    max_discount = models.DecimalField('最大优惠金额', max_digits=10, decimal_places=2, null=True, blank=True, help_text='百分比折扣时有效')
    total_count = models.PositiveIntegerField('发放总数', default=100)
    used_count = models.PositiveIntegerField('已使用数量', default=0)
    per_user_limit = models.PositiveIntegerField('每人限领', default=1)
    start_time = models.DateTimeField('生效时间')
    end_time = models.DateTimeField('过期时间')
    is_active = models.BooleanField('是否启用', default=True)
    created_at = models.DateTimeField('创建时间', auto_now_add=True)
    updated_at = models.DateTimeField('更新时间', auto_now=True)

    class Meta:
        db_table = 'coupons'
        verbose_name = '优惠券'
        verbose_name_plural = verbose_name
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.name} ({self.code})'

    @property
    def remaining_count(self):
        return self.total_count - self.used_count


class UserCoupon(models.Model):
    class Status(models.TextChoices):
        UNUSED = 'unused', '未使用'
        USED = 'used', '已使用'
        EXPIRED = 'expired', '已过期'

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='coupons', verbose_name='用户')
    coupon = models.ForeignKey(Coupon, on_delete=models.CASCADE, related_name='user_coupons', verbose_name='优惠券')
    status = models.CharField('状态', max_length=20, choices=Status.choices, default=Status.UNUSED)
    used_at = models.DateTimeField('使用时间', null=True, blank=True)
    created_at = models.DateTimeField('领取时间', auto_now_add=True)

    class Meta:
        db_table = 'user_coupons'
        verbose_name = '用户优惠券'
        verbose_name_plural = verbose_name
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.user.username} - {self.coupon.name}'

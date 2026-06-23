from django.db import models
from django.conf import settings
from apps.bookings.models import Booking
import uuid


def generate_payment_no():
    return f"PAY{uuid.uuid4().hex[:16].upper()}"


class Payment(models.Model):
    class Status(models.TextChoices):
        PENDING = 'pending', '待支付'
        SUCCESS = 'success', '支付成功'
        FAILED = 'failed', '支付失败'
        REFUNDED = 'refunded', '已退款'

    class PaymentMethod(models.TextChoices):
        ALIPAY = 'alipay', '支付宝'
        WECHAT = 'wechat', '微信支付'
        BANK_CARD = 'bank_card', '银行卡'

    payment_no = models.CharField('支付单号', max_length=64, unique=True, default=generate_payment_no, editable=False)
    booking = models.OneToOneField(Booking, on_delete=models.CASCADE, related_name='payment', verbose_name='预订')
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='payments', verbose_name='用户')
    amount = models.DecimalField('支付金额', max_digits=10, decimal_places=2)
    payment_method = models.CharField('支付方式', max_length=20, choices=PaymentMethod.choices, default=PaymentMethod.ALIPAY)
    status = models.CharField('支付状态', max_length=20, choices=Status.choices, default=Status.PENDING)
    transaction_id = models.CharField('第三方交易号', max_length=100, blank=True)
    paid_at = models.DateTimeField('支付时间', null=True, blank=True)
    created_at = models.DateTimeField('创建时间', auto_now_add=True)
    updated_at = models.DateTimeField('更新时间', auto_now=True)

    class Meta:
        db_table = 'payments'
        verbose_name = '支付记录'
        verbose_name_plural = verbose_name
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.payment_no} - {self.amount}元 - {self.get_status_display()}'

from django.db import models
from django.conf import settings


class Notification(models.Model):
    class Type(models.TextChoices):
        SYSTEM = 'system', '系统通知'
        BOOKING = 'booking', '预订通知'
        PAYMENT = 'payment', '支付通知'
        PROMOTION = 'promotion', '促销通知'
        OTHER = 'other', '其他'

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='notifications', verbose_name='用户')
    title = models.CharField('标题', max_length=200)
    content = models.TextField('内容')
    notification_type = models.CharField('类型', max_length=20, choices=Type.choices, default=Type.SYSTEM)
    is_read = models.BooleanField('是否已读', default=False)
    link = models.CharField('链接', max_length=500, blank=True)
    created_at = models.DateTimeField('创建时间', auto_now_add=True)

    class Meta:
        db_table = 'notifications'
        verbose_name = '消息通知'
        verbose_name_plural = verbose_name
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.user.username} - {self.title}'

    @classmethod
    def create_notification(cls, user, title, content, notification_type='system', link=''):
        return cls.objects.create(
            user=user,
            title=title,
            content=content,
            notification_type=notification_type,
            link=link
        )

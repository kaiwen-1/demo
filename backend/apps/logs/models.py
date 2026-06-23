from django.db import models
from django.conf import settings


class OperationLog(models.Model):
    class Action(models.TextChoices):
        CREATE = 'create', '创建'
        UPDATE = 'update', '更新'
        DELETE = 'delete', '删除'
        LOGIN = 'login', '登录'
        LOGOUT = 'logout', '登出'
        OTHER = 'other', '其他'

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True, related_name='operation_logs', verbose_name='操作用户')
    action = models.CharField('操作类型', max_length=20, choices=Action.choices, default=Action.OTHER)
    model_name = models.CharField('模型名称', max_length=100)
    object_id = models.CharField('对象ID', max_length=100, blank=True)
    object_repr = models.CharField('对象描述', max_length=200, blank=True)
    detail = models.TextField('操作详情', blank=True)
    ip_address = models.GenericIPAddressField('IP地址', null=True, blank=True)
    user_agent = models.CharField('用户代理', max_length=500, blank=True)
    created_at = models.DateTimeField('操作时间', auto_now_add=True)

    class Meta:
        db_table = 'operation_logs'
        verbose_name = '操作日志'
        verbose_name_plural = verbose_name
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.user} - {self.get_action_display()} - {self.model_name}'

    @classmethod
    def log(cls, user, action, model_name, object_id='', object_repr='', detail='', ip_address=None, user_agent=''):
        return cls.objects.create(
            user=user,
            action=action,
            model_name=model_name,
            object_id=object_id,
            object_repr=object_repr,
            detail=detail,
            ip_address=ip_address,
            user_agent=user_agent
        )


class LoginLog(models.Model):
    class Status(models.TextChoices):
        SUCCESS = 'success', '成功'
        FAILED = 'failed', '失败'

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True, related_name='login_logs', verbose_name='用户')
    username = models.CharField('用户名', max_length=150)
    status = models.CharField('状态', max_length=20, choices=Status.choices, default=Status.SUCCESS)
    ip_address = models.GenericIPAddressField('IP地址', null=True, blank=True)
    user_agent = models.CharField('用户代理', max_length=500, blank=True)
    message = models.TextField('消息', blank=True)
    created_at = models.DateTimeField('登录时间', auto_now_add=True)

    class Meta:
        db_table = 'login_logs'
        verbose_name = '登录日志'
        verbose_name_plural = verbose_name
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.username} - {self.get_status_display()} - {self.created_at}'

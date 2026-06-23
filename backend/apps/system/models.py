from django.db import models


class SystemConfig(models.Model):
    key = models.CharField('配置键', max_length=100, unique=True)
    value = models.TextField('配置值')
    description = models.CharField('描述', max_length=200, blank=True)
    created_at = models.DateTimeField('创建时间', auto_now_add=True)
    updated_at = models.DateTimeField('更新时间', auto_now=True)

    class Meta:
        db_table = 'system_configs'
        verbose_name = '系统配置'
        verbose_name_plural = verbose_name

    def __str__(self):
        return self.key

    @classmethod
    def get_value(cls, key, default=''):
        try:
            config = cls.objects.get(key=key)
            return config.value
        except cls.DoesNotExist:
            return default

    @classmethod
    def set_value(cls, key, value, description=''):
        config, created = cls.objects.update_or_create(
            key=key,
            defaults={'value': value, 'description': description}
        )
        return config

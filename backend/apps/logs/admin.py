from django.contrib import admin
from .models import OperationLog, LoginLog


@admin.register(OperationLog)
class OperationLogAdmin(admin.ModelAdmin):
    list_display = ['id', 'user', 'action', 'model_name', 'object_repr', 'ip_address', 'created_at']
    list_filter = ['action', 'model_name', 'created_at']
    search_fields = ['user__username', 'object_repr', 'detail']
    readonly_fields = ['user', 'action', 'model_name', 'object_id', 'object_repr', 'detail', 'ip_address', 'user_agent', 'created_at']


@admin.register(LoginLog)
class LoginLogAdmin(admin.ModelAdmin):
    list_display = ['id', 'username', 'status', 'ip_address', 'created_at']
    list_filter = ['status', 'created_at']
    search_fields = ['username', 'ip_address']
    readonly_fields = ['user', 'username', 'status', 'ip_address', 'user_agent', 'message', 'created_at']

from rest_framework import serializers
from .models import OperationLog, LoginLog


class OperationLogSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username', read_only=True)
    action_display = serializers.CharField(source='get_action_display', read_only=True)
    
    class Meta:
        model = OperationLog
        fields = ['id', 'user', 'username', 'action', 'action_display', 'model_name', 'object_id', 'object_repr', 'detail', 'ip_address', 'user_agent', 'created_at']
        read_only_fields = ['id', 'created_at']


class LoginLogSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    
    class Meta:
        model = LoginLog
        fields = ['id', 'user', 'username', 'username', 'status', 'status_display', 'ip_address', 'user_agent', 'message', 'created_at']
        read_only_fields = ['id', 'created_at']

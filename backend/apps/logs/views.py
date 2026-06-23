from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from django.http import HttpResponse
import csv
from .models import OperationLog, LoginLog
from .serializers import OperationLogSerializer, LoginLogSerializer


class OperationLogViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = OperationLog.objects.all().select_related('user')
    serializer_class = OperationLogSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['user', 'action', 'model_name']
    ordering = ['-created_at']

    @action(detail=False, methods=['get'])
    def export(self, request):
        queryset = self.filter_queryset(self.get_queryset())
        
        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="operation_logs.csv"'
        
        writer = csv.writer(response)
        writer.writerow(['ID', '用户', '操作类型', '模型名称', '对象ID', '对象描述', '详情', 'IP地址', '操作时间'])
        
        for log in queryset:
            writer.writerow([
                log.id,
                log.user.username if log.user else '',
                log.get_action_display(),
                log.model_name,
                log.object_id,
                log.object_repr,
                log.detail,
                log.ip_address or '',
                log.created_at.strftime('%Y-%m-%d %H:%M:%S')
            ])
        
        return response


class LoginLogViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = LoginLog.objects.all().select_related('user')
    serializer_class = LoginLogSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['user', 'status']
    ordering = ['-created_at']

    @action(detail=False, methods=['get'])
    def export(self, request):
        queryset = self.filter_queryset(self.get_queryset())
        
        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="login_logs.csv"'
        
        writer = csv.writer(response)
        writer.writerow(['ID', '用户名', '状态', 'IP地址', '用户代理', '消息', '登录时间'])
        
        for log in queryset:
            writer.writerow([
                log.id,
                log.username,
                log.get_status_display(),
                log.ip_address or '',
                log.user_agent,
                log.message,
                log.created_at.strftime('%Y-%m-%d %H:%M:%S')
            ])
        
        return response

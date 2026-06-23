import os
import platform
import sys
import django
from datetime import datetime
from rest_framework import viewsets, status
from rest_framework.decorators import action, api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from django.conf import settings
from django.db import connection
from django.core.management import call_command
from django.db.models import Sum
from io import StringIO
from .models import SystemConfig
from .serializers import SystemConfigSerializer
from apps.rooms.models import Room, RoomType
from apps.bookings.models import Booking
from apps.payments.models import Payment
from django.contrib.auth import get_user_model

User = get_user_model()


class SystemConfigViewSet(viewsets.ModelViewSet):
    queryset = SystemConfig.objects.all()
    serializer_class = SystemConfigSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['key']
    lookup_field = 'key'

    @action(detail=False, methods=['get'])
    def get_by_key(self, request):
        key = request.query_params.get('key')
        if not key:
            return Response({'error': '缺少key参数'}, status=status.HTTP_400_BAD_REQUEST)
        
        value = SystemConfig.get_value(key)
        return Response({'key': key, 'value': value})


@api_view(['get'])
@permission_classes([IsAuthenticated])
def system_info(request):
    info = {
        'system': {
            'os': platform.system(),
            'os_version': platform.version(),
            'python_version': sys.version,
            'django_version': django.VERSION,
        },
        'database': {
            'engine': settings.DATABASES['default']['ENGINE'],
            'name': settings.DATABASES['default']['NAME'],
        },
        'time': {
            'current': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
            'timezone': settings.TIME_ZONE,
        },
        'debug': settings.DEBUG,
    }
    return Response(info)


@api_view(['get'])
@permission_classes([IsAuthenticated])
def database_status(request):
    try:
        with connection.cursor() as cursor:
            cursor.execute('SELECT 1')
        return Response({'status': 'healthy', 'message': '数据库连接正常'})
    except Exception as e:
        return Response({'status': 'error', 'message': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['post'])
@permission_classes([IsAuthenticated])
def backup_database(request):
    if not request.user.is_admin:
        return Response({'error': '权限不足'}, status=status.HTTP_403_FORBIDDEN)
    
    try:
        output = StringIO()
        call_command('dumpdata', stdout=output, indent=2)
        backup_content = output.getvalue()
        
        response = Response({
            'status': 'success',
            'message': '数据库备份成功',
            'data': backup_content,
            'timestamp': datetime.now().strftime('%Y%m%d_%H%M%S')
        })
        return response
    except Exception as e:
        return Response({'status': 'error', 'message': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['post'])
@permission_classes([IsAuthenticated])
def clear_cache(request):
    if not request.user.is_admin:
        return Response({'error': '权限不足'}, status=status.HTTP_403_FORBIDDEN)
    
    try:
        from django.core.cache import cache
        cache.clear()
        return Response({'status': 'success', 'message': '缓存已清除'})
    except Exception as e:
        return Response({'status': 'error', 'message': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['get'])
@permission_classes([IsAuthenticated])
def dashboard_stats(request):
    total_rooms = Room.objects.filter(is_active=True).count()
    total_bookings = Booking.objects.count()
    total_users = User.objects.count()
    total_revenue = Payment.objects.filter(
        status=Payment.Status.SUCCESS
    ).aggregate(total=Sum('amount'))['total'] or 0
    
    room_status = {
        'available': Room.objects.filter(is_active=True, status=Room.Status.AVAILABLE).count(),
        'occupied': Room.objects.filter(is_active=True, status=Room.Status.OCCUPIED).count(),
        'maintenance': Room.objects.filter(is_active=True, status=Room.Status.MAINTENANCE).count(),
        'cleaning': Room.objects.filter(is_active=True, status=Room.Status.CLEANING).count(),
    }
    
    recent_bookings = Booking.objects.select_related(
        'user', 'room', 'room__room_type'
    ).order_by('-created_at')[:5]
    
    bookings_data = []
    for booking in recent_bookings:
        bookings_data.append({
            'id': booking.id,
            'user': {
                'id': booking.user.id,
                'username': booking.user.username,
            },
            'room': {
                'id': booking.room.id,
                'room_number': booking.room.room_number,
                'room_type': {
                    'id': booking.room.room_type.id,
                    'name': booking.room.room_type.name,
                }
            },
            'check_in_date': booking.check_in_date,
            'check_out_date': booking.check_out_date,
            'total_price': str(booking.total_price),
            'status': booking.status,
            'created_at': booking.created_at,
        })
    
    return Response({
        'total_rooms': total_rooms,
        'total_bookings': total_bookings,
        'total_users': total_users,
        'total_revenue': str(total_revenue),
        'room_status': room_status,
        'recent_bookings': bookings_data,
    })

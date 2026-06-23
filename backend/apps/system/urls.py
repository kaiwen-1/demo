from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import SystemConfigViewSet, system_info, database_status, backup_database, clear_cache, dashboard_stats

router = DefaultRouter()
router.register(r'configs', SystemConfigViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('info/', system_info, name='system-info'),
    path('database-status/', database_status, name='database-status'),
    path('backup/', backup_database, name='backup-database'),
    path('clear-cache/', clear_cache, name='clear-cache'),
    path('dashboard-stats/', dashboard_stats, name='dashboard-stats'),
]

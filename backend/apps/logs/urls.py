from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import OperationLogViewSet, LoginLogViewSet

router = DefaultRouter()
router.register(r'operation-logs', OperationLogViewSet)
router.register(r'login-logs', LoginLogViewSet)

urlpatterns = [
    path('', include(router.urls)),
]

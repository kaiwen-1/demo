from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import BookingViewSet, CheckInRecordViewSet

router = DefaultRouter()
router.register(r'', BookingViewSet, basename='booking')
router.register(r'records', CheckInRecordViewSet, basename='checkin-record')

urlpatterns = [
    path('', include(router.urls)),
]

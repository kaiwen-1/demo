from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import TagViewSet, RoomTypeTagViewSet

router = DefaultRouter()
router.register(r'tags', TagViewSet)
router.register(r'room-type-tags', RoomTypeTagViewSet)

urlpatterns = [
    path('', include(router.urls)),
]

from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import BannerViewSet, PromotionViewSet, CouponViewSet, UserCouponViewSet

router = DefaultRouter()
router.register(r'banners', BannerViewSet)
router.register(r'promotions', PromotionViewSet)
router.register(r'coupons', CouponViewSet)
router.register(r'user-coupons', UserCouponViewSet)

urlpatterns = [
    path('', include(router.urls)),
]

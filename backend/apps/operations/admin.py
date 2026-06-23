from django.contrib import admin
from .models import Banner, Promotion, Coupon, UserCoupon


@admin.register(Banner)
class BannerAdmin(admin.ModelAdmin):
    list_display = ['id', 'title', 'sort_order', 'is_active', 'start_time', 'end_time', 'created_at']
    list_filter = ['is_active', 'created_at']
    search_fields = ['title', 'subtitle']
    list_editable = ['sort_order', 'is_active']


@admin.register(Promotion)
class PromotionAdmin(admin.ModelAdmin):
    list_display = ['id', 'title', 'discount_type', 'discount_value', 'status', 'start_time', 'end_time', 'created_at']
    list_filter = ['status', 'discount_type', 'created_at']
    search_fields = ['title', 'description']
    filter_horizontal = ['room_types']


@admin.register(Coupon)
class CouponAdmin(admin.ModelAdmin):
    list_display = ['id', 'code', 'name', 'coupon_type', 'discount_value', 'total_count', 'used_count', 'is_active', 'end_time']
    list_filter = ['coupon_type', 'is_active', 'created_at']
    search_fields = ['code', 'name']


@admin.register(UserCoupon)
class UserCouponAdmin(admin.ModelAdmin):
    list_display = ['id', 'user', 'coupon', 'status', 'used_at', 'created_at']
    list_filter = ['status', 'created_at']
    search_fields = ['user__username', 'coupon__code']
    raw_id_fields = ['user', 'coupon']

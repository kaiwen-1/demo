from rest_framework import serializers
from .models import Banner, Promotion, Coupon, UserCoupon


class BannerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Banner
        fields = ['id', 'title', 'subtitle', 'image', 'link', 'sort_order', 'is_active', 'start_time', 'end_time', 'created_at', 'updated_at']
        read_only_fields = ['id', 'created_at', 'updated_at']


class PromotionSerializer(serializers.ModelSerializer):
    room_type_names = serializers.StringRelatedField(source='room_types', many=True, read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    discount_type_display = serializers.CharField(source='get_discount_type_display', read_only=True)
    
    class Meta:
        model = Promotion
        fields = ['id', 'title', 'description', 'image', 'discount_type', 'discount_type_display', 'discount_value', 'room_types', 'room_type_names', 'start_time', 'end_time', 'status', 'status_display', 'sort_order', 'created_at', 'updated_at']
        read_only_fields = ['id', 'created_at', 'updated_at']


class CouponSerializer(serializers.ModelSerializer):
    coupon_type_display = serializers.CharField(source='get_coupon_type_display', read_only=True)
    remaining_count = serializers.SerializerMethodField()
    
    class Meta:
        model = Coupon
        fields = ['id', 'code', 'name', 'coupon_type', 'coupon_type_display', 'discount_value', 'min_amount', 'max_discount', 'total_count', 'used_count', 'remaining_count', 'per_user_limit', 'start_time', 'end_time', 'is_active', 'created_at', 'updated_at']
        read_only_fields = ['id', 'used_count', 'created_at', 'updated_at']
    
    def get_remaining_count(self, obj):
        return obj.total_count - obj.used_count


class UserCouponSerializer(serializers.ModelSerializer):
    coupon_name = serializers.CharField(source='coupon.name', read_only=True)
    coupon_code = serializers.CharField(source='coupon.code', read_only=True)
    coupon_type = serializers.CharField(source='coupon.coupon_type', read_only=True)
    discount_value = serializers.DecimalField(source='coupon.discount_value', max_digits=10, decimal_places=2, read_only=True)
    min_amount = serializers.DecimalField(source='coupon.min_amount', max_digits=10, decimal_places=2, read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    
    class Meta:
        model = UserCoupon
        fields = ['id', 'coupon', 'coupon_name', 'coupon_code', 'coupon_type', 'discount_value', 'min_amount', 'status', 'status_display', 'used_at', 'created_at']
        read_only_fields = ['id', 'status', 'used_at', 'created_at']


class ClaimCouponSerializer(serializers.Serializer):
    code = serializers.CharField(max_length=50)

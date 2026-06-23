from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from django.utils import timezone
from django.db import models
from .models import Banner, Promotion, Coupon, UserCoupon
from .serializers import BannerSerializer, PromotionSerializer, CouponSerializer, UserCouponSerializer, ClaimCouponSerializer


class BannerViewSet(viewsets.ModelViewSet):
    queryset = Banner.objects.all()
    serializer_class = BannerSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['is_active']
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        queryset = Banner.objects.all()
        if self.request.query_params.get('active_only'):
            now = timezone.now()
            queryset = queryset.filter(
                is_active=True
            ).filter(
                models.Q(start_time__isnull=True) | models.Q(start_time__lte=now)
            ).filter(
                models.Q(end_time__isnull=True) | models.Q(end_time__gte=now)
            )
        return queryset


class PromotionViewSet(viewsets.ModelViewSet):
    queryset = Promotion.objects.all()
    serializer_class = PromotionSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['status']
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        queryset = Promotion.objects.all().prefetch_related('room_types')
        if self.request.query_params.get('active_only'):
            now = timezone.now()
            queryset = queryset.filter(status='active', start_time__lte=now, end_time__gte=now)
        return queryset


class CouponViewSet(viewsets.ModelViewSet):
    queryset = Coupon.objects.all()
    serializer_class = CouponSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['is_active', 'coupon_type']
    permission_classes = [IsAuthenticated]

    @action(detail=True, methods=['post'])
    def claim(self, request, pk=None):
        coupon = self.get_object()
        
        if not coupon.is_active:
            return Response({'error': '优惠券已停用'}, status=status.HTTP_400_BAD_REQUEST)
        
        if coupon.remaining_count <= 0:
            return Response({'error': '优惠券已领完'}, status=status.HTTP_400_BAD_REQUEST)
        
        user_coupon_count = UserCoupon.objects.filter(user=request.user, coupon=coupon).count()
        if user_coupon_count >= coupon.per_user_limit:
            return Response({'error': '已达到领取上限'}, status=status.HTTP_400_BAD_REQUEST)
        
        now = timezone.now()
        if now < coupon.start_time or now > coupon.end_time:
            return Response({'error': '优惠券不在有效期内'}, status=status.HTTP_400_BAD_REQUEST)
        
        user_coupon = UserCoupon.objects.create(user=request.user, coupon=coupon)
        serializer = UserCouponSerializer(user_coupon)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    @action(detail=False, methods=['post'])
    def claim_by_code(self, request):
        serializer = ClaimCouponSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        code = serializer.validated_data['code']
        
        try:
            coupon = Coupon.objects.get(code=code)
        except Coupon.DoesNotExist:
            return Response({'error': '优惠券码不存在'}, status=status.HTTP_404_NOT_FOUND)
        
        if not coupon.is_active:
            return Response({'error': '优惠券已停用'}, status=status.HTTP_400_BAD_REQUEST)
        
        if coupon.remaining_count <= 0:
            return Response({'error': '优惠券已领完'}, status=status.HTTP_400_BAD_REQUEST)
        
        user_coupon_count = UserCoupon.objects.filter(user=request.user, coupon=coupon).count()
        if user_coupon_count >= coupon.per_user_limit:
            return Response({'error': '已达到领取上限'}, status=status.HTTP_400_BAD_REQUEST)
        
        now = timezone.now()
        if now < coupon.start_time or now > coupon.end_time:
            return Response({'error': '优惠券不在有效期内'}, status=status.HTTP_400_BAD_REQUEST)
        
        user_coupon = UserCoupon.objects.create(user=request.user, coupon=coupon)
        serializer = UserCouponSerializer(user_coupon)
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class UserCouponViewSet(viewsets.ModelViewSet):
    queryset = UserCoupon.objects.all()
    serializer_class = UserCouponSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['status']

    def get_queryset(self):
        return UserCoupon.objects.filter(user=self.request.user).select_related('coupon')

    @action(detail=False, methods=['get'])
    def available(self, request):
        now = timezone.now()
        user_coupons = UserCoupon.objects.filter(
            user=request.user,
            status='unused',
            coupon__is_active=True,
            coupon__start_time__lte=now,
            coupon__end_time__gte=now
        ).select_related('coupon')
        serializer = self.get_serializer(user_coupons, many=True)
        return Response(serializer.data)

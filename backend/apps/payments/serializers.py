from rest_framework import serializers
from .models import Payment


class PaymentSerializer(serializers.ModelSerializer):
    booking_info = serializers.SerializerMethodField()
    
    class Meta:
        model = Payment
        fields = '__all__'
        read_only_fields = ['payment_no', 'user', 'transaction_id', 'paid_at', 'created_at', 'updated_at']
    
    def get_booking_info(self, obj):
        return {
            'id': obj.booking.id,
            'room_number': obj.booking.room.room_number,
            'room_type': obj.booking.room.room_type.name,
            'check_in_date': obj.booking.check_in_date,
            'check_out_date': obj.booking.check_out_date,
        }


class PaymentCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payment
        fields = ['booking', 'payment_method']
    
    def validate_booking(self, value):
        try:
            if value.payment:
                raise serializers.ValidationError('该预订已创建支付订单')
        except Payment.DoesNotExist:
            pass
        return value

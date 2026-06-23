from rest_framework import serializers
from django.db import transaction
from .models import Booking, CheckInRecord
from apps.rooms.serializers import RoomTypeSerializer
from apps.rooms.models import Room

class UserSimpleSerializer(serializers.ModelSerializer):
    class Meta:
        from django.contrib.auth import get_user_model
        model = get_user_model()
        fields = ['id', 'username', 'email', 'phone']

class RoomSimpleSerializer(serializers.ModelSerializer):
    room_type = RoomTypeSerializer(read_only=True)
    
    class Meta:
        from apps.rooms.models import Room
        model = Room
        fields = ['id', 'room_number', 'floor', 'status', 'room_type']

class BookingSerializer(serializers.ModelSerializer):
    user = UserSimpleSerializer(read_only=True)
    room = RoomSimpleSerializer(read_only=True)
    nights = serializers.ReadOnlyField()

    class Meta:
        model = Booking
        fields = '__all__'
        read_only_fields = ['user', 'total_price', 'created_at', 'updated_at']
    
    def get_fields(self):
        fields = super().get_fields()
        if self.context.get('request') and self.context['request'].method in ['POST', 'PUT', 'PATCH']:
            fields['room'] = serializers.PrimaryKeyRelatedField(queryset=Room.objects.all())
        return fields

    def validate(self, data):
        check_out = data.get('check_out_date')
        check_in = data.get('check_in_date')
        room = data.get('room')
        
        if check_out and check_in and check_out <= check_in:
            raise serializers.ValidationError({'check_out_date': '退房日期必须晚于入住日期'})
        
        if room and check_in and check_out:
            overlapping = Booking.objects.filter(
                room=room,
                status__in=[Booking.Status.PENDING, Booking.Status.CONFIRMED, Booking.Status.CHECKED_IN],
                check_in_date__lt=check_out,
                check_out_date__gt=check_in
            ).exists()
            
            if overlapping:
                raise serializers.ValidationError({'room': '该房间在所选日期已被预订'})
        
        return data

    @transaction.atomic
    def create(self, validated_data):
        room = validated_data['room']
        nights = (validated_data['check_out_date'] - validated_data['check_in_date']).days
        validated_data['total_price'] = room.room_type.price * nights
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)

class BookingListSerializer(serializers.ModelSerializer):
    user = UserSimpleSerializer(read_only=True)
    room = RoomSimpleSerializer(read_only=True)
    nights = serializers.ReadOnlyField()
    payment = serializers.SerializerMethodField()

    class Meta:
        model = Booking
        fields = '__all__'
    
    def get_payment(self, obj):
        if hasattr(obj, 'payment'):
            return {
                'id': obj.payment.id,
                'status': obj.payment.status,
                'payment_no': obj.payment.payment_no,
            }
        return None

class CheckInRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = CheckInRecord
        fields = '__all__'
        read_only_fields = ['actual_check_in', 'created_at']

class CheckInRecordDetailSerializer(serializers.ModelSerializer):
    booking = BookingListSerializer(read_only=True)

    class Meta:
        model = CheckInRecord
        fields = '__all__'

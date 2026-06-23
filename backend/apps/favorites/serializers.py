from rest_framework import serializers
from .models import Favorite


class FavoriteSerializer(serializers.ModelSerializer):
    room_type_name = serializers.CharField(source='room_type.name', read_only=True)
    room_type_price = serializers.DecimalField(source='room_type.price', max_digits=10, decimal_places=2, read_only=True)
    room_type_image = serializers.ImageField(source='room_type.image', read_only=True)
    room_type_capacity = serializers.IntegerField(source='room_type.capacity', read_only=True)
    
    class Meta:
        model = Favorite
        fields = ['id', 'room_type', 'room_type_name', 'room_type_price', 'room_type_image', 'room_type_capacity', 'created_at']
        read_only_fields = ['id', 'created_at']

from rest_framework import serializers
from .models import RoomType, Room

class RoomTypeSerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField(read_only=True)
    
    class Meta:
        model = RoomType
        fields = '__all__'
    
    def get_image_url(self, obj):
        if obj.image:
            request = self.context.get('request')
            if request:
                return request.build_absolute_uri(obj.image.url)
            return obj.image.url
        return None

class RoomSerializer(serializers.ModelSerializer):
    room_type_name = serializers.CharField(source='room_type.name', read_only=True)
    room_type_price = serializers.DecimalField(source='room_type.price', max_digits=10, decimal_places=2, read_only=True)

    class Meta:
        model = Room
        fields = '__all__'

class RoomListSerializer(serializers.ModelSerializer):
    room_type = RoomTypeSerializer(read_only=True)

    class Meta:
        model = Room
        fields = '__all__'

class RoomDetailSerializer(serializers.ModelSerializer):
    room_type = RoomTypeSerializer(read_only=True)

    class Meta:
        model = Room
        fields = '__all__'

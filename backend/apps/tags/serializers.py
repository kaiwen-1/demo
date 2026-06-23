from rest_framework import serializers
from .models import Tag, RoomTypeTag


class TagSerializer(serializers.ModelSerializer):
    room_count = serializers.SerializerMethodField()
    
    class Meta:
        model = Tag
        fields = ['id', 'name', 'color', 'description', 'sort_order', 'is_active', 'room_count', 'created_at', 'updated_at']
        read_only_fields = ['id', 'created_at', 'updated_at']
    
    def get_room_count(self, obj):
        return obj.room_type_tags.count()


class RoomTypeTagSerializer(serializers.ModelSerializer):
    tag_name = serializers.CharField(source='tag.name', read_only=True)
    tag_color = serializers.CharField(source='tag.color', read_only=True)
    room_type_name = serializers.CharField(source='room_type.name', read_only=True)
    
    class Meta:
        model = RoomTypeTag
        fields = ['id', 'room_type', 'tag', 'tag_name', 'tag_color', 'room_type_name', 'created_at']
        read_only_fields = ['id', 'created_at']


class BatchTagSerializer(serializers.Serializer):
    room_type_id = serializers.IntegerField()
    tag_ids = serializers.ListField(child=serializers.IntegerField())

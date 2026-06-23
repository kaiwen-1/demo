from django.contrib import admin
from .models import RoomType, Room

@admin.register(RoomType)
class RoomTypeAdmin(admin.ModelAdmin):
    list_display = ['name', 'price', 'capacity', 'size', 'is_active', 'created_at']
    list_filter = ['is_active']
    search_fields = ['name']
    list_editable = ['price', 'is_active']

@admin.register(Room)
class RoomAdmin(admin.ModelAdmin):
    list_display = ['room_number', 'floor', 'room_type', 'status', 'is_active', 'created_at']
    list_filter = ['status', 'room_type', 'floor', 'is_active']
    search_fields = ['room_number']
    list_editable = ['status', 'is_active']

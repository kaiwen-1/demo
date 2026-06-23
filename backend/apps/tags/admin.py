from django.contrib import admin
from .models import Tag, RoomTypeTag


@admin.register(Tag)
class TagAdmin(admin.ModelAdmin):
    list_display = ['id', 'name', 'color', 'sort_order', 'is_active', 'created_at']
    list_filter = ['is_active', 'created_at']
    search_fields = ['name', 'description']
    list_editable = ['sort_order', 'is_active']


@admin.register(RoomTypeTag)
class RoomTypeTagAdmin(admin.ModelAdmin):
    list_display = ['id', 'room_type', 'tag', 'created_at']
    list_filter = ['created_at']
    search_fields = ['room_type__name', 'tag__name']
    raw_id_fields = ['room_type', 'tag']

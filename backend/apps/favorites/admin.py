from django.contrib import admin
from .models import Favorite


@admin.register(Favorite)
class FavoriteAdmin(admin.ModelAdmin):
    list_display = ['id', 'user', 'room_type', 'created_at']
    list_filter = ['created_at']
    search_fields = ['user__username', 'room_type__name']
    raw_id_fields = ['user', 'room_type']

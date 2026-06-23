from django.contrib import admin
from .models import Review

@admin.register(Review)
class ReviewAdmin(admin.ModelAdmin):
    list_display = ['user', 'room_type', 'rating', 'title', 'is_visible', 'created_at']
    list_filter = ['rating', 'is_visible', 'room_type']
    search_fields = ['user__username', 'title', 'content']
    list_editable = ['is_visible']

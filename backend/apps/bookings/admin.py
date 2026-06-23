from django.contrib import admin
from .models import Booking, CheckInRecord

@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
    list_display = ['id', 'user', 'room', 'check_in_date', 'check_out_date', 'total_price', 'status', 'created_at']
    list_filter = ['status', 'check_in_date']
    search_fields = ['user__username', 'room__room_number', 'contact_name', 'contact_phone']
    date_hierarchy = 'check_in_date'

@admin.register(CheckInRecord)
class CheckInRecordAdmin(admin.ModelAdmin):
    list_display = ['booking', 'actual_check_in', 'actual_check_out', 'deposit', 'deposit_returned']
    list_filter = ['deposit_returned']
    search_fields = ['booking__user__username', 'booking__room__room_number']

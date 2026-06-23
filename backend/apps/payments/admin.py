from django.contrib import admin
from .models import Payment


@admin.register(Payment)
class PaymentAdmin(admin.ModelAdmin):
    list_display = ['payment_no', 'user', 'amount', 'payment_method', 'status', 'paid_at', 'created_at']
    list_filter = ['status', 'payment_method', 'created_at']
    search_fields = ['payment_no', 'user__username', 'transaction_id']
    readonly_fields = ['payment_no', 'transaction_id', 'paid_at', 'created_at', 'updated_at']
    ordering = ['-created_at']

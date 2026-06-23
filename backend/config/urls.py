from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView
from django.http import JsonResponse

def root_view(request):
    return JsonResponse({
        'message': 'Welcome to Hotel Management System API',
        'version': '1.0.0',
        'endpoints': {
            'users': '/api/users/',
            'rooms': '/api/rooms/',
            'bookings': '/api/bookings/',
            'reviews': '/api/reviews/',
            'payments': '/api/payments/',
            'schema': '/api/schema/',
            'docs': '/api/docs/'
        }
    })

urlpatterns = [
    path('', root_view, name='root'),
    path('admin/', admin.site.urls),
    path('api/users/', include('apps.users.urls')),
    path('api/rooms/', include('apps.rooms.urls')),
    path('api/bookings/', include('apps.bookings.urls')),
    path('api/reviews/', include('apps.reviews.urls')),
    path('api/favorites/', include('apps.favorites.urls')),
    path('api/notifications/', include('apps.notifications.urls')),
    path('api/tags/', include('apps.tags.urls')),
    path('api/operations/', include('apps.operations.urls')),
    path('api/logs/', include('apps.logs.urls')),
    path('api/system/', include('apps.system.urls')),
    path('api/payments/', include('apps.payments.urls')),
    path('api/schema/', SpectacularAPIView.as_view(), name='schema'),
    path('api/docs/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

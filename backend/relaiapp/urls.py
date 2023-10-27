"""relaiapp URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import path, include
from knox import views as knox_views
from rest_framework.authtoken.views import obtain_auth_token
from django.contrib.auth import views as auth_views
from rest_framework_simplejwt.views import (
    # TokenObtainPairView,
    TokenRefreshView,
)
from account.views import (
    SprinterRegistrationView,
    ResidentRegistrationView,
    ShopperRegistrationView,
    LoginView,
)


urlpatterns = [
    path('admin/', admin.site.urls),
    path('accounts/', include('account.urls', namespace='account')),
    path('accounts/register/sprinter/', SprinterRegistrationView.as_view(), name='sprinter_signup'),
    path('accounts/register/resident/', ResidentRegistrationView.as_view(), name='resident_signup'),
    path('accounts/register/shopper/', ShopperRegistrationView.as_view(), name='shopper_signup'),
    path('accounts/login/', LoginView.as_view(), name='login'),

    # path('relaiapp/register/', RegisterView.as_view(), name='register'),
    # path('relaiapp/token/obtain/', EmailTokenObtainPairView.as_view(),
    #      name='token_obtain_pair'),
    path('token/refresh/',
         TokenRefreshView.as_view(), name='token_refresh'),
    # path('relaiapp/login/', LoginObtainAuthToken.as_view(), name='login'),
    # path('password_change/done/', auth_views.PasswordChangeDoneView.as_view())

    path('maps/', include('maps.urls', namespace='maps'))
]

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

# path('sprinter/logout/', knox_views.LogoutView.as_view(), name='knox_logout'),
# path('sprinter/logoutall/', knox_views.LogoutAllView.as_view(),
#      name='knox_logoutall'),
# path('sprinter/token/', TokenObtainPairView.as_view(),
#      name='token_obtain_pair'),
# path('sprinter/token/refresh/',
#      TokenRefreshView.as_view(), name='token_refresh'),

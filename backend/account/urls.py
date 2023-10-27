from django.urls import include, path

from .views import (
    AccountsHome,
    sprinter_profile_view,
    resident_profile_view,
    shopper_profile_view
)

app_name = "account"

urlpatterns = [
    path('', AccountsHome.as_view(), name="accounts_home"),

    path('sprinters/<id>/profile/', sprinter_profile_view, name="sprinter_profile"),
    path('sprinters/', include(([
        path('<id>/profile/', sprinter_profile_view, name="sprinter_profile"),
    ], 'relaiapp'), namespace='sprinters')),

    path('residents/', include(([
        path('<id>/profile/', resident_profile_view, name="resident_profile"),
    ], 'relaiapp'), namespace='residents')),

    path('shoppers/', include(([
        path('<id>/profile/', shopper_profile_view, name="shopper_profile"),
    ], 'relaiapp'), namespace='shoppers')),
]
# urlpatterns = [
#     path('', v.ExampleView.as_view()),
#     path('api-token-auth/', v.CustomAuthToken.as_view()),
#     path('notes/', v.getNotes),
#     path('notes/create/', v.createNote),
#     path('notes/<str:pk>/update/', v.updateNote),
#     path('notes/<str:pk>/delete/', v.deleteNote),
#     path('notes/<str:pk>/', v.getNote),
#     path('', include("django.contrib.auth.urls")),
# ]

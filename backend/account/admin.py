from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin

from .models import Account


class AccountAdmin(BaseUserAdmin):
    '''Register an account admin to the admin website. This class also allows the admin page to
    display information about individual accounts, such as email, avatar, and password

    Args:
        BaseUserAdmin (UserAdmin)
    '''
    fieldsets = (
        (None, {'fields': ('email', 'password', 'first_name', 'last_name', 'roles', 'avatar')}),
        ('Permissions', {'fields': (
            'is_active',
            'is_staff',
            'is_admin',
            'is_superuser',
            'groups',
            'user_permissions',
        )}),
    )
    add_fieldsets = (
        (
            None,
            {
                'classes': ('wide',),
                'fields': ('email', 'password1', 'password2')
            }
        ),
    )

    list_display = ('email', 'first_name', 'last_name', 'is_staff')
    list_filter = ('is_staff', 'is_admin', 'is_superuser', 'is_active', 'groups')
    search_fields = ('email',)
    ordering = ('email',)
    filter_horizontal = ('groups', 'user_permissions',)


admin.site.register(Account, AccountAdmin)

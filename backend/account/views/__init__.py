from .sprinters import SprinterRegistrationView, sprinter_profile_view
from .residents import ResidentRegistrationView, resident_profile_view
from .shoppers import ShopperRegistrationView, shopper_profile_view
from .home import AccountsHome
from .login import LoginView

__all__ = [AccountsHome,
           LoginView,
           SprinterRegistrationView,
           ResidentRegistrationView,
           ShopperRegistrationView,
           sprinter_profile_view,
           resident_profile_view,
           shopper_profile_view]

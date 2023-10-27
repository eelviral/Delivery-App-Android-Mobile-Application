from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import permissions


class AccountsHome(APIView):
    permission_classes = (permissions.AllowAny,)

    def get(self, request):
        routes = [
            {
                'Endpoint': 'profiles/id/',
                'method': 'GET',
                'body': None,
                'headers': {
                    'Content-Type': 'application/json',
                    'Authorization': 'Token {token}',
                },
                'details': {
                    'allowed_users': 'sprinters, residents, shoppers',
                    'login_required': True,
                    'authentication': 'token, registered users only (any app)'
                },
                'description': 'Returns all profiles made by a single user'
            },
            {
                'Endpoint': 'sprinters/id/profile/',
                'method': 'GET',
                'body': None,
                'headers': {
                    'Content-Type': 'application/json',
                    'Authorization': 'Token {token}',
                },
                'details': {
                    'allowed_users': 'sprinters',
                    'login_required': True,
                    'authentication': 'token, registered sprinters only'
                },
                'description': 'Returns a single sprinter profile made by user'
            },
            {
                'Endpoint': 'residents/id/profile/',
                'method': 'GET',
                'body': None,
                'headers': {
                    'Content-Type': 'application/json',
                    'Authorization': 'Token {token}',
                },
                'details': {
                    'allowed_users': 'residents',
                    'login_required': True,
                    'authentication': 'token, registered residents only'
                },
                'description': 'Returns a single resident profile made by user'
            },
            {
                'Endpoint': 'shoppers/id/profile',
                'method': 'GET',
                'body': None,
                'headers': {
                    'Content-Type': 'application/json',
                    'Authorization': 'Token {token}',
                },
                'details': {
                    'allowed_users': 'shoppers',
                    'login_required': True,
                    'authentication': 'token, registered shoppers only'
                },
                'description': 'Returns all profiles made by a single user'
            },
        ]
        return Response(routes)

const String baseUrl = 'http://10.0.2.2:8000/';

Uri get loginUrl => Uri.parse('${baseUrl}accounts/login/');

Uri get registerUrl => Uri.parse('${baseUrl}accounts/register/sprinter/');

Uri accountUrl(id) {
  return Uri.parse('${baseUrl}accounts/sprinters/$id/profile/');
}
// get tokenAuthUrl => Uri.parse('${baseUrl}api-token-auth/');

Uri get mapsUrl => Uri.parse('${baseUrl}maps/');

Uri get routeEZUrl => Uri.parse('${baseUrl}maps/route/');

Uri get retrieveUrl => Uri.parse('$baseUrl?format=json');

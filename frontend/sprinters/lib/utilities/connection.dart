import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sprinters/accounts/login.dart';
import 'package:sprinters/assets/constants/constants.dart';
import 'package:sprinters/assets/url.dart';
import 'package:sprinters/widgets/alerts.dart';

class ServerConnect {
  BuildContext context;
  Client client;

  ServerConnect(this.context, this.client);

  register(Map<String, dynamic> data) async {
    String jsonData = json.encode(data);
    final response = await client.post(registerUrl, body: jsonData, headers: {
      'content-type': 'application/json'
    }).timeout(const Duration(seconds: timeoutSeconds), onTimeout: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CustomAlert(
            title: "Connection Timed Out",
            content: "Unable to connect to the server.",
          );
        },
      );
      return Response('Error', 408);
    });

    final responseJson = json.decode(response.body);
    if (responseJson['non_field_errors'] != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlert(
            title: "Registration Error",
            content: responseJson['non_field_errors'],
          );
        },
      );
    }

    if (response.statusCode == 201) {
      return response;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlert(
            title: "Registration Error",
            content: responseJson.toString(),
          );
        },
      );
      return Response('Error', response.statusCode);
    }
  }

  login(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      final data = json.encode({
        'email': email,
        'password': password,
      });

      final response = await client.post(loginUrl,
          body: data, headers: {'content-type': 'application/json'}).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const CustomAlert(
                title: "Connection Timed Out",
                content: "Unable to connect to the server.",
              );
            },
          );
          return Response('Error', 408);
        },
      );

      final responseJson = json.decode(response.body);

      if (responseJson['non_field_errors'] != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomAlert(
              title: "Login Error",
              content: "Unable to log in with provided credentials.",
            );
          },
        );
      }

      if (response.statusCode == 200) {
        return response;
      } else {
        return Response('Error', response.statusCode);
      }
    } else {
      return Response('Error', 400);
    }
  }

  logout() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  mapResponse(String token) async {
    final tokenResponse = await client.get(
      mapsUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Token $token"
      },
    ).timeout(
      const Duration(seconds: timeoutSeconds),
      onTimeout: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomAlert(
              title: "Connection Timed Out",
              content: "Unable to connect to the server.",
            );
          },
        );
        return Response('Error', 408);
      },
    );
    if (tokenResponse.statusCode == 200) {
      return tokenResponse;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CustomAlert(
              title: "Connection Error",
              content: "Unable to connect to the server.");
        },
      );
    }
  }

  getEZRoute(String token, double? latitude, double? longitude) async {
    if (latitude != null && longitude != null) {
      Map<String, String> data = {
        'latitude': latitude.toStringAsFixed(6),
        'longitude': longitude.toStringAsFixed(6),
      };

      final response = await client
          .post(routeEZUrl,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': "Token $token"
              },
              body: jsonEncode(data))
          .timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const CustomAlert(
                title: "Connection Timed Out",
                content: "Unable to connect to the server.",
              );
            },
          );
          return Response('Error', 408);
        },
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomAlert(
              title: "Connection Error",
              content: "Failed to Fetch Route",
            );
          },
        );
        return Response('Error', response.statusCode);
      }
    }
  }

  verifyToken(Response response) {
    final responseJson = json.decode(response.body);
    if (responseJson['token'] != null) {
      return mapResponse(responseJson['token']);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CustomAlert(
            title: "Connection Error",
            content: "Missing authentication token.",
          );
        },
      );
    }
  }

  accountResponse(String token, String id) async {
    final response = await client.get(accountUrl(id), headers: {
      "Content-Type": "application/json",
      'Authorization': "Token $token"
    }).timeout(const Duration(seconds: timeoutSeconds), onTimeout: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CustomAlert(
              title: "Connection Timed Out",
              content: "Unable to fetch account information.");
        },
      );
      return Response('Error', 408);
    });
    if (response.statusCode == 200) {
      return response;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CustomAlert(
              title: "Connection Error",
              content: "Unable to fetch account information.");
        },
      );
      return Response('Error', 408);
    }
  }
}

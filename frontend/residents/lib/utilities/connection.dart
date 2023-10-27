import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:residents/accounts/login.dart';
import 'package:residents/assets/url.dart';
import 'package:residents/constants/constants.dart';
import 'package:residents/widgets/alerts.dart';

class ServerConnect {
  BuildContext context;
  Client client;

  ServerConnect(this.context, this.client);

  register(File imageFile, Map<String, String> data) async {
    final request = http.MultipartRequest('POST', registerUrl);

    request.fields['data'] = json.encode(data);

    request.files.add(
      http.MultipartFile.fromBytes(
        'media',
        imageFile.readAsBytesSync(),
        filename: imageFile.path.split("/").last,
        contentType: MediaType('image', imageFile.path.split(".").last),
      ),
    );

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    final responseJson = json.decode(response.body);

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
      final response = await client.post(loginUrl, body: {
        'username': email,
        'password': password,
      }).timeout(
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
              body: json.encode(data))
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
            return CustomAlert(
              title: "Failed to Fetch Route",
              content: json.decode(response.body).toString(),
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
              content: "Unable to connect to the server.");
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
              content: "Unable to connect to the server.");
        },
      );
    }
  }
}

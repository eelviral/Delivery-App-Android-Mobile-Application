import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sprinters/accounts/registration/page_1.dart';
import 'package:sprinters/accounts/registration/page_2.dart';
import 'package:sprinters/accounts/registration/page_3.dart';
import 'package:sprinters/utilities/connection.dart';
import 'package:sprinters/menu/homepage.dart';

class RegistrationPageView extends StatefulWidget {
  final Client client;

  const RegistrationPageView({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  State<RegistrationPageView> createState() => _RegistrationPageViewState();
}

class _RegistrationPageViewState extends State<RegistrationPageView> {
  Map<String, dynamic> data = {};
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void _loadHomepage(dynamic token, String id) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomeScreen(
              client: widget.client,
              token: token,
              id: id,
            )));
  }

  _register() async {
    final connection = ServerConnect(context, widget.client);

    final response = await connection.register(data);
    if (response.statusCode == 201) {
      final tokenResponse = await connection.verifyToken(response);

      final responseJson = json.decode(response.body);
      String id;
      if (responseJson['id'] != null) {
        id = responseJson['id'].toString();
      } else {
        id = '';
      }

      if (tokenResponse.statusCode == 200) {
        _loadHomepage(responseJson['token'], id);
      }
    }
  }

  void addData(Map<String, dynamic> newData) {
    setState(() {
      data.addAll(newData);
    });
  }

  nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          Registration1(
            onNewData: (newData) => addData(newData),
            onNextButtonClicked: nextPage,
            onBackButtonClicked: () => Navigator.of(context).pop(),
          ),
          Registration2(
            onNewData: (newData) => addData(newData),
            onNextButtonClicked: nextPage,
            onBackButtonClicked: previousPage,
          ),
          Registration3(
            onNewData: (newData) {
              setState(() {
                data['why_sprinter'] = <String, String>{};
                data['why_sprinter'].addAll(newData);
              });
            },
            onSubmitButtonClicked: _register,
            onBackButtonClicked: previousPage,
          ),
        ],
      ),
    );
  }
}

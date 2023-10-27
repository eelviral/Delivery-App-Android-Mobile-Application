import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:residents/accounts/registration.dart';
import 'package:residents/assets/styles.dart';
import 'package:residents/utilities/connection.dart';
import 'package:residents/menu/homepage.dart';
import 'package:residents/widgets/accounts/login_widgets.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Client client = http.Client();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  _loadTheme() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final bool? theme = prefs.getBool('theme');
    // if (theme != null) {
    //   if (theme) {
    //     Get.changeTheme(ThemeData.light());
    //   } else {
    //     Get.changeTheme(ThemeData.dark());
    //   }
    // }
  }

  _loadHomepage(String token, String id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          client: client,
          token: token,
          id: id,
        ),
      ),
    );
  }

  _login(emailText, passwordText) async {
    final connection = ServerConnect(context, client);

    final response = await connection.login(emailText, passwordText);
    if (response.statusCode == 200) {
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

  @override
  void initState() {
    _loadTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginButton = GreenButton(
        text: Text(
          'Login',
          style: barlowFont.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
        onPressed: () {
          _login(
            _emailController.text,
            _passwordController.text,
          );
        });

    return Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 40.0),
                    child: SizedBox(
                      width: 300,
                      child: Image.asset(
                        "assets/images/relai-green-logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Text('Residents Login', style: barlowFont),
                  const SizedBox(height: 20.0),
                  LoginTextField(
                    controller: _emailController,
                    hintText: "Email",
                    iconData: Icons.person,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 25.0),
                  LoginTextField(
                    controller: _passwordController,
                    hintText: "Password",
                    obscureText: true,
                    iconData: Icons.lock,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 35.0,
                  ),
                  loginButton,
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "New to Relai? ",
                        style: barlowFont.copyWith(fontSize: 18.0),
                      ),
                      InkWell(
                        child: Text(
                          'Create Account Here',
                          style: barlowFont.copyWith(
                              color: relaiGreen, fontSize: 18.0),
                        ),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    RegistrationPageView(client: client))),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            margin:
                                const EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 0.0),
                            padding: const EdgeInsets.all(7.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                    width: 2,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white)),
                            child: const Icon(
                              Icons.link,
                              size: 30.0,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "Connect Shopper &"
                          "\nSprinter Accounts",
                          style: barlowFont.copyWith(fontSize: 15.0),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

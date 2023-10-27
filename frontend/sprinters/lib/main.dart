import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sprinters/accounts/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Sprinters App',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      // Theme mode depends on device settings at the beginning
      home: const LoginPage(),
    );
  }
}

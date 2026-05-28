import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme.dart';
import 'UI/pages/MainPage.dart';
import 'UI/pages/login_page.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final prefs =
  await SharedPreferences.getInstance();

  bool login =
      prefs.getBool("isLogged") ?? false;

  runApp(
    MyApp(check: login),
  );
}

class MyApp extends StatelessWidget {

  final bool check;

  const MyApp({
    super.key,
    required this.check,
  });

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      theme: AppTheme.darkTheme,

      home:

      check

          ? const MainPage()

          : const LoginScreen(),

    );

  }

}
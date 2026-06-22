import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/theme_provider.dart';
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

    ChangeNotifierProvider(

      create: (_) => ThemeProvider(),

      child: MyApp(
        check: login,
      ),

    ),

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

    return Consumer<ThemeProvider>(

      builder: (
          context,
          themeProvider,
          child,
          ) {

        return MaterialApp(

          debugShowCheckedModeBanner:
          false,

          theme: AppTheme.lightTheme,

          darkTheme: AppTheme.darkTheme,

          themeMode: themeProvider.themeMode,
          home:

          check

              ? const MainPage()

              : const LoginScreen(),

        );

      },

    );

  }

}
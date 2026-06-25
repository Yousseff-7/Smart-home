import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';

import 'l10n/app_localizations.dart';

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

    MultiProvider(

      providers: [

        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => LanguageProvider(),
        ),

      ],

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

    return Consumer2<
        ThemeProvider,
        LanguageProvider>(

      builder: (

          context,
          themeProvider,
          languageProvider,
          child,

          ) {

        return MaterialApp(

          debugShowCheckedModeBanner: false,

          theme: AppTheme.lightTheme,

          darkTheme: AppTheme.darkTheme,

          themeMode:
          themeProvider.themeMode,

          locale:
          languageProvider.locale,

          supportedLocales: const [

            Locale('en'),
            Locale('ar'),

          ],

          localizationsDelegates: const [

            AppLocalizations.delegate,

            GlobalMaterialLocalizations.delegate,

            GlobalWidgetsLocalizations.delegate,

            GlobalCupertinoLocalizations.delegate,

          ],

          home:

          check

              ? const MainPage()

              : const LoginScreen(),

        );

      },

    );

  }

}
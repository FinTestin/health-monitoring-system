import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './DataDisplay.dart';
import 'package:testingesp32/DataDisplay.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:testingesp32/l10n/app_localizations.dart';// Testing

void manin() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(

      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.grey,
        accentColor: Colors.black,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
        accentColor: Colors.black,
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Adaptive Theme Demo',
        theme: theme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,//testing
        supportedLocales: AppLocalizations.supportedLocales,//testing
        home: DisplayPage(),
      ),
    );

  }
}



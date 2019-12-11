import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pc_build_assistant/views/confirmation_screen.dart';
import 'package:pc_build_assistant/views/home_screen.dart';
import 'package:pc_build_assistant/views/login_screen.dart';
import 'package:pc_build_assistant/views/purchase_screen.dart';
import 'package:pc_build_assistant/views/registration_screen.dart';
import 'package:pc_build_assistant/views/reset_screen.dart';
import 'package:pc_build_assistant/views/view_screen.dart';
import 'package:pc_build_assistant/views/welcome_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(
        primaryTextTheme: Typography(platform: TargetPlatform.android).black,
        textTheme: Typography(platform: TargetPlatform.android).black,
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0.0,
        ),
        iconTheme: ThemeData.dark().iconTheme.copyWith(color: Colors.black),
      ),
      darkTheme: ThemeData.dark().copyWith(
          primaryTextTheme: Typography(platform: TargetPlatform.android).white,
          textTheme: Typography(platform: TargetPlatform.android).white,
          appBarTheme: AppBarTheme(
            color: Colors.transparent,
            elevation: 0.0,
          ),
          iconTheme: ThemeData.dark().iconTheme.copyWith(color: Colors.white)),
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        ResetScreen.id: (context) => ResetScreen(),
        ViewScreen.id: (context) => ViewScreen(),
        PurchaseScreen.id: (context) => PurchaseScreen(),
        ConfirmationScreen.id: (context) => ConfirmationScreen(),
      },
      initialRoute: WelcomeScreen.id,
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pc_build_assistant/components/rounded_button_widget.dart';
import 'package:pc_build_assistant/util/constants.dart';

import 'home_screen.dart';
import 'login_screen.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = "/";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    //getCurrentUser();
    super.initState();
  }

  getCurrentUser() async {
    FirebaseUser user;
    try {
      user = await _auth.currentUser();
      if (user != null) {
        print(user.email);
        Navigator.popAndPushNamed(context, HomeScreen.id);
      }
    } catch (excp) {
      print("error occured $excp");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("images/welcome_background.jpg")),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Hero(
                  tag: 'loginButton',
                  child: RoundedButton(
                    title: 'Log In',
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                    color: kLoginButtonColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Hero(
                  tag: 'registerButton',
                  child: RoundedButton(
                    title: 'Register',
                    onPressed: () {
                      Navigator.pushNamed(context, RegistrationScreen.id);
                    },
                    color: kRegisterButtonColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Hero(
                  tag: 'continueButton',
                  child: RoundedButton(
                    title: 'Continue As Guest',
                    onPressed: () {
                      Navigator.pushNamed(context, HomeScreen.id);
                    },
                    color: kContinueButtonColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

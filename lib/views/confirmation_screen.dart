import 'package:flutter/material.dart';
import 'package:pc_build_assistant/arguments/confirmation_screen_argument.dart';
import 'package:pc_build_assistant/util/constants.dart';

class ConfirmationScreen extends StatefulWidget {
  static final String id = "/confirmationScreenId";
  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    ConfirmationScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.black),
        title: Text(
          "Success!",
          style: TextStyle(fontFamily: "Rodin"),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            "Thank you ${args.name}, your products are being shipped to ${args.address}. Your total bill is ${args.bill} Tk. Billing details have been mailed to ${args.email}",
            style: kAnimatedTextStyle.copyWith(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}

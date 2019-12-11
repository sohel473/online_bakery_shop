import 'package:flutter/material.dart';
import 'package:pc_build_assistant/util/constants.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final Function onPressed;
  final String title;

  RoundedButton(
      {this.color = Colors.white,
      @required this.title,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      color: color,
      borderRadius: BorderRadius.circular(kRadius),
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: 200.0,
        height: 42.0,
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

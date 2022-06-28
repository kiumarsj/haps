import 'package:flutter/material.dart';
import 'package:healthy_meter/constants.dart';

class RoundedButton extends StatefulWidget {
  RoundedButton();

  @override
  State<RoundedButton> createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: lightColorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: () {
          setState(() {});
        },
        child: Text(
          "Update",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

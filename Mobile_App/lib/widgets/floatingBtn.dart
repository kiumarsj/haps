import 'package:flutter/material.dart';
import 'package:healthy_meter/constants.dart';

class FloatingBtn extends StatefulWidget {
  //const FloatingBtn({Key? key}) : super(key: key);
  FloatingBtn({required this.title, required this.onPressed});
  String title;
  Function onPressed;

  @override
  State<FloatingBtn> createState() => _FloatingBtnState();
}

class _FloatingBtnState extends State<FloatingBtn> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: lightColorScheme.primaryContainer,
      foregroundColor: Colors.black,
      onPressed: () {
        setState(() {
          widget.onPressed;
        });
      },
      icon: Icon(
        Icons.update_sharp,
        size: 30,
      ),
      label: Text(
        widget.title,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

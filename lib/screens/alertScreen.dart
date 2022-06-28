import 'package:flutter/material.dart';
import 'package:healthy_meter/constants.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  double size = 70;
  //
  // void alerting() async {
  //   while (1 == 1) {
  //     setState(() {
  //       for (int i = 0; i < 50; i++) {
  //         size--;
  //         Future.delayed(Duration(milliseconds: 300));
  //       }
  //       for (int i = 0; i < 50; i++) {
  //         size++;
  //         Future.delayed(Duration(milliseconds: 300));
  //       }
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    //alerting();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: AnimatedContainer(
                width: MyDimentions.width(context),
                duration: Duration(milliseconds: 10),
                color: Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.crisis_alert,
                      size: MyDimentions.width(context) - 50,
                    ),
                    Text(
                      "Alert!",
                      style: TextStyle(fontSize: 90, color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

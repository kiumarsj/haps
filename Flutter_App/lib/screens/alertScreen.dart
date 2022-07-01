import 'package:flutter/material.dart';
import 'package:healthy_meter/constants.dart';

String pateintName = '';
String pateintID = '';

class AlertScreen extends StatefulWidget {
  final data;
  const AlertScreen({this.data});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  double size = 70;

  void alerting() async {
    for (int i = 0; i < 100; i++) {
      for (int i = 0; i < 50; i++) {
        setState(() {
          size--;
        });
        Future.delayed(Duration(milliseconds: 300));
      }
      for (int i = 0; i < 50; i++) {
        setState(() {
          size++;
        });
        Future.delayed(Duration(milliseconds: 300));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // alerting();
  }

  @override
  Widget build(BuildContext context) {
    size = MyDimentions.width(context);
    final args = ModalRoute.of(context)!.settings.arguments as AlertScreen;
    pateintID = args.data[0]['patientId'].toString();
    pateintName = args.data[0]['patientName'].toString();
    return SafeArea(
      child: Scaffold(
        body: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      width: MyDimentions.width(context),
                      duration: Duration(milliseconds: 10),
                      child: Icon(
                        Icons.crisis_alert,
                        size: MyDimentions.width(context) - 50,
                      ),
                    ),
                    Text(
                      "Alert!",
                      style: TextStyle(fontSize: 80, color: Colors.black),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          pateintName + '   ' + pateintID,
                          style: TextStyle(fontSize: 30),
                        )
                      ],
                    ),
                    Text(
                      "is in a Critical Situation",
                      style: TextStyle(fontSize: 30, color: Colors.black),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

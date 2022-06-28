import 'package:flutter/material.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:healthy_meter/constants.dart';
import 'package:google_fonts/google_fonts.dart';

int delay = 30;

class InfoBoxWidget extends StatefulWidget {
  //const InfoBoxWidget({Key? key}) : super(key: key);
  InfoBoxWidget(
      {required this.number,
      required this.theprefix,
      this.bgColor,
      this.fgColor});

  double number;
  String theprefix = "heyy";
  Color? bgColor = lightColorScheme.secondaryContainer;
  Color? fgColor = lightColorScheme.onSecondary;

  @override
  State<InfoBoxWidget> createState() => _InfoBoxWidgetState();
}

class _InfoBoxWidgetState extends State<InfoBoxWidget> {
  double _value = 0.0;
  String? _theprefix;
  Color? _bgColor;
  Color? _fgColor;

  void setData(num, pref, bg, fg) async {
    _theprefix = pref;
    _bgColor = bg;
    _fgColor = fg;
    for (int i = 0; i < num; i++) {
      setState(() {
        _value++;
      });
      delay = (3000 / num).round();
      await Future.delayed(Duration(milliseconds: delay));
    }
  }

  void upState() {
    setState(() {});
  }

  @override
  void initState() {
    setData(widget.number, widget.theprefix, widget.bgColor, widget.fgColor);
    upState();
    super.initState();
  }

  @override
  void didUpdateWidget(InfoBoxWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    upState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MyDimentions.width(context) - 30,
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: _bgColor,
      ),
      child: AnimatedFlipCounter(
        textStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w500,
          fontFamily: GoogleFonts.timmana().fontFamily,
          color: _fgColor,
        ),
        value: _value,
        duration: Duration(milliseconds: 700),
        prefix: "$_theprefix: ",
        curve: Curves.decelerate,
      ),
    );
  }
}

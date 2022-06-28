import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:healthy_meter/constants.dart';
import 'package:healthy_meter/screens/patientProfileScreen.dart';
import 'package:intl/intl.dart';

class TimeChartsColumn extends StatefulWidget {
  final chartData;
  TimeChartsColumn(this.chartData);

  @override
  State<TimeChartsColumn> createState() => _TimeChartsColumnState();
}

class _TimeChartsColumnState extends State<TimeChartsColumn> {
  List xAxisLabels = chartData['xAxisLabels'];
  List yPulseOximetryAxis = chartData['yPulseOximetryAxis'];
  List yHeartBeatAxis = chartData['yHeartBeatAxis'];
  List yTemperatureAxis = chartData['yTemperatureAxis'];

  List<Series<TimeValueClass, DateTime>> createSeries(
      List x, List y, String id) {
    DateTime now = new DateTime.now();
    List<TimeValueClass> data = [];
    for (int i = 0; i < x.length - 1; i++) {
      print(int.parse(x[i]).toString());
      data.add(TimeValueClass(
          DateTime(now.year, now.month, now.day, int.parse(x[i])), y[i]));
    }

    return [
      Series<TimeValueClass, DateTime>(
        id: id,
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (TimeValueClass value, _) => value.time,
        measureFn: (TimeValueClass value, _) => value.value,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Pulse Oximetery'),
        SimpleTimeSeriesChart(
            createSeries(xAxisLabels, yPulseOximetryAxis, 'yPulseOximetryAxis'),
            animate: true),
        Text('Heartbeat'),
        SimpleTimeSeriesChart(
            createSeries(xAxisLabels, yHeartBeatAxis, 'yHeartBeatAxis'),
            animate: true),
        Text('Body Tempreture'),
        SimpleTimeSeriesChart(
            createSeries(xAxisLabels, yTemperatureAxis, 'yTemperatureAxis'),
            animate: true),
      ],
    );
  }
}

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<Series<dynamic, DateTime>> seriesList;
  final bool? animate;

  SimpleTimeSeriesChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        padding: EdgeInsets.all(15.0),
        width: MyDimentions.width(context) - 30,
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color: lightColorScheme.onInverseSurface,
        ),
        duration: Duration(seconds: 1),
        child: TimeSeriesChart(
          seriesList,
          animate: animate,
          dateTimeFactory: const LocalDateTimeFactory(),
        ),
      ),
    );
  }
}

class TimeValueClass {
  final DateTime time;
  final int value;

  TimeValueClass(this.time, this.value);
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthy_meter/constants.dart';
import 'package:http/http.dart' as http;
import 'package:healthy_meter/widgets/prettyLineChartWidget.dart';
import 'package:healthy_meter/widgets/timeChartWidget.dart';
import 'package:healthy_meter/services/networking.dart';
import 'package:intl/intl.dart';

List<int> tableRowIndex = [0, 3, 4, 5, 6, 7, 9, 10];
List<String> tableTitles = [
  'ID',
  'Full Name',
  'Father\'s Name',
  'National Code',
  'Age',
  'Disease ID',
  'Registration Date',
  'Registration Time'
];
final myList = List<DataRow>.empty(growable: true);
var chartData;
var keyList;

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({Key? key, this.pID}) : super(key: key);
  final pID;

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  late Future futurePatientInfo;
  late Future futureChart;

  Future<bool> GetPatientChart(id) async {
    http.Response response;

    DateTime now = new DateTime.now();
    var formatter = new DateFormat('yyyy%2FMM%2Fdd');
    String formattedDate = formatter.format(now);
    print(formattedDate);

    try {
      response = await Network().netGet(
          'https://api.iot.davoodhoseini.ir/api/Patients/GetPatientSituationChart?'
          'ReportType=hour&PatientId=${id}&FromDate=${formattedDate}&ToDate=${formattedDate}');

      // response = await Network().netGet(
      //     'https://api.iot.davoodhoseini.ir/api/Patients/GetPatientSituationChart?'
      //     'ReportType=hour&PatientId=${id}&FromDate=2022%2F06%2F18&ToDate=2022%2F06%2F18');

      if (response.statusCode == 200) {
        chartData = jsonDecode(response.body)['data'];
        print(chartData.toString());
        return true;
      } else {
        throw Exception("GetPatientChart API call failed");
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> GetPatientInfo(id) async {
    http.Response response;
    var body =
        jsonEncode(<String, dynamic>{"patientId": id, "nationalCode": ""});

    try {
      response = await Network().netPost(
          'https://api.iot.davoodhoseini.ir/api/Patients/GetPatientById', body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body)['data'];
        print("%%%%%%%%%%%%%%%%%%%%%%%%%%% start GetPatientInfo");
        print(result);
        keyList = result.keys.toList();
        print("%%%%%%%%%%%%%%%%%%%%%%%%%%% start GetPatientInfo");

        myList.clear();
        for (int i = 0; i < tableRowIndex.length; i++) {
          myList.add(
            DataRow(
              cells: [
                DataCell(
                  Text(
                    tableTitles[i],
                    style: TextStyle(fontFamily: "Vazir", fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataCell(
                  Text(
                    result[keyList[tableRowIndex[i]]].toString(),
                    style: TextStyle(fontFamily: "Vazir", fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }
        return true;
      } else {
        throw Exception("GetPatientById API call failed");
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    futureChart = GetPatientChart(widget.pID);
    futurePatientInfo = GetPatientInfo(widget.pID);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: lightColorScheme.primary,
          title: Text("Patient's Profile"),
          leading: TextButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            child: Icon(
              Icons.arrow_back_ios_new_sharp,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  child: FutureBuilder(
                    future: futurePatientInfo,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return DataTable(
                          showCheckboxColumn: false,
                          border: TableBorder(
                            horizontalInside: BorderSide(width: 1),
                          ),
                          columns: [
                            DataColumn(
                              label: Text(
                                "Title",
                                style: TextStyle(
                                    fontFamily: "Vazir", fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Data",
                                style: TextStyle(
                                    fontFamily: "Vazir", fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                          rows: myList,
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: futureChart,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return TimeChartsColumn(chartData);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
              //PrettyLineChart(isShowingMainData: false),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_meter/constants.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:healthy_meter/screens/patientProfileScreen.dart';
import 'package:healthy_meter/services/networking.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final myList = List<DataRow>.empty(growable: true);
String userDiplayName = "Dr.";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<int?> futureData;
  int patientCount = 0;
  int delay = 30;

  void showPatientProfile(patientID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientProfileScreen(
          pID: patientID,
        ),
      ),
    );
  }

  void patientCounter(num) async {
    for (int i = 0; i < num; i++) {
      setState(() {
        patientCount += 1;
      });
      delay = (2000 / num).round();
      await Future.delayed(Duration(milliseconds: delay));
    }
  }

  Future<int?> getPatients() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userDiplayName = prefs.getString("userDisplay") ?? "Dr.";
    http.Response response;
    var result;
    var theBody;

    // patients info list
    theBody = jsonEncode(<String, dynamic>{
      'paging': {'pageNumber': 1, 'pageSize': 50}
    });
    try {
      response = await Network().netPost(
          'https://api.iot.davoodhoseini.ir/api/Patients/GetPatients', theBody);
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
        patientCount = 0;
        int totalCount = result['data']['totalCount'];
        patientCounter(totalCount);

        myList.clear();
        for (int i = 0; i < totalCount; i++) {
          myList.add(
            DataRow(
              onSelectChanged: (isSelected) {
                setState(() {
                  showPatientProfile(result['data']['data'][i]['id']);
                });
              },
              cells: [
                DataCell(
                  Text(
                    result['data']['data'][i]['firstName'],
                    style: TextStyle(fontFamily: "Vazir", fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataCell(
                  Text(
                    result['data']['data'][i]['lastName'],
                    style: TextStyle(fontFamily: "Vazir", fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataCell(
                  Text(
                    result['data']['data'][i]['age'].toString(),
                    style: TextStyle(fontFamily: "Vazir", fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }
        return totalCount;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    futureData = getPatients();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: lightColorScheme.background,
        body: AnimatedContainer(
          duration: Duration(seconds: 1),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 30, 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "   Hi $userDiplayName",
                          style: TextStyle(
                              fontFamily: "Vazir",
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: lightColorScheme.primary,
                            borderRadius: BorderRadius.circular(40),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: MyDimentions.width(context) - 30,
                      height: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        color: lightColorScheme.secondaryContainer,
                      ),
                      child: AnimatedFlipCounter(
                        textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          fontFamily: GoogleFonts.timmana().fontFamily,
                          color: patientCount <= 120
                              ? lightColorScheme.onPrimaryContainer
                              : lightColorScheme.error,
                        ),
                        value: patientCount,
                        duration: Duration(milliseconds: 1000),
                        prefix: "Number of Patients: ",
                        curve: Curves.fastLinearToSlowEaseIn,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: lightColorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      alignment: Alignment.center,
                      child: FutureBuilder(
                        future: futureData,
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
                                    "Name",
                                    style: TextStyle(
                                        fontFamily: "Vazir", fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "LastName",
                                    style: TextStyle(
                                        fontFamily: "Vazir", fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Age",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

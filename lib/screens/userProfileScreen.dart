import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthy_meter/constants.dart';
import 'package:healthy_meter/services/data_management.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthy_meter/services/networking.dart';
import 'package:http/http.dart' as http;

String? userName;
String? userDisplay;
String? userRoleName;
int? userId;

Widget patientsTable = Text('');
List<DataRow> rowList = List<DataRow>.empty(growable: true);

final columnList = [
  DataColumn(
    label: Text(
      "Full Name",
      style: TextStyle(fontFamily: "Vazir", fontSize: 15),
      textAlign: TextAlign.center,
    ),
  ),
  DataColumn(
    label: Text(
      "National Code",
      style: TextStyle(fontFamily: "Vazir", fontSize: 15),
      textAlign: TextAlign.center,
    ),
  ),
  DataColumn(
    label: Text(
      "Pulse oximetry",
      style: TextStyle(fontFamily: "Vazir", fontSize: 15),
      textAlign: TextAlign.center,
    ),
  ),
  DataColumn(
    label: Text(
      "Heatbeat",
      style: TextStyle(fontFamily: "Vazir", fontSize: 15),
      textAlign: TextAlign.center,
    ),
  ),
  DataColumn(
    label: Text(
      "Body tempreture",
      style: TextStyle(fontFamily: "Vazir", fontSize: 15),
      textAlign: TextAlign.center,
    ),
  ),
  DataColumn(
    label: Text(
      "Update Time",
      style: TextStyle(fontFamily: "Vazir", fontSize: 15),
      textAlign: TextAlign.center,
    ),
  ),
  DataColumn(
    label: Text(
      "Update Date",
      style: TextStyle(fontFamily: "Vazir", fontSize: 15),
      textAlign: TextAlign.center,
    ),
  ),
];

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  //late Future futureUserPatiensData;

  void logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("userToken");
      prefs.remove("userId");
      Navigator.pop(context);
      Navigator.pushNamed(context, '/loginFamiliar');
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<bool> getUserInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userDisplay = prefs.getString("userDisplay");
      userName = prefs.getString("username");
      userRoleName = prefs.getString("userRoleName");
      userId = prefs.getInt("userId");
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> getUsersPatients(var result) async {
    http.Response response;
    try {
      response = await Network().netGet(
          'https://api.iot.davoodhoseini.ir/api/Patients/GetPatientLastSituation');
      if (response.statusCode == 200) {
        result = jsonDecode(response.body)['data'];
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ start getUsersPatients API call");
        print(result);
        // DataClass().patientsStatus = result;
        // DataClass().notifyListeners();
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ end getUsersPatients API call");

        rowList.clear();
        for (int i = 0; i < result.length; i++) {
          rowList.add(
            DataRow(
              cells: [
                DataCell(
                  Text(
                    result[i]['patientName'].toString(),
                    style: TextStyle(fontFamily: "Vazir", fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataCell(
                  Text(
                    result[i]['nationalCode'].toString(),
                    style: TextStyle(fontFamily: "Vazir", fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataCell(
                  Text(
                    result[i]['pulseOximetry'].toString(),
                    style: TextStyle(fontFamily: "Vazir", fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataCell(
                  Text(
                    result[i]['heartBeat'].toString(),
                    style: TextStyle(fontFamily: "Vazir", fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataCell(
                  Text(
                    result[i]['temperature'].toString(),
                    style: TextStyle(fontFamily: "Vazir", fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataCell(
                  Text(
                    result[i]['lastUpdateTime'].toString(),
                    style: TextStyle(fontFamily: "Vazir", fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataCell(
                  Text(
                    result[i]['lastUpdateDate'].toString(),
                    style: TextStyle(fontFamily: "Vazir", fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }
        patientsTable = AnimatedContainer(
          duration: Duration(seconds: 1),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: lightColorScheme.onInverseSurface,
            borderRadius: BorderRadius.circular(30),
          ),
          child: DataTable(
            showCheckboxColumn: false,
            border: TableBorder(
              horizontalInside: BorderSide(width: 1),
            ),
            columns: columnList,
            rows: rowList,
          ),
        );
      }
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    patientsTable = Text('');
    //futureUserPatiensData = getUsersPatients();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: lightColorScheme.error,
            borderRadius: BorderRadius.circular(35),
          ),
          child: TextButton(
            onPressed: logout,
            child: Text(
              "Logout",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
        backgroundColor: lightColorScheme.background,
        body: Scrollbar(
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
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          "Welcome $userDisplay\n" + "To your Dashboard",
                          style: TextStyle(
                              fontFamily: "Vazir",
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: lightColorScheme.primary,
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AnimatedContainer(
                    decoration: BoxDecoration(
                      color: lightColorScheme.onInverseSurface,
                      borderRadius: BorderRadius.circular(35),
                    ),
                    duration: Duration(seconds: 2),
                    child: FutureBuilder(
                      future: getUserInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Table(
                            border: TableBorder(
                              horizontalInside: BorderSide(width: 1),
                            ),
                            children: [
                              TableRow(
                                children: [
                                  Text(
                                    "Id",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    "$userId",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Text(
                                    "UserName",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    "$userName",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Text(
                                    "Role",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    "$userRoleName",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
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
                  height: 53,
                  child: Column(
                    children: [
                      Text(
                        "Patients Monitoring",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text('------------------------------------------'),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: FutureBuilder(
                    future: getUsersPatients(
                        context.watch<DataClass>().patientsStatus),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return patientsTable;
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

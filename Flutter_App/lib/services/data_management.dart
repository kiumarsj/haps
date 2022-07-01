import 'package:flutter/material.dart';
import 'package:healthy_meter/main.dart';
import 'package:healthy_meter/screens/alertScreen.dart';
import 'package:healthy_meter/services/socket.dart';
import 'package:http/http.dart' as http;
import 'package:healthy_meter/services/networking.dart';
import 'dart:convert';

class DataClass with ChangeNotifier {
  MySocket socketInstance = MySocket();

  var onlineGadgets;
  var patientsList;
  var patientsStatus;

  Future<void> initCall() async {
    http.Response response;
    var theBody;

    // // patients info list
    // theBody = jsonEncode(<String, dynamic>{
    //   'paging': {'pageNumber': 1, 'pageSize': 50}
    // });
    // response = await Network().netPost(
    //     'https://api.iot.davoodhoseini.ir/api/Patients/GetPatients', theBody);
    //
    // if (response.statusCode == 200) {
    //   patientsList = jsonDecode(response.body);
    //   notifyListeners();
    // }

    // Online gadgets list
    try {
      response = await Network()
          .netGet('https://api.iot.davoodhoseini.ir/api/Hub/GetOnlineGadgets');

      if (response.statusCode == 200) {
        onlineGadgets = jsonDecode(response.body);
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }

    // patients Lastest Status
    try {
      response = await Network().netGet(
          'https://api.iot.davoodhoseini.ir/api/Patients/GetPatientLastSituation');

      if (response.statusCode == 200) {
        patientsStatus = jsonDecode(response.body)['data'];
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void OpenSocket() async {
    await socketInstance.connection.start();
  }

  void Initialization() {
    initCall();
    OpenSocket();

    socketInstance.connection.on('SendInfo', (info) {
      socketInstance.connection.invoke('CatchInfo', args: ['Mobile App No. 1']);
    });
    //await connection.invoke('CatchInfo', args: ['Mobile App No. ${Random().nextInt(100)}']);

    socketInstance.connection.on('UpdateOnlineGadgets', (gadgetsUpdate) {
      onlineGadgets = jsonDecode(gadgetsUpdate![0].toString());
      notifyListeners();
    });

    socketInstance.connection.on('OnCriticalConditionHappened', (criticalData) {
      print("tttttttttttttttttttttttttttt start critical condition");
      var temp = jsonDecode(criticalData.toString());
      print(temp.toString());
      navigatorKey.currentState?.pushNamed('/alert',
          arguments: AlertScreen(
            data: temp,
          ));
      print("tttttttttttttttttttttttttttt end critical condition");
    });

    socketInstance.connection.on('PatientSituationUpdated', (newStatus) {
      print("1111111111111111111111111 start PatientSituationUpdated");
      var temp = jsonDecode(newStatus.toString());
      print(temp);
      for (int i = 0; i < temp.length; i++) {
        for (int j = 0; j < patientsStatus.length; j++) {
          if (patientsStatus[j]['patientId'] == temp[i]['patientId']) {
            print("this patient has updates: " + temp[i]['patientName']);
            patientsStatus[j]['pulseOximetry'] = temp[i]['pulseOximetry'];
            patientsStatus[j]['heartBeat'] = temp[i]['heartBeat'];
            patientsStatus[j]['temperature'] = temp[i]['temperature'];
            patientsStatus[j]['lastUpdateTime'] = temp[i]['lastUpdateTime'];
            patientsStatus[j]['lastUpdateDate'] = temp[i]['lastUpdateDate'];
          }
        }
      }
      notifyListeners();
      print("1111111111111111111111111s end PatientSituationUpdated");
    });

    socketInstance.connection.on('SetPatientSituations', (patientsSituation) {
      print("00000000000000000000000000 start SetPatientSituations");
      print(patientsSituation.toString());
      notifyListeners();
      print("00000000000000000000000000 end SetPatientSituations");
    });

    // socketInstance.connection.on('UpdatePatientMonitoring', (patientsMonitor) {
    //   print("///////////////////////// start UpdatePatientMonitoring");
    //   print(patientsMonitor.toString());
    //   print("///////////////////////// end UpdatePatientMonitoring");
    // });
  }
}

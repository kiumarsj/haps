import 'package:flutter/material.dart';
import 'package:healthy_meter/constants.dart';
import 'package:healthy_meter/services/networking.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:healthy_meter/services/data_management.dart';

List<DataRow> myList = List<DataRow>.empty(growable: true);

class GadgetsScreen extends StatelessWidget {
  void makeTableRows(var result) {
    myList.clear();
    for (int i = 0; i < result.length; i++) {
      myList.add(
        DataRow(
          cells: [
            DataCell(
              Text(
                result[i]['deviceName'],
                style: TextStyle(fontFamily: "Vazir", fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            DataCell(
              Text(
                result[i]['connectionId'],
                style: TextStyle(fontFamily: "Vazir", fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }
  }

  Future getGadgets(var result) async {
    http.Response response;
    try {
      response = await Network()
          .netGet('https://api.iot.davoodhoseini.ir/api/Hub/GetOnlineGadgets');

      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
        print(result.toString());
        makeTableRows(result);
      } else {
        throw Exception('Failed to get gadgets list.');
      }
    } catch (e) {
      print(e.toString());
    }
    return myList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: lightColorScheme.primary,
          title: Text("Online Patient's Gadgets"),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: lightColorScheme.onInverseSurface,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  alignment: Alignment.center,
                  child: FutureBuilder(
                    future:
                        getGadgets(context.watch<DataClass>().onlineGadgets),
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
                                "ID",
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
    );
  }
}

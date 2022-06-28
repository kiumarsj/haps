import 'dart:convert';
import 'package:http/http.dart' as http;

class Network {
  Future<http.Response> netGet(uri) async {
    var url = Uri.parse(uri);
    var response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    return response;
  }

  Future<http.Response> netPost(uri, theBody) async {
    var url = Uri.parse(uri);
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: theBody);
    return response;
  }

  Future<void> addPatient() async {
    var url = Uri.parse('https://api.iot.davoodhoseini.ir/api/Patients/Add');
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'firstName': 'Elnaz',
          'lastName': 'Mohammadi',
          'fatherName': 'IDK',
          'nationalCode': "0798421655",
          'age': 28,
          'diseaseId': 3
        }),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print("+++++++++++++++++++++++++++++++ start addPatient api call");
        print(result);
        print("+++++++++++++++++++++++++++++++ end addPatient api call");
      }
    } catch (e) {
      print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      print(e.toString());
      print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    }
  }
}

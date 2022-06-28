import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  Authentication({required this.userName, required this.password});
  final userName;
  final password;

  Future authenticate() async {
    var url = Uri.parse('https://api.iot.davoodhoseini.ir/api/Auth/Login');
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        //body: jsonEncode(<String, String>{'username': 'alirezahoseini', 'password': '123'}),
        body: jsonEncode(
            <String, String>{'username': '$userName', 'password': '$password'}),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print("++++++++++++++++++++++++++++++ start authentication result");
        print(result);
        print("++++++++++++++++++++++++++++++ end authentication result");

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("username", userName);
        prefs.setInt("userId", result['data']['userId']);
        prefs.setString("userDisplay", result['data']['userDisplayName']);
        prefs.setString("userRoleName", result['data']['userRoleName']);
        prefs.setString("userToken", result['data']['token']);
        prefs.setBool("isLoggedIn", true);

        return result['data']['isAuthenticated'];
      } else {
        throw Exception("User Authentication API Call Failed");
      }
    } catch (e) {
      print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  start authentication error');
      print(e);
      print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  end authentication error');
    }
  }
}

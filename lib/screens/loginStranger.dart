import 'package:healthy_meter/constants.dart';
import 'package:flutter/material.dart';
import 'package:healthy_meter/services/authentication.dart';

Widget theProgess = Text("");

class StrangerLogin extends StatefulWidget {
  const StrangerLogin({Key? key}) : super(key: key);

  @override
  State<StrangerLogin> createState() => _StrangerLoginState();
}

class _StrangerLoginState extends State<StrangerLogin> {
  bool _isObscure = true;
  String usernameValue = '';
  String passValue = '';

  @override
  void initState() {
    theProgess = Text("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 30, bottom: 70),
                child: Image.asset(
                  'assets/images/hm.jpg',
                  width: MyDimentions.width(context) / 2.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                ),
                child: TextField(
                  onChanged: (value) {
                    usernameValue = value;
                  },
                  decoration: new InputDecoration(
                    filled: true,
                    hintText: 'Username',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: lightColorScheme.secondary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.only(left: 10, top: 13, bottom: 13),
                    fillColor: Color(0xfff3f4f6),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: Color(0xfff3f4f6),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                ),
                child: TextField(
                  onChanged: (value) {
                    passValue = value;
                  },
                  obscureText: _isObscure,
                  decoration: new InputDecoration(
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: lightColorScheme.secondary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.only(left: 10, top: 13, bottom: 13),
                    fillColor: Color(0xfff3f4f6),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: Color(0xfff3f4f6),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                decoration: BoxDecoration(
                  color: lightColorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        setState(() {
                          theProgess = CircularProgressIndicator();
                        });
                        try {
                          if (usernameValue != '' && passValue != '') {
                            Authentication auth = Authentication(
                                userName: usernameValue, password: passValue);
                            bool result = await auth.authenticate();
                            if (result == true) {
                              theProgess = Text('');
                              Navigator.pushNamed(context, '/main');
                            }
                          } else {
                            theProgess = Text('');
                            print('fileds are empty');
                          }
                        } catch (e) {
                          theProgess = Text('');
                          print(e);
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: theProgess,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MyDimentions.height(context) * 0.2,
              ),
              InkWell(
                child: Center(
                  child: Text(
                    'Made by @kiumarsj',
                    style: TextStyle(
                      color: lightColorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

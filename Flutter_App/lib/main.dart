import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_meter/constants.dart';
import 'package:healthy_meter/screens/alertScreen.dart';
import 'package:healthy_meter/screens/homeScreen.dart';
import 'package:healthy_meter/screens/mainScreen.dart';
import 'package:healthy_meter/screens/patientProfileScreen.dart';
import 'package:healthy_meter/screens/gadgetsScreen.dart';
import 'package:healthy_meter/screens/splashScreen.dart';
import 'package:healthy_meter/screens/userProfileScreen.dart';
import 'package:healthy_meter/services/socket.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthy_meter/screens/loginStranger.dart';
import 'package:healthy_meter/screens/loginFamiliar.dart';
import 'package:provider/provider.dart';
import 'package:healthy_meter/services/data_management.dart';

// defining routes widget
Widget theRoute = StrangerLogin();

Future<void> main() async {
  //checking if user has bees signedIn before or not
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status = prefs.getBool('isLoggedIn') ?? false;
  print('------------------');
  print('isLoggedIn:  $status');
  print('------------------');
  theRoute = (status == true
      ? FamiliarLogin()
      : StrangerLogin()); // and decide to navigate it to correct page
  // runApp(MyApp());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DataClass()..Updater(),
      lazy: false,
      //builder: (context, _) => MyApp(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Healthy Meter',
        theme: ThemeData(
          // here we define app's theme and Locale
          fontFamily: "Vazir",
          primaryColor: lightColorScheme.primary,
          backgroundColor: lightColorScheme.background,
        ),
        // localizationsDelegates: [
        //   GlobalCupertinoLocalizations.delegate,
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        // ],
        // supportedLocales: [
        //   Locale("fa", "IR"),
        // ],
        // locale: Locale("fa", "IR"),
        routes: {
          '/main': (context) => MainScreen(),
          '/loginFamiliar': (context) => FamiliarLogin(),
          '/loginStranger': (context) => StrangerLogin(),
          '/splash': (context) => SplashScreen(),
          '/home': (context) => HomeScreen(),
          '/patient': (context) => GadgetsScreen(),
          '/userProfile': (context) => UserProfileScreen(),
          '/patientProfile': (context) => PatientProfileScreen(),
          '/alert': (context) => AlertScreen(),
        },
        home: theRoute,
      ),
    );
  }
}

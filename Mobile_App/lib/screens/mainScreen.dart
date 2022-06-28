import 'package:flutter/material.dart';
import 'package:healthy_meter/constants.dart';
import 'package:healthy_meter/screens/homeScreen.dart';
import 'package:healthy_meter/screens/userProfileScreen.dart';
import 'package:healthy_meter/screens/gadgetsScreen.dart';
import 'package:healthy_meter/services/data_management.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    GadgetsScreen(),
    UserProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: lightColorScheme.background,
          selectedItemColor: lightColorScheme.primary,
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/images/Home.png")),
              label: "",
              tooltip: "home",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(
                  "assets/images/Swap.png")), //Icons.device_hub_sharp
              label: "",
              tooltip: "patients",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/images/Profile.png")),
              label: "",
              tooltip: "userProfile",
            ),
          ],
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
    );
  }
}

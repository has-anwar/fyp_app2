import 'package:app2/screens/password_screen.dart';
import 'package:app2/utilities/prefs.dart';
import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/profile_screen.dart';
import 'screens/home_screen.dart';
import 'screens/update_profile.dart';
import 'screens/child_screen.dart';
import 'check_login.dart';

void main() => runApp(BMICalculator());

class BMICalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: LoginScreen(),
      // home: MainScreen(),
      // initialRoute: '/',
      routes: {
        '/': (context) => checkLogin(),
        '/login': (context) => LoginScreen(),
        // '/': (context) => LoginScreen(),
        '/main': (context) => MainScreen(),
        '/profile_screen': (context) => ProfileScreen(),
        '/update_profile': (context) => UpdateProfile(),
        '/change_password': (context) => UpdatePassword(),
        '/child_screen': (context) => ChildScreen(),
      },
    );
  }
}

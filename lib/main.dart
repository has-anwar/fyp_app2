import 'package:app2/utilities/prefs.dart';
import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/profile_screen.dart';
import 'screens/home_screen.dart';

void main() => runApp(BMICalculator());

class BMICalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: LoginScreen(),
      // home: MainScreen(),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/main': (context) => MainScreen(),
        '/profile_screen': (context) => ProfileScreen(),
      },
    );
  }
}
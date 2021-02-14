import 'package:app2/screens/password_screen.dart';
import 'package:app2/screens/splash_screen.dart';
import 'package:app2/utilities/constants.dart';
import 'package:app2/utilities/prefs.dart';
import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/profile_screen.dart';
import 'screens/home_screen.dart';
import 'screens/update_profile.dart';
import 'screens/child_screen.dart';
import 'check_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var id = preferences.getInt('parent_id');
  runApp(
    MaterialApp(
      theme: ThemeData(primaryColor: kOrangeColor, cursorColor: kOrangeColor),
      home: id == null ? LoginScreen() : HomeScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        '/profile_screen': (context) => ProfileScreen(),
        '/update_profile': (context) => UpdateProfile(),
        '/change_password': (context) => UpdatePassword(),
        '/child_screen': (context) => ChildScreen(),
      },
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:app2/utilities/prefs.dart';
import 'screens/login.dart';
import 'screens/home_screen.dart';

Widget checkLogin() {
  if (getParentID() != null) {
    return MainScreen();
  } else {
    return LoginScreen();
  }
}

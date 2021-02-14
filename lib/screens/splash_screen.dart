import 'package:app2/screens/home_screen.dart';
import 'package:app2/utilities/logo.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static final id = 'splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async {
    await Future.delayed(Duration(milliseconds: 3000), () {
      navigateToHomeScreen();
    });
  }

  void navigateToHomeScreen() async {
    Navigator.pushReplacementNamed(context, HomeScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(tag: 'tag1', child: Logo()),
      ),
    );
  }
}

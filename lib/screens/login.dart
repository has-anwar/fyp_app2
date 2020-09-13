import 'package:flutter/material.dart';
import 'package:app2/utilities/constants.dart';
import 'package:app2/utilities/reusable_card.dart';
import 'package:app2/utilities/reusable_text_field.dart';
import 'package:app2/resources/bottom_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app2/utilities/prefs.dart';
import 'package:app2/utilities/logo.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final textController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          color: kBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: height * 0.2),
              Center(
                child: Logo(),
              ),
              SizedBox(height: height * 0.1),
              ReusableCard(
                cardChild: ReusableTextField(
                  hint: 'Enter username',
                  icon: Icon(Icons.account_circle),
                  obscureText: false,
                  myController: textController,
                ),
                colour: kTextFieldBackgroundColor,
              ),
              SizedBox(height: height * 0.009),
              ReusableCard(
                cardChild: ReusableTextField(
                  hint: 'Enter password',
                  icon: Icon(Icons.lock),
                  obscureText: true,
                  myController: passwordController,
                ),
                colour: kTextFieldBackgroundColor,
              ),
              SizedBox(height: height * 0.1),
              BottomButton(
                buttonTitle: 'Log In',
                onTap: () async {
                  String username = textController.text;
                  String password = passwordController.text;
                  String path = '/parent_account/$username';
                  var response = await http.post(
                    url + path,
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(
                      <String, String>{'email': username, 'password': password},
                    ),
                  );
                  var userInfo = jsonDecode(response.body);
                  print(userInfo);
                  if (userInfo != null) {
                    setStatus(true);

                    int parentID = userInfo['id'];
                    String name = userInfo['name'];
                    String cnic = userInfo['cnic'];
                    String email = userInfo['email'];

                    setParentID(parentID);
                    setName(name);
                    setEmail(email);
                    setCNIC(cnic);

                    Navigator.popAndPushNamed(context, '/main');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

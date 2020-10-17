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

  final usernameSnackBar = SnackBar(
      content: Text(
    'Incorrect email or password',
    style: TextStyle(
      fontSize: 20.0,
    ),
  ));

  bool checkEmpty() {
    if (textController.text.isEmpty || passwordController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void login(context) async {
    String username = textController.text;
    String password = passwordController.text;
    String path = '/parent_account/$username';
    var response = await http.post(
      kUrl + path,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{'email': username, 'password': password},
      ),
    );
    var userInfo = jsonDecode(response.body);
    if (userInfo['flag'] == true) {
      setStatus(true);
      int parentID = userInfo['id'];
      String name = userInfo['name'];
      String cnic = userInfo['cnic'];
      String email = userInfo['email'];
      String address = userInfo['address'];
      String phone = userInfo['number'];

      setParentID(parentID);
      setName(name);
      setEmail(email);
      setCNIC(cnic);
      setPhoneNumber(phone);
      setAddress(address);

      Navigator.popAndPushNamed(context, '/main');
    } else {
      Scaffold.of(context).showSnackBar(usernameSnackBar);
      setState(() {
        displayErrorLogin();
      });
    }
  }

  final Color errorColor = Colors.red[900];
  Color backgroundColor = kBackgroundColor;

  void displayErrorLogin() {
    backgroundColor = errorColor;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            height: height,
            color: kBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.2),
                Center(
                  child: Logo(),
                ),
                SizedBox(height: height * 0.1),
                Row(
                  children: [
                    SizedBox(width: width * 0.2),
                    Icon(
                      Icons.cancel,
                      color: backgroundColor,
                    ),
                    SizedBox(width: width * 0.04),
                    Text(
                      'Incorrect email or password',
                      style: TextStyle(color: backgroundColor, fontSize: 20.0),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                ReusableCard(
                  cardChild: ReusableTextField(
                    hint: 'example@gmail.com',
                    icon: Icon(Icons.account_circle),
                    obscureText: false,
                    myController: textController,
                  ),
                  colour: kTextFieldBackgroundColor,
                ),
                SizedBox(height: height * 0.009),
                ReusableCard(
                  cardChild: ReusableTextField(
                    hint: 'password',
                    icon: Icon(Icons.lock),
                    obscureText: true,
                    myController: passwordController,
                  ),
                  colour: kTextFieldBackgroundColor,
                ),
                SizedBox(height: height * 0.1),
                Builder(
                  builder: (context) => BottomButton(
                    buttonTitle: 'Log In',
                    onTap: () async {
                      bool flag = checkEmpty();
                      if (flag) {
                        login(context);
                      } else {
                        print('fields cannot be left empty');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

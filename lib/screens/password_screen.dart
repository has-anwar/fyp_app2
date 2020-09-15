import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app2/utilities/constants.dart';
import 'package:app2/utilities/reusable_profile_text_field.dart';
import 'package:app2/utilities/reusable_text_field.dart';
import 'package:app2/utilities/my_drawer.dart';
import 'package:app2/resources/profile_labels.dart';
import 'package:app2/utilities/prefs.dart';
import 'package:http/http.dart' as http;

class UpdatePassword extends StatelessWidget {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool currentFlag = true;
  bool newFlag = true;
  bool confirmFlag = true;

  getUsername() async {
    String username = await getEmail();
    return username;
  }

  void getFlags() {
    if (currentPasswordController.text.isEmpty) {
      currentFlag = false;
    }
    if (newPasswordController.text.isEmpty) {
      newFlag = false;
    }
    if (confirmPasswordController.text.isEmpty) {
      confirmFlag = false;
    }
  }

  confirmCurrentPassword() async {
    String username = await getUsername();
    String path = '/parent_account/password/$username';
    var response = await http.post(
      kUrl + path,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'password': currentPasswordController.text,
          'new': confirmPasswordController.text
        },
      ),
    );
    return response;
  }

  void updatePassword() async {
    getFlags();
    if (currentFlag && newFlag && confirmFlag) {
      if (confirmPasswordController.text == newPasswordController.text) {
        var response = await confirmCurrentPassword();
        print(response);
        var userInfo = jsonDecode(response.body);
        if (userInfo['flag'] == true) {
          print(userInfo);
          print('UPdated');
        } else {
          print(userInfo);
          print('Wrong password');
        }
      } else {
        print('ERROR: WRONG NEW AND CONFIRM PASSWORD');
        //TODO: ERROR MESSAGE WRONG NEW AND CONFIRM PASSWORD
      }
    } else {
      if (!currentFlag) {
        //TODO: EMPTY FIELDS

        print(currentFlag);
        print('Current Empty');
      }
      if (!newFlag) {
        print('New Empty');
      }
      if (!confirmFlag) {
        print('Confirm Empty');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: kOrangeColor),
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.1,
            ),
            ProfileLabelText(label: 'Current Password'),
            ReusableTextField(
              hint: 'Enter current password',
              myController: currentPasswordController,
              obscureText: true,
              icon: Icon(
                Icons.vpn_key,
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            ProfileLabelText(label: 'Enter new Password'),
            ReusableTextField(
              hint: 'Enter new password',
              myController: newPasswordController,
              obscureText: true,
              icon: Icon(
                Icons.vpn_key,
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            ProfileLabelText(label: 'Confirm new Password'),
            ReusableTextField(
              hint: 'Confirm new password',
              myController: confirmPasswordController,
              obscureText: true,
              icon: Icon(
                Icons.vpn_key,
              ),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            ButtonTheme(
              minWidth: 200.0,
              height: 60.0,
              child: RaisedButton(
                padding: EdgeInsets.all(8.0),
                color: Colors.red[900],
                textColor: Colors.white,
                child: Text('Update Password'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                onPressed: () {
                  updatePassword();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

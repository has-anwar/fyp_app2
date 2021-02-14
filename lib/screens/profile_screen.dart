import 'dart:convert';

import 'package:app2/utilities/reusable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:app2/utilities/constants.dart';
import 'package:app2/utilities/my_drawer.dart';
import 'package:app2/utilities/prefs.dart';
import 'package:app2/utilities/user_info.dart';
import 'package:app2/utilities/reusable_card.dart';
import 'package:app2/utilities/reusable_profile_text_field.dart';
import 'package:app2/resources/bottom_button.dart';
import 'package:app2/resources/profile_labels.dart';
import 'package:http/http.dart' as http;
import 'package:app2/resources/my_appbar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var name = 'loading...';
  var email = 'loading...';
  String contactNumber = 'loading...';
  var address = 'loading...';
  var cnic = 'loading...';
  bool isEnabled = false;

  getInfo() async {
    var _name = await getName();
    var _email = await getEmail();
    var _phoneNumber = await getPhoneNumber();
    var _address = await getAddress();
    var _cnic = await getCNIC();

    UserInfo userInfo = UserInfo(
        name: _name,
        email: _email,
        number: _phoneNumber,
        address: _address,
        cnic: _cnic);

    setState(() {
      name = userInfo.name;
      email = userInfo.email;
      contactNumber = userInfo.number;
      address = userInfo.address;
      cnic = userInfo.cnic;
      // print(name);
    });
  }

  Future<bool> updateInfo() async {
    bool _isUpdated = false;
    var _email = await getEmail();
    Map<String, String> map = {'password': 'null', 'email': 'null'};

    String path = '/parent_account/$_email';
    if (emailController.text.isNotEmpty) {
      map['email'] = emailController.text;
      print(map['email']);
      var response = await http.put(kUrl + path, body: map);
      var userEmail = jsonDecode(response.body);
      email = await userEmail['email'];
      _isUpdated = true;
      setState(() {
        setEmail(userEmail['email']);
        emailController.clear();
      });
    } else {
      print('New email not entered');
    }
    var _cnic = await getCNIC();
    var _phone = await getPhoneNumber();
    Map<String, String> map2 = {
      'cnic': '$_cnic',
      'mobile': 'null',
      'address': 'null'
    };

    String path2 = '/parent';

    if (numberController.text.isNotEmpty || addressController.text.isNotEmpty) {
      if (numberController.text.isEmpty) {
        map2['mobile'] = "null";
      } else {
        _isUpdated = true;
        map2['mobile'] = numberController.text;
      }
      if (addressController.text.isEmpty) {
        map2['address'] = "null";
      } else {
        _isUpdated = true;
        map2['address'] = addressController.text;
      }
      var response = await http.put(kUrl + path2, body: map2);
      var userData = jsonDecode(response.body);

      address = await userData['address'];
      contactNumber = await userData["mobile"];
      setState(() {
        setAddress(userData['address']);
        setPhoneNumber(userData['mobile']);
        numberController.clear();
        addressController.clear();
      });
    }
    return _isUpdated;
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  final numberController = TextEditingController();
  final cnicController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    final labelWidthFactor = 0.18;
    final ScrollController _scrollController = ScrollController();

    return Scaffold(
      appBar: MyAppBar(
        title: 'Profile',
      ),
      drawer: MyDrawer(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          // controller: _scrollController,

          // physics: NeverScrollableScrollPhysics(),
          child: SafeArea(
            child: Container(
              height: height,
              // width: ,
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Center(
                    child: Text(
                      '$name',
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 8,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Divider(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height * 0.03,
                      ),
                      // Row(
                      //   children: [
                      //     SizedBox(
                      //       width: width * labelWidthFactor,
                      //     ),
                      //     ProfileLabelText(label: 'Mobile'),
                      //   ],
                      // ),
                      SizedBox(
                        width: width * 0.8,
                        child: ReusableProfileTextField(
                          hint: contactNumber,
                          icon: Icon(
                            Icons.phone_android,
                            size: SizeConfig.safeBlockHorizontal * 5,
                          ),
                          myController: numberController,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      // Row(
                      //   children: [
                      //     SizedBox(
                      //       width: width * 0.18,
                      //     ),
                      //     ProfileLabelText(label: 'E-Mail'),
                      //   ],
                      // ),
                      SizedBox(
                        width: width * 0.8,
                        child: ReusableProfileTextField(
                          hint: '$email',
                          icon: Icon(Icons.alternate_email,
                              size: SizeConfig.safeBlockHorizontal * 5),
                          myController: emailController,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      // Row(
                      //   children: [
                      //     SizedBox(
                      //       width: width * 0.18,
                      //     ),
                      //     ProfileLabelText(label: 'CNIC'),
                      //   ],
                      // ),
                      SizedBox(
                        width: width * 0.8,
                        child: ReusableProfileTextField(
                          icon: Icon(Icons.credit_card,
                              size: SizeConfig.safeBlockHorizontal * 5),
                          hint: '$cnic',
                          enabled: false,
                          myController: cnicController,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      // Row(
                      //   children: [
                      //     SizedBox(
                      //       width: width * 0.18,
                      //     ),
                      //     ProfileLabelText(label: 'Home Address'),
                      //   ],
                      // ),
                      SizedBox(
                        width: width * 0.8,
                        child: ReusableProfileTextField(
                          hint: '$address',
                          icon: Icon(Icons.home,
                              size: SizeConfig.safeBlockHorizontal * 5),
                          myController: addressController,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Builder(builder: (context) {
                    return ButtonTheme(
                      minWidth: 200.0,
                      height: height * 0.07,
                      child: RaisedButton(
                        padding: EdgeInsets.all(8.0),
                        color: kOrangeColor,
                        textColor: Colors.white,
                        child: Text('Update Profile'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                        onPressed: () async {
                          bool isUpdated = await updateInfo();
                          if (isUpdated) {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline_outlined,
                                      color: Colors.yellow,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text('Credentials have been updated')
                                  ],
                                ),
                              ),
                            );
                          } else {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline_outlined,
                                      color: Colors.yellow,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text('No credentials edited to update')
                                  ],
                                ),
                              ),
                            );
                          }
                          // Navigator.pushNamed(context, '/update_profile');
                        },
                      ),
                    );
                  }),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  ButtonTheme(
                    minWidth: 200.0,
                    height: height * 0.07,
                    child: RaisedButton(
                      padding: EdgeInsets.all(8.0),
                      color: Colors.red[900],
                      textColor: Colors.white,
                      child: Text('Change Password'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                      onPressed: () {
                        updateInfo();
                        Navigator.pushNamed(context, '/change_password');
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

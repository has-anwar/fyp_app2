import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app2/utilities/constants.dart';
import 'package:app2/utilities/prefs.dart';
import 'package:app2/utilities/logo.dart';
import 'package:app2/utilities/my_drawer.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  getUserID() async {
    // int token = await getUserToken();
  }

  @override
  void initState() {
    getUserID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //   title: Text('App 2'),
        backgroundColor: kBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: kOrangeColor),
      ),
      drawer: MyDrawer(),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
        color: Color(0xCCCCCC),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Children',
                      style: TextStyle(
                        fontSize: kLabelFontSize,
                        color: kOrangeColor,
                        fontFamily: 'Cormorant_Garamond',
                      ),
                    ),
                    Icon(Icons.search),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(8.0),
                  children: [
                    Card(
                      child: Container(
                        height: 100,
                        // width: 390,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

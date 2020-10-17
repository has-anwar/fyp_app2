import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app2/utilities/constants.dart';
import 'package:app2/utilities/prefs.dart';
import 'package:app2/utilities/logo.dart';
import 'package:app2/resources/children_data.dart';
import 'package:app2/utilities/my_drawer.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:app2/utilities/loading_dialog.dart';

import 'package:app2/resources/my_appbar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var childList = [];
  String fatherName;
  String motherName;

  int _id = 0;
  initializeData() async {
    int id = await getParentID();
    String path = '/childlist/$id';
    var request = await http.get(kUrl + path);
    // print("this is a : ${request.body.runtimeType}");
    setChildren(request.body);
    var temp = await getChildren();
    path = '/parent_info/$id';
    request = await http.get(kUrl + path);
    var data = jsonDecode(request.body);
    // print(data);
    setState(() {
      fatherName = data['father'];
      motherName = data['mother'];
      // print(fatherName);
      // print(motherName);
    });
  }

  getChildrenInfo() async {
    var children = await getChildren();
    var temp = jsonDecode(children)['Children'];
    // print('this shit $temp');
    return temp;
  }

  Future<List<ChildData>> _getChildData() async {
    int id = await getParentID();
    String path = '/childlist/$id';
    var request = await http.get(kUrl + path);
    var jsonData1 = json.decode(request.body);
    path = '/parent_info/$id';
    request = await http.get(kUrl + path);
    var jsonData2 = jsonDecode(request.body);
    List<ChildData> childList = [];

    for (var c in jsonData1['Children']) {
      ChildData childData = ChildData(
          name: c['name'],
          childId: c['child_id'],
          age: c['age'],
          parentId: c['parent_id'],
          fatherName: jsonData2['father'],
          motherName: jsonData2['mother']);
      childList.add(childData);
    }
    return childList;
  }

  @override
  void initState() {
    initializeData();
    getChildrenInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: MyAppBar(
        title: 'Dashboard',
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Center(
          child: Center(
            child: Container(
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
                    myContainer(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget myContainer(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: _getChildData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Container(
            width: width,
            height: height * 0.4,
            child: Center(
              child: CircularProgressIndicator(
                // backgroundColor: kOrangeColor,
                valueColor: AlwaysStoppedAnimation<Color>(kOrangeColor),
              ),
            ),
          );
        } else {
          return Container(
            height: height * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildChildrenCard2(context, index, snapshot.data),
            ),
          );
        }
      },
    );
  }

  Widget buildChildrenCard2(BuildContext context, int index, var data) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String safeGuard = 'onlinevrs';
    final GlobalKey<State> _keyLoader = new GlobalKey<State>();

    return Container(
      child: GestureDetector(
        onTap: () async {
          Dialogs.showLoadingDialog(context, _keyLoader);
          http.Response response = await http.put(
            kUrl + '/child_token',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(
              <String, String>{"id": "${data[index].childId}"},
            ),
          );
          // if (response.statusCode == 200) {
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
          // }
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("${data[index].name}"),
                content: SizedBox(
                  width: width * 0.5,
                  height: height * 0.2,
                  // width: width * 0.5,
                  // height: height * 0.5,
                  child: Center(
                    child: Card(
                      child: QrImage(
                        data:
                            'onlinevrs ${jsonDecode(response.body)["Token"]} onlinevrs',
                        version: QrVersions.auto,
                        size: 200,
                      ),
                    ),
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                      elevation: 5.0,
                      child: Text(
                        "Dismiss",
                        style: TextStyle(color: kOrangeColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
                elevation: 24.0,
                // backgroundColor: kOrangeColor,
              );
            },
            barrierDismissible: false,
          );
          // Navigator.pushNamed(context, '/child_screen', arguments: data[index]);
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(5, 10, 5, 4),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          data[index].name,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Spacer(),
                    ],
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

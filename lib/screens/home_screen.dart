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
import 'package:app2/resources/qr_popup.dart';
import 'package:app2/resources/my_appbar.dart';

class HomeScreen extends StatefulWidget {
  static final String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    print('this shit $temp');
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
          dob: c['dob'],
          parentId: c['parent_id'],
          fatherName: jsonData2['father'],
          motherName: jsonData2['mother']);
      childList.add(childData);
    }
    // for(var child in childList){
    //   print(child.name);
    // }
    return childList;
  }

  @override
  void initState() {
    initializeData();
    // getChildrenInfo();
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
        } else if (snapshot.hasData) {
          return Container(
            height: height * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildChildrenCard2(context, index, snapshot.data),
            ),
          );
        } else {
          return Center(
            child: Text('LOADING'),
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
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
      child: GestureDetector(
        onTap: () async {
          http.Response response = await http.put(
            kUrl + '/child_token',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(
              <String, String>{"id": "${data[index].childId}"},
            ),
          );

          Navigator.pushNamed(context, '/child_screen', arguments: data[index]);
        },
        child: Card(
          // color: Color.fromARGB(255, 10, 17, 40),
          color: Color.fromARGB(255, 224, 221, 207),

          // margin: EdgeInsets.fromLTRB(5, 10, 5, 4),
          elevation: 5.0,
          margin: EdgeInsets.only(left: 6.0, right: 6.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),

          // margin: EdgeInsets.fromLTRB(5, 10, 5, 4),

          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          data[index].name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              kChildDetailCardTextStyle.copyWith(fontSize: 17),
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

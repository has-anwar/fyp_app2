import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app2/utilities/constants.dart';
import 'package:app2/utilities/prefs.dart';
import 'package:app2/utilities/logo.dart';
import 'package:app2/utilities/my_drawer.dart';
import 'package:app2/resources/children_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var childList = [];

  int _id = 0;
  Future<int> getParentId() async {
    int id = await getParentID();
    String path = '/childlist/$id';
    var request = await http.get(kUrl + path);
    // print("this is a : ${request.body.runtimeType}");
    setChildren(request.body);
    var temp = await getChildren();
    // print('Children from prefs: $temp');
    // var childData = jsonDecode(request.body);
    // var _childList = childData['Children'];
    // print(childData);
    // print('Child Data List : ${_childList.length}');
    // print('Child Data List : $_childList');
    // for (int i = 0; i <= _childList.length; i++) {
    //   print(childList[i]);
    // }

    // setState(() {
    //   childList = _childList;
    // });
  }

  final List<ChildData> children = [
    ChildData("Child1", DateTime.now(), 1),
    ChildData("Child2", DateTime.now(), 1),
    ChildData("Child3", DateTime.now(), 1),
    ChildData("Child7", DateTime.now(), 1),
    ChildData("Child7", DateTime.now(), 1),
    ChildData("Child7", DateTime.now(), 1),
    ChildData("Child7", DateTime.now(), 1),
    ChildData("Child7", DateTime.now(), 1),
    ChildData("Child7", DateTime.now(), 1)
  ];

  getChildrenInfo() async {
    var children = await getChildren();
    var temp = jsonDecode(children)['Children'];
    print('this shit $temp');
    return temp;
  }

  @override
  void initState() {
    getParentId();
    getChildrenInfo();

    // var json = getChildrenInfo();
    // childrenFuture = jsonDecode(json);
    // print(childrenFuture);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: kOrangeColor),
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
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
                // Container(
                //   height: height * 0.9,
                //   child: ListView.builder(
                //       shrinkWrap: true,
                //       itemCount: children.length,
                //       itemBuilder: (BuildContext context, int index) =>
                //           buildChildrenCard(context, index)),
                // ),
                myContainer(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myContainer(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return FutureBuilder(
        future: getChildrenInfo(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('NoneNone');
            case ConnectionState.active:
              return Text('Active');
            case ConnectionState.waiting:
              return Text('Waiting');
            case ConnectionState.done:
              // return Text('DOne${snapshot.data.length.toString()}');
              return Container(
                height: height * 0.9,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildChildrenCard2(context, index, snapshot.data)),
              );
            default:
              return Text('default');
          }
        });
  }

  Widget buildChildrenCard2(BuildContext context, int index, var data) {
    // final child = children[index];

    return Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      data[index]['name'].toString(),
                      style: TextStyle(fontSize: 50.0),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(data[index]['dob']),
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChildrenCard(BuildContext context, int index) {
    final child = children[index];

    return Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      child.name,
                      style: TextStyle(fontSize: 50.0),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(child.dob.toString()),
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

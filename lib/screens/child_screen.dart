import 'dart:convert';
import 'dart:developer';

import 'package:app2/main.dart';
import 'package:app2/resources/children_data.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:app2/utilities/constants.dart';
import 'package:app2/utilities/my_drawer.dart';
import 'package:app2/resources/my_appbar.dart';
import 'package:app2/resources/child_info_card.dart';
import 'package:http/http.dart' as http;
import 'package:app2/resources/qr_popup.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ChildScreen extends StatefulWidget {
  ChildScreen({this.childData});
  final ChildData childData;

  @override
  _ChildScreenState createState() => _ChildScreenState();
}

class _ChildScreenState extends State<ChildScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ChildData args = ModalRoute.of(context).settings.arguments;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Future<List<Record>> getRecords() async {
      String path = '/vaccine_records/${args.childId}';

      var response = await http.get(kUrl + path);

      var data = jsonDecode(response.body);
      print('data: $data');
      List<Record> records = [];

      for (var rec in data['Vaccine Records']) {
        Record record =
            Record(rec['vaccine'], rec['doa'], rec['toa'], rec['tor']);
        records.add(record);
      }
      for (var rec in records) {
        print(rec);
      }
      List<Record> reversed_records = records.reversed.toList();
      return reversed_records;
    }

    var _getRecords = getRecords();

    return Scaffold(
      appBar: MyAppBar(title: 'Child Menu'),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kOrangeColor,
        icon: Icon(MdiIcons.qrcode),
        label: Text('Generate QR'),
        onPressed: () async {
          String path = '/child_token';
          http.Response response = await http.put(
            kUrl + path,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, int>{
              'id': args.childId,
            }),
          );
          var data = jsonDecode(response.body);
          log(data["Token"]);
          String token = data["Token"];
          displayQR(context, args.name, token);
        },
      ),
      body: Container(
          width: width,
          child: FutureBuilder(
              future: getRecords(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    height: height * 0.7,
                    child: SimpleDialog(
                      backgroundColor: Colors.white,
                      children: <Widget>[
                        Center(
                          child: Column(
                            children: [
                              LinearProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    kOrangeColor),
                                backgroundColor: Colors.white,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Please Wait....",
                                style: TextStyle(color: kOrangeColor),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  print(snapshot.data.length);
                  return Container(
                    height: height,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: childInfoCard(args),
                        ),
                        // Expanded(child: Text('History')),
                        Expanded(
                          flex: 5,
                          child: ScrollConfiguration(
                            behavior: ScrollBehavior(),
                            child: GlowingOverscrollIndicator(
                              axisDirection: AxisDirection.down,
                              color: kOrangeColor,
                              child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  Record record = snapshot.data[index];
                                  return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Column(
                                        children: [
                                          // Text(record.name),
                                          // Text(record.doa),
                                          // Text(record.toa),
                                          // Text(record.tor)
                                          Card(
                                            margin: EdgeInsets.fromLTRB(
                                                5, 10, 5, 4),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 20, 20, 20),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          record.name,
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  height * 0.02,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  kOrangeColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(
                                                    color: kOrangeColor,
                                                  ),
                                                  Text(
                                                      'Date of administration: ${record.doa}'),
                                                  Text(
                                                      'Time of administration: ${record.toa}'),
                                                  // Text('Re-administration date: ${record.tor??'unspecified'} ')
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ));
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              })),
    );
  }
}

class Record {
  String name;
  String doa;
  String toa;
  String tor;

  Record(this.name, this.doa, this.toa, this.tor);

  void printRecords() {
    print(name);
    print(doa);
    print(toa);
    print(tor);
  }
}

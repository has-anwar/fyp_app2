import 'dart:convert';
import 'dart:developer';

import 'package:app2/main.dart';
import 'package:app2/resources/children_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:app2/utilities/constants.dart';
import 'package:app2/utilities/my_drawer.dart';
import 'package:app2/resources/my_appbar.dart';
import 'package:app2/resources/child_info_card.dart';
import 'package:http/http.dart' as http;
import 'package:app2/resources/qr_popup.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:intl';

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

  bool _isGettingRecords = false;

  @override
  Widget build(BuildContext context) {
    final ChildData args = ModalRoute.of(context).settings.arguments;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Future<List<Record>> getRecords() async {
      setState(() {
        _isGettingRecords = false;
      });
      String path = '/vaccine_records/${args.childId}';

      var response = await http.get(kUrl + path);

      var data = jsonDecode(response.body);
      // print('data: $data');
      List<Record> records = [];

      for (var rec in data['Vaccine Records']) {
        Record record =
            Record(rec['vaccine'], rec['doa'], rec['toa'], rec['dor']);
        records.add(record);
      }
      // for (var rec in records) {
      //   print(rec);
      // }
      List<Record> reversed_records = records.reversed.toList();
      if (mounted)
        setState(() {
          _isGettingRecords = true;
        });
      return reversed_records;
    }

    bool _isLoading = false;
    var _getRecords = getRecords();

    Future<void> onRefresh() async {
      setState(() {});
    }

    return Scaffold(
      appBar: MyAppBar(title: 'Child Screen'),
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
                  // print(snapshot.data.length);
                  return Container(
                    height: height,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: childInfoCard(args),
                        ),
                        // Expanded(child: Text('History')),
                        _isGettingRecords
                            ? CircularProgressIndicator()
                            : Expanded(
                                flex: 5,
                                child: ScrollConfiguration(
                                  behavior: ScrollBehavior(),
                                  child: GlowingOverscrollIndicator(
                                    axisDirection: AxisDirection.down,
                                    color: kOrangeColor,
                                    child: ListView.builder(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        Record record = snapshot.data[index];
                                        return ChildDetailCard(record: record);
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

class ChildDetailCard extends StatelessWidget {
  final Record record;
  ChildDetailCard({@required this.record});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
        child: Column(
          children: [
            Card(
              color: Color.fromARGB(255, 255, 241, 208),
              // margin: EdgeInsets.fromLTRB(5, 10, 5, 4),
              elevation: 5.0,
              margin: EdgeInsets.only(left: 6.0, right: 6.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            record.name,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: height * 0.02,
                              fontWeight: FontWeight.bold,
                              color: kOrangeColor,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: kOrangeColor,
                    ),
                    Row(
                      children: [
                        Text(
                          'Administration Date:   ',
                          style: kChildDetailCardTextStyle,
                        ),
                        Text(
                          '${record.doa}',
                          style: kChildDetailCardTextStyle,
                        ),
                      ],
                    ),
                    // Text(
                    //   'Time of administration:   ${record.toa}',
                    //   style: kChildDetailCardTextStyle,
                    // ),
                    Divider(
                      color: Colors.grey,
                    ),
                    record.tor != 'None'
                        ? Row(
                            children: [
                              Text(
                                'Re-administration Date:    ',
                                style: kChildDetailCardTextStyle.copyWith(
                                    letterSpacing: 0.0),
                              ),
                              Text(
                                '${record.tor == 'None' ? 'None' : record.getDateInFormat()}',
                                style: kChildDetailCardTextStyle,
                              ),
                            ],
                          )
                        : Container(),
                    record.tor != 'None'
                        ? record.getDaysLeft() != null
                            ? Row(
                                children: [
                                  Spacer(),
                                  Icon(
                                    Icons.error_outline,
                                    color: Color.fromARGB(255, 50, 162, 135),
                                    size: 14,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '${record.getDaysLeft()} Day/s Remaining',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color:
                                            Color.fromARGB(255, 50, 162, 135)),
                                  ),
                                ],
                              )
                            : Container()
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ));
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

  getDateInFormat() {
    final DateTime date = DateTime.parse(this.tor);
    DateFormat formatter = DateFormat('dd/MM/yyy');
    final String formatted = formatter.format(date);
    return formatted;
  }

  getDaysLeft() {
    if (this.tor != null) {
      final DateTime date = DateTime.parse(this.tor);
      final DateTime today = DateTime.now();
      int hoursLeft = date.difference(today).inHours;
      final int daysLeft = (hoursLeft / 24).ceil();
      if (daysLeft > 0) return daysLeft.toString();
    }
  }
}

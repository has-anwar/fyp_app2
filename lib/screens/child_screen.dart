import 'package:app2/main.dart';
import 'package:app2/resources/children_data.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:app2/utilities/constants.dart';
import 'package:app2/utilities/my_drawer.dart';

class ChildScreen extends StatefulWidget {
  ChildScreen({this.childData});
  final ChildData childData;

  @override
  _ChildScreenState createState() => _ChildScreenState();
}

class _ChildScreenState extends State<ChildScreen> {
  @override
  Widget build(BuildContext context) {
    final ChildData args = ModalRoute.of(context).settings.arguments;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: kOrangeColor),
      ),
      drawer: MyDrawer(),
      body: Container(
        width: width,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.1,
            ),
            Text(
              args.name,
              style: TextStyle(fontSize: 40.0, color: kOrangeColor),
            ),
            Row(
              children: [
                Text(
                  'Father ',
                  style: TextStyle(fontSize: 20.0, color: kOrangeColor),
                ),
                Text(
                  args.fatherName,
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
            Text(args.motherName),
            SizedBox(
              height: height * 0.05,
            ),
            QrImage(
              data: args.childId.toString(),
              version: QrVersions.auto,
              size: 100.0,
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Text(
              'QR code should read',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Text(
              '${args.childId}',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}

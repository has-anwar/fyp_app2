import 'package:app2/main.dart';
import 'package:app2/resources/children_data.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:app2/utilities/constants.dart';
import 'package:app2/utilities/my_drawer.dart';

class ChildScreen extends StatefulWidget {
  ChildScreen({this.childId});
  final ChildData childId;

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
        // elevation: 0,
        title: Row(
          children: [
            SizedBox(
              width: width * 0.27,
            ),
            Text(
              'QR Code',
              textAlign: TextAlign.center,
              style: TextStyle(color: kOrangeColor),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: kOrangeColor),
      ),
      drawer: MyDrawer(),
      body: Container(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.1,
            ),
            Text(
              args.name,
              style: TextStyle(fontSize: 40.0),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            QrImage(
              data: args.id.toString(),
              version: QrVersions.auto,
              size: 200.0,
            ),
            Container(
              width: width,
              child: Center(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'QR code should read ${args.id}',
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

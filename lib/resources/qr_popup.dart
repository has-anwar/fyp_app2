import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app2/utilities/constants.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';

displayQR(context, data, index, response){

  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  String safeGuard = 'onlinevrs';

  return showDialog(
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
                '$safeGuard ${jsonDecode(response.body)["Token"]} $safeGuard',
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
}
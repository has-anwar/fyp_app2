import 'package:flutter/material.dart';

import 'children_data.dart';

Card childInfoCard(ChildData args) {
  String getAge(ChildData childData) {
    DateTime now = DateTime.now();
    DateTime dob = DateTime.parse(childData.dob);
    int ageInHours = now.difference(dob).inHours;
    if (ageInHours < 17520)
      return '${((ageInHours / 730)).floor()} Months';
    else
      return '${((ageInHours / 730) / 12).floor()} Years';
  }

  double _fontSize = 20.0;
  Color textColor = Color(0xFFF212121);
  Color cardColor = Color(0xFFFE5E5E5);
  return Card(
    // color: cardColor,
    color: Color.fromARGB(255, 224, 221, 207),

    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    margin: EdgeInsets.all(20.0),
    elevation: 7.0,
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 25.0),
          child: Text(
            '${args.name}',
            style: TextStyle(
              fontSize: _fontSize + 5,
              color: Color.fromARGB(255, 8, 103, 136),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Divider(
          color: Color(0xFFFBDBDBD),
        ),
        Padding(
          padding:
              EdgeInsets.only(left: 25.0, top: 0.0, right: 25.0, bottom: 10.0),
          child: Row(
            children: [
              Text(
                'Father\'s name: ${args.fatherName}',
                style: TextStyle(
                    fontSize: _fontSize,
                    color: Color.fromARGB(255, 8, 103, 136),
                    letterSpacing: 0.8),
              ),
            ],
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(left: 25.0, top: 0.0, right: 25.0, bottom: 10.0),
          child: Row(
            children: [
              Text(
                'Mother\'s name: ${args.motherName}',
                style: TextStyle(
                    fontSize: _fontSize,
                    color: Color.fromARGB(255, 8, 103, 136),
                    letterSpacing: 0.3),
              ),
            ],
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(left: 25.0, top: 0.0, right: 25.0, bottom: 10.0),
          child: Row(
            children: [
              Text(
                '${args.name}\'s age: ${getAge(args)}',
                style: TextStyle(
                    fontSize: _fontSize,
                    color: Color.fromARGB(255, 8, 103, 136),
                    letterSpacing: 0.8),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

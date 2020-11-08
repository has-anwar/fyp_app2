import 'package:flutter/material.dart';

Card childInfoCard(args) {
  double _fontSize = 20.0;
  Color textColor = Color(0xFFF212121);
  Color cardColor = Color(0xFFFE5E5E5);
  return Card(
    color: cardColor,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)),
    margin: EdgeInsets.all(20.0),
    elevation: 7.0,
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 25.0),
          child: Text(
            '${args.name}',
            style: TextStyle(
              fontSize: _fontSize + 5,
              color: textColor,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Divider(
          color: Color(0xFFFBDBDBD),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: 25.0,
              top: 0.0,
              right: 25.0,
              bottom: 10.0),
          child: Row(
            children: [
              Text(
                'Father: ${args.fatherName}',
                style: TextStyle(
                  fontSize: _fontSize,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: 25.0,
              top: 0.0,
              right: 25.0,
              bottom: 10.0),
          child: Row(
            children: [
              Text(
                'Mother: ${args.motherName}',
                style: TextStyle(
                  fontSize: _fontSize,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: 25.0,
              top: 0.0,
              right: 25.0,
              bottom: 10.0),
          child: Row(
            children: [
              Text(
                'Age: ${args.age}',
                style: TextStyle(
                  fontSize: _fontSize,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
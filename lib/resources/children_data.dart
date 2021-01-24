import 'package:flutter/material.dart';

class ChildData {
  String name;
  int childId;
  String dob;
  int parentId;
  String fatherName;
  String motherName;

  ChildData({
    @required this.name,
    @required this.childId,
    @required this.dob,
    @required this.parentId,
    @required this.fatherName,
    @required this.motherName,
  });
}

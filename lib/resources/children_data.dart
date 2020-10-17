import 'package:flutter/material.dart';

class ChildData {
  String name;
  int childId;
  int age;
  int parentId;
  String fatherName;
  String motherName;

  ChildData({
    @required this.name,
    @required this.childId,
    @required this.age,
    @required this.parentId,
    @required this.fatherName,
    @required this.motherName,
  });
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

setCNIC(String cnic) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('cnic', cnic);
}

getCNIC() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String cnic = preferences.getString('cnic');
  return cnic;
}

setName(String name) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('name', name);
}

getName() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String name = preferences.getString('name');
  return name;
}

setEmail(String email) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('email', email);
}

getEmail() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String email = preferences.getString('email');
  return email;
}

setParentID(int id) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setInt('parent_id', id);
}

getParentID() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  int parentID = preferences.getInt('parent_id') ?? -1;
  return parentID;
}

setStatus(bool status) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool('status', status);
}

getStatus() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  int parentID = preferences.getInt('status') ?? false;
  return parentID;
}

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
  int parentID = preferences.getInt('parent_id');
  return parentID;
}

setStatus(bool status) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool('status', status);
}

getStatus() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool status = preferences.getBool('status') ?? false;
  return status;
}

setPhoneNumber(int number) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setInt('number', number);
}

getPhoneNumber() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  int phone = preferences.getInt('number');
  return phone;
}

setAddress(String address) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('address', address);
}

getAddress() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String address = preferences.getString('address');
  return address;
}

setPassword(String password) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('password', password);
}

getPassword() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String password = preferences.getString('password');
  return password;
}

setChildren(children) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('children', children);
}

getChildren() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String children = preferences.getString('children');
  return children;
}

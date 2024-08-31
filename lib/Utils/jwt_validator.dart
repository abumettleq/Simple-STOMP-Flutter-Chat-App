import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../Providers/user_provider.dart';
import 'user_data_holder.dart';



class JwtValidator 
{
  JwtValidator._();
  static JwtValidator jwtValidator = JwtValidator._();

  final storage = const FlutterSecureStorage();

  Future<bool> validate() async {
    bool isValid = false;

    String? token = await storage.read(key: 'auth_token');

    final response = await http.post(
      Uri.parse('http://${UserDataHolder.userDataHolder.hostIP}:8080/api/validate'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'token': token,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (!data['success']) {
        const FlutterSecureStorage storage = FlutterSecureStorage();
        await storage.write(key: 'auth_token', value: "");
      }

      Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);

      if(data['success'])
      {
        isValid = true;
        UserDataHolder.userDataHolder.username = data['username'];
        UserProvider().fetchUserId();
      }
    } 
    else {
      Fluttertoast.showToast(
          msg: "An error ocurred.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return isValid;
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nova_messenger/Providers/user_provider.dart';

import '../Utils/user_data_holder.dart';

class LoginProvider with ChangeNotifier {
  GlobalKey<FormState> loginKey = GlobalKey();
  TextEditingController userIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? userIDValidator(String? value) {
    if (value!.isEmpty) {
      return 'Required *';
    } else if (value.length < 4) {
      return 'Your ID Must be at least 4 digits';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Required *';
    } else if (value.length < 8) {
      return 'Your Password must be at least 8 characters';
    }
    return null;
  }

  Future<bool> login() async {
    bool isTrue = false;

    final response = await http.post(
      Uri.parse('http://${UserDataHolder.userDataHolder.hostIP}:8080/api/authenticate'),
      headers: <String, String>{
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': '*/*'
      },
      body: {
        'username': userIDController.text,
        'password': passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success']) {
        const FlutterSecureStorage storage = FlutterSecureStorage();
        final String token =
            data['token']; // Assuming the token is in the 'token' field
        await storage.write(key: 'auth_token', value: token);

        UserDataHolder.userDataHolder.username = userIDController.text;
        UserProvider().fetchUserId();

        isTrue = true;
      }

      Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "An error ocurred.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    notifyListeners();
    return isTrue;
  }
}

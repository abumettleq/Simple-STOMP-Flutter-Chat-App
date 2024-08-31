import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../Utils/user_data_holder.dart';

class UserProvider with ChangeNotifier
{
  Future<void> fetchUserId() async
  {
    final response = await http.post(
      Uri.parse('http://${UserDataHolder.userDataHolder.hostIP}:8080/api/fetch-user-id'),
      headers: <String, String>{
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': '*/*'
      },
      body: {
        'username': UserDataHolder.userDataHolder.username
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success']) {
        UserDataHolder.userDataHolder.userId = data['userId'];
      }

    }
    else{
      debugPrint("Failed to fetch userId.");
    }
    notifyListeners();
  }
}
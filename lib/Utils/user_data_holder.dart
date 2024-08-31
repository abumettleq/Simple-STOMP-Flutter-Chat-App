import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class UserDataHolder 
{
  UserDataHolder._();
  static UserDataHolder userDataHolder = UserDataHolder._();

  String username = "";
  int userId = 0;
  String hostIP = "";

  BuildContext? msgContext;

  void detectPlatform() {
  if (kIsWeb) {
    hostIP = "localhost";
  } else if (Platform.isAndroid) {
    hostIP = "10.0.2.2";
  }
}

}
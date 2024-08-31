import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import '../../Animation/page_animation.dart';

class AppRouter {
  static GlobalKey<NavigatorState> navKey = GlobalKey();
  static pushToWidget(Widget widget) async {
    Navigator.of(navKey.currentContext!)
        .push(MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }

  static pushWithReplacementToWidget(Widget widget) {
    Navigator.of(navKey.currentContext!)
        .pushReplacement(MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }

  static pop() {
    Navigator.of(navKey.currentContext!).pop();
  }

  static pushWithAnimation(Widget widget) {
    Navigator.push(
        navKey.currentContext!, PageAnimation(widget, Alignment.centerLeft));
  }

  static showErrorSnackBar(String title, String message) {
    ScaffoldMessenger.of(navKey.currentContext!)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        content: AwesomeSnackbarContent(
            title: title, message: message, contentType: ContentType.failure),
      )
    );
  }

  static showSnackBar(String title, String message) =>
      ScaffoldMessenger.of(navKey.currentContext!)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          content: AwesomeSnackbarContent(
              title: title, message: message, contentType: ContentType.success),
        )
  );
}
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class Popups {
  static void toast({required String msg, Color bgColor = Colors.red}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: bgColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

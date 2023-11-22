import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
    textColor: Colors.white,
    webBgColor: '#2697FF',
    fontSize: 16.0,
    timeInSecForIosWeb: 6,
  );
}

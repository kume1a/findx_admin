import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

void showDialog() {
  SmartDialog.show(builder: (context) {
    return Container(
      height: 80,
      width: 180,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: const Text(
        'easy custom dialog',
        style: TextStyle(color: Colors.white),
      ),
    );
  });
}

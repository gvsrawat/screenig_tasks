import 'package:flutter/material.dart';

class SharedWidgets {
  static SharedWidgets _instance;

  SharedWidgets._init();

  factory SharedWidgets() {
    if (_instance == null) {
      _instance = SharedWidgets._init();
    }
    return _instance;
  }

  Widget button(
      Function onTap, String buttonText, double buttonWidth, double screenWidth,
      {Color buttonColor}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: buttonColor ?? Colors.green,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        width: buttonWidth,
        height: screenWidth * 8,
        child: Center(
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: screenWidth * 4),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ResponsiveText {
  static double _baseHeight = 640.0; // base height you designed for

  static double getFontSize(BuildContext context, double fontSize) {
    double screenHeight = MediaQuery.of(context).size.height;
    return (fontSize / _baseHeight) * screenHeight;
  }
}

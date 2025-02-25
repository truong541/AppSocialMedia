import 'package:flutter/material.dart';

class MyContainer {
  static double defaultWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double defaultHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double height30(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.3; // 30% chiều cao màn hình
  }
}

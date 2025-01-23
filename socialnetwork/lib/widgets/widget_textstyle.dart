import 'package:flutter/material.dart';

class MyTextstyle {
  static const TextStyle textSmall = TextStyle(
    fontSize: 15,
    color: Colors.black,
  );

  static const TextStyle textMedium = TextStyle(
    fontSize: 18,
    color: Colors.black,
  );

  static const TextStyle textLarge = TextStyle(
    fontSize: 22,
    color: Colors.black,
  );

  static const TextStyle textSmall_ = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static const TextStyle textMedium_ = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static const TextStyle textLarge_ = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static const TextStyle textMedium_White = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  String formatNumber(String input) {
    // Chuyển chuỗi thành số
    int number = int.tryParse(input) ?? 0;

    if (number >= 1000000000) {
      // Hàng tỷ (B)
      double billions = number / 1000000000;
      return "${billions.toStringAsFixed(billions.truncateToDouble() == billions ? 0 : 1)} B";
    } else if (number >= 1000000) {
      // Hàng triệu (M)
      double millions = number / 1000000;
      return "${millions.toStringAsFixed(millions.truncateToDouble() == millions ? 0 : 1)} M";
    } else {
      // Giữ nguyên
      return number.toString();
    }
  }
}

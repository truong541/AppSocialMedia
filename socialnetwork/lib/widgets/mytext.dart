import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyTextStyle {
  static TextStyle textSmall(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontSize: 15,
          color: Theme.of(context).colorScheme.onSurface,
        );
  }

  static TextStyle textMedium(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontSize: 18,
          color: Theme.of(context).colorScheme.onSurface,
        );
  }

  static TextStyle textLarge(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontSize: 22,
          color: Theme.of(context).colorScheme.onSurface,
        );
  }

  static TextStyle textSmall_(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        );
  }

  static TextStyle textMedium_(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        );
  }

  static TextStyle textLarge_(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        );
  }
  // static TextStyle textSmallGrey(BuildContext context) {
  //   return Theme.of(context).textTheme.headlineLarge!.copyWith(
  //         fontSize: 13,
  //         color: Theme.of(context).colorScheme.onSurface,
  //       );
  // }

  static const TextStyle textMediumWhite = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static const TextStyle textSmallGrey = TextStyle(
    fontSize: 13,
    color: Color(0xff888888),
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

  String getTimeAgo(String dateTimeString) {
    String formattedDateTime =
        dateTimeString.replaceAll('T', ' ').replaceAll('Z', '');
    final dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    final parsedDate = dateFormat.parse(formattedDateTime);
    final currentTime = DateTime.now();
    final difference = currentTime.difference(parsedDate);

    if (difference.inSeconds < 60) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays < 30) {
      return "${difference.inDays} days ago";
    } else if (difference.inDays < 365) {
      return "${(difference.inDays / 30).floor()} months ago";
    } else {
      return "${(difference.inDays / 365).floor()} years ago";
    }
  }

  String capitalize(String text) {
    if (text.isEmpty) return "";
    return text[0].toUpperCase() + text.substring(1);
  }

  String toLowerCaseFirstLetter(String input) {
    List<String> words = input.split(' ');
    List<String> modifiedWords = words.map((word) {
      return word.toLowerCase();
    }).toList();
    return modifiedWords.join(' ');
  }

  String toChangeVN(String input) {
    return utf8.decode(input.runes.toList());
  }
}

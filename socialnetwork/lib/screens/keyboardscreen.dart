import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class KeyboardScreen extends StatefulWidget {
  const KeyboardScreen({super.key});

  @override
  State<KeyboardScreen> createState() => _KeyboardScreenState();
}

class _KeyboardScreenState extends State<KeyboardScreen> {
  final List<List<String>> keyRows = [
    ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
    ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
    ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
    ['⇧', 'z', 'x', 'c', 'v', 'b', 'n', 'm', '⌫'],
    ['.', 'Space', '-', '\''],
  ];

  TextEditingController controller = TextEditingController();
  bool isUppercase = false;
  Timer? _deleteTimer;
  final Map<String, bool> _pressedKeys = {};
  final exampleText =
      "My friend is very strong. He can lift up the table himself."; // Chuỗi ví dụ
  List<String> allowedKeys = []; // Các phím được phép nhấn

  @override
  void initState() {
    super.initState();
    allowedKeys = exampleText.toLowerCase().split('');

    List<String> allChars =
        List.generate(26, (index) => String.fromCharCode(97 + index));
    List<String> availableChars =
        allChars.where((char) => !allowedKeys.contains(char)).toList();
    Random random = Random();
    int requiredCount = 5;

    // Kiểm tra nếu có đủ ký tự trong availableChars để thêm
    if (availableChars.length < requiredCount) {
      requiredCount = availableChars.length;
    }
    // Thêm các ký tự ngẫu nhiên vào mảng
    for (int i = 0; i < requiredCount; i++) {
      String randomChar = availableChars[random.nextInt(availableChars.length)];
      allowedKeys.add(randomChar);
      availableChars.remove(randomChar);
    }

    allowedKeys.add('.');
    allowedKeys.add('-');
    allowedKeys.add('\'');
    allowedKeys.add('⇧');
    allowedKeys.add('⌫');
    allowedKeys.add('Space');
  }

  void _onKeyPress(String key) {
    final text = controller.text;
    final selection = controller.selection;
    final cursorPos = selection.start;

    setState(() {
      if (key == '⌫') {
        if (cursorPos > 0) {
          controller.text =
              text.substring(0, cursorPos - 1) + text.substring(cursorPos);
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: cursorPos - 1),
          );
        }
      } else if (key == 'Space') {
        controller.text =
            '${text.substring(0, cursorPos)} ${text.substring(cursorPos)}';
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: cursorPos + 1),
        );
      } else if (key == '⇧') {
        setState(() {
          isUppercase = !isUppercase;
        });
      } else {
        final newChar = isUppercase ? key.toUpperCase() : key;
        final hasKey = allowedKeys.contains(key.toLowerCase());
        if (hasKey) {
          controller.text = text.substring(0, cursorPos) +
              newChar +
              text.substring(cursorPos);
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: cursorPos + 1),
          );
          return;
        }
      }
    });
  }

  void _onDeleteHold() {
    _deleteTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _onKeyPress('⌫');
    });
  }

  void _onDeleteRelease() {
    if (_deleteTimer != null) {
      _deleteTimer?.cancel();
      _deleteTimer = null; // Hủy bỏ Timer
    }
  }

  @override
  Widget build(BuildContext context) {
    final double paddingKeyboard = 3;
    final fullWidth = MediaQuery.of(context).size.width - paddingKeyboard;
    final screenWidth = fullWidth / 10 - paddingKeyboard;
    final secondWidth = (fullWidth - screenWidth) / 9 - paddingKeyboard;
    final spaceKeyWidth = (fullWidth / 2) - paddingKeyboard * 3;
    // double heightKey =
    //     constraints.maxWidth > 600 ? 500 : constraints.maxWidth * 0.9;

    return Scaffold(
        appBar: AppBar(
          title: Text('Keyboard'),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(exampleText),
                    TextFormField(
                      controller: controller,
                      readOnly: true,
                      autofocus: true,
                      showCursor: true, // Hiện con trỏ
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Input',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(paddingKeyboard),
                decoration: BoxDecoration(color: Colors.grey[800]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: keyRows.map((keyrow) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: paddingKeyboard),
                      child: Row(
                        spacing: paddingKeyboard,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: keyrow.map((item) {
                          final hasItem =
                              allowedKeys.contains(item.toLowerCase());
                          return GestureDetector(
                            onLongPress: item == '⌫' ? _onDeleteHold : null,
                            onLongPressUp:
                                item == '⌫' ? _onDeleteRelease : null,
                            onTapDown: (_) {
                              setState(() {
                                _pressedKeys[item] = true; // Xóa viền khi nhấn
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                _pressedKeys[item] = false;
                                _onKeyPress(item);
                                // Hiện lại viền sau khi nhả
                              });
                            },
                            onTapCancel: () {
                              setState(() {
                                _pressedKeys[item] =
                                    false; // Đảm bảo viền trở lại khi hủy nhấn
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              height: constraints.maxWidth > 600
                                  ? screenWidth * 0.6
                                  : screenWidth * 1.1,
                              width: item == '⇧' || item == '⌫'
                                  ? secondWidth * 1.47
                                  : item == 'Space'
                                      ? spaceKeyWidth
                                      : item == '.' ||
                                              item == '-' ||
                                              item == '\''
                                          ? spaceKeyWidth / 3
                                          : keyRows[0].isNotEmpty &&
                                                  keyRows[1].isNotEmpty
                                              ? screenWidth
                                              : secondWidth,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: hasItem || item == 'Space'
                                    ? Colors.grey[600]
                                    : Colors.grey[800],
                                borderRadius: BorderRadius.circular(6.0),
                                border: hasItem || item == 'Space'
                                    ? Border(
                                        bottom: BorderSide(
                                          color: (_pressedKeys[item] ?? false)
                                              ? Colors.transparent
                                              : Colors.white,
                                          width: 2.0,
                                        ),
                                      )
                                    : null,
                              ),
                              child: Text(
                                item == 'Space'
                                    ? ' '
                                    : isUppercase
                                        ? item.toUpperCase()
                                        : item,
                                style: TextStyle(
                                  fontSize: constraints.maxWidth > 600
                                      ? screenWidth / 3
                                      : screenWidth / 2,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        }));
  }
}

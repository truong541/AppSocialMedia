import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socialnetwork/utils/gettoken.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    int userId = 28;
    updateUserStatusOnLogin(userId, true);
  }

  @override
  void dispose() {
    int userId = 28;
    updateUserStatusOnLogin(userId, false);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      int userId = 28;
      updateUserStatusOnLogin(userId, false);
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> updateUserStatusOnLogin(int userId, bool bool) async {
    final accessToken = await GetToken().getAccessToken();
    final response = await http.patch(
      Uri.parse('http://10.0.2.2:8000/account/status/$userId/'), // API URL
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'is_active': bool
      }), // Đặt trạng thái người dùng là active khi vào ứng dụng
    );

    if (response.statusCode == 200) {
      print('User is now active.');
    } else {
      print('Failed to update user status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

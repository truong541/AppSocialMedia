import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:socialnetwork/utils/gettoken.dart';

class LogoutService {
  // API logout
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = await GetToken().getAccessToken();
    final refreshToken = prefs.getString('refresh_token');

    if (accessToken == null || refreshToken == null) {
      return;
    }

    final url = Uri.parse('http://10.0.2.2:8000/account/logout/');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        await prefs.remove('access_token');
        await prefs.remove('refresh_token');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout successful')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.body)),
        );
        print(response.body);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during logout: $e')),
      );
    }
  }
}

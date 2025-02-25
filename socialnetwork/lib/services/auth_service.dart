import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialnetwork/screens/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:socialnetwork/services/api_service.dart';

class AuthService {
  final String baseUrl = "http://10.0.2.2:8000/account";
  Future<bool> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login/"); // Endpoint login

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', data['access_token']);
        await prefs.setString('refresh_token', data['refresh_token']);

        return true;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message']);
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<void> registerAccount(Map<String, dynamic>? body) async {
    final endpoint = ApiEndpoints.register;
    final response = await ApiService().request(
        endpoint: endpoint, method: 'POST', body: body, includeAuth: false);
    if (response == null) {
      print("Registration failed: No response from server.");
      return;
    }
    print(response);
    final prefs = await SharedPreferences.getInstance();
    if (response.containsKey('access_token') &&
        response.containsKey('refresh_token')) {
      await prefs.setString('access_token', response['access_token']);
      await prefs.setString('refresh_token', response['refresh_token']);
      print("Registration successful: Tokens saved.");
    } else {
      print("Registration response does not contain tokens: $response");
    }
  }

  Future<void> loginAccount(Map<String, dynamic>? body) async {
    final endpoint = ApiEndpoints.login;
    final response = await ApiService().request(
        endpoint: endpoint, method: 'POST', body: body, includeAuth: false);
    final prefs = await SharedPreferences.getInstance();
    if (response.containsKey('access_token') &&
        response.containsKey('refresh_token')) {
      await prefs.setString('access_token', response['access_token']);
      await prefs.setString('refresh_token', response['refresh_token']);
      print("Registration successful: Tokens saved.");
    } else {
      print("Registration response does not contain tokens: $response");
    }
  }

  signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? account = await GoogleSignIn().signIn();
    if (account == null) return null; // Người dùng hủy đăng nhập
    final GoogleSignInAuthentication gAuth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      final url = 'http://10.0.2.2:8000/account/google-login/';
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            'idGoogle': user.uid,
            'email': user.email,
            'username': user.displayName,
            'profileImage': user.photoURL,
            // Thêm thông tin khác nếu cần
          }));
      if (response.statusCode == 201 || response.statusCode == 200) {
        _showMessage(context, 'User created successfully!');
        return true;
      } else {
        _showMessage(context, 'Login failed!');
        return false;
      }
    }

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> signOut(BuildContext context) async {
    try {
      // Đăng xuất khỏi Firebase
      await FirebaseAuth.instance.signOut();

      // Đăng xuất khỏi Google
      await GoogleSignIn().signOut();

      // Quay lại trang đăng nhập sau khi đăng xuất
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen()), // Trang LoginPage
      );

      print("User signed out successfully!");
    } catch (e) {
      print("Error during sign out: $e");
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socialnetwork/screens/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
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

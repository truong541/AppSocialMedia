import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialnetwork/screens/loginscreen.dart';
import 'package:socialnetwork/screens/navscreen.dart';
import 'package:socialnetwork/utils/gettoken.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Kiểm tra xem người dùng đã đăng nhập hay chưa
  Future<void> _checkLoginStatus() async {
    final token = await GetToken().getAccessToken();

    // Kiểm tra xem token có tồn tại hay không
    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavBottomScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Loading...'), // Hiển thị loading trong khi kiểm tra
      ),
    );
  }
}

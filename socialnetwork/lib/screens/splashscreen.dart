import 'package:flutter/material.dart';
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

  // Kiểm tra trạng thái login của người dùng
  Future<void> _checkLoginStatus() async {
    final accessToken = await GetToken().getAccessToken();

    // Sử dụng Future.delayed để đợi trước khi điều hướng
    await Future.delayed(
        const Duration(seconds: 2)); // Tùy chọn, có thể là thời gian loading

    // Điều hướng đến trang tương ứng
    if (accessToken != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavBottomScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
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

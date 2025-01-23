import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:socialnetwork/components/dialog_announce.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with WidgetsBindingObserver {
  final user = FirebaseAuth.instance.currentUser;
  Future<void> checkConnection(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/account/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': 'test123',
          'email': 'tuducvv@example.com',
          'password': 'password123',
          'password2': 'password1234',
        }),
      );

      if (response.statusCode == 201) {
        // Nếu server trả về status 200 (OK), kết nối thành công
        // ignore: use_build_context_synchronously
        dialogAnnounce(context, 'Thông báo', 'Tạo tài khoản thành công');
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        String message = responseBody['error'];
        // ignore: use_build_context_synchronously
        dialogAnnounce(context, 'Thông báo', message);
      }
    } catch (e) {
      // Xử lý lỗi nếu không thể kết nối
      print('Lỗi kết nối: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    int userId = 2;
    updateUserStatusOnLogin(userId, true);
  }

  @override
  void dispose() {
    int userId = 2;
    updateUserStatusOnLogin(userId, false);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      int userId = 2;
      updateUserStatusOnLogin(userId, false);
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> updateUserStatusOnLogin(int userId, bool bool) async {
    final response = await http.patch(
      Uri.parse('http://10.0.2.2:8000/account/status/$userId/'), // API URL
      headers: {'Content-Type': 'application/json'},
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
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Account'),
        // ),
        // body: Column(
        //   children: [
        //     Text(user?.displayName ?? ''),
        //     Text(user?.email ?? ''),
        //     Image.network(
        //       user?.photoURL ?? '',
        //       width: 100,
        //       height: 100,
        //     ),
        //     InkWell(
        //       onTap: () {
        //         checkConnection(context);
        //       },
        //       child: Text('Test connection'),
        //     ),
        //     InkWell(
        //       onTap: () async {
        //         await FirebaseAuth.instance.signOut();
        //         GoogleSignIn().signOut();
        //       },
        //       child: Text('Đăng Xuất'),
        //     ),
        //     ShaderMask(
        //       shaderCallback: (bounds) {
        //         return LinearGradient(colors: [
        //           Color(0xFFA8C3BC), // Opal Light Blue (Xanh da trời sáng)
        //           Color(0xFFF0FFFF), // Azure (Xanh nhạt)
        //           Color(0xFFD2B5C4), // Opal Light Pink (Hồng nhạt)
        //         ]).createShader(bounds);
        //       },
        //       blendMode: BlendMode.srcATop,
        //       child: Image.asset(
        //         'assets/icon/tick.png',
        //         width: 200,
        //         height: 200,
        //       ),
        //     ),
        //   ],
        // ),
        );
  }
}

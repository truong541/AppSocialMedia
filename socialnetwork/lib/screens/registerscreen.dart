import 'package:flutter/material.dart';
import 'package:socialnetwork/components/EditText.dart';
import 'package:socialnetwork/screens/navscreen.dart';
import 'package:socialnetwork/widgets/widget_textstyle.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isRegistered = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/account/register/'), // Thay URL backend
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'password2': confirmPasswordController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['access_token']);
      await prefs.setString('refresh_token', data['refresh_token']);

      setState(() {
        _isRegistered = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful!')),
      );
    } else {
      final error = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error['error'] ?? 'Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ĐĂNG KÝ TÀI KHOẢN MỚI', style: MyTextstyle.textLarge_),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                EditText(
                  controller: usernameController,
                  labelText: 'Username',
                  radius: 30,
                ),
                SizedBox(height: 20),
                EditText(
                  controller: emailController,
                  labelText: 'Email address',
                  radius: 30,
                ),
                SizedBox(height: 20),
                EditText(
                  controller: passwordController,
                  labelText: 'Password',
                  radius: 30,
                ),
                SizedBox(height: 20),
                EditText(
                  controller: confirmPasswordController,
                  labelText: 'Re-enter password',
                  radius: 30,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!_isRegistered) {
                        await _register(); // Gọi API đăbbbng ký
                      }

                      // Nếu đã đăng ký thành công, chuyển trang
                      if (_isRegistered) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NavBottomScreen()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                        backgroundColor: Colors.blueAccent),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Register',
                            style: MyTextstyle.textMedium_White,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

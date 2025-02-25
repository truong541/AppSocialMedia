import 'package:flutter/material.dart';
import 'package:socialnetwork/components/edit_text.dart';
import 'package:socialnetwork/components/responsive.dart';
import 'package:socialnetwork/screens/navscreen.dart';
import 'package:socialnetwork/services/auth_service.dart';
import 'package:socialnetwork/widgets/mytext.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _selectedGender = 'male';
  bool _isLoading = false;
  bool _isRegistered = false;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });

    await AuthService().registerAccount({
      'fullname': fullnameController.text,
      'username': usernameController.text,
      'gender': _selectedGender,
      'email': emailController.text,
      'password': passwordController.text,
      'password2': confirmPasswordController.text
    });
    setState(() {
      _isLoading = false;
      _isRegistered = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registration successful!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ĐĂNG KÝ TÀI KHOẢN MỚI',
            style: MyTextStyle.textLarge_(context)),
      ),
      body: IndexResponsive(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                EditText(
                  controller: fullnameController,
                  labelText: 'Fullname',
                  radius: 30,
                ),
                SizedBox(height: 20),
                EditText(
                  controller: usernameController,
                  labelText: 'Username',
                  radius: 30,
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    ListTile(
                      title: Text('Nam'),
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: Radio<String>(
                          value: 'male',
                          groupValue: _selectedGender,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Nữ'),
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: Radio<String>(
                          value: 'female',
                          groupValue: _selectedGender,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                EditText(
                  controller: emailController,
                  labelText: 'Email address',
                  keyboardType: TextInputType.emailAddress,
                  radius: 30,
                ),
                SizedBox(height: 20),
                EditText(
                  controller: passwordController,
                  labelText: 'Password',
                  radius: 30,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                EditText(
                  controller: confirmPasswordController,
                  labelText: 'Re-enter password',
                  radius: 30,
                  obscureText: !_isConfirmPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!_isRegistered) {
                        await _register();
                      }
                      if (_isRegistered) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NavBottomScreen()),
                          (Route<dynamic> route) => false,
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
                            style: MyTextStyle.textMediumWhite,
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

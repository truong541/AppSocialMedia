import 'package:flutter/material.dart';
import 'package:socialnetwork/components/button.dart';
import 'package:socialnetwork/screens/navscreen.dart';
import 'package:socialnetwork/screens/registerscreen.dart';
import 'package:socialnetwork/services/auth_service.dart';

import 'package:socialnetwork/widgets/mytext.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  Future<void> handleLogin() async {
    setState(() {
      _emailError =
          emailController.text.isEmpty ? "Email cannot be empty" : null;
      _passwordError =
          passwordController.text.isEmpty ? "Password cannot be empty" : null;
    });
    if (_emailError != null || _passwordError != null) return;
    setState(() {
      _isLoading = true;
    });
    await AuthService().loginAccount(
        {"email": emailController.text, "password": passwordController.text});
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => NavBottomScreen()),
      (Route<dynamic> route) => false,
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth =
              constraints.maxWidth > 600 ? 500 : constraints.maxWidth * 0.9;

          return Center(
            child: Container(
              width: maxWidth,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icon/main.png', // Replace with your logo link
                      height: 100,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Smarted Leaning.'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.blue,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 32),
                    SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              errorText: _emailError,
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^\S+@\S+\.\S+\$').hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password Input
                          TextFormField(
                            controller: passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              errorText: _passwordError,
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock),
                              prefixIconColor: Color(0xFFFF5733),
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
                          ),
                          const SizedBox(height: 24),

                          // Login Button
                          ElevatedButton(
                            onPressed: handleLogin,
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 48),
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text('Login'),
                          ),
                        ])),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Nếu chưa có tài khoản?  ',
                          style: MyTextStyle.textSmall(context),
                        ),
                        ButtonText(
                          onTapped: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()),
                            );
                          },
                          text: 'Đăng ký',
                          colorText: Colors.blueAccent,
                          isBold: true,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('OR'),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),

                    //Google Login Button
                    ButtonAccount(
                      text: 'Đăng nhập với google',
                      onPressed: () async {
                        // UserCredential? userCredential =
                        //     await AuthService().signInWithGoogle(context);
                        // if (userCredential == null) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //         content: Text("Sign in failed or canceled")),
                        //   );
                        // } else {
                        //   Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => NavBottomScreen()),
                        //   );
                        // }
                        bool isSignedIn =
                            await AuthService().signInWithGoogle(context);
                        if (isSignedIn) {
                          // Chuyển đến trang HomePage sau khi đăng nhập thành công

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NavBottomScreen()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Sign in thanh cong")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Sign in failed or canceled")),
                          );
                        }
                      },
                      imageUrl: 'assets/icon/google.png',
                    ),
                    // GoogleSignInPage(),
                    const SizedBox(height: 16),

                    // Facebook Login Button
                    ButtonAccount(
                      text: 'Đăng nhập với Facebook',
                      onPressed: () {},
                      imageUrl: 'assets/icon/facebook.png',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

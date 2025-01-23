import 'package:flutter/material.dart';
import 'package:socialnetwork/widgets/widget_textstyle.dart';
import 'package:socialnetwork/utils/gettoken.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Map<String, dynamic>? userInfo = {};
  @override
  void initState() {
    super.initState();
    _fetchAndPrintUserInfo();
  }

  Future<void> _fetchAndPrintUserInfo() async {
    try {
      final response = await GetToken().getUserCurrent();
      setState(() {
        userInfo = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit My Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Username: ${userInfo!['username']}'),
            GestureDetector(
              onTap: () {},
              child: Center(
                child: Column(
                  children: [
                    ClipOval(
                      child: Image.network(
                          'https://nuoccat.vn/wp-content/uploads/2023/05/thien-nhien-la-gi-2.jpeg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover),
                    ),
                    Text(
                      'Edit avatar',
                      style: MyTextstyle.textSmall_,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

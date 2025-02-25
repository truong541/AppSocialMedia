import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socialnetwork/components/bottom_sheet.dart';
import 'package:socialnetwork/components/button_info.dart';
import 'package:socialnetwork/components/edit_avatar.dart';
import 'package:socialnetwork/screens/editusertextscreen.dart';
import 'package:socialnetwork/widgets/mytext.dart';
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
    setState(() {
      fetchAndPrintUserInfo();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      fetchAndPrintUserInfo();
    });
  }

  Future<void> fetchAndPrintUserInfo() async {
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
    String? fullname = userInfo!['fullname'];
    String decodedUsername = utf8.decode((fullname?.runes.toList()) ?? []);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit My Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  ShowBottomSheet().showBottomSheet(context, 0.5, EditAvatar());
                },
                child: Center(
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.network(
                            userInfo!['avatar'] ??
                                'https://media.tarkett-image.com/large/TH-Aquarelle_Wall_HFS-Stone_Light_Grey.jpg',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover),
                      ),
                      Text(
                        'Edit avatar',
                        style: MyTextStyle.textSmall_(context),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ButtonInfo(
                title: 'Your name',
                content: MyTextStyle().toChangeVN(userInfo!['fullname'] ?? ''),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditUserTextScreen(
                              content: userInfo!['fullname'],
                            )),
                  );
                },
              ),
              ButtonInfo(
                title: 'Username',
                content: userInfo!['username'] ?? '',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditUserTextScreen(
                              content: userInfo!['username'],
                              isUsername: true,
                            )),
                  );
                },
              ),
              ButtonInfo(
                title: 'Gender',
                content: userInfo!['gender'] ?? '',
                onTap: () {},
              ),
              ButtonInfo(
                title: 'Bio',
                content: userInfo!['bio'] ?? '',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditUserTextScreen(
                              content: userInfo!['bio'] ?? '',
                              isBio: true,
                            )),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

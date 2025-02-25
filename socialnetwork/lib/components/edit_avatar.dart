import 'package:flutter/material.dart';
import 'package:socialnetwork/components/custom_icon.dart';
import 'package:socialnetwork/utils/gettoken.dart';
import 'package:socialnetwork/widgets/mytext.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditAvatar extends StatefulWidget {
  const EditAvatar({super.key});

  @override
  State<EditAvatar> createState() => _EditAvatarState();
}

class _EditAvatarState extends State<EditAvatar> {
  File? imageFile;
  Map<String, dynamic>? userInfo = {};

  @override
  void initState() {
    super.initState();
    fetchAndPrintUserInfo();
  }

  Future<void> fetchAndPrintUserInfo() async {
    try {
      final response = await GetToken().getUserCurrent();
      setState(() {
        userInfo = response;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      await updateUserInfo();
    }
  }

  Future<void> updateUserInfo() async {
    final accessToken = await GetToken().getAccessToken();
    final url = Uri.parse("http://10.0.2.2:8000/account/edit-user/");
    var request = http.MultipartRequest("PATCH", url);
    request.headers["Authorization"] = "Bearer $accessToken";

    // Nếu có ảnh mới, thêm ảnh vào request
    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "avatar",
          imageFile!.path,
          filename: basename(imageFile!.path), // Lấy tên file gốc
        ),
      );
    }

    // Gửi request
    var response = await request.send();

    if (response.statusCode != 200) {
      print('Thất bại');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: imageFile != null
              ? FileImage(imageFile!)
              : NetworkImage(userInfo!['avatar'] ?? '') as ImageProvider,
        ),
        ListTile(
          leading: CustomIcon(
              icon: 'avatar_gallery.png', color: 0xff000000, width: 35),
          title: Text(
            'Chọn từ thư viện',
            style: MyTextStyle.textLarge(context),
          ),
          onTap: () {
            pickImage(ImageSource.gallery);
          },
        ),
        ListTile(
          leading: CustomIcon(
              icon: 'avatar_camera.png', color: 0xff000000, width: 35),
          title: Text(
            'Chụp ảnh',
            style: MyTextStyle.textLarge(context),
          ),
          onTap: () {
            pickImage(ImageSource.camera);
          },
        ),
      ],
    );
  }
}

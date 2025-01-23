import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
// import 'package:dio/dio.dart';
// import 'dart:convert';
import 'dart:io';

import 'package:socialnetwork/utils/gettoken.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (!mounted) return;
    setState(() {
      _selectedImages.addAll(images);
    });
  }

  Future<void> _submitPost() async {
    const String apiUrl = "http://10.0.2.2:8000/post/create-post/";

    try {
      final resUser = await GetToken().getUserCurrent();
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['user'] =
          resUser!['idUser'].toString(); // User ID (cho sẵn)
      request.fields['content'] = _contentController.text;

      // Thêm từng ảnh vào request
      for (var image in _selectedImages) {
        request.files.add(await http.MultipartFile.fromPath(
          'uploaded_images', // Tên key trong API
          image.path,
        ));
      }

      // Gửi request
      var response = await request.send();
      if (!mounted) return;
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Post created successfully!"),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to create post."),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước đó
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: "Content"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImages,
              child: Text("Pick Images"),
            ),
            SizedBox(height: 16),
            Wrap(
              children: _selectedImages.map((image) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.file(
                    File(image.path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}

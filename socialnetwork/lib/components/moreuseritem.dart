import 'package:flutter/material.dart';
import 'package:socialnetwork/components/button.dart';
import 'package:socialnetwork/utils/gettoken.dart';
import 'package:socialnetwork/widgets/mytext.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MoreUserItem extends StatefulWidget {
  final Map<String, dynamic> list;
  const MoreUserItem({super.key, required this.list});

  @override
  State<MoreUserItem> createState() => _MoreUserItemState();
}

class _MoreUserItemState extends State<MoreUserItem> {
  bool _isLoading = false;
  bool isStatus = false;
  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });
    final accessToken = await GetToken().getAccessToken();
    final list = widget.list;

    final response = await http.post(
      Uri.parse(
          'http://10.0.2.2:8000/account/follow/${list['idUser'].toString()}/'), // Thay URL backend
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      setState(() {
        isStatus = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã theo dõi!')),
      );
    } else {
      final error = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error['error'] ?? 'Follow failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.list;
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.network(
                {list['profileImage']}.isEmpty
                    ? 'http://127.0.0.1:8000/${list['profileImage']}'
                    : 'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              list['username'],
              style: MyTextStyle.textMedium(context),
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ButtonNormal(
                    onTapped: () {
                      _register();
                    },
                    text: isStatus ? 'Followed' : 'Follow',
                    radius: 50,
                  ),
          ],
        ),
      ),
    );
  }
}

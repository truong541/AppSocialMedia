import 'package:flutter/material.dart';
import 'package:socialnetwork/utils/gettoken.dart';
import 'package:socialnetwork/widgets/mytext.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ButtonLike extends StatefulWidget {
  final int text;
  final int id;
  final bool isLiked;
  const ButtonLike(
      {super.key, required this.text, required this.id, required this.isLiked});

  @override
  State<ButtonLike> createState() => _ButtonLikeState();
}

class _ButtonLikeState extends State<ButtonLike> {
  late int numLike;
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    numLike = widget.text;
    isLiked = widget.isLiked;
  }

  Future<void> likePost() async {
    final accessToken = await GetToken().getAccessToken();

    final response = await http.post(
      Uri.parse(
          'http://10.0.2.2:8000/post/like/${widget.id}/'), // Thay URL backend
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 201) {
      setState(() {
        numLike++;
        isLiked = !isLiked;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã thích!')),
      );
    } else if (response.statusCode == 204) {
      setState(() {
        numLike--;
        isLiked = !isLiked;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã hủy thích!')),
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
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            likePost();
          },
          child: Image.asset(
            isLiked ? 'assets/icon/liked.png' : 'assets/icon/like.png',
            width: 28,
          ),
        ),
        SizedBox(width: 5),
        Text(
          numLike.toString(),
          style: MyTextStyle.textSmall(context),
        ),
      ],
    );
  }
}

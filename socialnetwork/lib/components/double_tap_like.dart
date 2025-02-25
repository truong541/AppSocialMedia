import 'package:flutter/material.dart';
import 'package:socialnetwork/components/carousel_images.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socialnetwork/utils/gettoken.dart';

class DoubleTapLike extends StatefulWidget {
  // final Widget child;
  final List<Map<String, dynamic>> images;
  final int idPost;

  const DoubleTapLike({super.key, required this.images, required this.idPost});

  @override
  State<DoubleTapLike> createState() => _DoubleTapLikeState();
}

class _DoubleTapLikeState extends State<DoubleTapLike> {
  bool _isHeartVisible = false;

  void _onDoubleTap() async {
    final accessToken = await GetToken().getAccessToken();

    final response = await http.post(
      Uri.parse(
          'http://10.0.2.2:8000/post/only-like/${widget.idPost}/'), // Thay URL backend
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 201 || response.statusCode == 204) {
      setState(() {
        _isHeartVisible = true;
      });

      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _isHeartVisible = false;
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã thích bài viết này!')),
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
    return GestureDetector(
      onDoubleTap: _onDoubleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CarouselImages(
            images: widget.images,
          ),
          AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: _isHeartVisible ? 1.0 : 0.0,
            child: Icon(
              Icons.favorite,
              color: Colors.white,
              size: 100,
            ),
          ),
        ],
      ),
    );
  }
}

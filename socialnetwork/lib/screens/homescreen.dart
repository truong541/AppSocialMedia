import 'package:flutter/material.dart';
import 'package:socialnetwork/components/post_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> listPost = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse('http://10.0.2.2:8000/post/list-posts/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          listPost = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Social Network',
          style: TextStyle(fontSize: 22),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Icon(Icons.comment_bank),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listPost.length,
              itemBuilder: (context, index) {
                final post = listPost[index];
                // return PostItem(post: post);
                return PostItem(post: post);
              },
            ),
    );
  }
}

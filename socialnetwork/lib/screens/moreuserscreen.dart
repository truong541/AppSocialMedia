import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:socialnetwork/components/moreuseritem.dart';
import 'package:socialnetwork/utils/gettoken.dart';

class MoreUserScreen extends StatefulWidget {
  const MoreUserScreen({super.key});

  @override
  State<MoreUserScreen> createState() => _MoreUserScreenState();
}

class _MoreUserScreenState extends State<MoreUserScreen> {
  List<dynamic> listUser = [];
  bool _isLoading = false;
  Future<void> fetchUsers() async {
    try {
      final resUser = await GetToken().getUserCurrent();
      final accessToken = await GetToken().getAccessToken();

      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:8000/account/list-user-by-id/${resUser!['idUser'].toString()}/'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          listUser = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: listUser.map(
                (list) {
                  return MoreUserItem(list: list);
                },
              ).toList(),
            ),
    );
  }
}

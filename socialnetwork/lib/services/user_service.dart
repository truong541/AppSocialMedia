import 'dart:convert';

import 'package:socialnetwork/models/info_user.dart';
import 'package:http/http.dart' as http;
import 'package:socialnetwork/utils/gettoken.dart';

class UserService {
  final String baseUrl = "http://10.0.2.2:8000/account";

  Future<InfoUserModel?> infoUser(int idUser) async {
    final accessToken = await GetToken().getAccessToken();
    final url = Uri.parse('$baseUrl/detail/$idUser/');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return InfoUserModel.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to load user: ${response.statusCode}');
      return null;
    }
  }
}

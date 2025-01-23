import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class GetToken {
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final refreshToken = prefs.getString('refresh_token');
    if (accessToken != null) {
      if (JwtDecoder.isExpired(accessToken)) {
        print('Access token đã hết hạn, làm mới...');
        return _refreshAccessToken(refreshToken);
      } else {
        print('Access token còn hợp lệ.');
        return accessToken;
      }
    } else {
      print('Không tìm thấy access token, làm mới...');
      return _refreshAccessToken(refreshToken);
    }
  }

  Future<String?> _refreshAccessToken(String? refreshToken) async {
    if (refreshToken == null) {
      print('Không tìm thấy refresh token.');
      return null;
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/account/token/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newAccessToken = data['access'];
      final newRefreshToken = data['refresh'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', newAccessToken);
      if (newRefreshToken != null) {
        await prefs.setString('refresh_token', newRefreshToken);
      }

      print('Access token mới đã được cập nhật.');
      return newAccessToken;
    } else {
      print('Lỗi khi làm mới token: ${response.statusCode}, ${response.body}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserCurrent() async {
    try {
      final token = await getAccessToken();
      if (token == null) {
        print('Không có access token.');
        return null;
      }

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/account/current-user/'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Lỗi API: ${response.statusCode}, ${response.body}');
        return null;
      }
    } catch (e) {
      print('Lỗi trong quá trình lấy dữ liệu: $e');
      return null;
    }
  }
}

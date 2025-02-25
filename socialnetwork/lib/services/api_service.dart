import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';
import 'package:socialnetwork/utils/gettoken.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8000";

  static Future<Map<String, String>> getHeaders(
      {bool includeAuth = true, bool isMultipart = false}) async {
    final headers = <String, String>{};
    if (!isMultipart) {
      headers['Content-Type'] = 'application/json';
    }

    if (includeAuth) {
      final accessToken = await GetToken().getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';
    }

    return headers;
  }

  Future<T?> request<T>({
    required String endpoint,
    required String method, // "GET", "POST", "PUT", "DELETE"
    Map<String, File>? files,
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson, // Chỉ cần khi có phản hồi JSON
    bool includeAuth = true,
    bool isMultipart = false,
  }) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = await getHeaders(isMultipart: isMultipart);
    http.Response response;
    try {
      if (isMultipart) {
        var request = http.MultipartRequest(method, url);
        request.headers.addAll(headers);

        if (files != null) {
          for (var entry in files.entries) {
            request.files.add(await http.MultipartFile.fromPath(
              entry.key,
              entry.value.path,
              filename: basename(entry.value.path),
            ));
          }
        }

        body?.forEach((key, value) {
          request.fields[key] = value.toString();
        });

        var streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        response = await _sendRequest(method, url, headers, body);
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (fromJson != null) {
          return fromJson(jsonDecode(response.body));
        }
        return jsonDecode(response.body);
      } else {
        print('Error ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e) {
      print("Request failed: $e");
      return null;
    }
  }

  Future<http.Response> _sendRequest(String method, Uri url,
      Map<String, String> headers, Map<String, dynamic>? body) async {
    switch (method) {
      case "GET":
        return await http.get(url, headers: headers);
      case "POST":
        return await http.post(url, headers: headers, body: jsonEncode(body));
      case "PUT":
        return await http.put(url, headers: headers, body: jsonEncode(body));
      case "DELETE":
        return await http.delete(url, headers: headers);
      default:
        throw UnsupportedError("Unsupported method: $method");
    }
  }
}

class ApiEndpoints {
  //Auth
  static const String register = "account/register/";
  static const String login = "account/login/";
  //Post
  static const String listPost = "post/list-posts/";
  static const String listPostByUser = "post/list-by-user/{id}/";
  static const String createPost = "post/create-post/";
  //Comment
  static const String listComment = "comment/list/{id}/";
  static const String createComment = "comment/create/{id}/";
  static const String deleteComment = "comment/delete/{id}/";
  static const String editComment = "comment/edit/{id}/";
  //Respond Comment
  static const String listRespondComment = "comment/respond/list/{id}/";
  static const String createRespondComment =
      "comment/respond/create/{id1}/{id2}/";
  //Like Comment
  static const String countLikeComment = "comment/like/list/{id}/";
  static const String statusLikeComment = "comment/like/status/{id}/";
  static const String likeUnlikeComment = "comment/like-unlike/{id}/";
  //Follow
  static const String listUnfollowedUser = "account/list-unfollowed-user/{id}";
  static const String followUser = "account/follow-user/{id}/";
  static const String followStatus = "account/follow-status/{id}/";
  //Message
  static const String createMessage = "message/create/{id}/";
  static const String listMessage = "message/list-message/{id}/";
  static const String listChatUser = "message/list-user/";
}

// String endpoint = ApiEndpoints.getUser.replaceFirst("{id}", idUser.toString());

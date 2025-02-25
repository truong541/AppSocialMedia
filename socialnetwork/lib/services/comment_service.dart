import 'package:socialnetwork/services/api_service.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class CommentService {
  Future<List<dynamic>> listComment(int idPost) async {
    final endpoint =
        ApiEndpoints.listComment.replaceFirst('{id}', idPost.toString());
    final response =
        await ApiService().request(endpoint: endpoint, method: 'GET');
    return response ?? [];
  }

  Future<void> createComment(int idPost, Map<String, dynamic>? body) async {
    final endpoint =
        ApiEndpoints.createComment.replaceFirst('{id}', idPost.toString());
    final response = await ApiService()
        .request(endpoint: endpoint, method: 'POST', body: body);
    return response;
  }

  Future<void> editComment(int idComment, Map<String, dynamic>? body) async {
    final endpoint =
        ApiEndpoints.createComment.replaceFirst('{id}', idComment.toString());
    final response = await ApiService()
        .request(endpoint: endpoint, method: 'PUT', body: body);
    return response;
  }

  Future<void> deleteComment(int idComment) async {
    final endpoint =
        ApiEndpoints.deleteComment.replaceFirst('{id}', idComment.toString());
    final response =
        await ApiService().request(endpoint: endpoint, method: 'DELETE');
    return response;
  }

  Future<Map<String, dynamic>?> likeUnlikeComment(int idComment) async {
    final endpoint = ApiEndpoints.likeUnlikeComment
        .replaceFirst('{id}', idComment.toString());
    final response = await ApiService()
        .request(endpoint: endpoint, method: 'POST', body: {});
    return response;
  }

  // Future<void> editComment(int idComment, String newContent) async {
  //   final accessToken = await GetToken().getAccessToken();
  //   final response = await http.put(
  //     Uri.parse('$baseUrl/comment/edit/$idComment/'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $accessToken',
  //     },
  //     body: jsonEncode({'content': newContent}),
  //   );

  //   if (response.statusCode == 200) {
  //     return;
  //   } else {
  //     final error = jsonDecode(response.body);
  //     throw Exception(error['message']);
  //   }
  // }

  // Future<bool> deleteComment(int idComment) async {
  //   final accessToken = await GetToken().getAccessToken();
  //   final response = await http.delete(
  //     Uri.parse('$baseUrl/comment/delete/$idComment/'),
  //     headers: {
  //       'Authorization': 'Bearer $accessToken',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     return true;
  //   } else {
  //     final error = jsonDecode(response.body);
  //     throw Exception(error['message']);
  //   }
  // }
}

class CommentWebSocket {
  final WebSocketChannel channel;

  CommentWebSocket(int idPost)
      : channel = WebSocketChannel.connect(
          Uri.parse('ws://10.0.2.2:8000/ws/comment/$idPost/'),
        );

  Stream<dynamic> get commentsStream =>
      channel.stream.map((event) => jsonDecode(event));

  void dispose() {
    channel.sink.close();
  }
}

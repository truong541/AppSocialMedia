import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socialnetwork/utils/gettoken.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class CommentLikeService {
  Future<int> getLikeCount(int commentId) async {
    final accessToken = await GetToken().getAccessToken();
    final url =
        Uri.parse('http://10.0.2.2:8000/comment/count-like/$commentId/');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['like_count'];
    } else {
      throw Exception('Failed to load like count');
    }
  }

  Future<String> statusLikeByUser(int commentId) async {
    final accessToken = await GetToken().getAccessToken();
    final url = Uri.parse(
        'http://10.0.2.2:8000/comment/status-like-by-user/$commentId/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return data['status'];
    } else {
      throw Exception('Failed to load like count');
    }
  }

  Future<void> likeComment(int commentId) async {
    final accessToken = await GetToken().getAccessToken();
    final url =
        Uri.parse('http://10.0.2.2:8000/comment/like-unlike/$commentId/');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode != 201 && response.statusCode != 204) {
      print(jsonDecode(response.body));
    }
  }
}

class LikeWebSocketService {
  final WebSocketChannel channel;

  LikeWebSocketService(int idComment)
      : channel = WebSocketChannel.connect(
          Uri.parse('ws://10.0.2.2:8000/ws/comment/likes/$idComment/'),
        );

  void listenForUpdates(Function(int) onLikeCountUpdated) {
    channel.stream.listen((message) {
      final data = json.decode(message);
      final likeCount = data['like_count'];
      onLikeCountUpdated(likeCount);
    });
  }

  void close() {
    channel.sink.close(status.normalClosure);
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:socialnetwork/models/viewed_user.dart';
import 'package:socialnetwork/utils/gettoken.dart';
import 'package:http/http.dart' as http;

class ViewedUserService {
  final String baseUrl = "http://10.0.2.2:8000/account";

  Future<void> createViewedUser(int idUser) async {
    final accessToken = await GetToken().getAccessToken();
    final response = await http.post(
      Uri.parse('$baseUrl/viewed-user/create/$idUser/'),
      headers: {
        // 'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }

  Future<List<ViewedUser>> listViewedUser() async {
    final accessToken = await GetToken().getAccessToken();
    final url = Uri.parse("$baseUrl/viewed-user/");
    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        // return json.decode(response.body);
        List<dynamic> jsonData = json.decode(response.body);
        List<ViewedUser> viewedUsers =
            jsonData.map((data) => ViewedUser.fromJson(data)).toList();

        return viewedUsers;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message']);
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}

class ViewedUserWebSocket {
  WebSocket? socket;
  ViewedUserWebSocket._(this.socket);

  static Future<ViewedUserWebSocket> connect() async {
    final accessToken = await GetToken().getAccessToken();
    final url = 'ws://10.0.2.2:8000/ws/viewed-user/';

    final socket = await WebSocket.connect(
      url,
      headers: {
        "Authorization": "Bearer $accessToken"
      }, // Gửi token qua headers
    );

    return ViewedUserWebSocket._(socket);
  }

  Stream<dynamic> get viewedUserStream =>
      socket!.asBroadcastStream().map((event) {
        print("WebSocket: Nhận sự kiện $event");
        return jsonDecode(event);
      });

  void dispose() {
    socket?.close();
  }
}
// class ViewedUserWebSocket {
//   final WebSocketChannel channel;

//   ViewedUserWebSocket()
//       : channel = WebSocketChannel.connect(
//           Uri.parse('ws://10.0.2.2:8000/ws/viewed-user/'),
//         );

//   Stream<dynamic> get viewedUserStream => channel.stream.map((event) {
//         print("WebSocket: Nhận sự kiện $event");
//         return jsonDecode(event);
//       });

//   void dispose() {
//     channel.sink.close();
//   }
// }

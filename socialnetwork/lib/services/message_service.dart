import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:socialnetwork/models/chat_user.dart';
import 'package:socialnetwork/utils/gettoken.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:socialnetwork/services/api_service.dart';

class MessageService {
  Future<void> createMessage(int idUser, Map<String, dynamic>? body,
      {File? image}) async {
    final endpoint =
        ApiEndpoints.createMessage.replaceFirst('{id}', idUser.toString());
    Map<String, File>? files;
    if (image != null) {
      files = {'image': image};
    }
    final response = await ApiService().request(
        endpoint: endpoint,
        method: 'POST',
        body: body,
        files: files,
        isMultipart: true);
    return response;
  }

  Future<List<dynamic>> getMessages(int idUser) async {
    final endpoint =
        ApiEndpoints.listMessage.replaceFirst('{id}', idUser.toString());
    final response =
        await ApiService().request(endpoint: endpoint, method: 'GET');
    return response ?? [];
  }

  Future<List<ChatUser>> listChatUser() async {
    final endpoint = ApiEndpoints.listChatUser;
    final response =
        await ApiService().request(endpoint: endpoint, method: 'GET');
    if (response != null && response is List) {
      return response.map((json) => ChatUser.fromJson(json)).toList();
    }
    return [];
  }
}

class MessageWebSocketService {
  // WebSocketChannel? _channel;

  // Future<void> connect() async {
  //   final token = await GetToken().getAccessToken();
  //   if (token == null) return;

  //   _channel = WebSocketChannel.connect(
  //     Uri.parse("ws://10.0.2.2:8000/ws/chat/?token=$token"),
  //   );

  //   _channel!.stream.listen((message) {
  //     print("📩 Nhận từ WebSocket: $message");
  //   }, onError: (error) {
  //     print("❌ Lỗi WebSocket: $error");
  //   }, onDone: () {
  //     print("🔌 WebSocket đã đóng");
  //   });
  // }
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _streamController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _streamController.stream;

  Future<void> connect() async {
    final token = await GetToken().getAccessToken();
    print(token);
    if (token == null) return;

    _channel = WebSocketChannel.connect(
      Uri.parse("ws://10.0.2.2:8000/ws/chat/?token=$token"),
    );

    _channel!.stream.listen((message) {
      print("📩 Nhận từ WebSocket: $message");

      var data = jsonDecode(message);
      if (data["type"] == "chat_message") {
        print("✅ Đẩy tin nhắn vào StreamController: ${data["message"]}");
        _streamController.add(data["message"]);
      }
    }, onError: (error) {
      print("❌ Lỗi WebSocket: $error");
    }, onDone: () {
      print("🔌 WebSocket đã đóng");
    });
  }

  void disconnect() {
    _channel?.sink.close();
    _streamController.close();
  }
}

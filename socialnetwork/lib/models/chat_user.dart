import 'package:socialnetwork/models/last_message.dart';

class ChatUser {
  final int idUser;
  final String fullname;
  final String username;
  final String avatar;
  final LastMessage lastMessage;

  ChatUser({
    required this.idUser,
    required this.fullname,
    required this.username,
    required this.avatar,
    required this.lastMessage,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      idUser: json["idUser"],
      fullname: json["fullname"] ?? "",
      username: json["username"] ?? "",
      avatar: json["avatar"] ?? "",
      lastMessage: LastMessage.fromJson(json["last_message"] ?? {}),
    );
  }
}

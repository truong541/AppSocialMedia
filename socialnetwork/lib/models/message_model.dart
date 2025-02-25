class MessageModel {
  final int idMessage;
  final int sender;
  final int receiver;
  final String content;
  final String image;
  final bool isRead;
  final bool isDeleted;
  final String createdAt;

  MessageModel({
    required this.idMessage,
    required this.sender,
    required this.receiver,
    required this.content,
    required this.image,
    required this.isRead,
    required this.isDeleted,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      idMessage: json['idMessage'] ?? 0,
      sender: json["sender"] ?? 0,
      receiver: json["receiver"] ?? 0,
      content: json["content"] ?? "",
      image: json["image"] ?? "",
      isRead: json["isRead"] ?? false,
      isDeleted: json["isDeleted"] ?? false,
      createdAt: json["createdAt"] ?? "",
    );
  }
}

class LastMessage {
  final String content;
  final String? image;
  final String createdAt;
  final bool isRead;
  final bool isDeleted;

  LastMessage({
    required this.content,
    required this.image,
    required this.createdAt,
    required this.isRead,
    required this.isDeleted,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      content: json["content"] ?? "",
      image: json["image"],
      createdAt: json["createdAt"] ?? "",
      isRead: json["isRead"] ?? false,
      isDeleted: json["isDeleted"] ?? false,
    );
  }
}

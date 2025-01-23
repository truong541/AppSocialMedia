class Comment {
  final String urlUser;
  final String name;
  final String comment;
  final String liked;
  final bool isAuthor;
  final List<Comment> replies;

  Comment({
    required this.urlUser,
    required this.name,
    required this.comment,
    required this.liked,
    required this.isAuthor,
    required this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      urlUser: json['urlUser'],
      name: json['name'],
      comment: json['comment'],
      liked: json['liked'],
      isAuthor: json['isAuthor'] == "true",
      replies: json['reply'] != null
          ? (json['reply'] as List<dynamic>)
              .map((e) => Comment.fromJson(e))
              .toList()
          : [], // Trường hợp nếu 'reply' là null, trả về danh sách rỗng
    );
  }
}

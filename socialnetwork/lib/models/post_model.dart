import 'package:socialnetwork/models/media_model.dart';
import 'package:socialnetwork/models/user.dart';

class PostModel {
  final int idPost;
  final UserModel user;
  final String content;
  final int likeCount;
  final String commentCount;
  final bool isLiked;
  final MediaModel url;
  final String createdAt;

  PostModel({
    required this.idPost,
    required this.user,
    required this.content,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
    required this.url,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      idPost: json['idUser'] ?? 0,
      user: UserModel.fromJson(json["user"] ?? {}),
      content: json["content"] ?? "",
      likeCount: json["like_count"] ?? 0,
      commentCount: json["comment_count"] ?? 0,
      isLiked: json["isLiked"] ?? false,
      url: MediaModel.fromJson(json["url"] ?? {}),
      createdAt: json["createdAt"] ?? "",
    );
  }
}

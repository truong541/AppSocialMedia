import 'dart:convert';

class InfoUserModel {
  final int idUser;
  final String fullname;
  final String username;
  final String gender;
  final String email;
  final String avatar;
  final String? bio;
  final int followersCount;
  final int followingCount;
  final int postsCount;

  InfoUserModel({
    required this.idUser,
    required this.fullname,
    required this.username,
    required this.gender,
    required this.email,
    required this.avatar,
    this.bio,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
  });

  // Convert JSON to Object
  factory InfoUserModel.fromJson(Map<String, dynamic> json) {
    return InfoUserModel(
      idUser: json['idUser'] ?? 0,
      fullname: json['fullname'],
      username: json['username'],
      gender: json['gender'],
      email: json['email'],
      avatar: json['avatar'],
      bio: json['bio'],
      followersCount: json['followers_count'],
      followingCount: json['following_count'],
      postsCount: json['posts_count'],
    );
  }

  // Convert Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'fullname': fullname,
      'username': username,
      'gender': gender,
      'email': email,
      'avatar': avatar,
      'bio': bio,
      'followers_count': followersCount,
      'following_count': followingCount,
      'posts_count': postsCount,
    };
  }

  // Convert JSON String to Object
  static InfoUserModel fromJsonString(String jsonString) {
    return InfoUserModel.fromJson(jsonDecode(jsonString));
  }

  // Convert Object to JSON String
  String toJsonString() {
    return jsonEncode(toJson());
  }
}

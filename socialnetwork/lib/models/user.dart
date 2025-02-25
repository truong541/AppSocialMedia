import 'dart:convert';

class UserModel {
  final int idUser;
  final String fullname;
  final String username;
  final String gender;
  final String email;
  final String avatar;
  final String? bio;

  UserModel({
    required this.idUser,
    required this.fullname,
    required this.username,
    required this.gender,
    required this.email,
    required this.avatar,
    this.bio,
  });

  // Convert JSON to Object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['idUser'] ?? 0,
      fullname: json['fullname'],
      username: json['username'],
      gender: json['gender'],
      email: json['email'],
      avatar: json['avatar'],
      bio: json['bio'],
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
    };
  }

  // Convert JSON String to Object
  static UserModel fromJsonString(String jsonString) {
    return UserModel.fromJson(jsonDecode(jsonString));
  }

  // Convert Object to JSON String
  String toJsonString() {
    return jsonEncode(toJson());
  }
}

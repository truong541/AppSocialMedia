class ViewedUser {
  final int idViewedUser;
  final Map<String, dynamic> user;
  final int idViewer;
  final String createdAt;

  ViewedUser(
      {required this.idViewedUser,
      required this.user,
      required this.idViewer,
      required this.createdAt});

  factory ViewedUser.fromJson(Map<String, dynamic> json) {
    return ViewedUser(
      idViewedUser: json['idViewedUser'],
      user: json['user'],
      idViewer: json['idViewer'],
      createdAt: json['createdAt'],
    );
  }
}

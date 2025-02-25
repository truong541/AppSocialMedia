class MediaModel {
  final int idMedia;
  final String url;
  final String createdAt;

  MediaModel({
    required this.idMedia,
    required this.url,
    required this.createdAt,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      idMedia: json['idMedia'] ?? 0,
      url: json["url"] ?? "",
      createdAt: json["createdAt"] ?? "",
    );
  }
}

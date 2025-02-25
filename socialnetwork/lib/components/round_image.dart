import 'package:flutter/material.dart';

class RoundImage extends StatelessWidget {
  final String? image;
  final double size;
  const RoundImage({super.key, required this.image, this.size = 50});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.network(
        image ?? "https://encycolorpedia.vn/808080.png",
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}

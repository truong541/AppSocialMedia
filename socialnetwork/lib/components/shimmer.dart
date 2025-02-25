import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CommonShimmer extends StatelessWidget {
  final Widget child;
  const CommonShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: child,
    );
  }
}

class ContainerShimmer extends StatelessWidget {
  final bool isFullWidth;
  final bool isShort;
  final bool isMedium;
  final double height;
  final bool isLargeHeight;
  const ContainerShimmer({
    super.key,
    this.isFullWidth = true,
    this.isShort = false,
    this.isMedium = false,
    this.height = 12,
    this.isLargeHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isLargeHeight ? 200 : height,
      width: isShort
          ? 80
          : isMedium
              ? 120
              : double.infinity,
      color: Colors.white,
    );
  }
}

class CirleShimmer extends StatelessWidget {
  final double size;
  const CirleShimmer({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }
}

class CustomShimmer {
  Widget shimmerListPost() {
    return ListView.builder(
      itemCount: 5, // Số lượng khung xám giả lập
      itemBuilder: (context, index) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  CommonShimmer(
                    child: CirleShimmer(),
                  ),
                  SizedBox(width: 10),
                  ContainerShimmer(isShort: true),
                ],
              ),
            ),
            ContainerShimmer(
              isLargeHeight: true,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ContainerShimmer(
                    isShort: true,
                  ),
                  SizedBox(height: 10),
                  ContainerShimmer(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

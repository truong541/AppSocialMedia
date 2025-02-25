import 'package:flutter/material.dart';

class IndexResponsive extends StatelessWidget {
  final Widget child;
  const IndexResponsive({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double maxWidth =
          constraints.maxWidth > 600 ? 600 : constraints.maxWidth * 0.9;
      return Center(
        child: Container(
          width: maxWidth,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: child,
        ),
      );
    });
  }
}

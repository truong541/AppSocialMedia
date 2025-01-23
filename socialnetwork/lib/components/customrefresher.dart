import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomRefresher extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const CustomRefresher({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  State<CustomRefresher> createState() => _CustomRefresherState();
}

class _CustomRefresherState extends State<CustomRefresher> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      controller: _refreshController,
      onRefresh: widget.onRefresh,
      child: widget.child,
    );
  }
}

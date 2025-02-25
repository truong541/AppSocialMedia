import 'package:flutter/material.dart';

class CustomFutureBuilder<T> extends StatelessWidget {
  final Future<List<T>> future;
  final Widget Function(T item) itemBuilder;
  final bool isGridView;
  final bool isScrollHorizontal;
  //Của GridView
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final bool isNeverScroll;
  //Widget khi không có dữ liệu
  final bool isWidgetNotList;
  final Widget? childNotList;
  //Widget khi load dữ liệu
  final bool isShimmer;
  final Widget? childShimmer;

  const CustomFutureBuilder({
    super.key,
    required this.future,
    required this.itemBuilder,
    this.isGridView = false,
    this.isScrollHorizontal = false,
    this.crossAxisCount = 3,
    this.crossAxisSpacing = 1,
    this.mainAxisSpacing = 1,
    this.isNeverScroll = true,
    this.isWidgetNotList = false,
    this.childNotList,
    this.isShimmer = false,
    this.childShimmer,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return isShimmer
              ? childShimmer!
              : Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Lỗi tải dữ liệu"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return isWidgetNotList
              ? childNotList!
              : Center(child: Text("Không có dữ liệu nào!"));
        } else {
          final list = snapshot.data!;

          if (isGridView) {
            return GridView.builder(
              physics: isNeverScroll ? NeverScrollableScrollPhysics() : null,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount, // Số cột trong GridView
                crossAxisSpacing: crossAxisSpacing, // Khoảng cách giữa các cột
                mainAxisSpacing: mainAxisSpacing, // Khoảng cách giữa các hàng
              ),
              itemCount: list.length,
              itemBuilder: (context, index) => itemBuilder(list[index]),
            );
          } else {
            return ListView.builder(
              scrollDirection:
                  isScrollHorizontal ? Axis.horizontal : Axis.vertical,
              itemCount: list.length,
              itemBuilder: (context, index) => itemBuilder(list[index]),
            );
          }
        }
      },
    );
  }
}

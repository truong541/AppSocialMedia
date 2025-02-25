import 'package:flutter/material.dart';

class ShowBottomSheet {
  void showBottomSheet(
      BuildContext context, double initialChildSize, Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: initialChildSize,
          minChildSize: initialChildSize / 2,
          maxChildSize: initialChildSize,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  height: 5,
                  width: 100,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: child,
                ),
              ],
            );
          },
        );
      },
    );
  }
}

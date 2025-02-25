import 'package:flutter/material.dart';
import 'package:socialnetwork/widgets/mytext.dart';

class ContainerEditUserText extends StatelessWidget {
  final Widget child;
  const ContainerEditUserText({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0xffcccccc)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

class TitleEditUserText extends StatelessWidget {
  final TextEditingController controller;
  final int maxLength;
  final String title;

  const TitleEditUserText(
      {super.key,
      required this.controller,
      required this.maxLength,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: MyTextStyle.textSmall(context),
        ),
        Text("${controller.text.length}/$maxLength",
            style: MyTextStyle.textSmallGrey)
      ],
    );
  }
}

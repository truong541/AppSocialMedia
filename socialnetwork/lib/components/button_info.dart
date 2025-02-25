import 'package:flutter/material.dart';
import 'package:socialnetwork/widgets/mycontainer.dart';
import 'package:socialnetwork/widgets/mytext.dart';

class ButtonInfo extends StatefulWidget {
  final String title;
  final String content;
  final VoidCallback onTap;
  const ButtonInfo(
      {super.key,
      required this.title,
      required this.content,
      required this.onTap});

  @override
  State<ButtonInfo> createState() => _ButtonInfoState();
}

class _ButtonInfoState extends State<ButtonInfo> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: MyContainer.defaultWidth(context),
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Color(0xffcccccc)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: widget.content.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: MyTextStyle.textSmallGrey,
                    ),
                    Text(
                      widget.title == 'Gender'
                          ? MyTextStyle().capitalize(widget.content)
                          : widget.content,
                      style: MyTextStyle.textSmall(context),
                    ),
                  ],
                )
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    widget.title,
                    style: TextStyle(fontSize: 15, color: Color(0xff888888)),
                  ),
                ),
        ));
  }
}

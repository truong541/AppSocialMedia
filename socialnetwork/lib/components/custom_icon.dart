import 'package:flutter/material.dart';

class CustomIcon extends StatefulWidget {
  //Tên icon trong assets/icon
  final String icon;
  //Mã màu icon
  final int color;
  //Kích cỡ
  final double width;
  //Nếu dùng icon mặc định light/dark
  final bool isDefaultColor;
  const CustomIcon(
      {super.key,
      required this.icon,
      this.color = 0xff000000,
      required this.width,
      this.isDefaultColor = false});

  @override
  State<CustomIcon> createState() => _CustomIconState();
}

class _CustomIconState extends State<CustomIcon> {
  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        widget.isDefaultColor
            ? Theme.of(context).colorScheme.onSurface
            : Color(widget.color),
        BlendMode.srcATop,
      ),
      child: Image.asset(
        'assets/icon/${widget.icon}',
        width: widget.width,
        height: widget.width,
      ),
    );
  }
}

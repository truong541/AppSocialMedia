import 'package:flutter/material.dart';

class ButtonAccount extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String imageUrl;

  const ButtonAccount({
    super.key,
    required this.text,
    required this.onPressed,
    this.imageUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Image.asset(
        imageUrl,
        height: 24,
      ),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 48),
      ),
    );
  }
}

class ButtonIcon extends StatelessWidget {
  final VoidCallback onTapped;
  final String imageIcon;
  final double widthIcon;
  final Color colorIcon;

  const ButtonIcon({
    super.key,
    required this.onTapped,
    this.imageIcon = '',
    this.widthIcon = 30,
    this.colorIcon = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapped,
      child: ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(
            colors: [colorIcon, colorIcon], // Tô màu tùy chỉnh
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcATop,
        child: Image.asset(
          'assets/icon/$imageIcon',
          width: widthIcon,
          height: widthIcon,
        ),
      ),
    );
  }
}

class ButtonText extends StatelessWidget {
  final VoidCallback onTapped;
  final String text;
  final Color colorText;
  final bool isBold;

  const ButtonText({
    super.key,
    required this.onTapped,
    this.text = '',
    this.colorText = Colors.black,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapped,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 15,
            color: colorText,
            fontWeight: isBold ? FontWeight.w500 : null),
      ),
    );
  }
}

class ButtonNormal extends StatelessWidget {
  final VoidCallback onTapped;
  final String text;
  final double radius;
  final double paddingVertical;
  final Color textColor;
  final Color bgColor;
  final bool isBold;

  const ButtonNormal({
    super.key,
    required this.onTapped,
    this.text = '',
    this.radius = 10,
    this.paddingVertical = 5,
    this.textColor = Colors.black,
    this.bgColor = Colors.white,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapped,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: paddingVertical),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ButtonTextIcon extends StatelessWidget {
  final VoidCallback onTapped;
  final String icon;
  final double radius;
  final double padding;
  final double widthIcon;
  final Color colorIcon;
  final Color bgColor;

  const ButtonTextIcon({
    super.key,
    required this.onTapped,
    this.icon = '',
    this.radius = 10,
    this.padding = 5,
    this.widthIcon = 16,
    this.colorIcon = Colors.black,
    this.bgColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapped,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [colorIcon, colorIcon], // Tô màu tùy chỉnh
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: Image.asset(
            'assets/icon/$icon',
            width: widthIcon,
            height: widthIcon,
          ),
        ),
      ),
    );
  }
}

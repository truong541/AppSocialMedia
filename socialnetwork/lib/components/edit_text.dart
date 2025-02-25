import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socialnetwork/widgets/mytext.dart';

class EditText extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double radius;

  const EditText({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: color),
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: color)),
        errorText: validator?.call(controller?.text),
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      ),
      onChanged: onChanged,
      validator: validator,
    );
  }
}

class EditUserText extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int maxLength;
  const EditUserText(
      {super.key,
      required this.controller,
      required this.focusNode,
      required this.maxLength});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: MyTextStyle.textMedium(context),
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}

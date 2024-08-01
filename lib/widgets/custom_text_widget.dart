import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final String fontFamily;

  const CustomTextWidget({
    Key? key,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    this.color,
    this.fontFamily = 'Tajawal',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color ?? Colors.white,
          fontFamily: fontFamily,
        ),
      ),
    );
  }
}

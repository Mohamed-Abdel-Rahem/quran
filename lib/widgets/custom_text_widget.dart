import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final String fontFamily;

  const CustomTextWidget({
    super.key,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    this.color,
    this.fontFamily = 'Tajawal',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
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

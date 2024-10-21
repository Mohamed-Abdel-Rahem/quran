import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

Widget buildAnimatedText(String text) => Container(
      height: 20,
      child: Marquee(
        textDirection: TextDirection.ltr,
        text: text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.amber,
          fontFamily: 'Tajawal',
        ),
        blankSpace: 250,
      ),
    );

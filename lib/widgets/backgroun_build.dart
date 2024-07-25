import 'dart:ui';

import 'package:flutter/material.dart';

class BackgrounBuild extends StatelessWidget {
  const BackgrounBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/background/background2.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.black
              .withOpacity(0.2), // Optional: Adjust the opacity if needed
        ),
      ),
    );
    // Ellipses
  }
}

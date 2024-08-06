import 'package:flutter/material.dart';
import 'package:quran/widgets/sura_play_background.dart';

class SuraPlay extends StatelessWidget {
  const SuraPlay({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        AudioPlayerScreen(),
        Positioned(
          top: -screenSize.width * 0.25,
          right: -screenSize.width * 0.25,
          child: Image.asset(
            'assets/ellipse/Ellipse 10.png',
            width: screenSize.width * 1.1,
            height: screenSize.width * 1.1,
          ),
        ),
      ]),
    );
  }
}

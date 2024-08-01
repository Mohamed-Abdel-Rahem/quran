import 'package:flutter/material.dart';
import 'package:quran/widgets/backgroun_build.dart';

class MtonPage extends StatelessWidget {
  const MtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          const BackgrounBuild(),
          Positioned(
            top: -screenSize.width * 0.25,
            right: -screenSize.width * 0.25,
            child: Image.asset(
              'assets/ellipse/Ellipse 10.png',
              width: screenSize.width * 1.1,
              height: screenSize.width * 1.1,
            ),
          ),
          //content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          )
          // content
        ],
      ),
    );
  }
}

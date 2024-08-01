import 'package:flutter/material.dart';
import 'package:quran/widgets/backgroun_build.dart';
import 'package:quran/widgets/custom_text_widget.dart';

class RoquiaPage extends StatelessWidget {
  const RoquiaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
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
          // content
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.09),
                const Row(
                  children: [
                    CustomTextWidget(
                      text: 'الرقيه الشرعيه',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

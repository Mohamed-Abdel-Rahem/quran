import 'package:flutter/material.dart';
import 'package:quran/widgets/backgroun_build.dart';
import 'package:quran/widgets/custom_container.dart';
import 'package:quran/widgets/custom_text_widget.dart';

class MotonPage extends StatelessWidget {
  const MotonPage({super.key});

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
          Column(
            children: [
              SizedBox(height: screenSize.height * 0.09),
              const Align(
                alignment: Alignment.topRight,
                child: CustomTextWidget(
                  text: 'المتون',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.03),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                            child: CustomContainer(
                          text: 'متن تحفة الأطفال',
                          image: 'assets/images/child.png',
                        )),
                        SizedBox(
                          width: screenSize.width * 0.05,
                        ), // Space between the two containers
                        const Expanded(
                            child: CustomContainer(
                          text: 'متن الجزرية',
                          image: 'assets/images/elge.png',
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // content
        ],
      ),
    );
  }
}

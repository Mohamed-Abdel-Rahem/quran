import 'package:flutter/material.dart';
import 'package:quran/screens/developer_.dart';
import 'package:quran/screens/reader_page.dart';
import 'package:quran/services/facebok.dart';
import 'package:quran/services/telegram.dart';
import 'package:quran/services/tiktok.dart';
import 'package:quran/services/youtube.dart';
import 'package:quran/widgets/backgroun_build.dart';
import 'package:quran/widgets/custom_text_widget.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenSize.height * 0.09),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: CustomTextWidget(
                      text: 'المزيد',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.04),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: CustomTextWidget(
                      text: 'عن القارئ',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.05),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width * 0.01),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xff00676E),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(screenSize.width * 0.03),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'القارئ محمد السمرجي',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Tajawal',
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  'الاسم / محمد رمضان كمال محمود السمرجي',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Tajawal',
                                    color: Color.fromARGB(255, 165, 164, 164),
                                  ),
                                ),
                                SizedBox(
                                  height: screenSize.width * 0.03,
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ReaderDetailsPage()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amber,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: const Text('معرفة المزيد'),
                                    ),
                                    iconCreate(
                                      onPressed: () {
                                        launchFacebook(context);
                                      },
                                      iconPath: 'assets/icons/facebook.png',
                                    ),
                                    iconCreate(
                                      onPressed: () {
                                        launchTelegram(context);
                                      },
                                      iconPath: 'assets/icons/telegram.png',
                                    ),
                                    iconCreate(
                                      onPressed: () {
                                        launchTikTok(context);
                                      },
                                      iconPath: 'assets/icons/social-media.png',
                                    ),
                                    iconCreate(
                                      onPressed: () {
                                        launchYouTube(context);
                                      },
                                      iconPath: 'assets/icons/youtube.png',
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Image.asset(
                              'assets/images/sh1.png',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.07),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width * 0.03),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DeveloperPage()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.03,
                          vertical: screenSize.width * 0.04),
                      decoration: BoxDecoration(
                        color: const Color(
                            0xff222D2E), // Set the background color here
                        borderRadius:
                            BorderRadius.circular(16.0), // Rounded corners
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.error_outline,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DeveloperPage()),
                              );
                            },
                          ),
                          const Text(
                            'عن المطور',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Tajawal'),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_right,
                              color: Colors.white,
                              size: 33,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DeveloperPage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget iconCreate(
      {required VoidCallback onPressed, required String iconPath}) {
    return Expanded(
      child: IconButton(
        iconSize: 2,
        onPressed: onPressed,
        icon: Image.asset(
          iconPath,
        ),
      ),
    );
  }
}

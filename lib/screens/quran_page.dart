import 'package:flutter/material.dart';
import 'package:quran/screens/sura_play.dart';
import 'package:quran/widgets/backgroun_build.dart';
import 'package:quran/widgets/custom_list_tile.dart';
import 'package:quran/widgets/custom_text_widget.dart';
import 'package:quran/widgets/row_chooser.dart';

class QuranPage extends StatelessWidget {
  const QuranPage({super.key});

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
          // Content
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: screenSize.height * 0.05),
                const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8, top: 8),
                    child: CustomTextWidget(
                      text: 'مرحبا بك',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: CustomTextWidget(
                      text: 'اذكر الله فبذكره تطمئن القلوب',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                    height: 20), // Add some space between texts and row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const CustomTextWidget(
                      text: 'استمع الي القران الكريم',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xffE7A600),
                    ),
                    Container(
                      width: screenSize.width * 0.5,
                      height: 63,
                      decoration: BoxDecoration(
                        color: const Color(0xff2F3B3C),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: const Color.fromARGB(255, 175, 173, 173),
                          width: 1.0, // Adjust the width as needed
                        ),
                      ),
                      child: TextField(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10.0),
                          hintText: 'البحث عن سورة',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const CustomButtonRow(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SuraPlay()),
                    );
                  },
                  child: ListView.builder(
                    shrinkWrap:
                        true, // Ensures the list takes only the required height
                    physics:
                        const NeverScrollableScrollPhysics(), // Disables separate scrolling for the list
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return const CustomListTile();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

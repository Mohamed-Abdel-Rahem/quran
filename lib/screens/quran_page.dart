import 'package:flutter/material.dart';
import 'package:quran/firebase/services/list_of_quran.dart';
import 'package:quran/screens/sura_play.dart';
import 'package:quran/widgets/backgroun_build.dart';
import 'package:quran/widgets/custom_list_tile.dart';
import 'package:quran/widgets/custom_text_widget.dart';

class QuranPage extends StatefulWidget {
  QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Filter surahs based on the search query
    List<Map<String, dynamic>> filteredSurahs = surahs.where((sura) {
      return sura['nameArabic']
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          sura['nameEnglish'].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

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
                const SizedBox(height: 20),
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
                          width: 1.0,
                        ),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
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

                // const CustomButtonRow(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredSurahs.length,
                  itemBuilder: (context, index) {
                    final sura = filteredSurahs[index];
                    return CustomListTile(
                      suraName: sura['nameArabic'],
                      numberOfAyahs: sura['numberOfAyahs'],
                      type: sura['type'],
                      onPlay: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AudioPlayerScreen(
                              surahNameArabic: sura['nameArabic'],

                              // Pass the Surah name
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

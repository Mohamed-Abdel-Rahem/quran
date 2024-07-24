import 'package:flutter/material.dart';
import 'package:quran/widgets/custom_text_widget.dart';
import 'package:quran/widgets/row_chooser.dart';

class QuranPage extends StatelessWidget {
  const QuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/background/background2.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            // Ellipses
            Positioned(
              top: -screenSize.width * 0.25,
              right: -screenSize.width * 0.25,
              child: Image.asset(
                'assets/background/Ellipse 10.png',
                width: screenSize.width * 1.1,
                height: screenSize.width * 1.1,
              ),
            ),
            // Content
            Column(
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
                Expanded(
                  child: ListView.builder(
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.01,
                          horizontal: screenSize.width * 0.05,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff2F3B3C),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            leading: IconButton(
                              icon: Icon(Icons.play_circle_fill,
                                  color: Colors.green),
                              onPressed: () {},
                            ),
                            title: CustomTextWidget(
                              text: 'اسم السورة',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            subtitle: CustomTextWidget(
                              text: 'مكية - عدد الآيات (90)',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.bookmark_border,
                                  color: Colors.white),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QuranItem extends StatelessWidget {
  final String title;
  final String description;

  const QuranItem({Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0x0affffff),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: Icon(
            Icons.play_circle,
            color: Colors.yellow,
            size: 36.0,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Icon(
            Icons.bookmark,
            color: Colors.yellow,
          ),
          subtitle: Text(
            description,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }
}

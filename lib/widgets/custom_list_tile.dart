import 'package:flutter/material.dart';
import 'package:quran/widgets/custom_text_widget.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenSize.height * 0.01,
        horizontal: screenSize.width * 0.05,
      ),
      child: Container(
        width: screenSize.width * 0.9,
        height: screenSize.height * 0.1,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 175, 173, 173),
            width: 1.0,
          ),
          color: const Color(0x0affffff),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: ListTile(
            title: CustomTextWidget(
              text: 'اسم السورة',
              fontSize: screenSize.width * 0.06,
              fontWeight: FontWeight.w400,
            ),
            subtitle: CustomTextWidget(
              text: 'مكية - عدد الآيات (90)',
              fontSize: screenSize.width * 0.035,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.bookmark_border,
                    color: Colors.white,
                    size: screenSize.width * 0.05,
                  ),
                  onPressed: () {
                    // Add your bookmark action here
                  },
                ),
                SizedBox(
                    width: screenSize.width * 0.02), // Spacing between icons
                Container(
                  width: screenSize.width * 0.1,
                  height: screenSize.width * 0.1,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: screenSize.width * 0.05,
                    ),
                    onPressed: () {
                      // Add your play icon action here
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

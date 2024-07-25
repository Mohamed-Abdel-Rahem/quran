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
        width: 398,
        height: 90,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 175, 173, 173),
            width: 1.0, // Adjust the width as needed
          ),
          color: Color(0x0affffff),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: ListTile(
            title: const CustomTextWidget(
              text: 'اسم السورة',
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
            subtitle: const CustomTextWidget(
              text: 'مكية - عدد الآيات (90)',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.bookmark_border, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}

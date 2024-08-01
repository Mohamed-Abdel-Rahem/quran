import 'package:flutter/material.dart';
import 'package:quran/widgets/custom_text_widget.dart';

class CustomContainer extends StatelessWidget {
  final String text;
  final String image;

  const CustomContainer({super.key, required this.text, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Margin around the container
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        color: const Color(0xff314547),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Fit the column to its content
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width *
                0.4, // Adjust height to maintain aspect ratio
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: Image.asset(
                image, // Replace with your image asset path
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 2), // Space between image and text
          CustomTextWidget(
            text: text,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}

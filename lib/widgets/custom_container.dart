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
            // Adjust height to maintain aspect ratio
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xff659F7C),
                width: 1.0, // Adjust the width as needed
              ),
              borderRadius: BorderRadius.circular(19),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(19),
                child: Column(
                  children: [
                    Image.asset(
                      image, // Replace with your image asset path
                      fit: BoxFit.cover,
                    ),
                    Text(
                      text,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Tajawal',
                          color: Colors.white),
                    )
                  ],
                )),
          ),
          // Space between image and text
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomButtonRow extends StatefulWidget {
  const CustomButtonRow({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomButtonRowState createState() => _CustomButtonRowState();
}

class _CustomButtonRowState extends State<CustomButtonRow> {
  String _selectedButton = 'سورة';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton('سورة'),
        const SizedBox(width: 20), // Adjust spacing as needed
        const SizedBox(width: 20), // Adjust spacing as needed
        _buildButton('المفضلة'),
      ],
    );
  }

  Widget _buildButton(String text) {
    bool isSelected = _selectedButton == text;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedButton = text;
        });
      },
      // ignore: sort_child_properties_last
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isSelected
              ? Colors.black
              : Colors.white, // Text color based on selection
        ),
        textAlign: TextAlign.center,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.white : const Color(0xff2F3B3C),
        side: BorderSide(
            color: isSelected ? Colors.white : const Color(0xff2F3B3C),
            width: 2.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}

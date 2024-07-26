import 'package:flutter/material.dart';

class CusotmBottomNavigationBar extends StatefulWidget {
  const CusotmBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<CusotmBottomNavigationBar> createState() =>
      _CusotmBottomNavigationBarState();
}

class _CusotmBottomNavigationBarState extends State<CusotmBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/icons/quran.png'),
              color: _selectedIndex == 0 ? Colors.white : Colors.grey,
            ),
            label: 'القران الكريم',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/icons/ruqia.png'),
              color: _selectedIndex == 1 ? Colors.white : Colors.grey,
            ),
            label: 'الرقيه الشرعيه',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/icons/quran.png'),
              color: _selectedIndex == 2 ? Colors.white : Colors.grey,
            ),
            label: 'المتون',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/icons/more.png'),
              color: _selectedIndex == 3 ? Colors.white : Colors.grey,
            ),
            label: 'المتون',
          ),
        ],
        backgroundColor:
            Color(0xff072730), // Ensuring the background color is set
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(color: Colors.white),
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 15,
        unselectedFontSize: 15,
        onTap: _onItemTapped,
      ),
    );
  }
}

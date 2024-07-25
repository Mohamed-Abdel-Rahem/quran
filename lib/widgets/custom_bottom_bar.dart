import 'package:flutter/material.dart';

class CusotmBottomNavigationBar extends StatefulWidget {
  const CusotmBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<CusotmBottomNavigationBar> createState() =>
      _CusotmBottomNavigationBarState();
}

class _CusotmBottomNavigationBarState extends State<CusotmBottomNavigationBar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('القران الكريم'),
    Text('الرقيه الشرعيه'),
    Text('Profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: Colors.white,
          ),
          label: 'القران الكريم',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'الرقيه الشرعيه',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      backgroundColor: Color(0xff072630),
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }
}

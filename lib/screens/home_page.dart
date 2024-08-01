import 'package:flutter/material.dart';
import 'package:quran/screens/more_page.dart';
import 'package:quran/screens/mton.dart';
import 'package:quran/screens/quran_page.dart';
import 'package:quran/screens/roquia.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routName = 'HomeScreen';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  List<Widget> tabs = [QuranPage(), RoquiaPage(), MtonPage(), MorePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xff072730),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors
                .transparent, // Transparent background for BottomNavigationBar
            elevation: 0, // Removing any shadow
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/icons/quran.png'),
                  color: selectedIndex == 0 ? Colors.white : Colors.grey,
                ),
                label: 'القران الكريم',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/icons/ruqia.png'),
                  color: selectedIndex == 1 ? Colors.white : Colors.grey,
                ),
                label: 'الرقيه الشرعيه',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/icons/quran.png'),
                  color: selectedIndex == 2 ? Colors.white : Colors.grey,
                ),
                label: 'المتون',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/icons/more.png'),
                  color: selectedIndex == 3 ? Colors.white : Colors.grey,
                ),
                label: 'المزيد',
              ),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: Colors.white,
            selectedLabelStyle: TextStyle(color: Colors.white),
            unselectedLabelStyle: TextStyle(color: Colors.grey),
            unselectedItemColor: Colors.grey,
            selectedFontSize: 15,
            unselectedFontSize: 15,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        ),
      ),
      body: tabs[selectedIndex],
    );
  }
}
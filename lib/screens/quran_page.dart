import 'package:flutter/material.dart';

class QuranPage extends StatelessWidget {
  const QuranPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              top: -100,
              right: -100,
              child: Image.asset(
                'assets/background/Ellipse 10.png',
                width: 414,
                height: 414,
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "مرحبا بك",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "اذكر الله فبذكره تطمئن القلوب",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "استمع الي القران الكريم",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE7A600),
                        ),
                      ),
                      Container(
                        width: 192,
                        height: 63,
                        decoration: BoxDecoration(
                          color: Color(0xff2F3B3C),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: 'البحث عن سورة',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: InputBorder.none,
                            suffixIcon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

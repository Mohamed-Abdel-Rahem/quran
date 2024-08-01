import 'package:flutter/material.dart';

class ReaderDetailsPage extends StatelessWidget {
  const ReaderDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF0E3D39),
      appBar: AppBar(
        backgroundColor: const Color(0xFF032022),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_right,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        title: const Text('عن القارئ', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: screenSize.width * 0.6,
              height: screenSize.width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: const DecorationImage(
                  image: AssetImage(
                      'assets/images/sh2.png'), // Replace with your image asset path
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'القارئ محمد السمرجي\n'
              'الاسم / محمد رمضان كمال محمود السمرجي\n'
              'الشهير ب / محمد السمرجي\n'
              'ت الميلاد ٢ / ٦ / ١٩٩٦\n'
              'حاصل على\n'
              'المركز الأول على مستوى العالم في المسابقة العالمية للقرآن الكريم 2015\n'
              'والمركز الأول في\n'
              'مسابقة الماهر بفهم القرآن بالسعودية\n'
              'مسابقة الفائزون وأم السعد وغيرها\n'
              '* مجاز بالقراءات العشر\n'
              'وحاصل على\n'
              '* ليسانس شريعة وقانون\n'
              '* دبلومة دراسات عليا في الشريعة الإسلامية\n'
              '* تمهيدي ماجستير في الشريعة الإسلامية\n'
              '* باحث ماجستير في الفقه المقارن .',
              style:
                  TextStyle(color: Colors.white, fontSize: 16.0, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.email, color: Colors.white),
                  const SizedBox(width: 8.0),
                  const Text(
                    '............@gmail.com',
                    style: TextStyle(color: Colors.white),
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

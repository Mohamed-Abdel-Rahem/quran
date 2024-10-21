import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quran/screens/certificatePage.dart';

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
        title: const Text(
          'عن القارئ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'Tajawal',
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: screenSize.width * 0.8,
                height: screenSize.width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: const DecorationImage(
                    image: AssetImage(
                        'assets/images/sh2.png'), // Replace with your image asset path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: screenSize.width * 0.06),
              const Text(
                'القارئ محمد السمرجي\n',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              const Text(
                'الاسم / محمد رمضان كمال محمود السمرجي\n'
                'الشهير ب / محمد السمرجي\n'
                'ت الميلاد ٢ / ٦ / ١٩٩٦\n'
                '* ٳمام وخطيب ومدرس بوزارة الأوقاف المصرية \n'
                '* عضو المقرأة النموذجيه بوزارة الأوقاف \n'
                '* موفد وزاارة الأوقاف  لٳحياء ليالي رمضان بدول العالم الاسلامي \n'
                'حاصل على\n'
                'المركز الأول على مستوى العالم في المسابقة العالمية للقرآن الكريم 2015\n'
                'والمركز الأول في\n'
                'مسابقة الماهر بفهم القرآن بالسعودية\n'
                'مسابقة الفائزون وأم السعد وغيرها\n'
                '* مجاز بالقراءات العشر\n'
                'وحاصل على\n'
                '* ليسانس شريعة وقانون\n'
                '* دراسات عليا في الشريعة الإسلامية\n'
                '* باحث ماجستير في الفقه المقارن .',
                style: TextStyle(
                    color: Colors.white, fontSize: 25.0, fontFamily: 'Tajawal'),
                textAlign: TextAlign.right,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Certificatepage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF032022),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                child: const Text('الشهادات'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

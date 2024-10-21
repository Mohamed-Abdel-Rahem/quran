import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:quran/screens/image_detail.dart';

class Certificatepage extends StatefulWidget {
  const Certificatepage({super.key});

  @override
  State<Certificatepage> createState() => _CertificatepageState();
}

class _CertificatepageState extends State<Certificatepage> {
  @override
  Widget build(BuildContext context) {
    List<String> cer = [
      'assets/certificat/1.jpeg',
      'assets/certificat/2.jpeg',
      'assets/certificat/3.jpeg',
      'assets/certificat/4.jpeg',
      'assets/certificat/5.jpeg',
      'assets/certificat/6.jpeg',
      'assets/certificat/7.jpeg',
      'assets/certificat/8.jpeg',
      'assets/certificat/9.jpeg',
      'assets/certificat/10.jpeg',
      'assets/certificat/11.jpeg',
      'assets/certificat/12.jpeg',
      'assets/certificat/13.jpeg',
      'assets/certificat/14.jpeg',
      'assets/certificat/15.jpeg',
      'assets/certificat/16.jpeg',
    ];
    String? selectedImage;
    return Scaffold(
        backgroundColor: const Color(0xFF0E3D39),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 41, 58, 59),
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
            'شهادات القارئ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontFamily: 'Tajawal',
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: [
              for (var i = 0; i < cer.length; i++)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedImage = cer[i]; // Set the tapped image
                    });
                  },
                  onDoubleTap: () {
                    ZoomPageTransitionsBuilder(
                        allowEnterRouteSnapshotting: true);
                  },
                  child: InstaImageViewer(
                    disableSwipeToDismiss: true,
                    backgroundIsTransparent: true,
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      cer[i],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}

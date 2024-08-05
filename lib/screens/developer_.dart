import 'package:flutter/material.dart';
import 'package:quran/services/email_services.dart';
import 'package:quran/services/whatsapp_services.dart';
import 'package:quran/widgets/connect_widget.dart';
import 'package:quran/widgets/custom_text_widget.dart';

class DeveloperPage extends StatefulWidget {
  const DeveloperPage({super.key});

  @override
  State<DeveloperPage> createState() => _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage> {
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
          'عن المطور',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: screenSize.width * 0.1),
          const Align(
            alignment: Alignment.topRight,
            child: CustomTextWidget(
              text: "تم التطوير والتصميم بواسطة @ محمد عبد الرحيم احمد",
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: screenSize.width * 0.2),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: screenSize.width * 0.03,
                    right: screenSize.width * 0.06),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/taw.png',
                    ),
                    const Align(
                      alignment: Alignment.topRight,
                      child: CustomTextWidget(
                        text: "للتواصل",
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              ConnectWidget(
                onTap: () {
                  funcOpenMailComposer();
                },
                text: 'mohamedar2002mail@gmail.com',
                icon: Icons.email,
              ),
              SizedBox(height: screenSize.width * 0.06),
              ConnectWidget(
                onTap: () {
                  funcOpenWhatsApp();
                },
                icon: Icons.call,
                text: 'Whatsapp and Call : (+20) 01152619144 ',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

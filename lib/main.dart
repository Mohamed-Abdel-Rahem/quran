import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:quran/generated/l10n.dart';
import 'package:quran/screens/quran_page.dart';

void main() {
  runApp(
    const QuranApp(),
  );
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale('ar'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: QuranPage(),
    );
  }
}

bool isArabic() {
  return Intl.getCurrentLocale() == 'ar';
}

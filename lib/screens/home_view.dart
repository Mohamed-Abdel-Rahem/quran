import 'package:flutter/material.dart';
import 'package:quran/generated/l10n.dart';
import 'package:quran/main.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).title),
        ),
        body: Row(
          children: [
            Text(
              S.of(context).title,
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: isArabic() ? 0 : 16,
                right: isArabic() ? 16 : 0,
              ),
              child: Text(
                S.of(context).subTitle,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ));
  }
}

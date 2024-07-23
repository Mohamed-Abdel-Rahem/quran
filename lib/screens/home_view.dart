import 'package:flutter/material.dart';
import 'package:quran/generated/l10n.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).title),
        ),
        body: Row(
          children: [Text('لخبخبخييب')],
        ));
  }
}

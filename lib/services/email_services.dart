import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

void funcOpenMailComposer() async {
  final mailtoLink = Mailto(
    to: ['mohamedar2002mail@gmail.com'],
  );
  await launch('$mailtoLink');
}

import 'package:url_launcher/url_launcher.dart';

void launchTelegram() async {
  var tgUrl =
      'tg://resolve?domain=Mohamedelsamragy'; // Telegram link for the app
  var webUrl = 'https://t.me/Mohamedelsamragy'; // Web fallback

  if (await canLaunch(tgUrl)) {
    await launch(tgUrl);
  } else if (await canLaunch(webUrl)) {
    await launch(webUrl);
  } else {
    throw 'Could not launch $webUrl';
  }
}

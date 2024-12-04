import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void launchTelegram(BuildContext context) async {
  var tgUrl = Uri.parse(
      'tg://resolve?domain=Mohamedelsamragy'); // Telegram link for the app
  var webUrl = Uri.parse('https://t.me/Mohamedelsamragy'); // Web fallback

  try {
    // First, try to launch the Telegram app
    if (await canLaunchUrl(tgUrl)) {
      await launchUrl(tgUrl);
    } else if (await canLaunchUrl(webUrl)) {
      // If Telegram app is not available, open the web link
      await launchUrl(webUrl);
    } else {
      // Show a Snackbar if neither URL can be opened
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Telegram app or web version is not accessible.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    // Handle any unexpected errors with a Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An error occurred while launching Telegram.'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

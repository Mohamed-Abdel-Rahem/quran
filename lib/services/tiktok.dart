import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchTikTok(BuildContext context) async {
  const String tiktokAppUrl =
      'snssdk1233://user/profile/elsamragy2015'; // TikTok app URL scheme for the profile
  const String tiktokWebUrl =
      'https://www.tiktok.com/@elsamragy2015?_t=8qbMEE1e6kx&_r=1'; // Your TikTok profile web URL

  try {
    final Uri appUri = Uri.parse(tiktokAppUrl); // Parse the TikTok app URL
    final Uri webUri = Uri.parse(tiktokWebUrl); // Parse the TikTok web URL

    // Try launching the TikTok app
    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(webUri)) {
      // Fallback to the web version if the app isn't installed
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    } else {
      // Show a Snackbar if neither URL can be launched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'TikTok app is not installed, and the URL cannot be opened.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    // Show a Snackbar if an error occurs
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An error occurred: $e'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

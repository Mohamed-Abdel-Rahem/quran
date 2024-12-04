import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchYouTube(BuildContext context) async {
  final Uri ytAppUrl = Uri.parse(
      'youtube://www.youtube.com/channel/UChRsET-Pt7eR1WUVLx78kRA'); // YouTube app link
  final Uri ytWebUrl = Uri.parse(
      'https://www.youtube.com/channel/UChRsET-Pt7eR1WUVLx78kRA'); // YouTube web link

  try {
    // Try launching the YouTube app URL
    if (await canLaunchUrl(ytAppUrl)) {
      await launchUrl(ytAppUrl);
    } else if (await canLaunchUrl(ytWebUrl)) {
      // Fallback to the web link if the app isn't installed
      await launchUrl(ytWebUrl);
    } else {
      // If neither works, show a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('YouTube is not installed, opening web version.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    // Handle any unexpected errors with a Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An error occurred while trying to open YouTube.'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

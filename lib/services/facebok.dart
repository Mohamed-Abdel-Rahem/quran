import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void launchFacebook(BuildContext context) async {
  final Uri fbUrl = Uri.parse(
      'fb://facewebmodal/f?href=https://www.facebook.com/profile.php?id=100063722688789&mibextid=ZbWKwL');
  final Uri webUrl = Uri.parse(
      'https://www.facebook.com/profile.php?id=100063722688789&mibextid=ZbWKwL');

  try {
    // Try to launch the Facebook app URL
    if (await canLaunchUrl(fbUrl)) {
      await launchUrl(fbUrl, mode: LaunchMode.externalApplication);
    }
    // If Facebook app is not available, launch the web URL
    else if (await canLaunchUrl(webUrl)) {
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    } else {
      // Show a Snackbar if neither URL can be launched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Facebook app is not installed, and the URL cannot be opened.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    // Handle any error that occurs and show a Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An error occurred: $e'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

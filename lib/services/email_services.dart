import 'package:flutter/material.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

void funcOpenMailComposer(BuildContext context) async {
  final mailtoLink = Mailto(
    to: ['mohamedar2002mail@gmail.com'],
  );

  try {
    final uri = Uri.parse('$mailtoLink'); // Parse the Mailto link
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Show a Snackbar if the mail app is not available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No email application found.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    // Show a Snackbar for any unexpected errors
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An error occurred: $e'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

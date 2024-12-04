import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

// Update function to accept BuildContext parameter
Future<void> funcOpenWhatsApp(BuildContext context) async {
  final link = WhatsAppUnilink(
    phoneNumber: '201152619144', // Your phone number in international format
    text: 'Hello, I would like to chat with you!',
  );

  final url = link.asUri().toString();

  try {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // If WhatsApp cannot be launched, show a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('WhatsApp is not installed on your device.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    // Handle any unexpected errors with a Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An error occurred while trying to open WhatsApp.'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

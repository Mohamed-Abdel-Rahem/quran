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
      print('Cannot be launched');
      // Show an error message to the user, passing the context
      _showErrorDialog(context,
          'Cannot open WhatsApp. Please check if WhatsApp is installed.');
    }
  } catch (e) {
    print('Error launching URL: $e');
    // Show an error message to the user, passing the context
    _showErrorDialog(
        context, 'An error occurred while trying to open WhatsApp.');
  }
}

// Update function to accept BuildContext parameter
void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

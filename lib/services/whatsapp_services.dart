import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

void funcOpenWhatsApp() async {
  final link = WhatsAppUnilink(
    phoneNumber: '201152619144', // Your phone number in international format
    text: 'Hello, I would like to chat with you!',
  );

  final url = link.asUri().toString();

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch $url');
    // You can also show an error message using Flutter EasyLoading or another method
  }
}

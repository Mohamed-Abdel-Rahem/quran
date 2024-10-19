import 'package:url_launcher/url_launcher.dart';

void launchFacebook() async {
  var fbUrl =
      'fb://facewebmodal/f?href=https://www.facebook.com/profile.php?id=100063722688789&mibextid=ZbWKwL';
  var webUrl =
      'https://www.facebook.com/profile.php?id=100063722688789&mibextid=ZbWKwL';

  // Try to launch the Facebook app URL
  if (await canLaunch(fbUrl)) {
    await launch(fbUrl);
  }
  // If Facebook app is not available, launch the web URL
  else if (await canLaunch(webUrl)) {
    await launch(webUrl);
  } else {
    throw 'Could not launch $webUrl';
  }
}

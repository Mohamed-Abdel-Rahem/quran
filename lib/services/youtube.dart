import 'package:url_launcher/url_launcher.dart';

void launchYouTube() async {
  var ytUrl =
      'youtube://www.youtube.com/channel/UChRsET-Pt7eR1WUVLx78kRA'; // YouTube channel link
  var webUrl = 'https://www.youtube.com/channel/UChRsET-Pt7eR1WUVLx78kRA';

  if (await canLaunch(ytUrl)) {
    await launch(ytUrl);
  } else if (await canLaunch(webUrl)) {
    await launch(webUrl);
  } else {
    throw 'Could not launch $webUrl';
  }
}

import 'package:url_launcher/url_launcher.dart';

Future<void> launchTikTok() async {
  const String tiktokAppUrl =
      'snssdk1233://user/profile/elsamragy2015'; // TikTok app URL scheme for the profile
  const String tiktokWebUrl =
      'https://www.tiktok.com/@elsamragy2015?_t=8qbMEE1e6kx&_r=1'; // Your TikTok profile web URL

  // Try launching the TikTok app
  if (await canLaunch(tiktokAppUrl)) {
    await launch(tiktokAppUrl);
  } else if (await canLaunch(tiktokWebUrl)) {
    // Fallback to the web version if the app isn't installed
    await launch(tiktokWebUrl);
  } else {
    throw 'Could not launch TikTok';
  }
}


import 'package:url_launcher/url_launcher.dart';
class FreeSoundAuthService {
  final String clientId = 'sVFVjOZKw8DoDY3jEXvx'; // Replace with your client ID
  final String clientSecret = 'lOMmS3wRHdF8yMwmv7I3O0qdYT8s6JpS3hiU3esO'; // Replace with your client secret
  final String authorizationEndpoint = 'https://freesound.org/apiv2/oauth2/authorize/';
  final String tokenEndpoint = 'https://freesound.org/apiv2/oauth2/access_token/';

  Future<void> getAuthorizationUrl() async {
    final Uri uri = Uri.parse(authorizationEndpoint).replace(queryParameters: {
      'client_id': clientId,
      'response_type': 'code',
    });
    print("Authorization url: $uri");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $uri';
    }
  }

}

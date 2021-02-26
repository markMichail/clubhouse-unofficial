import 'package:club_house_unofficial/api/keys.dart';
import 'package:club_house_unofficial/api/sharedPrefsController.dart';
import 'package:http/http.dart' as http;

class JoinChannel {
  String channel;
  JoinChannel({this.channel});

  Future<String> join() async {
    var attributionSource = "feed";
    var attributionDetails = "eyJpc19leHBsb3JlIjpmYWxzZSwicmFuayI6MX0=";
    final response = await http.post("$API_URL/join_channel", headers: {
      'CH-Languages': 'en-US',
      'CH-Locale': 'en_US',
      'Accept': 'application/json',
      'CH-AppBuild': API_BUILD_ID,
      'CH-AppVersion': API_BUILD_VERSION,
      'User-Agent': API_UA,
      'CH-DeviceId': SharedPrefsController.deviceID,
      'Authorization': 'Token ' + SharedPrefsController.user.authToken,
      'CH-UserID': SharedPrefsController.user.userId.toString(),
    }, body: {
      "channel": channel,
      "attribution_source": attributionSource,
      "attribution_details": attributionDetails,
    });
    if (response.statusCode == 200) {
      return response.body;
    }

    return null;
  }
}

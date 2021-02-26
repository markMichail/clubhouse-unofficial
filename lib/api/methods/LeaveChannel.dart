import 'package:club_house_unofficial/api/keys.dart';
import 'package:club_house_unofficial/api/sharedPrefsController.dart';
import 'package:http/http.dart' as http;

class LeaveChannel {
  String channel;
  int channelId;
  LeaveChannel({this.channelId, this.channel});

  Future<String> leave() async {
    final response = await http.post("$API_URL/leave_channel", headers: {
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
      "channel_id": channelId.toString(),
    });
    if (response.statusCode == 200) {
      // var data = jsonDecode(response.body);

      return response.body;
    }

    return null;
  }
}

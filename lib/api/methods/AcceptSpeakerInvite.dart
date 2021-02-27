import 'dart:convert';
import 'package:club_house_unofficial/api/keys.dart';
import 'package:club_house_unofficial/api/sharedPrefsController.dart';
import 'package:http/http.dart' as http;

class AcceptSpeakerInvite {
  String channel;

  AcceptSpeakerInvite({this.channel});

  Future<dynamic> accept() async {
    try {
      var response = await http.post(
        "$API_URL/accept_speaker_invite",
        headers: {
          'CH-Languages': 'en-US',
          'CH-Locale': 'en_US',
          'Accept': 'application/json',
          'CH-AppBuild': API_BUILD_ID,
          'CH-AppVersion': API_BUILD_VERSION,
          'User-Agent': API_UA,
          'CH-DeviceId': SharedPrefsController.deviceID,
          'Authorization': 'Token ' + SharedPrefsController.user.authToken,
          'CH-UserID': SharedPrefsController.user.userId.toString(),
        },
        body: {
          // "channel": "xX3p3ovP",
          "channel": channel,
          "user_id": SharedPrefsController.user.userId.toString(),
        },
      );
      if (DEBUG)
        print(
            "accept_speaker_invite : responose.statusCode = ${response.statusCode} , response.body = ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("AAAA");
        print(data);
        return data;
      } else
        return {'success': false, 'message': 'Error: ${response.statusCode}'};
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': e.toString()};
    }
  }
}

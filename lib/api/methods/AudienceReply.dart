import 'dart:convert';

import 'package:club_house_unofficial/api/keys.dart';
import 'package:club_house_unofficial/api/sharedPrefsController.dart';
import 'package:http/http.dart' as http;

class AudienceReply {
  String channel;
  bool raiseHands = true, unraiseHands = false;
  AudienceReply({this.channel});

  Future<dynamic> raiseHand() async {
    // Dio dio = new Dio();

    // print(channel);
    // var headers = {
    //   'CH-Languages': 'en-US',
    //   'CH-Locale': 'en_US',
    //   'Accept': 'application/json',
    //   'CH-AppBuild': API_BUILD_ID,
    //   'CH-AppVersion': API_BUILD_VERSION,
    //   'User-Agent': API_UA,
    //   'CH-DeviceId': SharedPrefsController.deviceID,
    //   'Authorization': 'Token ' + SharedPrefsController.user.authToken,
    //   'CH-UserID': SharedPrefsController.user.userId.toString(),
    // };
    var body = {
      // "channel": "xX3p3ovP",
      "channel": channel,
      "raise_hands": "true".toString(),
      "unraise_hands": "false".toString(),
    };
    try {
      // var response = await dio.post("${API_URL}audience_reply",
      //     options: Options(headers: headers),
      //     data: {
      //       "channel": "xVl9KQVR",
      //       "raise_hands": true,
      //       "unraise_hands": false,
      //     });
      // print(response.statusCode);
      var response = await http.post("$API_URL/audience_reply",
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
          body: body);
      // print(jsonEncode(body));
      if (DEBUG)
        print(
            "audience_reply : responose.statusCode = ${response.statusCode} , response.body = ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
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

import 'package:club_house_unofficial/api/sharedPrefsController.dart';
import 'package:flutter/widgets.dart';
import 'package:club_house_unofficial/api/keys.dart';
import 'package:http/http.dart' as http;

class GetProfile {
  int userId;
  GetProfile({@required this.userId});

  Future<String> getProfile() async {
    try {
      final response = await http.post(
        "$API_URL/get_profile",
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
          "user_id": userId.toString(),
        },
      );

      print("rr" + response.statusCode.toString());
      if (response.statusCode == 200) {
        // print(response.body);
        // var data = jsonDecode(response.body);
        // print(data);
        return response.body;
      }
    } catch (e) {
      print(e.toString());
    }

    return null;
    // return """{"user_profile":{"user_id":1822835720,"name":"mark refaat","displayname":null,"photo_url":"https://clubhouseprod.s3.amazonaws.com:443/1822835720_b3784f26-e7c6-4681-8f46-5cd21bce985e","username":"markrefaat","bio":"Computer science student","twitter":null,"instagram":null,"num_followers":1,"num_following":22,"time_created":"2021-02-21T14:05:38.007733+00:00","follows_me":false,"is_blocked_by_network":false,"mutual_follows_count":0,"mutual_follows":[],"notification_type":null,"invited_by_user_profile":{"user_id":1587577580,"name":"Nada Rabiee","photo_url":"https://clubhouseprod.s3.amazonaws.com:443/1587577580_5e350517-4ba7-434c-a0b3-e18d52ccef13_thumbnail_250x250","username":"nadarabiee"},"clubs":[],"has_verified_email":false,"can_edit_username":false,"can_edit_name":true,"can_edit_displayname":true,"topics":[]},"success":true}""";
  }
}

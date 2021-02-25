import 'dart:convert';

import 'package:club_house_unofficial/api/models/User.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsController {
  static User user;
  static String deviceID = Uuid().v4().toString().toUpperCase();

  static Future<void> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userJson = prefs.getString("user");
    user = User.fromJson(json: jsonDecode(userJson));
    deviceID = prefs.getString("device_id");
    if (deviceID == null) {
      deviceID = Uuid().v4().toString().toUpperCase();
      prefs.setString('device_id', deviceID);
    }
  }

  static void write() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (deviceID == null) {
      deviceID = Uuid().v4().toString().toUpperCase();
    }
    prefs.setString("device_id", deviceID);
    prefs.setString("user", jsonEncode(user));
  }

  static bool isLoggedIn() {
    return user?.userId != null;
  }
}

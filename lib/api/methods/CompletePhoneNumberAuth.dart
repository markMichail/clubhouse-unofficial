import 'dart:convert';

import 'package:club_house_unofficial/api/keys.dart';
import 'package:club_house_unofficial/api/models/User.dart';
import 'package:club_house_unofficial/api/sharedPrefsController.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompletePhoneNumberAuth {
  String phoneNumber;
  CompletePhoneNumberAuth({@required this.phoneNumber});

  Future<Map<String, dynamic>> verifyCode(verificationCode) async {
    try {
      Dio dio = new Dio();
      var response = await dio.post(
        "$API_URL/complete_phone_number_auth",
        options: Options(headers: headers(isAuth: false)),
        data: {
          "phone_number": this.phoneNumber,
          "verification_code": verificationCode
        },
      );
      if (DEBUG)
        print(
            "complete_phone_number_auth : responose.statusCode = ${response.statusCode} , response.body = ${response.data}");
      if (response.statusCode == 200) {
        var data = jsonDecode(jsonEncode(response.data));
        data['user_profile']['auth_token'] = data['auth_token'];
        data['user_profile']['is_waitlisted'] = data['is_waitlisted'];
        SharedPreferences.getInstance().then((prefs) {
          prefs.clear();
          User user = User.fromJson(json: data['user_profile']);
          SharedPrefsController.user = user;
          SharedPrefsController.write();
        });
        data['success'] = true;
        return data;
      } else
        return {'success': false, 'message': 'Error: ${response.statusCode}'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}

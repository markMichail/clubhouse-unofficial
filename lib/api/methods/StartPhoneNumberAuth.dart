import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:club_house_unofficial/api/keys.dart';
import 'package:flutter/widgets.dart';

class StartPhoneNumberAuth {
  String phoneNumber;
  BuildContext context;
  StartPhoneNumberAuth({@required this.phoneNumber, @required this.context});

  Future<Map<String, dynamic>> getVerificationCode() async {
    try {
      Dio dio = new Dio();
      // print(headers(isAuth: false)['CH-Languages']);
      // print("$API_URL/start_phone_number_auth");
      // print(FormData.fromMap({"phone_number": phoneNumber}).toString());
      // return {'success': false, 'message': 'Error'};
      var response = await dio.post(
        "$API_URL/start_phone_number_auth",
        options: Options(
          headers: headers(isAuth: false),
        ),
        data: {"phone_number": phoneNumber},
      );
      print(response.statusCode);
      print(response.data);
      print(response.data.runtimeType);
      // print(jsonDecode(response.data));
      if (DEBUG)
        print(
            "start_phone_number_auth : responose.statusCode = ${response.statusCode} , response.body = ${response.data}");
      if (response.statusCode == 200)
        return response.data;
      else
        return {'success': false, 'message': 'Error: ${response.statusCode}'};
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': e.toString()};
    }
  }
}

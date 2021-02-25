import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:club_house_unofficial/api/keys.dart';
import 'package:club_house_unofficial/api/models/User.dart';

class GetChannels {
  User user;
  GetChannels({@required this.user});

  Future<dynamic> getChannels() async {
    try {
      Dio dio = new Dio();
      var response = await dio.post(
        "$API_URL/get_channels",
        options: Options(
          headers: headers(isAuth: true),
        ),
      );
      if (DEBUG)
        print(
            "get_channels : responose.statusCode = ${response.statusCode} , response.body = ${response.data}");

      if (response.statusCode == 200) {
        print("go back");
        response.data['success'] = true;
        return response.data;
      } else
        return {'success': false, 'message': 'Error: ${response.statusCode}'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}

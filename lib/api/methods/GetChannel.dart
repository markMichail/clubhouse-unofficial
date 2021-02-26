import 'dart:convert';

import 'package:club_house_unofficial/api/keys.dart';
import 'package:club_house_unofficial/api/models/ChannelUser.dart';
import 'package:club_house_unofficial/api/sharedPrefsController.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class GetChannel {
  String channel;
  int channelId;
  GetChannel({@required this.channel, this.channelId});

  Future<Map<String, dynamic>> exce() async {
    final response = await http.post(
      "$API_URL/get_channel",
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
        "channel": channel,
        "channel_id": channelId.toString(),
      },
    );

    if (response.statusCode == 200) {
      List<ChannelUser> speakers = [];
      List<ChannelUser> followedBySpeaker = [];
      List<ChannelUser> others = [];
      List users = jsonDecode(response.body)['users'];
      users.forEach((user) {
        if (user['is_speaker']) {
          speakers.add(ChannelUser.fromJson(user));
        } else if (user['is_followed_by_speaker'])
          followedBySpeaker.add(ChannelUser.fromJson(user));
        else
          others.add(ChannelUser.fromJson(user));
      });
      return {
        'speakers': speakers,
        'followedBySpeaker': followedBySpeaker,
        'others': others
      };
    }

    return null;
  }
}

import 'dart:convert';

import 'package:club_house_unofficial/api/sharedPrefsController.dart';
import 'package:flutter/material.dart';

const String TAG = "ClubhouseAPI";
const bool DEBUG = false;

const String API_URL = "https://www.clubhouseapi.com/api";

const String API_BUILD_ID = "304";
const String API_BUILD_VERSION = "0.1.28";
const String API_UA =
    "clubhouse/" + API_BUILD_ID + " (iPhone; iOS 13.5.1; Scale/3.00)";

const String PUBNUB_PUB_KEY = "pub-c-6878d382-5ae6-4494-9099-f930f938868b";
const String PUBNUB_SUB_KEY = "sub-c-a4abea84-9ca3-11ea-8e71-f2b83ac9263d";

const String TWITTER_ID = "NyJhARWVYU1X3qJZtC2154xSI";
const String TWITTER_SECRET =
    "ylFImLBFaOE362uwr4jut8S8gXGWh93S1TUKbkfh7jDIPse02o";

const String AGORA_KEY = "938de3e8055e42b281bb8c6f69c21f78";
const String SENTRY_KEY =
    "5374a416cd2d4009a781b49d1bd9ef44@o325556.ingest.sentry.io/5245095";
const String INSTABUG_KEY = "4e53155da9b00728caa5249f2e35d6b3";
const String AMPLITUDE_KEY = "9098a21a950e7cb0933fb5b30affe5be";

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

showLoadingDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => alert,
  );
}

headers({@required bool isAuth}) {
  if (isAuth) {
    return {
      'CH-Languages': 'en-US',
      'CH-Locale': 'en_US',
      'Accept': 'application/json',
      'CH-AppBuild': API_BUILD_ID,
      'CH-AppVersion': API_BUILD_VERSION,
      'User-Agent': API_UA,
      'CH-DeviceId': SharedPrefsController.deviceID,
      'Authorization': 'Token ' + SharedPrefsController.user.authToken,
      'CH-UserID': SharedPrefsController.user.userId.toString(),
    };
  } else {
    return {
      'CH-Languages': 'en-US',
      'CH-Locale': 'en_US',
      'Accept': 'application/json',
      'CH-AppBuild': API_BUILD_ID,
      'CH-AppVersion': API_BUILD_VERSION,
      'User-Agent': API_UA,
      'CH-DeviceId': SharedPrefsController.deviceID,
    };
  }
}

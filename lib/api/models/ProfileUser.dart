import 'dart:convert';

import 'package:club_house_unofficial/api/models/User.dart';
import 'package:intl/intl.dart';

class ProfileUser extends User {
  String displayname, bio, twitter, instagram;
  int numFollowers, numFollowing;
  bool followsMe, isBlockedByNetwork;
  String timeCreated;
  User invitedByUserProfile;
  // null = not following
  // 2 = following
  // other values = ?
  int notificationType;

  ProfileUser(json) {
    print(json);
    var data = jsonDecode(json);
    // print(data);
    userId = data['user_profile']['user_id'];
    photoUrl = data['user_profile']['photo_url'];
    name = data['user_profile']['name'];
    username = data['user_profile']['username'];
    displayname = data['user_profile']['displayname'];
    bio =
        data['user_profile']['bio'] == null ? "" : data['user_profile']['bio'];
    twitter = data['user_profile']['twitter'];
    instagram = data['user_profile']['instagram'];
    numFollowers = data['user_profile']['num_followers'];
    numFollowing = data['user_profile']['num_following'];
    followsMe = data['user_profile']['follows_me'];
    isBlockedByNetwork = data['user_profile']['is_blocked_by_network'];
    invitedByUserProfile = data['user_profile']['invited_by_user_profile'] !=
            null
        ? User.fromJson(json: data['user_profile']['invited_by_user_profile'])
        : null;

    var inputDate = DateFormat('yyyy-MM-ddThh:mm:ss')
        .parse(data['user_profile']['time_created']);
    timeCreated = DateFormat('MMM dd, yyyy').format(inputDate);
  }

  bool isFollowed() {
    return notificationType == 2;
  }
}

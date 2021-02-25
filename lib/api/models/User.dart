import 'package:flutter/widgets.dart';

class User with ChangeNotifier {
  int userId;
  String name;
  String photoUrl;
  String username;
  String authToken;
  bool waitlisted;

  // List<User> speakers;
  // List<User> followedBySpeaker;
  // List<User> others;
  // User.forUserChannel({this.userId, this.name, this.photoUrl});

  User({
    this.userId,
    this.name,
    this.authToken,
    this.photoUrl,
    this.username,
    this.waitlisted,
  });

  factory User.fromJson({@required Map<String, dynamic> json}) {
    return User(
      name: json['name'],
      authToken: json['auth_token'],
      photoUrl: json['photo_url'],
      userId: int.tryParse(json['user_id']),
      username: json['username'],
      waitlisted: json['waitlisted'],
    );
  }

  setProvider(json) {
    return User.fromJson(json: json);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'auth_token': authToken,
        'photo_url': photoUrl,
        'user_id': userId.toString(),
        'username': username,
        'waitlisted': waitlisted
      };

  // loadData({source}) {
  //   var data = jsonDecode(source);
  //   try {
  //     this.userId = int.parse(data['user_id']);
  //   } catch (e) {
  //     this.userId = data['user_id'];
  //   }
  //   // this.userId = int.parse(data['user_id']);
  //   this.name = data['name'];
  //   this.photoUrl = data['photo_url'];
  //   this.username = data['username'];
  //   this.authToken = data['user_token'];
  //   this.deviceId = data['device_id'] ?? "";
  // }
}

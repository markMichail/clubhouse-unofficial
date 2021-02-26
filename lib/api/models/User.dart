import 'package:flutter/widgets.dart';

class User with ChangeNotifier {
  int userId;
  String name;
  String photoUrl;
  String username;
  String authToken;
  bool isWaitlisted;

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
    this.isWaitlisted,
  });

  factory User.fromJson({@required Map<String, dynamic> json}) {
    return User(
      name: json['name'] ?? "",
      authToken: json['auth_token'] ?? "",
      photoUrl: json['photo_url'],
      userId: int.parse(json['user_id'].toString()),
      username: json['username'] ?? "",
      isWaitlisted: json['is_waitlisted'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'auth_token': authToken,
        'photo_url': photoUrl,
        'user_id': userId.toString(),
        'username': username,
        'is_waitlisted': isWaitlisted
      };
}

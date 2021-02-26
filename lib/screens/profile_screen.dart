import 'package:club_house_unofficial/api/keys.dart';
import 'package:club_house_unofficial/api/methods/GetProfile.dart';
import 'package:club_house_unofficial/api/models/ChannelUser.dart';
import 'package:club_house_unofficial/api/models/ProfileUser.dart';
import 'package:club_house_unofficial/api/models/User.dart';
import 'package:club_house_unofficial/widgets/squircle_widget.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  final ChannelUser channelUser;
  ProfileScreen({this.user, this.channelUser});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _userId;
  Future<String> profileUser;

  @override
  Widget build(BuildContext context) {
    _userId =
        widget.user != null ? widget.user.userId : widget.channelUser.userId;
    profileUser = GetProfile(userId: _userId).getProfile();
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        // actions: [
        //   SizedBox(width: 10.0),
        //   IconButton(
        //     icon: Icon(Icons.search),
        //     onPressed: () {},
        //   ),
        //   Spacer(),
        //   InkWell(child: CircleAvatar()),
        // ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            profileUser = GetProfile(userId: _userId).getProfile();
          });
          return profileUser;
        },
        child: FutureBuilder(
          future: profileUser,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              ProfileUser _profileUser = ProfileUser(snapshot.data.toString());
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SquircleUser(
                        photoUrl: _profileUser.photoUrl,
                        size: 120,
                      ),
                      SizedBox(height: 20),
                      Text(
                        _profileUser.name,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 8),
                      Text("@" + _profileUser.username),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          InkWell(
                              onTap: () {},
                              child: Text(
                                  "${_profileUser.numFollowers} Follower")),
                          SizedBox(width: 20),
                          InkWell(
                              onTap: () {},
                              child: Text(
                                  "${_profileUser.numFollowing} Following"))
                        ],
                      ),
                      SizedBox(height: 30),
                      InkWell(
                        onTap: () {},
                        child: Text(utf8convert(_profileUser.bio)),
                      ),
                      SizedBox(height: 25),
                      _profileUser.invitedByUserProfile != null
                          ? ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                      user: _profileUser.invitedByUserProfile,
                                    ),
                                  ),
                                );
                              },
                              contentPadding: const EdgeInsets.all(0),
                              leading: SquircleUser(
                                photoUrl:
                                    _profileUser.invitedByUserProfile?.photoUrl,
                                size: 45,
                              ),
                              title: Text("Joined ${_profileUser.timeCreated}"),
                              subtitle: Text(
                                  "Nominated by ${_profileUser.invitedByUserProfile.name}"),
                            )
                          : Container()
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

import 'package:club_house_unofficial/api/keys.dart';
import 'package:club_house_unofficial/api/methods/GetProfile.dart';
import 'package:club_house_unofficial/api/models/ProfileUser.dart';
import 'package:club_house_unofficial/api/models/User.dart';
import 'package:club_house_unofficial/widgets/squircle_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  ProfileScreen({this.user});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // User authUser = Provider.of<User>(context);
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
      body: FutureBuilder(
        future: GetProfile(user: widget.user).getProfile(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            ProfileUser profileUser = ProfileUser(snapshot.data.toString());
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 30, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SquircleUser(
                      photoUrl: profileUser.photoUrl,
                      size: 120,
                    ),
                    SizedBox(height: 20),
                    Text(
                      profileUser.name,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 8),
                    Text("@" + profileUser.username),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        InkWell(
                            onTap: () {},
                            child:
                                Text("${profileUser.numFollowers} Follower")),
                        SizedBox(width: 20),
                        InkWell(
                            onTap: () {},
                            child:
                                Text("${profileUser.numFollowing} Following"))
                      ],
                    ),
                    SizedBox(height: 30),
                    InkWell(
                      onTap: () {},
                      child: Text(utf8convert(profileUser.bio)),
                    ),
                    SizedBox(height: 25),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              user: profileUser.invitedByUserProfile,
                            ),
                          ),
                        );
                      },
                      contentPadding: const EdgeInsets.all(0),
                      leading: SquircleUser(
                        photoUrl: profileUser.invitedByUserProfile.photoUrl,
                        size: 45,
                      ),
                      title: Text("Joined ${profileUser.timeCreated}"),
                      subtitle: Text(
                          "Nominated by ${profileUser.invitedByUserProfile.name}"),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

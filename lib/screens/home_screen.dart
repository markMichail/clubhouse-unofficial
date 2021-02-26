import 'package:club_house_unofficial/api/methods/GetChannels.dart';
import 'package:club_house_unofficial/api/models/Channel.dart';
import 'package:club_house_unofficial/api/models/User.dart';
import 'package:club_house_unofficial/widgets/channel_home_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:club_house_unofficial/widgets/squircle_widget.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<dynamic> data;
  User user;
  List<Channel> channels = List<Channel>();

  List<Widget> appBarActions(user) => [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: IconButton(
            icon: Icon(
              Icons.notifications_none_outlined,
              color: Colors.grey[600],
              size: 30,
            ),
            onPressed: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15, top: 10),
          child: InkWell(
            onTap: () {},
            child: SquircleUser(
              photoUrl: user.photoUrl,
              size: 40.0,
            ),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    data = GetChannels(user: user).getChannels();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: appBarActions(user),
      ),
      body: FutureBuilder(
        future: data,
        builder: (_, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError)
            return errorWidget('Error: ${snapshot.error}');
          else if (snapshot.hasData) {
            if (snapshot.data['success']) {
              Map<String, dynamic> map =
                  Map<String, dynamic>.from(snapshot.data);
              List<dynamic> channelsJson = map["channels"];
              channels = [];
              channelsJson.forEach((channel) {
                channels.add(Channel.fromJson(channel));
              });
              //print("home_screen channels count: ${channels.length}");
              return RefreshIndicator(
                onRefresh: () {
                  setState(() {
                    data = GetChannels(user: user).getChannels();
                    data.then((p) {
                      Map<String, dynamic> map = Map<String, dynamic>.from(p);
                      List<dynamic> channelsJson = map["channels"];
                      channels = [];
                      channelsJson.forEach((channel) {
                        channels.add(Channel.fromJson(channel));
                      });
                    });
                  });
                  return data;
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: channels.length,
                    itemBuilder: (context, index) {
                      return ChannelHomeScreenWidget(channel: channels[index]);
                    },
                  ),
                ),
              );
            } else
              return errorWidget('Error loading data!');
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Center errorWidget(String text) {
    return Center(
      child: Column(
        children: [
          Text(text),
          MaterialButton(
            child: Text("Retry"),
            color: Colors.grey,
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}

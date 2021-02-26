import 'dart:convert';
import 'dart:developer';

import 'package:club_house_unofficial/api/DataProvider.dart';
// import 'package:club_house_unofficial/api/call.dart';
import 'package:club_house_unofficial/api/keys.dart';
import 'package:club_house_unofficial/api/methods/JoinChannel.dart';
import 'package:club_house_unofficial/api/methods/LeaveChannel.dart';
import 'package:club_house_unofficial/api/models/Channel.dart';
import 'package:club_house_unofficial/screens/call_screen.dart';
import 'package:club_house_unofficial/widgets/squircle_widget.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ChannelHomeScreenWidget extends StatefulWidget {
  final Channel channel;

  ChannelHomeScreenWidget({@required this.channel});

  @override
  _ChannelHomeScreenWidgetState createState() =>
      _ChannelHomeScreenWidgetState();
}

class _ChannelHomeScreenWidgetState extends State<ChannelHomeScreenWidget> {
  Channel _channelToOpen;

  void joinChannel() async {
    _channelToOpen = DataProvider.getChannel(widget.channel.channel.toString());
    if (await Permission.microphone.request().isGranted) {
      if (_channelToOpen != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(
              channel: _channelToOpen,
            ),
          ),
        );
      } else {
        if (CallScreen.engine != null) {
          try {
            LeaveChannel(
                    channel: widget.channel.channel,
                    channelId: widget.channel.channelId)
                .leave();
            CallScreen.engine.leaveChannel();
            CallScreen.engine.destroy();
            CallScreen.engine = null;
          } catch (e) {}
        }
        showLoadingDialog(context);
        JoinChannel(channel: widget.channel.channel).join().then((response) {
          Map<String, dynamic> _obj = jsonDecode(response);
          widget.channel.token = _obj['token'];
          DataProvider.saveChannel(widget.channel);
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CallScreen(
                channel: widget.channel,
              ),
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          joinChannel();
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                    widget.channel.topic == null ? "" : widget.channel.topic),
              ),
              Row(
                children: [
                  Container(
                    height: 80,
                    width: 100,
                    child: Stack(
                      overflow: Overflow.visible,
                      children: [
                        Positioned(
                          child: SquircleUser(
                            photoUrl: widget.channel.users[0].photoUrl == null
                                ? "https://media.istockphoto.com/vectors/default-profile-picture-avatar-photo-placeholder-vector-illustration-vector-id1214428300?k=6&m=1214428300&s=612x612&w=0&h=rvt5KGND3z8kfrHELplF9zmr8d6COZQ-1vYK9mvSxnc="
                                : widget.channel.users[0].photoUrl,
                            size: 50,
                          ),
                        ),
                        Positioned(
                          top: 20,
                          left: 25,
                          child: SquircleUser(
                            photoUrl: widget.channel.users.length < 2
                                ? "https://media.istockphoto.com/vectors/default-profile-picture-avatar-photo-placeholder-vector-illustration-vector-id1214428300?k=6&m=1214428300&s=612x612&w=0&h=rvt5KGND3z8kfrHELplF9zmr8d6COZQ-1vYK9mvSxnc="
                                : widget.channel.users[1].photoUrl == null
                                    ? "https://media.istockphoto.com/vectors/default-profile-picture-avatar-photo-placeholder-vector-illustration-vector-id1214428300?k=6&m=1214428300&s=612x612&w=0&h=rvt5KGND3z8kfrHELplF9zmr8d6COZQ-1vYK9mvSxnc="
                                    : widget.channel.users[1].photoUrl,
                            size: 50,
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i in widget.channel.users)
                        Row(
                          children: [
                            Text(i.name),
                            i.isSpeaker
                                ? SizedBox(
                                    width: 15,
                                    child: Icon(
                                      Icons.speaker_notes_rounded,
                                      color: Colors.grey[600],
                                      size: 18,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Text(widget.channel.numAll.toString()),
                            SizedBox(width: 5),
                            Icon(
                              Icons.person,
                              color: Colors.grey[600],
                              size: 22,
                            ),
                            SizedBox(width: 20),
                            Text(widget.channel.numSpeakers.toString()),
                            SizedBox(width: 5),
                            Icon(
                              Icons.speaker_notes_rounded,
                              color: Colors.grey[600],
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

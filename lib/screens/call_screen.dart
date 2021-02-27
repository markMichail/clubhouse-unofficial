import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:club_house_unofficial/api/keys.dart';
import 'package:club_house_unofficial/api/methods/AcceptSpeakerInvite.dart';
import 'package:club_house_unofficial/api/methods/AudienceReply.dart';
import 'package:club_house_unofficial/api/methods/GetChannel.dart';
import 'package:club_house_unofficial/api/methods/LeaveChannel.dart';
import 'package:club_house_unofficial/api/models/Channel.dart';
import 'package:club_house_unofficial/api/models/ChannelUser.dart';
import 'package:club_house_unofficial/api/sharedPrefsController.dart';
import 'package:club_house_unofficial/screens/profile_screen.dart';
import 'package:club_house_unofficial/widgets/squircle_widget.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:toast/toast.dart';

class CallScreen extends StatefulWidget {
  static const routeName = '/callScreen';
  final Channel channel;
  static RtcEngine engine;

  /// Creates a call page with given channel name.
  const CallScreen({Key key, this.channel}) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  int speakerId = 0;
  Future<Map<String, dynamic>> data;
  List<int> mutedUserIds = [];
  ChannelUser me;
  bool askAboutInvitation = true;
  fetchData() async {
    setState(() {
      data = GetChannel(
        channel: widget.channel.channel,
        channelId: widget.channel.channelId,
      ).exce();
      data.then((d) {
        me = d['me'];
      });
    });
  }

  // User user;
  // @override
  // void dispose() {
  //   // clear users
  //   _users.clear();
  //   // destroy sdk
  //   widget.engine.leaveChannel();
  //   widget.engine.destroy();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    fetchData();
    CallScreen.engine?.leaveChannel();
    CallScreen.engine?.destroy();
    CallScreen.engine = null;
    onCreate();
  }

  void onCreate() async {
    try {
      CallScreen.engine = await RtcEngine.create(AGORA_KEY);
      // CallScreen.engine.setChannelProfile(ChannelProfile.Communication);
      // CallScreen.engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
      // YOU HAVE TO APPLY THIS TO USE MIC
      CallScreen.engine.setChannelProfile(me != null && me.isSpeaker
          ? ChannelProfile.Communication
          : ChannelProfile.LiveBroadcasting);
    } catch (x) {
      // print(TAG + ": Error initializing agora" + x.toString());
      return;
    }

    CallScreen.engine.setDefaultAudioRoutetoSpeakerphone(true);
    CallScreen.engine.enableAudioVolumeIndication(500, 3, false);
    CallScreen.engine.muteLocalAudioStream(true);

    CallScreen.engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {},
      activeSpeaker: (uid) {
        setState(() {
          speakerId = uid;
        });
      },
      userMuteAudio: (uid, isMute) {
        setState(() {
          print("Speaker $uid isMute: $isMute");
          isMute ? mutedUserIds.add(uid) : mutedUserIds.remove(uid);
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) {},
      leaveChannel: (stats) {},
      userJoined: (uid, elapsed) {},
      userOffline: (uid, elapsed) {},
    ));

    await CallScreen.engine.joinChannel(widget.channel.token,
        widget.channel.channel, null, SharedPrefsController.user.userId);
    // , "xX3p3ovP", null,
    // SharedPrefsController.user.userId);
  }

  void _onCallEnd(BuildContext context) {
    LeaveChannel(channel: widget.channel.channel).leave().then((a) {
      // _users.clear();
      CallScreen.engine?.leaveChannel();
      CallScreen.engine?.destroy();
      CallScreen.engine = null;
      Navigator.of(context).pop();
    });
  }

  void _onToggleMute() async {
    setState(() {
      me.isMuted = !me.isMuted;
    });
    await CallScreen.engine.muteLocalAudioStream(me.isMuted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: widget.channel.topic != null
            ? widget.channel.topic.length > 30
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: AppBar().preferredSize.height,
                    child: Marquee(
                      scrollAxis: Axis.horizontal,
                      text: widget.channel.topic,
                      blankSpace: 20,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  )
                : Text(widget.channel.topic)
            : Text(""),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: data,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    var dataJson = snapshot.data;
                    // me = dataJson['me'];
                    if (me.isSpeaker)
                      CallScreen.engine
                          .setChannelProfile(ChannelProfile.Communication);
                    if (me.isInvitedAsSpeaker && askAboutInvitation) {
                      askAboutInvitation = false;
                      joinRequest(context);
                    }
                    return RefreshIndicator(
                      onRefresh: () {
                        setState(() {
                          askAboutInvitation = true;
                          data = GetChannel(
                            channel: widget.channel.channel,
                            channelId: widget.channel.channelId,
                          ).exce();
                          data.then((d) {
                            me = d['me'];
                          });
                        });
                        return data;
                      },
                      child: CustomScrollView(
                        slivers: [
                          SliverPadding(
                              padding: const EdgeInsets.only(top: 10.0)),
                          SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            delegate: SliverChildListDelegate(
                              [
                                for (ChannelUser speaker
                                    in dataJson['speakers'])
                                  mutedUserIds.contains(speaker.userId)
                                      ? mutedSpeaker(context, speaker)
                                      : unMutedSpeaker(speaker),
                              ],
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                dataJson['followedBySpeaker'].length > 0
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          left: 15,
                                          bottom: 25,
                                        ),
                                        child: Text(
                                          "Followed by Speaker",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4),
                            delegate: SliverChildListDelegate(
                              [
                                for (ChannelUser followedBySpeaker
                                    in dataJson['followedBySpeaker'])
                                  followedBySpeakerUser(followedBySpeaker),
                              ],
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                dataJson['others'].length > 0
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          left: 15,
                                          bottom: 25,
                                        ),
                                        child: Text(
                                          "Audience",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4),
                            delegate: SliverChildListDelegate(
                              [
                                for (ChannelUser other in dataJson['others'])
                                  audience(context, other),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          _buttomBar(context)
        ],
      ),
    );
  }

  Future joinRequest(BuildContext context) async {
    await Future.delayed(Duration(microseconds: 1));
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Alert!"),
        content: Text("You are invited to join as speaker!"),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Join"),
            onPressed: () async {
              AcceptSpeakerInvite(channel: widget.channel.channel).accept();
              CallScreen.engine.leaveChannel();
              CallScreen.engine.destroy();
              CallScreen.engine = null;
              await CallScreen.engine.joinChannel(
                  widget.channel.token,
                  widget.channel.channel,
                  null,
                  SharedPrefsController.user.userId);
              CallScreen.engine.setChannelProfile(ChannelProfile.Communication);
              fetchData();
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            child: new Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  InkWell audience(BuildContext context, ChannelUser other) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProfileScreen(
              channelUser: other,
            ),
          ),
        );
      },
      child: SquircleUser(
        photoUrl: other.photoUrl == null
            ? "https://media.istockphoto.com/vectors/default-profile-picture-avatar-photo-placeholder-vector-illustration-vector-id1214428300?k=6&m=1214428300&s=612x612&w=0&h=rvt5KGND3z8kfrHELplF9zmr8d6COZQ-1vYK9mvSxnc="
            : other.photoUrl,
        isSpeaking: other.userId == speakerId ? true : false,
        name: other.name,
        size: 65,
      ),
    );
  }

  InkWell followedBySpeakerUser(ChannelUser followedBySpeaker) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProfileScreen(channelUser: followedBySpeaker),
          ),
        );
      },
      child: SquircleUser(
        photoUrl: followedBySpeaker.photoUrl == null
            ? "https://media.istockphoto.com/vectors/default-profile-picture-avatar-photo-placeholder-vector-illustration-vector-id1214428300?k=6&m=1214428300&s=612x612&w=0&h=rvt5KGND3z8kfrHELplF9zmr8d6COZQ-1vYK9mvSxnc="
            : followedBySpeaker.photoUrl,
        isSpeaking: followedBySpeaker.userId == speakerId ? true : false,
        name: followedBySpeaker.name,
        size: 65,
      ),
    );
  }

  Widget unMutedSpeaker(ChannelUser speaker) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProfileScreen(channelUser: speaker),
          ),
        );
      },
      child: SquircleUser(
        photoUrl: speaker.photoUrl == null
            ? "https://media.istockphoto.com/vectors/default-profile-picture-avatar-photo-placeholder-vector-illustration-vector-id1214428300?k=6&m=1214428300&s=612x612&w=0&h=rvt5KGND3z8kfrHELplF9zmr8d6COZQ-1vYK9mvSxnc="
            : speaker.photoUrl,
        isSpeaking: speaker.userId == speakerId ? true : false,
        name: speaker.name,
        size: 90,
      ),
    );
  }

  Widget mutedSpeaker(BuildContext context, ChannelUser speaker) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProfileScreen(channelUser: speaker),
          ),
        );
      },
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SquircleUser(
              photoUrl: speaker.photoUrl == null
                  ? "https://media.istockphoto.com/vectors/default-profile-picture-avatar-photo-placeholder-vector-illustration-vector-id1214428300?k=6&m=1214428300&s=612x612&w=0&h=rvt5KGND3z8kfrHELplF9zmr8d6COZQ-1vYK9mvSxnc="
                  : speaker.photoUrl,
              isSpeaking: speaker.userId == speakerId ? true : false,
              isModerator: speaker.isModerator,
              name: speaker.name,
              size: 90,
            ),
            Positioned(
              top: 60,
              left: 85,
              child: ClipOval(
                child: Material(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(Icons.mic_off),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buttomBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                "Leave quietly",
                style: TextStyle(color: Colors.red),
              ),
              color: Colors.grey[100],
              onPressed: () {
                _onCallEnd(context);
              },
            ),
          ),
          Spacer(),
          me != null && !me.isSpeaker
              ? RawMaterialButton(
                  shape: CircleBorder(),
                  fillColor: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.pan_tool_rounded,
                      color: Colors.amber,
                    ),
                  ),
                  onPressed: () {
                    AudienceReply(channel: widget.channel.channel).raiseHand();
                    Toast.show(
                      "Hand Raised!",
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.BOTTOM,
                      backgroundRadius: 15,
                    );
                  },
                )
              : Container(),
          me != null && me.isSpeaker
              ? MaterialButton(
                  child: Icon(
                    me.isMuted ? Icons.mic_off : Icons.mic,
                    // Icons.mic_off,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    _onToggleMute();
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}

import 'package:club_house_unofficial/api/models/ChannelUser.dart';

class Channel {
  /*
	* "channels":[
{
"creator_user_profile_id":5468389,
"channel_id":15215112,
"channel":"xlJkYk6m",
"topic":null,
"is_private":false,
"is_social_mode":false,
"url":"https://www.joinclubhouse.com/room/xlJkYk6m",
"feature_flags":[
],
"club":null,
"club_name":null,
"club_id":null,
"welcome_for_user_profile":null,
"num_other":0,
"has_blocked_speakers":false,
"is_explore_channel":false,
"num_speakers":8,
"num_all":184,
"users":[
{
"user_id":877820863,
"name":"Валентин Кашпур",
"photo_url":"https://clubhouseprod.s3.amazonaws.com:443/877820863_2cd32360-0f8a-46c1-826e-ae88f66ebc36_thumbnail_250x250",
"is_speaker":true,
"is_moderator":true,
"time_joined_as_speaker":"2021-02-19T00:52:31.484403+00:00",
"is_followed_by_speaker":true,
"is_invited_as_speaker":true
},
{
"user_id":1808486887,
"name":"Bogdan Kalashnikov",
"photo_url":"https://clubhouseprod.s3.amazonaws.com:443/1808486887_b08a9768-71a5-4968-a5bd-f4998bea0a95_thumbnail_250x250",
"is_speaker":true,
"is_moderator":true,
"time_joined_as_speaker":"2021-02-19T02:26:02.364976+00:00",
"is_followed_by_speaker":true,
"is_invited_as_speaker":true
},
{
"user_id":261058534,
"name":"Yulia Lis",
"photo_url":"https://clubhouseprod.s3.amazonaws.com:443/261058534_a3a1f882-487b-450a-be69-6c5a268c6b38_thumbnail_250x250",
"is_speaker":true,
"is_moderator":true,
"time_joined_as_speaker":"2021-02-19T02:30:29.539969+00:00",
"is_followed_by_speaker":true,
"is_invited_as_speaker":true
}
]
	* */

  int creatorUserProfileId;
  int channelId;
  String channel;
  String topic;
  bool isPrivate;
  bool isSocialMode;
  String url;
  int numOther;
  bool hasBlockedSpeakers;
  bool isExploreChannel;
  int numSpeakers;
  int numAll;
  List<ChannelUser> users;
  String token;
  bool isHandraiseEnabled;
  // String pubnubToken;
  // int pubnubHeartbeatValue;
  // int pubnubHeartbeatInterval;

  // int describeContents() {
  //   return 0;
  // }
  Channel({
    this.creatorUserProfileId,
    this.channelId,
    this.channel,
    this.topic,
    this.isPrivate,
    this.isSocialMode,
    this.url,
    this.numOther,
    this.hasBlockedSpeakers,
    this.isExploreChannel,
    this.numSpeakers,
    this.numAll,
    this.users,
    this.token,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    List<dynamic> channelUsersJson = json["users"];
    List<ChannelUser> channelUsers = [];
    channelUsersJson.forEach((user) {
      channelUsers.add(ChannelUser.fromJson(user));
    });
    return Channel(
      creatorUserProfileId: json['creator_user_profile_id'],
      channelId: json['channel_id'],
      channel: json['channel'],
      topic: json['topic'],
      isPrivate: json['is_private'],
      isSocialMode: json['is_social_mode'],
      url: json['url'],
      numOther: json['num_other'],
      hasBlockedSpeakers: json['has_blocked_speakers'],
      isExploreChannel: json['is_explore_channel'],
      numSpeakers: json['num_speakers'],
      numAll: json['num_all'],
      users: channelUsers,
      token: json['token'],
    );
  }

  //  void writeToParcel(Parcel dest, int flags){
  // 	dest.writeInt(this.creatorUserProfileId);
  // 	dest.writeInt(this.channelId);
  // 	dest.writeString(this.channel);
  // 	dest.writeString(this.topic);
  // 	dest.writeByte(this.isPrivate ? (byte) 1 : (byte) 0);
  // 	dest.writeByte(this.isSocialMode ? (byte) 1 : (byte) 0);
  // 	dest.writeString(this.url);
  // 	dest.writeInt(this.numOther);
  // 	dest.writeByte(this.hasBlockedSpeakers ? (byte) 1 : (byte) 0);
  // 	dest.writeByte(this.isExploreChannel ? (byte) 1 : (byte) 0);
  // 	dest.writeInt(this.numSpeakers);
  // 	dest.writeInt(this.numAll);
  // 	dest.writeTypedList(this.users);
  // 	dest.writeString(this.token);
  // 	dest.writeByte(this.isHandraiseEnabled ? (byte) 1 : (byte) 0);
  // 	dest.writeString(this.pubnubToken);
  // 	dest.writeInt(this.pubnubHeartbeatValue);
  // 	dest.writeInt(this.pubnubHeartbeatInterval);
  // }

  //  void readFromParcel(Parcel source){
  // 	this.creatorUserProfileI:source.readInt();
  // 	this.channelI:source.readInt();
  // 	this.channe:source.readString();
  // 	this.topi:source.readString();
  // 	this.isPrivat:source.readByte():0;
  // 	this.isSocialMod:source.readByte():0;
  // 	this.ur:source.readString();
  // 	this.numOthe:source.readInt();
  // 	this.hasBlockedSpeaker:source.readByte():0;
  // 	this.isExploreChanne:source.readByte():0;
  // 	this.numSpeaker:source.readInt();
  // 	this.numAl:source.readInt();
  // 	this.user:source.createTypedArrayList(ChannelUser.CREATOR);
  // 	this.toke:source.readString();
  // 	this.isHandraiseEnable:source.readByte():0;
  // 	this.pubnubToke:source.readString();
  // 	this.pubnubHeartbeatValu:source.readInt();
  // 	this.pubnubHeartbeatInterva:source.readInt();
  // }

  // Channel(Parcel in){
  // 	this.creatorUserProfileI:in.readInt();
  // 	this.channelI:in.readInt();
  // 	this.channe:in.readString();
  // 	this.topi:in.readString();
  // 	this.isPrivat:in.readByte():0;
  // 	this.isSocialMod:in.readByte():0;
  // 	this.ur:in.readString();
  // 	this.numOthe:in.readInt();
  // 	this.hasBlockedSpeaker:in.readByte():0;
  // 	this.isExploreChanne:in.readByte():0;
  // 	this.numSpeaker:in.readInt();
  // 	this.numAl:in.readInt();
  // 	this.user:in.createTypedArrayList(ChannelUser.CREATOR);
  // 	this.toke:in.readString();
  // 	this.isHandraiseEnable:in.readByte():0;
  // 	this.pubnubToke:in.readString();
  // 	this.pubnubHeartbeatValu:in.readInt();
  // 	this.pubnubHeartbeatInterva:in.readInt();
  // }
}

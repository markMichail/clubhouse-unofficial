class ChannelUser {
  final int userId;
  final String name;
  final String photoUrl;
  final bool isSpeaker;
  final bool isModerator;
  final bool isFollowedBySpeaker;
  final bool isInvitedAsSpeaker;
  final String timeJoinedAsSpeaker;
  bool isNew;
  String firstName;
  bool isMuted;

  ChannelUser({
    this.userId,
    this.name,
    this.photoUrl,
    this.isSpeaker,
    this.isModerator,
    this.isFollowedBySpeaker,
    this.isInvitedAsSpeaker,
    this.isNew,
    this.timeJoinedAsSpeaker,
    this.isMuted,
  });

  factory ChannelUser.fromJson(Map<String, dynamic> json) {
    return ChannelUser(
      userId: int.parse(json['user_id'].toString()),
      name: json['name'],
      photoUrl: json['photo_url'],
      isSpeaker: json['is_speaker'],
      isFollowedBySpeaker: json['is_followed_by_speaker'],
      isInvitedAsSpeaker: json['is_invited_as_speaker'],
      isNew: json['is_new'],
      isMuted: json['is_muted'] == null ? true : json['is_muted'],
      isModerator: json['is_moderator'],
    );
  }
}

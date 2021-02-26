import 'package:club_house_unofficial/api/models/Channel.dart';

class DataProvider {
  static Channel channelCache;

  static Channel getChannel(String id) {
    if (channelCache == null) return null;
    return channelCache.channel == id ? channelCache : null;
  }

  static void saveChannel(Channel channel) {
    channelCache = channel;
  }
}

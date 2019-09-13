import "dart:async";
import 'package:flutter_go/model/playList.dart';
import 'package:flutter_go/model/playListItem.dart';
import "package:http/http.dart" as http;
import 'dart:developer';
import 'dart:convert';

const YOUTUBE_DATA_API_KEY = 'AIzaSyAo2S2MqNTn1mw7Kzk-E4zZPrzBnxJCDs0';
const PLAY_LIST_ID = 'FL-mhB5Q4QfGaY249PUrPJtQ';
const YOUTUBE_DATA_PLAYLIST_ITEMS_URL =
    'https://www.googleapis.com/youtube/v3/playlistItems';
const YOUTUBE_DATA_PLAYLIST_URL =
    'https://www.googleapis.com/youtube/v3/playlists';

Future<PlayList> getYoutubePlayList(String accessToken) async {
  var auth = new Map<String, String>();
  auth['Authorization'] = 'Bearer $accessToken';
  print(auth);
  final http.Response response = await http.get(
      '$YOUTUBE_DATA_PLAYLIST_URL?part=snippet,contentDetails&maxResults=25&mine=true&key=$YOUTUBE_DATA_API_KEY',
      headers: auth);
  if (response.statusCode != 200) {
    print(
        'getYoutubePlayList failed API ${response.statusCode} response: ${response.body}');
    return null;
  }

  log('item: ${response.body}');
  String rawJson = '${response.body}';
  Map<String, dynamic> map = jsonDecode(rawJson);
  PlayList playList = PlayList.fromJson(map);
  // for (var items in playList.items) {
  //   log('playList items: ${items.snippet.title}');
  //   print('playlist id = ${items.id}' );
  //   print('title = ${items.snippet.title}');
  //   print('defaultImage = ${items.snippet.thumbnails.defaultImage.url}');
  // }

  return playList;
}

Future<PlayListItem> getYoutubePlayListItem(String playlistId) async {
  final http.Response response = await http.get(
      '$YOUTUBE_DATA_PLAYLIST_ITEMS_URL?part=snippet&maxResults=30&playlistId=$playlistId&key=$YOUTUBE_DATA_API_KEY');
  if (response.statusCode != 200) {
    print(
        'getYoutubePlayListItem failed ${response.statusCode} response: ${response.body}');
    return null ;
  }

  log('item: ${response.body}');
  String rawJson = '${response.body}';
  Map<String, dynamic> map = jsonDecode(rawJson);
  PlayListItem playListItem = PlayListItem.fromJson(map);

  return playListItem;
  // try {
  //   for (var items in playListItem.items) {
  //     log('playList items title: ${items.snippet.title}');
  //     log('playList items description: ${items.snippet.title}');
  //     log('playlist video id = ${items.snippet.resourceId.videoId}');
  //     log('defaultImage = ${items.snippet.thumbnails.defaultImage.url}');
  //   }
  // } catch (e) {}
}

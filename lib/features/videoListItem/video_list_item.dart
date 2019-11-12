import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_go/model/play_list.dart';
import 'package:flutter_go/model/play_list_item.dart';
import 'package:flutter_go/network/youtube_api_service.dart';
import 'package:flutter_go/widgets/webview_youtube_player.dart';

class VideoListItem extends StatefulWidget {
  VideoListItem({Key key, this.playListId}) : super(key: key);

  String playListId;
  String _playingVideoId;

  @override
  _VideoListItemState createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  PlayListItem _playListItem;

  String _playingVideoId;
  

  @override
  void initState() {
    super.initState();
    getYoutubePlayListItem(widget.playListId).then((result) {
      setState(() {
        _playListItem = result;
      });
    });
  }

  void onTapped(index) {
    // navigate to the next screen.
    var id = _playListItem.items[index].snippet.resourceId.videoId;
    print('onTapped playListItem video id = $id');
    _navigateYTPlayer(id);
  }

  void _navigateYTPlayer(String videoId) {
    setState(() {
      _playingVideoId = videoId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video List'),
      ),
      body: Column(
        children: <Widget>[
          _playingVideoId != null ? WebViewYoutubePlayer(videoId: _playingVideoId) : Text('choose a song..'),
          // WebViewYoutubePlayer(videoId: _playingVideoId),
          Expanded(
            child: SafeArea(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  if (_playListItem == null ||
                      _playListItem.items == null ||
                      _playListItem.items[index] == null) {
                    return Text('loading...');
                  }

                  var data = _playListItem.items[index];

                  return ListTile(
                    leading: Image.network(
                        data.snippet.thumbnails.defaultImage.url),
                    title: Text(data.snippet.title),
                    onTap: () => onTapped(index),
                  );
                },
                itemCount: _playListItem?.items?.length ?? 0,
              ),
            ),
          )
        ],
      ),
    );
  }
}

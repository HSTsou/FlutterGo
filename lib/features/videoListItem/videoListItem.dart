import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_go/model/playList.dart';
import 'package:flutter_go/model/playListItem.dart';
import 'package:flutter_go/network/youtubeAPIService.dart';
import 'package:flutter_go/widgets/webviewYoutubePlayer.dart';

class VideoListItem extends StatefulWidget {
  VideoListItem({Key key, this.playListId}) : super(key: key);

  String playListId;

  @override
  _VideoListItemState createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  PlayListItem _playListItem;

  @override
  void initState() {
    super.initState();
    getYoutubePlayListItem(widget.playListId).then((result) {
      setState(() {
        _playListItem = result;
      });
      try {
        for (var items in _playListItem.items) {
          // log('playList items title: ${items.snippet.title}');
          // log('playList items description: ${items.snippet.title}');
          // log('playlist video id = ${items.snippet.resourceId.videoId}');
          // log('defaultImage = ${items.snippet.thumbnails.defaultImage.url}');
        }
      } catch (e) {}
    });
  }

  void onTapped(index) {
    // navigate to the next screen.
    var id = _playListItem.items[index].snippet.resourceId.videoId;
    print('onTapped playListItem video id = $id');
    _navigateYTPlayer(id);
  }

  void _navigateYTPlayer(String videoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WebViewContainer(videoId: videoId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video List'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var data = _playListItem.items[index];

          return ListTile(
            leading:
                new Image.network(data.snippet.thumbnails.defaultImage.url),
            title: Text(data.snippet.title),
            onTap: () => onTapped(index),
          );
        },
        itemCount: _playListItem.items.length,
      ),
    );
  }
}

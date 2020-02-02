
import 'package:flutter/material.dart';
import 'package:flutter_go/model/play_list_item.dart';
import 'package:flutter_go/network/youtube_api_service.dart';
import 'package:flutter_go/widgets/webview_youtube_player.dart';

class VideoListItem extends StatefulWidget {
  VideoListItem({Key key, this.playListId}) : super(key: key);

  String playListId;

  @override
  _VideoListItemState createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  PlayListItem _playListItem;

  String _playingVideoId;
  int _playingVideoIndex;

  @override
  void initState() {
    super.initState();
    getYoutubePlayListItem(widget.playListId).then((result) {
      setState(() {
        _playListItem = result;
      });
    }).then((value) => this.onTapped(0));
  }


  @override
  void didUpdateWidget(VideoListItem oldWidget) {
    if(oldWidget.playListId != widget.playListId){
      print("reload");
      getYoutubePlayListItem(widget.playListId).then((result) {
        setState(() {
          _playListItem = result;
        });
      }).then((value) => this.onTapped(0));
    }
  }

  void onTapped(index) {
    var id = _playListItem?.items[index]?.snippet?.resourceId?.videoId;
    print('onTapped playListItem video id = $id');
    if (id == null) {
      return;
    }
    _navigateYTPlayer(id, index);
  }

  void _navigateYTPlayer(String videoId, int index) {
    setState(() {
      _playingVideoId = videoId;
      _playingVideoIndex = index;
    });
  }

  void onVideoEndCallback() {
    int nextVideoIndex = _playingVideoIndex % (_playListItem.items.length - 1);
    bool lastOne = _playingVideoIndex == (_playListItem.items.length - 1);
    if (nextVideoIndex == 0 && lastOne) {
      onTapped(0);
      return;
    }
    onTapped(++nextVideoIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text('Video List'),
//      ),
      body: Column(
        children: <Widget>[
          _playingVideoId != null
              ? WebViewYoutubePlayer(
                  videoId: _playingVideoId, onVideoEnd: onVideoEndCallback)
              : Text('choose a song..'),
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

                  return Container(
                    color: _playingVideoIndex == index ? Colors.purple : Colors.transparent,
                    child: ListTile(
                      leading:
                          Image.network(data.snippet.thumbnails.defaultImage.url),
                      title: Text(data.snippet.title),
                      onTap: () => onTapped(index),
                    ),
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

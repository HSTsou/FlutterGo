import 'package:flutter/material.dart';
import 'package:flutter_go/features/videoListItem/videoListItem.dart';
import 'package:flutter_go/model/playList.dart';
import 'package:flutter_go/network/youtubeAPIService.dart';

class VideoAlbumList extends StatefulWidget {
  VideoAlbumList({Key key, this.accessToken}) : super(key: key);

  String accessToken;

  @override
  _VideoAlbumListState createState() => _VideoAlbumListState();
}

class _VideoAlbumListState extends State<VideoAlbumList> {
  PlayList _playList;

  @override
  void initState() {
    super.initState();
    getYoutubePlayList(widget.accessToken).then((result) {
      setState(() {
        _playList = result;
      });
      for (var items in result.items) {
        // print('playlist id = ${items.id}');
        // print('title = ${items.snippet.title}');
        // print('defaultImage = ${items.snippet.thumbnails.defaultImage.url}');
      }
    });
  }

  void onTapped(index) {
    // navigate to the next screen.
    var id = _playList.items[index].id;
    print('ffffff playListItem id = $id');
    // getYoutubePlayListItem(id);
    _navigateVideoList(id);
  }

  void _navigateVideoList(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VideoListItem(playListId: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Album'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var data = _playList.items[index];

          if (data == null) {
            return Text('loading...');
          }

          return ListTile(
            leading:
                new Image.network(data.snippet.thumbnails.defaultImage.url),
            title: Text(data.snippet.title),
            onTap: () => onTapped(index),
          );
        },
        itemCount: _playList.items.length,
      ),
    );
  }
}

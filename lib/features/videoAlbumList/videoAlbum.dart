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
    });
  }

  void onTapped(index) {
    var id = _playList.items[index].id;
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
      body: new Container(
          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: GridView.builder(
            reverse: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 1.0),
            itemBuilder: (BuildContext context, int index) {
              if (_playList == null ||
                  _playList.items == null ||
                  _playList.items[index] == null ||
                  _playList.items.length == 0) {
                return Text('loading...');
              }

              var data = _playList.items[index];

              return Wrap(
                children: <Widget>[
                  ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0), //3像素圆角
                          boxShadow: [
                            BoxShadow(
                                color: Colors.white,
                                offset: Offset(2.0, 2.0),
                                blurRadius: 2.0)
                          ]),
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 24.0),
                          child: GestureDetector(
                              onTap: () => onTapped(index),
                              child: new Column(children: <Widget>[
                                new Image.network(
                                    data.snippet.thumbnails.defaultImage.url),
                                new Text(
                                  '${data.snippet.title}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,

                                      // fontFamily: "Courier",
                                      // background: new Paint()
                                      //   ..color = Colors.black54,
                                      decoration: TextDecoration.none,
                                      decorationStyle:
                                          TextDecorationStyle.dotted),
                                ),
                              ]))))),
                ],
              );
            },
            itemCount: _playList?.items?.length ?? 0,
          )),
    );
  }
}

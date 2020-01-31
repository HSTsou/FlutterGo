import 'package:flutter/material.dart';
import 'package:flutter_go/features/videoListItem/video_list_item.dart';
import 'package:flutter_go/model/play_list.dart';
import 'package:flutter_go/network/youtube_api_service.dart';

import 'AlbumCard.dart';

class IPodView extends StatefulWidget {
  IPodView({Key key, this.accessToken}) : super(key: key);

  String accessToken;

  @override
  _IPodViewState createState() => _IPodViewState();
}

class _IPodViewState extends State<IPodView> {
  final PageController _pageCtrl = PageController(viewportFraction: 0.6);
  PlayList _playList;
  double currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    getYoutubePlayList(widget.accessToken).then((result) {
      setState(() {
        _playList = result;
      });
    });
    _pageCtrl.addListener(() {
      setState(() {
        currentPage = _pageCtrl.page;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_playList == null) {
      return Container();
    }

    double height = MediaQuery
        .of(context)
        .size
        .height;

    return new Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: height * 0.4,
              color: Colors.black,
              child: PageView.builder(
                controller: _pageCtrl,
                scrollDirection: Axis.horizontal,
                itemCount: _playList.items.length,
                itemBuilder: (context, int currentIdx) {
                  var data = _playList.items[currentIdx];
                  String imageUrl = data.snippet.thumbnails.defaultImage.url
                      .replaceAll("default", "hqdefault");
                  return AlbumCard(
                    color: Colors.grey,
                    idx: currentIdx,
                    imageUrl: imageUrl,
                    title: data.snippet.title,
                    currentPage: currentPage,
                  );
                },
              ),
            ),
            Spacer(),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onPanUpdate: _panHandler,
                    child: Container(
                      height: height * 0.4,
                      width: height * 0.4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Stack(children: [
                        Container(
                          child: Text(
                            'MENU',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.only(top: 16),
                        ),
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.fast_forward),
                            iconSize: 40,
                            onPressed: () =>
                                _pageCtrl.animateToPage(
                                    (_pageCtrl.page + 1).toInt(),
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeIn),
                          ),
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 0),
                        ),
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.fast_rewind),
                            iconSize: 40,
                            onPressed: () =>
                                _pageCtrl.animateToPage(
                                    (_pageCtrl.page - 1).toInt(),
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeIn),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 0),
                        ),
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.play_arrow),
                            iconSize: 40,
                            onPressed: () => onTapped(currentPage.toInt()),
                          ),
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.only(bottom: 8),
                        )
                      ]),
                    ),
                  ),
                  Container(
                    height: height * 0.2,
                    width: height * 0.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  void _panHandler(DragUpdateDetails d) {
    /// Pan movements
    bool panUp = d.delta.dy <= 0.0;
    bool panLeft = d.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    /// Pan location on the wheel
    bool onTop = d.localPosition.dy <= 150; // 150 == radius of circle
    bool onLeftSide = d.localPosition.dx <= 150;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    /// Absoulte change on axis
    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();

    /// Directional change on wheel
    double vert = (onRightSide && panUp) || (onLeftSide && panDown)
        ? yChange
        : yChange * -1;

    double horz =
    (onTop && panLeft) || (onBottom && panRight) ? xChange : xChange * -1;

    // Total computed change with velocity
    double scrollOffsetChange = (horz + vert) * (d.delta.distance * 0.2);

    // Move the page view scroller
    _pageCtrl.jumpTo(_pageCtrl.offset + scrollOffsetChange);
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

}

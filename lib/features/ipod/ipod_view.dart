import 'package:flutter/material.dart';
import 'package:flutter_go/features/ipod/ipod_view_store.dart';
import 'package:flutter_go/features/videoListItem/video_list_item.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'album_card.dart';

class IPodView extends StatefulWidget {
  IPodView({Key key, this.accessToken}) : super(key: key);

  String accessToken;

  @override
  _IPodViewState createState() => _IPodViewState();
}

class _IPodViewState extends State<IPodView> {
  final PageController _pageCtrl = PageController(viewportFraction: 0.6);

  final PanelController _panelController = new PanelController();

  final IpodViewStore store = IpodViewStore();

  @override
  void initState() {
    super.initState();

    store.init(widget.accessToken);
    _pageCtrl.addListener(() {
      store.setCurrentPage(_pageCtrl.page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      if (store.playList == null) {
        return Container();
      }

      double height = MediaQuery.of(context).size.height;

      return Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Observer(builder: (_) {
                    return Container(
                      height: height * 0.4,
                      color: Colors.black,
                      child: PageView.builder(
                        controller: _pageCtrl,
                        scrollDirection: Axis.horizontal,
                        itemCount: store.playList.items.length,
                        itemBuilder: (context, int currentIdx) {
                          var data = store.playList.items[currentIdx];
                          String imageUrl = data
                              .snippet.thumbnails.defaultImage.url
                              .replaceAll("default", "hqdefault");
                          return Observer(builder: (_) {
                            return AlbumCard(
                              color: Colors.grey,
                              idx: currentIdx,
                              imageUrl: imageUrl,
                              title: data.snippet.title,
                              currentPage: store.currentPage,
                            );
                          });
                        },
                      ),
                    );
                  }),
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
                              GestureDetector(
                                onTap: () {
                                  _panelController.open();
                                },
                                child: Container(
                                  child: Text(
                                    'MENU',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  alignment: Alignment.topCenter,
                                  margin: EdgeInsets.only(top: 16),
                                ),
                              ),
                              Container(
                                child: IconButton(
                                  icon: Icon(Icons.fast_forward),
                                  iconSize: 40,
                                  onPressed: () => _pageCtrl.animateToPage(
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
                                  onPressed: () => _pageCtrl.animateToPage(
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
                                  onPressed: () =>
                                      onTapped(store.currentPage.toInt()),
                                ),
                                alignment: Alignment.bottomCenter,
                                margin: EdgeInsets.only(bottom: 4),
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
                  Spacer(),
                ],
              ),
              SlidingUpPanel(
                controller: _panelController,
                collapsed: GestureDetector(
                  onTap: () {
                    _panelController.open();
                  },
                  child: Container(
                    color: Colors.black,
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.arrow_drop_up),
                        iconSize: 36,
                      ),
                    ),
                  ),
                ),
                isDraggable: false,
                backdropEnabled: true,
                panel: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _panelController.close();
                      },
                      onPanUpdate: _onVideoPanelUpdated,
                      child: Container(
                        color: Colors.black,
                        height: 48,
                        child: Center(
                          child: IconButton(
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 36,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: VideoListItem(playListId: store.playListId)),
                  ],
                ),
                minHeight: 48,
                maxHeight: height,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0)),
              ),
            ],
          ),
        ),
      );
    });
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

  void _onVideoPanelUpdated(DragUpdateDetails d) {
//    double yChange = d.localPosition.dy;
//    double deltaYChange = d.delta.dy;
//    double height = MediaQuery.of(context).size.height * 0.8;
//
//    print('yChange' + yChange.toString());
//    print('deltaYChange' + deltaYChange.toString());
//    print('height' + height.toString());
    bool panUp = d.delta.dy <= 0.0;
    bool panDown = !panUp;
    if (panDown) {
      _panelController.animatePanelToPosition(0);
    }
  }

  void onTapped(index) {
    var id = store.playList.items[index].id;
    store.setPlayListId(id);
  }
}

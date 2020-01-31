import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewYoutubePlayer extends StatefulWidget {
  WebViewYoutubePlayer({this.videoId});
  var videoId;

  static const onPlayerReady = 'onPlayerReady';
  static const onPlayerStateChange = 'onPlayerStateChange';
  static const onPlayerError = 'onPlayerError';
  static const playVideo = 'playVideo';
  static const pauseVideo = 'pauseVideo';

  @override
  createState() => _WebViewYoutubePlayerState();
}

class _WebViewYoutubePlayerState extends State<WebViewYoutubePlayer> {
  var _url = 'https://movie2019.appspot.com/?video_id=';
  var _playingUrl = '';
  var videoId;
  double currentTime = 0;
  bool _isPlaying = false;
  double _screenOpacity = 0;
  var _webViewController;
  final _key = UniqueKey();
  _WebViewYoutubePlayerState();

  onClickScreen() {
    setState(() => _screenOpacity = 1);
    Future.delayed(
        Duration(milliseconds: 2000),
        () => setState(() {
              _screenOpacity = 0;
            }));
  }

  void clickVideoScreen() {
    onClickScreen();
    if (_isPlaying) {
      pauseVideo();
      return;
    }

    playVideo();
  }

  void clickRightSideScreen() {
    onClickScreen();
    findCurrentTime();
    seekTo(currentTime + 10);
  }

  void clickLeftSideScreen() {
    onClickScreen();
    findCurrentTime();
    seekTo(currentTime - 10);
  }

  void playVideo() {
    // print('playVideo');
    postMessage('playVideo');
    setState(() {
      _isPlaying = true;
    });
  }

  void pauseVideo() {
    // print('pauseVideo');
    postMessage('pauseVideo');
    setState(() {
      _isPlaying = false;
    });
  }

  void seekTo(double s) {
    // print('pauseVideo');
    postMessage('seekTo', payload: s);
  }

  void findCurrentTime() {
    postMessage('getCurrentTime');
  }

  void postMessage(method, {payload = ''}) {
    var msg = {};
    msg["method"] = method;
    msg["payload"] = payload;

    var data = {};
    String msgJson = json.encode(msg);
    data["data"] = msgJson;
    String dataJson = json.encode(data);

    String run = 'handleReactNativeMessage($dataJson)';

    _webViewController?.evaluateJavascript(run)?.then((result) {
      print('run result');
    });
  }

  Widget getScreenCover() {
    return AnimatedOpacity(
        opacity: _screenOpacity,
        duration: const Duration(milliseconds: 500),
        // transitionBuilder: (Widget child, Animation<double> animation) {
        //   return FadeTransition(child: child, opacity: animation);
        // },
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                constraints: BoxConstraints.expand(),
                color: Colors.black12,
                child: GestureDetector(
                  onTap: clickLeftSideScreen,
                  child: Container(
                    color: Colors.transparent,
                    child: new Icon(
                      Icons.replay_10,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                constraints: BoxConstraints.expand(),
                child: GestureDetector(
                    onTap: clickVideoScreen,
                    child: Container(
                      color: Colors.transparent,
                      child: _isPlaying
                          ? new Icon(
                              Icons.pause,
                              size: 48,
                            )
                          : new Icon(Icons.play_arrow, size: 48),
                      constraints: BoxConstraints.expand(),
                    )),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.black12,
                constraints: BoxConstraints.expand(),
                child: GestureDetector(
                    onTap: clickRightSideScreen,
                    child: Container(
                      color: Colors.transparent,
                      child: new Icon(
                        Icons.forward_10,
                        size: 48,
                      ),
                    )),
              ),
            ),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _playingUrl = '$_url${widget.videoId}';
    });
  }

  @override
  void didUpdateWidget(WebViewYoutubePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // print('didUpdateWidget');
    if (oldWidget.videoId != widget.videoId) {
      // print('oldWidget  = ${oldWidget.videoId}');
      // print('widget ${widget.videoId}');
      setState(() {
        _playingUrl = '$_url${widget.videoId}';
      });
      _webViewController?.loadUrl(_playingUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        AspectRatio(
            aspectRatio: 16 / 9,
            child: new Stack(children: <Widget>[
              new WebView(
                key: _key,
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: _playingUrl,
                javascriptChannels: Set.from([
                  JavascriptChannel(
                      name: 'ReactNativeWebView',
                      onMessageReceived: (JavascriptMessage message) {
                        print(message.message);
                        if (message.message == 'onPlayerReady_') {
                          playVideo();
                        } else if (message.message
                            .contains('getCurrentTime_')) {
                          var time = message.message.split('_');
                          currentTime = double.parse(time[1]);
                        }
                      })
                ]),
                onWebViewCreated: (WebViewController w) {
                  _webViewController = w;
                },
              ),
              getScreenCover(),
            ])),
      ],
    ));
  }
}
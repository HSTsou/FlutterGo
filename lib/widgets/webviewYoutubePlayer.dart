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
  bool isPlaying = false;
  var _webViewController;
  final _key = UniqueKey();
  _WebViewYoutubePlayerState();

  void clickVideoScreen() {
    if (isPlaying) {
      pauseVideo();
      return;
    }

    playVideo();
  }

  void playVideo() {
    print('playVideo');
    postMessage('playVideo');
    isPlaying = true;
  }

  void pauseVideo() {
    print('pauseVideo');
    postMessage('pauseVideo');
    isPlaying = false;
  }

  void seekTo(double s) {
    print('pauseVideo');
    postMessage('seekTo', payload: s);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _playingUrl = '$_url${widget.videoId}';
    });
  }

  @override
  void didUpdateWidget(WebViewYoutubePlayer oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget');
    if (oldWidget.videoId != widget.videoId) {
      print('oldWidget  = ${oldWidget.videoId}');
      print('widget ${widget.videoId}');
      // initState();
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
                        }
                      })
                ]),
                onWebViewCreated: (WebViewController w) {
                  _webViewController = w;
                },
              ),
              GestureDetector(
                onTap: clickVideoScreen,
                // onDoubleTap: ,
              )
            ])),
      ],
    ));
  }
}

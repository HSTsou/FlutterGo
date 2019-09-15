import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  WebViewContainer({this.videoId});
  final videoId;

  static const onPlayerReady = 'onPlayerReady';
  static const onPlayerStateChange = 'onPlayerStateChange';
  static const onPlayerError = 'onPlayerError';
  static const playVideo = 'playVideo';
  static const pauseVideo = 'pauseVideo';

  @override
  createState() => _WebViewContainerState(this.videoId);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url = 'https://movie2019.appspot.com/?video_id=';
  var videoId;
  var _webViewController;
  final _key = UniqueKey();
  _WebViewContainerState(this.videoId);

  void playVideo() {
    print('playVideo');
    postMessage('playVideo');
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
    print('run $run');
    _webViewController?.evaluateJavascript(run)?.then((result) {
      print('run result');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            AspectRatio(
                aspectRatio: 16 / 9,
                child: WebView(
                  key: _key,
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: '$_url$videoId',
                  javascriptChannels: Set.from([
                    JavascriptChannel(
                        name: 'ReactNativeWebView',
                        onMessageReceived: (JavascriptMessage message) {
                          //This is where you receive message from
                          //javascript code and handle in Flutter/Dart
                          //like here, the message is just being printed
                          //in Run/LogCat window of android studio
                          print(message.message);
                          if (message.message == 'onPlayerReady_') {
                            playVideo();
                          }
                        })
                  ]),
                  onWebViewCreated: (WebViewController w) {
                    print(' onWebViewCreated');
                    _webViewController = w;
                  },
                ))
          ],
        ));
  }
}

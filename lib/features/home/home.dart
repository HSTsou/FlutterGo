import 'package:flutter/material.dart';
import 'package:flutter_go/features/ipod/ipod_view.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;
import 'package:mobx/mobx.dart';
import 'dart:convert' show json;
import 'diamond_border.dart';
import 'package:flutter_go/features/login/google_login_button.dart';
import './home_store.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final homeStore = HomeStore();
  ReactionDisposer disposer;

  @override
  void initState() {
    super.initState();
    homeStore.init();
    disposer = autorun((_) {
      print("userName = ${homeStore.userName}");
    });
  }

  @override
  void dispose() {
    super.dispose();
    homeStore.dispose();
  }

  void _navigateVideoAlbum(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => IPodView(accessToken: homeStore.accessToken)),
    );
  }

  void _clickLoginButton() {
    homeStore.clickLoginButton();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Observer(builder: (_) {
              return GoogleSignInButton(
                  text: homeStore.loginStatusMsg, onPressed: _clickLoginButton);
            }),
            Observer(builder: (_) {
              return Text(homeStore.userName);
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateVideoAlbum(context);
        },
        tooltip: 'go to video album',
        child: Icon(Icons.library_music),
        shape: DiamondBorder(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

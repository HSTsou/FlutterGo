import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;
import 'package:mobx/mobx.dart';
import 'dart:convert' show json;
import 'diamond_border.dart';
import 'package:flutter_go/network/youtubeAPIService.dart';
import 'package:flutter_go/features/login/googleLoginButton.dart';
import 'package:flutter_go/features/videoAlbumList/videoAlbum.dart';
import './home_store.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
    'https://www.googleapis.com/auth/youtube.readonly',
  ],
);

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  GoogleSignIn _googleSignIn;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleSignInAccount _currentUser;
  String _contactText = 'Plz Login';
  String goolgeLoginButtonText = 'Login';
  String _accessToken;

  final homeStore = HomeStore();
  ReactionDisposer disposer;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      // print('onCurrentUserChanged ${account.authentication}');
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });
    _googleSignIn.signInSilently().then((result) {
      result.authentication.then((googleKey) {
        print('signInSilently accessToken = ' + googleKey.accessToken);
        setState(() {
          if (googleKey.accessToken != null) {
            _accessToken = googleKey.accessToken;
            goolgeLoginButtonText = "Logout";
          }
        });
      }).catchError((err) {
        print('inner error');
      });
    }).catchError((err) {
      print('error occured');
    });

    disposer = autorun((_) {
      print(homeStore.userName);
    });
  }

  @override
  void dispose() {
    disposer();
  }

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = "Loading contact info...";
      goolgeLoginButtonText = "log out";
    });
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
      '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }

    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    homeStore.setUserName(namedContact);
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  void _clickLoginButton() {
    if (_currentUser != null) {
      _googleSignIn.signOut().then((result) {
        setState(() {
          _contactText = "Plz Login";
          goolgeLoginButtonText = "Login";
        });
      });

      return;
    }

    _handleSignIn();
  }

  Future<void> _handleSignIn() async {
    try {
      _googleSignIn.signIn().then((result) {
        result.authentication.then((googleKey) {
          print('accessToken = ' + googleKey.accessToken);
          setState(() {
            if (googleKey.accessToken != null) {
              _accessToken = googleKey.accessToken;
              goolgeLoginButtonText = "Logout";
            }
          });
          // getYoutubePlayList(googleKey.accessToken);
        }).catchError((err) {
          print('inner error');
        });
      }).catchError((err) {
        print('error occured');
      });
    } catch (error) {
      print(error);
    }
  }

  void _navigateVideoAlbum(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VideoAlbumList(accessToken: _accessToken)),
    );
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
            GoogleSignInButton(
                text: goolgeLoginButtonText, onPressed: _clickLoginButton),
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

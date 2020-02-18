import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobx/mobx.dart';
import "package:http/http.dart" as http;
import 'dart:convert';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      'https://www.googleapis.com/auth/youtube.readonly',
    ],
  );

  List<StreamSubscription> _subscriptions;

  @observable
  String userName = 'login...';

  @observable
  String loginStatusMsg = 'Login';

  @observable
  GoogleSignInAccount googleCurrentUser;

  @observable
  String accessToken;

  void init() {
    _subscriptions = [
      _setUpLoginUserChanged(),
//      _setUpLoginSilently(),
    ];
    _setUpLoginUserChanged();
    _setUpLoginSilently();
  }

  void dispose() {
    _subscriptions.forEach((subscription) => subscription.cancel());
  }

  @action
  void setUserName(String name) {
    userName = name;
  }

  @action
  void setLoginStatusMsg(String msg) {
    loginStatusMsg = msg;
  }

  @action
  void setCurrentUser(GoogleSignInAccount currentUser) {
    this.googleCurrentUser = currentUser;
  }

  @action
  void setAccessToken(String token) {
    accessToken = token;
  }

  @action
  StreamSubscription _setUpLoginUserChanged() {
    return _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) {
      setCurrentUser(account);
      if (account != null) {
        _handleGetContact();
      }
    });
  }

  @action
  Future<StreamSubscription> _setUpLoginSilently() async {
    var result = await _googleSignIn.signInSilently();
    return result.authentication.then((googleKey) {
      if (googleKey.accessToken != null) {
        setAccessToken(googleKey.accessToken);
        setLoginStatusMsg("Logout");
      }
    }).catchError((err) {
      print('inner error');
    });
  }

  @action
  Future<void> clickLoginButton() async {
    if (googleCurrentUser != null) {
      _googleSignIn.signOut().then((result) {
        setLoginStatusMsg("Login");
        setUserName("");
      });

      return;
    }

    _handleSignIn();
  }

  Future<void> _handleSignIn() async {
    try {
      _googleSignIn.signIn().then((result) {
        result.authentication.then((googleKey) {
          if (googleKey.accessToken != null) {
            setAccessToken(googleKey.accessToken);
            setLoginStatusMsg("Logout");
          }
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

  Future<void> _handleGetContact() async {
    setLoginStatusMsg("log out");

    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
      '?requestMask.includeField=person.names',
      headers: await googleCurrentUser.authHeaders,
    );

    if (response.statusCode != 200) {
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }

    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);

    setUserName(namedContact);
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
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeStore on _HomeStore, Store {
  final _$userNameAtom = Atom(name: '_HomeStore.userName');

  @override
  String get userName {
    _$userNameAtom.context.enforceReadPolicy(_$userNameAtom);
    _$userNameAtom.reportObserved();
    return super.userName;
  }

  @override
  set userName(String value) {
    _$userNameAtom.context.conditionallyRunInAction(() {
      super.userName = value;
      _$userNameAtom.reportChanged();
    }, _$userNameAtom, name: '${_$userNameAtom.name}_set');
  }

  final _$loginStatusMsgAtom = Atom(name: '_HomeStore.loginStatusMsg');

  @override
  String get loginStatusMsg {
    _$loginStatusMsgAtom.context.enforceReadPolicy(_$loginStatusMsgAtom);
    _$loginStatusMsgAtom.reportObserved();
    return super.loginStatusMsg;
  }

  @override
  set loginStatusMsg(String value) {
    _$loginStatusMsgAtom.context.conditionallyRunInAction(() {
      super.loginStatusMsg = value;
      _$loginStatusMsgAtom.reportChanged();
    }, _$loginStatusMsgAtom, name: '${_$loginStatusMsgAtom.name}_set');
  }

  final _$currentUserAtom = Atom(name: '_HomeStore.currentUser');

  @override
  GoogleSignInAccount get currentUser {
    _$currentUserAtom.context.enforceReadPolicy(_$currentUserAtom);
    _$currentUserAtom.reportObserved();
    return super.currentUser;
  }

  @override
  set currentUser(GoogleSignInAccount value) {
    _$currentUserAtom.context.conditionallyRunInAction(() {
      super.currentUser = value;
      _$currentUserAtom.reportChanged();
    }, _$currentUserAtom, name: '${_$currentUserAtom.name}_set');
  }

  final _$accessTokenAtom = Atom(name: '_HomeStore.accessToken');

  @override
  String get accessToken {
    _$accessTokenAtom.context.enforceReadPolicy(_$accessTokenAtom);
    _$accessTokenAtom.reportObserved();
    return super.accessToken;
  }

  @override
  set accessToken(String value) {
    _$accessTokenAtom.context.conditionallyRunInAction(() {
      super.accessToken = value;
      _$accessTokenAtom.reportChanged();
    }, _$accessTokenAtom, name: '${_$accessTokenAtom.name}_set');
  }

  final _$_setUpLoginSilentlyAsyncAction = AsyncAction('_setUpLoginSilently');

  @override
  Future<StreamSubscription> _setUpLoginSilently() {
    return _$_setUpLoginSilentlyAsyncAction
        .run(() => super._setUpLoginSilently());
  }

  final _$clickLoginButtonAsyncAction = AsyncAction('clickLoginButton');

  @override
  Future<void> clickLoginButton() {
    return _$clickLoginButtonAsyncAction.run(() => super.clickLoginButton());
  }

  final _$_HomeStoreActionController = ActionController(name: '_HomeStore');

  @override
  void setUserName(String name) {
    final _$actionInfo = _$_HomeStoreActionController.startAction();
    try {
      return super.setUserName(name);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoginStatusMsg(String msg) {
    final _$actionInfo = _$_HomeStoreActionController.startAction();
    try {
      return super.setLoginStatusMsg(msg);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentUser(GoogleSignInAccount currentUser) {
    final _$actionInfo = _$_HomeStoreActionController.startAction();
    try {
      return super.setCurrentUser(currentUser);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAccessToken(String token) {
    final _$actionInfo = _$_HomeStoreActionController.startAction();
    try {
      return super.setAccessToken(token);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  StreamSubscription _setUpLoginUserChanged() {
    final _$actionInfo = _$_HomeStoreActionController.startAction();
    try {
      return super._setUpLoginUserChanged();
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }
}

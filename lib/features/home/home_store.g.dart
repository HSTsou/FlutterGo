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
}

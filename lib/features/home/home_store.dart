import 'package:mobx/mobx.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  @observable
  String userName = 'login...';

  @action
  void setUserName(String name) {
    userName = name;
  }
}

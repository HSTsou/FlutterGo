import 'package:flutter_go/model/play_list.dart';
import 'package:flutter_go/network/youtube_api_service.dart';

import 'package:mobx/mobx.dart';

part 'ipod_view_store.g.dart';

class IpodViewStore = _IpodViewStore with _$IpodViewStore;

abstract class _IpodViewStore with Store {
  @observable
  PlayList playList;

  @observable
  String playListId;

  @observable
  double currentPage = 0.0;

  @action
  void setPlayList(PlayList playList) {
    this.playList = playList;
  }

  @action
  void setPlayListId(String playListId) {
    this.playListId = playListId;
  }

  @action
  void setCurrentPage(double page) {
    currentPage = page;
  }

  void init(String accessToken) {
    loadPlayList(accessToken);
  }

  loadPlayList(String accessToken) {
    getYoutubePlayList(accessToken).then((result) {
      setPlayList(result);
    });
  }
}

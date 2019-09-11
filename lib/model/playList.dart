class PlayList {
  String _kind;
  String _etag;
  PageInfo _pageInfo;
  List<Items> _items;

  PlayList({String kind, String etag, PageInfo pageInfo, List<Items> items}) {
    this._kind = kind;
    this._etag = etag;
    this._pageInfo = pageInfo;
    this._items = items;
  }

  String get kind => _kind;
  set kind(String kind) => _kind = kind;
  String get etag => _etag;
  set etag(String etag) => _etag = etag;
  PageInfo get pageInfo => _pageInfo;
  set pageInfo(PageInfo pageInfo) => _pageInfo = pageInfo;
  List<Items> get items => _items;
  set items(List<Items> items) => _items = items;

  PlayList.fromJson(Map<String, dynamic> json) {
    _kind = json['kind'];
    _etag = json['etag'];
    _pageInfo = json['pageInfo'] != null
        ? new PageInfo.fromJson(json['pageInfo'])
        : null;
    if (json['items'] != null) {
      _items = new List<Items>();
      json['items'].forEach((v) {
        _items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this._kind;
    data['etag'] = this._etag;
    if (this._pageInfo != null) {
      data['pageInfo'] = this._pageInfo.toJson();
    }
    if (this._items != null) {
      data['items'] = this._items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PageInfo {
  int _totalResults;
  int _resultsPerPage;

  PageInfo({int totalResults, int resultsPerPage}) {
    this._totalResults = totalResults;
    this._resultsPerPage = resultsPerPage;
  }

  int get totalResults => _totalResults;
  set totalResults(int totalResults) => _totalResults = totalResults;
  int get resultsPerPage => _resultsPerPage;
  set resultsPerPage(int resultsPerPage) => _resultsPerPage = resultsPerPage;

  PageInfo.fromJson(Map<String, dynamic> json) {
    _totalResults = json['totalResults'];
    _resultsPerPage = json['resultsPerPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalResults'] = this._totalResults;
    data['resultsPerPage'] = this._resultsPerPage;
    return data;
  }
}

class Items {
  String _kind;
  String _etag;
  String _id;
  Snippet _snippet;
  ContentDetails _contentDetails;

  Items(
      {String kind,
      String etag,
      String id,
      Snippet snippet,
      ContentDetails contentDetails}) {
    this._kind = kind;
    this._etag = etag;
    this._id = id;
    this._snippet = snippet;
    this._contentDetails = contentDetails;
  }

  String get kind => _kind;
  set kind(String kind) => _kind = kind;
  String get etag => _etag;
  set etag(String etag) => _etag = etag;
  String get id => _id;
  set id(String id) => _id = id;
  Snippet get snippet => _snippet;
  set snippet(Snippet snippet) => _snippet = snippet;
  ContentDetails get contentDetails => _contentDetails;
  set contentDetails(ContentDetails contentDetails) =>
      _contentDetails = contentDetails;

  Items.fromJson(Map<String, dynamic> json) {
    _kind = json['kind'];
    _etag = json['etag'];
    _id = json['id'];
    _snippet =
        json['snippet'] != null ? new Snippet.fromJson(json['snippet']) : null;
    _contentDetails = json['contentDetails'] != null
        ? new ContentDetails.fromJson(json['contentDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this._kind;
    data['etag'] = this._etag;
    data['id'] = this._id;
    if (this._snippet != null) {
      data['snippet'] = this._snippet.toJson();
    }
    if (this._contentDetails != null) {
      data['contentDetails'] = this._contentDetails.toJson();
    }
    return data;
  }
}

class Snippet {
  String _publishedAt;
  String _channelId;
  String _title;
  String _description;
  Thumbnails _thumbnails;
  String _channelTitle;
  Localized _localized;
  String _defaultLanguage;

  Snippet(
      {String publishedAt,
      String channelId,
      String title,
      String description,
      Thumbnails thumbnails,
      String channelTitle,
      Localized localized,
      String defaultLanguage}) {
    this._publishedAt = publishedAt;
    this._channelId = channelId;
    this._title = title;
    this._description = description;
    this._thumbnails = thumbnails;
    this._channelTitle = channelTitle;
    this._localized = localized;
    this._defaultLanguage = defaultLanguage;
  }

  String get publishedAt => _publishedAt;
  set publishedAt(String publishedAt) => _publishedAt = publishedAt;
  String get channelId => _channelId;
  set channelId(String channelId) => _channelId = channelId;
  String get title => _title;
  set title(String title) => _title = title;
  String get description => _description;
  set description(String description) => _description = description;
  Thumbnails get thumbnails => _thumbnails;
  set thumbnails(Thumbnails thumbnails) => _thumbnails = thumbnails;
  String get channelTitle => _channelTitle;
  set channelTitle(String channelTitle) => _channelTitle = channelTitle;
  Localized get localized => _localized;
  set localized(Localized localized) => _localized = localized;
  String get defaultLanguage => _defaultLanguage;
  set defaultLanguage(String defaultLanguage) =>
      _defaultLanguage = defaultLanguage;

  Snippet.fromJson(Map<String, dynamic> json) {
    _publishedAt = json['publishedAt'];
    _channelId = json['channelId'];
    _title = json['title'];
    _description = json['description'];
    _thumbnails = json['thumbnails'] != null
        ? new Thumbnails.fromJson(json['thumbnails'])
        : null;
    _channelTitle = json['channelTitle'];
    _localized = json['localized'] != null
        ? new Localized.fromJson(json['localized'])
        : null;
    _defaultLanguage = json['defaultLanguage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['publishedAt'] = this._publishedAt;
    data['channelId'] = this._channelId;
    data['title'] = this._title;
    data['description'] = this._description;
    if (this._thumbnails != null) {
      data['thumbnails'] = this._thumbnails.toJson();
    }
    data['channelTitle'] = this._channelTitle;
    if (this._localized != null) {
      data['localized'] = this._localized.toJson();
    }
    data['defaultLanguage'] = this._defaultLanguage;
    return data;
  }
}

class Thumbnails {
  Default _default;

  Thumbnails({Default defaultImage}) {
    this._default = defaultImage;
  }

  Default get defaultImage => _default;
  set defaultImage(Default defaultImage) => _default = defaultImage;

  Thumbnails.fromJson(Map<String, dynamic> json) {
    _default =
        json['default'] != null ? new Default.fromJson(json['default']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._default != null) {
      data['default'] = this._default.toJson();
    }
    return data;
  }
}

class Default {
  String _url;
  int _width;
  int _height;

  Default({String url, int width, int height}) {
    this._url = url;
    this._width = width;
    this._height = height;
  }

  String get url => _url;
  set url(String url) => _url = url;
  int get width => _width;
  set width(int width) => _width = width;
  int get height => _height;
  set height(int height) => _height = height;

  Default.fromJson(Map<String, dynamic> json) {
    _url = json['url'];
    _width = json['width'];
    _height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this._url;
    data['width'] = this._width;
    data['height'] = this._height;
    return data;
  }
}

class Localized {
  String _title;
  String _description;

  Localized({String title, String description}) {
    this._title = title;
    this._description = description;
  }

  String get title => _title;
  set title(String title) => _title = title;
  String get description => _description;
  set description(String description) => _description = description;

  Localized.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this._title;
    data['description'] = this._description;
    return data;
  }
}

class ContentDetails {
  int _itemCount;

  ContentDetails({int itemCount}) {
    this._itemCount = itemCount;
  }

  int get itemCount => _itemCount;
  set itemCount(int itemCount) => _itemCount = itemCount;

  ContentDetails.fromJson(Map<String, dynamic> json) {
    _itemCount = json['itemCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemCount'] = this._itemCount;
    return data;
  }
}

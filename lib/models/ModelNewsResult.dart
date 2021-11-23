import 'dart:math';

import 'package:carkee/config/singleton.dart';
import 'package:carkee/models/safe_convert.dart';

class ModelNewsResult {
  bool success;
  List<ModelNews> data;
  int count;
  int currentPage;
  int pageCount;
  int code;

  ModelNewsResult(
      {this.success,
        this.data,
        this.count,
        this.currentPage,
        this.pageCount,
        this.code});

  int getPageCountInt() {
    return Session.shared.convertToInt(data: pageCount);
  }

  int getPageCurrentInt() {
    return Session.shared.convertToInt(data: currentPage);
  }

  bool isLastedPage() {
    return (getPageCurrentInt() >= getPageCountInt());
  }

  getNextPageInt() {
    var currentPage = getPageCurrentInt();
    var pageCount = getPageCountInt();
    currentPage++;
    var nextPage = min(currentPage, pageCount);
    return nextPage;
  }


  ModelNewsResult.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<ModelNews>();
      json['data'].forEach((v) {
        data.add(new ModelNews.fromJson(v));
      });
    }
    count = json['count'];
    currentPage = json['currentPage'];
    pageCount = json['pageCount'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['currentPage'] = this.currentPage;
    data['pageCount'] = this.pageCount;
    data['code'] = this.code;
    return data;
  }
}
//
// class ModelNews {
//   int newsId;
//   String title;
//   String createdAt;
//   String summary;
//   String image;
//   String url;
//   bool isPublic;
//   String view_more_message;
//   List<Galleries> galleries;
//
//   ModelNews(
//       {this.newsId,
//         this.title,
//         this.createdAt,
//         this.summary,
//         this.image,
//         this.url,
//         this.isPublic,
//         this.view_more_message,
//         this.galleries});
//
//   ModelNews.fromJson(Map<String, dynamic> json) {
//     newsId = json['news_id'];
//     title = json['title'];
//     createdAt = json['created_at'];
//     summary = json['summary'];
//     image = json['image'];
//     url = json['url'];
//     isPublic = json['is_public'];
//     view_more_message = json['view_more_message'];
//     if (json['galleries'] != null) {
//       galleries = new List<Galleries>();
//       json['galleries'].forEach((v) {
//         galleries.add(new Galleries.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['news_id'] = this.newsId;
//     data['title'] = this.title;
//     data['created_at'] = this.createdAt;
//     data['summary'] = this.summary;
//     data['image'] = this.image;
//     data['url'] = this.url;
//     data['is_public'] = this.isPublic;
//     data['view_more_message'] = this.view_more_message;
//     if (this.galleries != null) {
//       data['galleries'] = this.galleries.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class Galleries {
  int id;
  String url;

  Galleries({this.id, this.url});

  Galleries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    return data;
  }
}


class ModelNews {
  String type = "news";
  int newsId = 0;
  String title = "";
  String createdAt = "";
  String summary = "";
  String image = "";
  String url = "";
  //link
  String link = "";
  bool isPublic = false;
  String viewMoreMessage;
  List<Galleries> galleries = [];

  ModelNews({
    this.type,
    this.newsId,
    this.title,
    this.createdAt,
    this.summary,
    this.image,
    this.url,
    this.link,
    this.isPublic,
    this.viewMoreMessage,
    this.galleries,
  });

  ModelNews.fromJson(Map<String, dynamic> json)
      :	newsId = SafeManager.parseInt(json, 'news_id'),
        title = SafeManager.parseString(json, 'title'),
        createdAt = SafeManager.parseString(json, 'created_at'),
        summary = SafeManager.parseString(json, 'summary'),
        image = SafeManager.parseString(json, 'image'),
        url = SafeManager.parseString(json, 'url'),
        link = SafeManager.parseString(json, 'link'),
        type = SafeManager.parseString(json, 'type'),
  //link

        isPublic = SafeManager.parseBoolean(json, 'is_public'),
        viewMoreMessage = SafeManager.parseString(json, 'view_more_message'),
        galleries = SafeManager.parseList(json, 'galleries')
            ?.map((e) => Galleries.fromJson(e))
            ?.toList();

  Map<String, dynamic> toJson() => {
    'type': this.type,
    'news_id': this.newsId,
    'title': this.title,
    'created_at': this.createdAt,
    'summary': this.summary,
    'image': this.image,
    'url': this.url,
    'link': this.link,
    'is_public': this.isPublic,
    'view_more_message': this.viewMoreMessage,
    'galleries': this.galleries,

  };
}
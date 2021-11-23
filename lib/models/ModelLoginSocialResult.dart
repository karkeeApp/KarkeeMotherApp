import 'package:flutter/cupertino.dart';

class ModelLoginSocialResult {
  int code;
  Facebook facebook;
  Google google;
  Apple apple;
  bool inDb;
  int userId;
  String access_token;

  ModelLoginSocialResult({this.code, this.facebook, this.google, this.inDb, this.userId, this.access_token});


  isNewAccount() {
    return (inDb == false);
  }
  getNameFacebook(){
    return facebook?.name ?? "";
  }
  getNameGoogle(){
    return google?.name ?? "";
  }

  getNameApple(){
    return "";
  }

  getIDFacebook(){
    return facebook?.id ?? "";
  }
  getIDGoogle(){
    return google?.id ?? "";
  }

  getIDApple(){
    return apple?.sub ?? "";
  }

  getEmailFB(){
    return facebook?.email ?? "";
  }

  getEmailApple(){
    return apple?.email ?? "";
  }
  getEmailGoogle(){
    return google?.email ?? "";
  }
  getToken(){
    return access_token ?? "";
  }


  ModelLoginSocialResult.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    facebook = json['facebook'] != null
        ? new Facebook.fromJson(json['facebook'])
        : null;
    apple = json['apple'] != null
        ? new Apple.fromJson(json['apple'])
        : null;
    google = json['google'] != null
        ? new Google.fromJson(json['google'])
        : null;
    inDb = json['in_db'];
    userId = json['user_id'];
    access_token = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.facebook != null) {
      data['facebook'] = this.facebook.toJson();
    }

    if (this.apple != null) {
      data['apple'] = this.apple.toJson();
    }
    if (this.google != null) {
      data['google'] = this.google.toJson();
    }
    data['in_db'] = this.inDb;
    data['user_id'] = this.userId;
    data['access_token'] = this.access_token;
    return data;
  }
}

class Facebook {
  String id;
  String name;
  String email;

  Facebook({this.id, this.name, this.email});

  Facebook.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
  }
}

class Google {
  String email;
  String familyName;

  String givenName;

  String id;

  String locale;
  String name;
  String picture;
  bool verifiedEmail;

  Google(
      {this.email,
        this.familyName,

        this.givenName,

        this.id,

        this.locale,
        this.name,
        this.picture,
        this.verifiedEmail});

  Google.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    familyName = json['familyName'];

    givenName = json['givenName'];

    id = json['id'];

    locale = json['locale'];
    name = json['name'];
    picture = json['picture'];
    verifiedEmail = json['verifiedEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['familyName'] = this.familyName;

    data['givenName'] = this.givenName;

    data['id'] = this.id;

    data['locale'] = this.locale;
    data['name'] = this.name;
    data['picture'] = this.picture;
    data['verifiedEmail'] = this.verifiedEmail;
    return data;
  }
}

class Apple {
  String iss;
  String aud;
  int exp;
  int iat;
  String sub;
  String cHash;
  String email;
  String emailVerified;
  int authTime;
  bool nonceSupported;

  Apple(
      {this.iss,
        this.aud,
        this.exp,
        this.iat,
        this.sub,
        this.cHash,
        this.email,
        this.emailVerified,
        this.authTime,
        this.nonceSupported});

  Apple.fromJson(Map<String, dynamic> json) {
    iss = json['iss'];
    aud = json['aud'];
    exp = json['exp'];
    iat = json['iat'];
    sub = json['sub'];
    cHash = json['c_hash'];
    email = json['email'];
    emailVerified = json['email_verified'];
    authTime = json['auth_time'];
    nonceSupported = json['nonce_supported'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iss'] = this.iss;
    data['aud'] = this.aud;
    data['exp'] = this.exp;
    data['iat'] = this.iat;
    data['sub'] = this.sub;
    data['c_hash'] = this.cHash;
    data['email'] = this.email;
    data['email_verified'] = this.emailVerified;
    data['auth_time'] = this.authTime;
    data['nonce_supported'] = this.nonceSupported;
    return data;
  }
}
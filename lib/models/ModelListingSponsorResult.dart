import 'package:carkee/models/ModelListingResult.dart';
import 'package:carkee/models/ModelNewsResult.dart';

class ModelListingSponsorResult {
  List<ModelListingSponsor> data;
  int code;

  ModelListingSponsorResult({this.data, this.code});

  ModelListingSponsorResult.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ModelListingSponsor>();
      json['data'].forEach((v) {
        data.add(new ModelListingSponsor.fromJson(v));
      });
    }
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    return data;
  }
}

class ModelListingSponsor {
  String name;
  List<ModelListing> data;

  ModelListingSponsor({this.name, this.data});

  ModelListingSponsor.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['data'] != null) {
      data = new List<ModelListing>();
      json['data'].forEach((v) {
        data.add(new ModelListing.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int listingId;
  int userId;
  String title;
  String content;
  int status;
  String createdAt;
  String updatedAt;
  int approvedBy;
  int confirmedBy;
  int isPrimary;
  String statusValue;
  String primaryPhoto;
  List<Galleries> gallery;
  VendorInfo vendorInfo;

  Data(
      {this.listingId,
        this.userId,
        this.title,
        this.content,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.approvedBy,
        this.confirmedBy,
        this.isPrimary,
        this.statusValue,
        this.primaryPhoto,
        this.gallery,
        this.vendorInfo});

  Data.fromJson(Map<String, dynamic> json) {
    listingId = json['listing_id'];
    userId = json['user_id'];
    title = json['title'];
    content = json['content'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    approvedBy = json['approved_by'];
    confirmedBy = json['confirmed_by'];
    isPrimary = json['is_primary'];
    statusValue = json['status_value'];
    primaryPhoto = json['primary_photo'];
    if (json['gallery'] != null) {
      gallery = new List<Galleries>();
      json['gallery'].forEach((v) {
        gallery.add(new Galleries.fromJson(v));
      });
    }
    vendorInfo = json['vendor_info'] != null
        ? new VendorInfo.fromJson(json['vendor_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listing_id'] = this.listingId;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['approved_by'] = this.approvedBy;
    data['confirmed_by'] = this.confirmedBy;
    data['is_primary'] = this.isPrimary;
    data['status_value'] = this.statusValue;
    data['primary_photo'] = this.primaryPhoto;
    if (this.gallery != null) {
      data['gallery'] = this.gallery.map((v) => v.toJson()).toList();
    }
    if (this.vendorInfo != null) {
      data['vendor_info'] = this.vendorInfo.toJson();
    }
    return data;
  }
}

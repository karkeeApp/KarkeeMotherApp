import 'package:carkee/models/ModelListingResult.dart';
import 'package:carkee/models/ModelNewsResult.dart';

class ModelItemListingResult {
  bool success;
  List<ModelItem> data;
  int count;
  int currentPage;
  int pageCount;
  int code;

  ModelItemListingResult(
      {this.success,
        this.data,
        this.count,
        this.currentPage,
        this.pageCount,
        this.code});

  ModelItemListingResult.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<ModelItem>();
      json['data'].forEach((v) {
        data.add(new ModelItem.fromJson(v));
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

class ModelItem {
  int itemId;
  int userId;
  String title;
  String content;
  int limit;
  int status;
  String createdAt;
  String updatedAt;
  String amount;
  String approvedBy;
  String confirmedBy;
  String statusValue;
  String redeemCount;
  String prettyAmount;
  String primaryPhoto;
  List<Galleries> gallery;
  VendorInfo vendorInfo;

  ModelItem(
      {this.itemId,
        this.userId,
        this.title,
        this.content,
        this.limit,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.amount,
        this.approvedBy,
        this.confirmedBy,
        this.statusValue,
        this.redeemCount,
        this.prettyAmount,
        this.primaryPhoto,
        this.gallery,
        this.vendorInfo});

  ModelItem.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    userId = json['user_id'];
    title = json['title'];
    content = json['content'];
    limit = json['limit'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    amount = json['amount'];
    approvedBy = json['approved_by'];
    confirmedBy = json['confirmed_by'];
    statusValue = json['status_value'];
    redeemCount = json['redeem_count'];
    prettyAmount = json['pretty_amount'];
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
    data['item_id'] = this.itemId;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['limit'] = this.limit;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['amount'] = this.amount;
    data['approved_by'] = this.approvedBy;
    data['confirmed_by'] = this.confirmedBy;
    data['status_value'] = this.statusValue;
    data['redeem_count'] = this.redeemCount;
    data['pretty_amount'] = this.prettyAmount;
    data['primary_photo'] = this.primaryPhoto;
    if (this.gallery != null) {
      data['gallery'] = this.gallery.map((v) => v.toJson()).toList();
    }
    if (this.vendorInfo != null) {
      data['vendor_info'] = this.vendorInfo.toJson();
    }
    return data;
  }

  String geImageUrl() {
    return primaryPhoto ?? "https://picsum.photos/1/1";
  }
  //
  // bool isAvailable() {
  //
  // }

}

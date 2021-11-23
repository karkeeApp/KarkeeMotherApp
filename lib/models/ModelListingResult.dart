import 'package:carkee/models/ModelNewsResult.dart';

class ModelListingResult {
  bool success;
  List<ModelListing> data;
  int count;
  int currentPage;
  int pageCount;
  int code;


  ModelListingResult(
      {this.success,
        this.data,
        this.count,
        this.currentPage,
        this.pageCount,
        this.code});


  ModelListingResult.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<ModelListing>();
      json['data'].forEach((v) {
        data.add(new ModelListing.fromJson(v));
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

class ModelListing {
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

  ModelListing(
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

  ModelListing.fromJson(Map<String, dynamic> json) {
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
    if (json['gallery'] != String) {
      gallery = new List<Galleries>();
      json['gallery'].forEach((v) {
        gallery.add(new Galleries.fromJson(v));
      });
    }
    vendorInfo = json['vendor_info'] != String
        ? new VendorInfo.fromJson(json['vendor_info'])
        : String;
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
    if (this.gallery != String) {
      data['gallery'] = this.gallery.map((v) => v.toJson()).toList();
    }
    if (this.vendorInfo != String) {
      data['vendor_info'] = this.vendorInfo.toJson();
    }
    return data;
  }
}


class VendorInfo {

  isEmptyLongLat() {
    return (this.longitude == null || this.latitude == null);
  }

  int userId;
  String imgProfile;
  String imgVendor;
  String mobileCode;
  String mobile;
  String level;
  String company;
  String vendorName;
  String vendorDescription;
  String about;
  String country;
  String postalCode;
  String unitNo;
  String add1;
  String add2;
  String longitude;
  String latitude;
  String statusPretty;
  int status;
  String approvedAt;
  String company_logo;
  String club_logo;
  String brand_guide;
  String brand_synopsis;

  VendorInfo(
      {this.userId,
        this.imgProfile,
        this.imgVendor,
        this.mobileCode,
        this.mobile,
        this.level,
        this.company,
        this.vendorName,
        this.vendorDescription,
        this.about,
        this.country,
        this.postalCode,
        this.unitNo,
        this.add1,
        this.add2,
        this.longitude,
        this.latitude,
        this.statusPretty,
        this.status,
        this.company_logo,
        this.club_logo,
        this.brand_guide,
        this.brand_synopsis,

        this.approvedAt});

  VendorInfo.fromJson(Map<String, dynamic> json) {



    userId = json['user_id'];
    imgProfile = json['img_profile'];
    imgVendor = json['img_vendor'];
    mobileCode = json['mobile_code'];
    mobile = json['mobile'];
    level = json['level'];
    company = json['company'];
    vendorName = json['vendor_name'];
    vendorDescription = json['vendor_description'];
    about = json['about'];
    country = json['country'];
    postalCode = json['postal_code'];
    unitNo = json['unit_no'];
    add1 = json['add_1'];
    add2 = json['add_2'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    statusPretty = json['status_pretty'];
    status = json['status'];
    approvedAt = json['approved_at'];

    company_logo = json['company_logo'];
    club_logo = json['club_logo'];
    brand_guide = json['brand_guide'];
    brand_synopsis = json['brand_synopsis'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;

    data['company_logo'] = this.company_logo;
    data['club_logo'] = this.club_logo;
    data['brand_guide'] = this.brand_guide;
    data['brand_synopsis'] = this.brand_synopsis;

    data['img_profile'] = this.imgProfile;
    data['img_vendor'] = this.imgVendor;
    data['mobile_code'] = this.mobileCode;
    data['mobile'] = this.mobile;
    data['level'] = this.level;
    data['company'] = this.company;
    data['vendor_name'] = this.vendorName;
    data['vendor_description'] = this.vendorDescription;
    data['about'] = this.about;
    data['country'] = this.country;
    data['postal_code'] = this.postalCode;
    data['unit_no'] = this.unitNo;
    data['add_1'] = this.add1;
    data['add_2'] = this.add2;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['status_pretty'] = this.statusPretty;
    data['status'] = this.status;
    data['approved_at'] = this.approvedAt;
    return data;
  }


}


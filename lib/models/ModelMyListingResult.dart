import 'package:carkee/models/ModelListingResult.dart';

class ModelMyListingResult {
  bool success;
  ModelListing primary;
  List<ModelListing> data;
  int code;
  ModelMyListingResult({this.success, this.primary, this.data, this.code});
  ModelMyListingResult.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    primary =
    json['primary'] != null ? new ModelListing.fromJson(json['primary']) : null;
    if (json['data'] != null) {
      data = new List<ModelListing>();
      json['data'].forEach((v) {
        data.add(new ModelListing.fromJson(v));
      });
    }
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.primary != null) {
      data['primary'] = this.primary.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    return data;
  }
}

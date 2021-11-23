import 'package:carkee/models/ModelListingResult.dart';

class ModelListingDetailsByIDResult {
  int code;
  ModelListing data;
  List<ModelListing> related;
  ModelListingDetailsByIDResult({this.code, this.data, this.related});
  ModelListingDetailsByIDResult.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new ModelListing.fromJson(json['data']) : null;
    if (json['related'] != null) {
      related = new List<ModelListing>();
      json['related'].forEach((v) {
        related.add(new ModelListing.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    if (this.related != null) {
      data['related'] = this.related.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class ModelBannerResult {
    List<ModelGallery> data;
    int code;
    ModelBannerResult({this.data, this.code});
    ModelBannerResult.fromJson(Map<String, dynamic> json) {
        if (json['data'] != null) {
            data = new List<ModelGallery>();
            json['data'].forEach((v) {
                data.add(new ModelGallery.fromJson(v));
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

class ModelGallery {
    int id;
    String image;

    ModelGallery({this.id, this.image});

    ModelGallery.fromJson(Map<String, dynamic> json) {
        id = json['id'];
        image = json['image'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['image'] = this.image;
        return data;
    }
}

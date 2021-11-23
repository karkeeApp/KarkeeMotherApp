class ModelSiteSettingResult {
  int code;
  List<ModelAccounts> accounts;

  ModelSiteSettingResult({this.code, this.accounts});

  ModelSiteSettingResult.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['accounts'] != null) {
      accounts = new List<ModelAccounts>();
      json['accounts'].forEach((v) {
        accounts.add(new ModelAccounts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.accounts != null) {
      data['accounts'] = this.accounts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModelAccounts {
  int id;
  String value;

  ModelAccounts({this.id, this.value});

  ModelAccounts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    return data;
  }
}
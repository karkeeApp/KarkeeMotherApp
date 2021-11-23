class ModelEndpoint {
    int account_id;
    int code;
    String endpoint;
    String hash_id;

    ModelEndpoint({this.account_id, this.code, this.endpoint, this.hash_id});

    factory ModelEndpoint.fromJson(Map<String, dynamic> json) {
        return ModelEndpoint(
            account_id: json['account_id'], 
            code: json['code'], 
            endpoint: json['endpoint'], 
            hash_id: json['hash_id'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['account_id'] = this.account_id;
        data['code'] = this.code;
        data['endpoint'] = this.endpoint;
        data['hash_id'] = this.hash_id;
        return data;
    }
}
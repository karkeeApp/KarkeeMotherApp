// class ModelErrorJson {
//     dynamic code;
//     String message;
//     String name;
//     // int status;
//     // String type;
//     dynamic status;
//     dynamic type;
//
//     ModelErrorJson({this.code, this.message, this.name, this.status, this.type});
//
//     factory ModelErrorJson.fromJson(Map<String, dynamic> json) {
//         return ModelErrorJson(
//             code: json['code'],
//             message: json['message'],
//             name: json['name'],
//             status: json['status'],
//             type: json['type'],
//         );
//     }
//
//     Map<String, dynamic> toJson() {
//         final Map<String, dynamic> data = new Map<String, dynamic>();
//         data['code'] = this.code;
//         data['message'] = this.message;
//         data['name'] = this.name;
//         data['status'] = this.status;
//         data['type'] = this.type;
//         return data;
//     }
//
//     getMessage() {
//         return message ?? "";
//     }
// }
//

import 'package:carkee/models/safe_convert.dart';

class ModelErrorJson {
    dynamic code = 0;
    dynamic message = "";
    dynamic name = "";
    dynamic status = "";
    dynamic type = "";

    ModelErrorJson({
        this.code,
        this.message,
        this.name,
        this.status,
        this.type,
    });

    ModelErrorJson.fromJson(Map<String, dynamic> json)
        :	code = SafeManager.parseString(json, 'code'),
            message = SafeManager.parseString(json, 'message'),
            name = SafeManager.parseString(json, 'name'),
            status = SafeManager.parseString(json, 'status'),
            type = SafeManager.parseString(json, 'type');

    Map<String, dynamic> toJson() => {
        'code': this.code,
        'message': this.message,
        'name': this.name,
        'status': this.status,
        'type': this.type,
    };

    getMessage() {
        return message ?? "";
    }
}

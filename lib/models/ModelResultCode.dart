import 'package:carkee/models/safe_convert.dart';

class ModelResultCode {
	 dynamic code = 0;
	 dynamic message = "";
	 dynamic name = "";
	 dynamic status = "";
	 dynamic type = "";

	ModelResultCode({
		this.code,
		this.message,
		this.name,
		this.status,
		this.type,
	});

	ModelResultCode.fromJson(Map<String, dynamic> json)
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
}

import 'safe_convert.dart';
/// new file -> convert json to dart code, ko chon create contructo de khong can khoi tao. chi Gen ve`
/// null crash cũng la 1 dạng lợi thế nếu server error ma ko cần debug
class test_json_safe_model {
	List<Data> data = [];
	int code = 0;

	test_json_safe_model({
		this.data,
		this.code,
	});

	test_json_safe_model.fromJson(Map<String, dynamic> json)
			:	data = SafeManager.parseList(json, 'data')
		?.map((e) => Data.fromJson(e))
		?.toList(),
	code = SafeManager.parseInt(json, 'code');

	Map<String, dynamic> toJson() => {
				'data': this.data?.map((e) => e.toJson())?.toList(),
				'code': this.code,
			};
}
class Data {
	int id = 0;
	String image = "";

	Data({
		this.id,
		this.image,
	});

	Data.fromJson(Map<String, dynamic> json)
			:	id = SafeManager.parseInt(json, 'id'),
	image = SafeManager.parseString(json, 'image');

	Map<String, dynamic> toJson() => {
				'id': this.id,
				'image': this.image,
			};
}

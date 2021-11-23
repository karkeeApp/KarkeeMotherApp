import 'safe_convert.dart';

class test_2_no_constructor {
	List<Data> data;
	int code;

	test_2_no_constructor.fromJson(Map<String, dynamic> json)
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
	int id;
	String image;

	Data.fromJson(Map<String, dynamic> json)
			:	id = SafeManager.parseInt(json, 'id'),
	image = SafeManager.parseString(json, 'image');

	Map<String, dynamic> toJson() => {
				'id': this.id,
				'image': this.image,
			};
}

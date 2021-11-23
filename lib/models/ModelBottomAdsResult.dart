import 'safe_convert.dart';

class ModelBottomAdsResult {
	ModelBottomAds data;
	int code = 0;

	ModelBottomAdsResult({
		this.data,
		this.code,
	});

	ModelBottomAdsResult.fromJson(Map<String, dynamic> json)
			:	data = ModelBottomAds.fromJson(
	SafeManager.parseObject(json, 'data'),
),
	code = SafeManager.parseInt(json, 'code');

	Map<String, dynamic> toJson() => {
				'data': this.data?.toJson(),
				'code': this.code,
			};
}
class ModelBottomAds {
	int id = 0;
	String image = "";
	String url = "";

	ModelBottomAds({
		this.id,
		this.image,
		this.url,
	});

	ModelBottomAds.fromJson(Map<String, dynamic> json)
			:	id = SafeManager.parseInt(json, 'id'),
	image = SafeManager.parseString(json, 'image'),
				url = SafeManager.parseString(json, 'url');

	Map<String, dynamic> toJson() => {
				'id': this.id,
				'image': this.image,
				'link': this.url,
			};
}

import 'safe_convert.dart';

class ModelAdminDashBoard {
	int code = 0;
	String isAdmin = "";
	String message = "";
	String dashboardUrl = "";

	ModelAdminDashBoard({
		this.code,
		this.isAdmin,
		this.message,
		this.dashboardUrl,
	});

	ModelAdminDashBoard.fromJson(Map<String, dynamic> json)
			:	code = SafeManager.parseInt(json, 'code'),
	isAdmin = SafeManager.parseString(json, 'is_admin'),
	message = SafeManager.parseString(json, 'message'),
	dashboardUrl = SafeManager.parseString(json, 'dashboard_url');

	Map<String, dynamic> toJson() => {
				'code': this.code,
				'is_admin': this.isAdmin,
				'message': this.message,
				'dashboard_url': this.dashboardUrl,
			};
}

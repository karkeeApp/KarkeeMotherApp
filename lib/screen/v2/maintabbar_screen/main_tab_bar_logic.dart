import 'package:carkee/screen/v2/dashboard_screen/dashboard_screen_page.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/screen/screens.dart';

class MainTabbarController extends GetxController {
  final ProfileController profileController = Get.find();
  var index = 0.obs; //start index
  var pageVendor = [
    // DashboardScreen(),
    DashboardScreenPage(),
    NewsFeedScreen(
        key: PageStorageKey(
            'NewsFeedScreen')), // lưu state của screen khi switch tab!
    SponsorTabScreen(),
    ProfileVendorTabScreen()
  ];
  var pageMember = [
    // DashboardScreen(),
    DashboardScreenPage(),
    NewsFeedScreen(
        key: PageStorageKey(
            'NewsFeedScreen')), // lưu state của screen khi switch tab!
    EventTabScreen(),
    SponsorTabScreen(),
    ProfileMemberTabScreen()
  ];
  void changePage(int _index) {
    index.value = _index;
  }

  getPage_vendor() {
    return pageVendor[index.value];
  }

  getPage_member() {
    return pageMember[index.value];
  }

  @override
  void onInit() {
    // called immediately after the widget is allocated memory
    super.onInit();
  }

  @override
  void onClose() {
    // called just before the Controller is deleted from memory
    super.onClose();
  }

  goProfileTab() {
    if (profileController.getIsCompany()) {
      changePage(3);
    } else {
      changePage(4);
    }
  }

  goSponsor() {
    if (profileController.getIsCompany()) {
      changePage(2);
    } else {
      changePage(3);
    }
  }
}

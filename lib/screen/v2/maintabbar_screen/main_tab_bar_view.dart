import 'package:carkee/config/strings.dart';
import 'package:carkee/controllers/main_tab_bar_controller.dart';
import 'package:carkee/screen/screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainTabbarNew extends StatelessWidget {
  double iconSize = 50;
  double opacityIcon = 0.2;
  final MainTabbarController mainTabbarController =
      Get.put(MainTabbarController(), permanent: true);
  iconSelected() {
    return Image.asset(Strings.placeHolderImage, width: iconSize);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Colors.white,
          drawer: SizedBox(
            width: Get.width,
            child: MenuSlide(),
          ),
          // body: mainTabbarController.profileController.getIsCompany()
          //     ? mainTabbarController.getPage_vendor()
          //     : mainTabbarController.getPage_member(),
      body: mainTabbarController.getPagesContent(),
          bottomNavigationBar: Container(
              decoration: BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage('assets/images/logo.png'),
                //   fit: BoxFit.cover,
                // ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: BottomNavigationBar(
                  // items: mainTabbarController.profileController.getIsCompany()
                  //     ? items_vendor()
                  //     : items_member(),
                  items: mainTabbarController.getPagesContent(),
                  onTap: (index) => mainTabbarController.changePage(index),
                  elevation: 5,
                  backgroundColor: Colors.amber[50],
                  type: BottomNavigationBarType.fixed,
                  iconSize: 35,
                  selectedLabelStyle: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: TextStyle(color: Colors.black),
                  currentIndex: mainTabbarController.index.value,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                ),
              )),
        ));
  }

  List<BottomNavigationBarItem> items_vendor() {
    return [
      //ic_tabbar_home => ic_home_unative
      BottomNavigationBarItem(
          icon: mainTabbarController.index.value == 0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/ic_home_selected_3x.png',
                      height: iconSize),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/ic_home_inselected_3x.png',
                      height: iconSize),
                ),
          label: 'Home'),
      BottomNavigationBarItem(
          icon: mainTabbarController.index.value == 1
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/ic_news_selected_3x.png',
                      height: iconSize),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/ic_news_inselected_3x.png',
                      height: iconSize),
                ),
          label: 'News'),
      BottomNavigationBarItem(
          icon: mainTabbarController.index.value == 2
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/ic_sponsor_selected_3x.png',
                    height: iconSize,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                      'assets/images/ic_sponsor_inselected_3x.png',
                      height: iconSize),
                ),
          label: 'Sponsors'),
      BottomNavigationBarItem(
          icon: mainTabbarController.index.value == 3
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/ic_account_selected_3x.png',
                      height: iconSize),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                      'assets/images/ic_account_inselected_3x.png',
                      height: iconSize),
                ),
          label: 'Profile')
    ];
  }

  List<BottomNavigationBarItem> items_member() {
    return [
      BottomNavigationBarItem(
          icon: mainTabbarController.index.value == 0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/ic_home_selected_3x.png',
                      height: iconSize),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/ic_home_inselected_3x.png',
                      height: iconSize),
                ),
          label: 'Home'),
      BottomNavigationBarItem(
          icon: mainTabbarController.index.value == 1
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/ic_news_selected_3x.png',
                      height: iconSize),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/ic_news_inselected_3x.png',
                      height: iconSize),
                ),
          label: 'News'),
      BottomNavigationBarItem(
          icon: mainTabbarController.index.value == 2
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/ic_event_selected_3x.png',
                      height: iconSize),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/ic_event_inselected_3x.png',
                      height: iconSize),
                ),
          label: 'Events'),
      BottomNavigationBarItem(
          icon: mainTabbarController.index.value == 3
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/ic_sponsor_selected_3x.png',
                      height: iconSize),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                      'assets/images/ic_sponsor_inselected_3x.png',
                      height: iconSize),
                ),
          label: 'Sponsors'),
      BottomNavigationBarItem(
          icon: mainTabbarController.index.value == 4
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/ic_account_selected_3x.png',
                      height: iconSize),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                      'assets/images/ic_account_inselected_3x.png',
                      height: iconSize),
                ),
          label: 'Profile')
    ];
  }
}

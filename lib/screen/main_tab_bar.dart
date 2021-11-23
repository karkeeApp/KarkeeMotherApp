import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/config/strings.dart';
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/controllers/main_tab_bar_controller.dart';
import 'package:carkee/screen/screens.dart';

class MainTabbar extends StatelessWidget {
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
      drawer: SizedBox(width: Get.width, child: MenuSlide()),
      // body: mainTabbarController.profileController.getIsCompany()
      //     ? mainTabbarController.getPage_vendor()
      //     : mainTabbarController.getPage_member(),
      body: mainTabbarController.getPagesContent(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0.0, 1.00), //(x,y)
                blurRadius: 4.00,
                color: Colors.black12,
                spreadRadius: 2.00),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
              elevation: 10,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              onTap: (currentIndex) =>
                  mainTabbarController.changePage(currentIndex),
              selectedLabelStyle: TextStyle(
                  color: Config.secondColor, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.normal),
              unselectedItemColor: Colors.black,
              selectedItemColor: Config.secondColor,
              currentIndex: mainTabbarController.index.value,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              iconSize: 35,
              items : getItemsBottomBar()
              // items: mainTabbarController.profileController.getIsCompany()
              //     ? items_vendor()
              //     : items_member()
          ),
          // items: items_member()),// new UI only member 5 tab!
        ),
      ),
    )
    );
  }

  List<BottomNavigationBarItem> getItemsBottomBar(){
    if ((Session.shared.isLogedin())) {
      final ProfileController profileController = Get.find();
      return profileController.getIsCompany() ? items_vendor() : items_member();
    } else {
      return items_guest();
    }
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

  List<BottomNavigationBarItem> items_guest() {
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
    ];
  }
}

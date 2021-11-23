import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/models/ModelAdminDashBoard.dart';
import 'package:carkee/screen/join_club.dart';
import 'package:carkee/screen/join_club_v2/join_club_v2_page.dart';

import '../components/network_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/app_configs.dart';
import '../config/singleton.dart';

import '../config/colors.dart';
import '../screen/screens.dart';

import 'get_app_screen.dart';

class MenuSlide extends StatefulWidget {
  //function

  @override
  _MenuSlideState createState() => _MenuSlideState();
}

class _MenuSlideState extends State<MenuSlide> {
  var isAdmin = false;
  var url_dashboard = '';
  bool _selected = false;

  logout() {
    Session.shared.showAlertPopup2ButtonWithCallback(
        title: 'Logout',
        content: 'Are you sure?',
        titleButtonLeft: "Cancel",
        titleButtonRight: "OK",
        callback: () async {
          //clear token
          await Session.shared.logout();
          Session.shared.changeRootViewToGuest();
        });
  }

  callAPIGetAdminLink() async {
    print("start callAPIGetAdminLink");
    var endpoint = url_member_check_admin;
    Map<String, dynamic> jsonQuery = {
      "access-token": await Session.shared.getToken(),
    };
    var network = NetworkAPI(endpoint: endpoint, jsonQuery: jsonQuery);
    var jsonBody = await network.callAPIGET(showLog: false);
    if (jsonBody["code"] == 100) {
      print(" => CALL API $endpoint OK");
      var model = ModelAdminDashBoard.fromJson(jsonBody);
      setState(() {
        isAdmin = (model.isAdmin == '1');
        url_dashboard = (model.dashboardUrl);
      });
    } else {
      print("no handle, because not show");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Session.shared.isLogedin()) {
      callAPIGetAdminLink();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black87,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20), //spacing 20 cho cai box!
              IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Get.back();
                  }),
              SizedBox(height: 20),
              Expanded(
                  child: ListView(
                children: [
                  InkWell(
                    onTap: () {
                      print("Home tap");
                      Session.shared.goHomeTab();
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Config.kDefaultPadding * 2,
                          vertical: Config.kDefaultPadding),
                      child: Text(
                        "Home",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print("News tap");
                      Session.shared.goNewsTab();
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Config.kDefaultPadding * 2,
                          vertical: Config.kDefaultPadding),
                      child: Text(
                        "News",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print("Events tap");
                      Session.shared.goEventTab();
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Config.kDefaultPadding * 2,
                          vertical: Config.kDefaultPadding),
                      child: Text(
                        "Events",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print("Sponsors tap");
                      Session.shared.goSponsorTab();
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Config.kDefaultPadding * 2,
                          vertical: Config.kDefaultPadding),
                      child: Text(
                        "Sponsors",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Session.shared.isLogedin() ? InkWell(
                    onTap: () {
                      print("Profile tap");
                      Session.shared.goProfileTab();
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Config.kDefaultPadding * 2,
                          vertical: Config.kDefaultPadding),
                      child: Text(
                        "Profile",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ): SizedBox(),
                  Session.shared.isLogedin() ? InkWell(
                    onTap: () {
                      print("Settings tap");
                      Get.to(() => SettingsScreen());
                      // Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        right: 20,
                        left: 20,
                      ),
                      child: Text(
                        "Settings",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ) : SizedBox(),
                  Session.shared.isLogedin() ? Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      childrenPadding: EdgeInsets.only(bottom: 10),
                      tilePadding: EdgeInsets.symmetric(horizontal: 20),
                      title: Text('Clubs',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      children: getListClubs(),
                      onExpansionChanged: (value) {
                        setState(() {
                          _selected = value;
                        });
                      },
                    ),
                  ) : SizedBox(),

                  Session.shared.isLogedin() ? InkWell(
                    onTap: () {
                      print("Member Join a Club");
                      Get.to(() => JoinClubV2Page());
                      // Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 20, left: 20, bottom: 20),
                      child: Text(
                        "Join a Club",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ): SizedBox(),
                  Session.shared.isLogedin() ? InkWell(
                    onTap: () {
                      print("Create a Club App tap");
                      Get.to(() => GetAppScreen());
                      // Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 20, left: 20, bottom: 10),
                      child: Text(
                        "Create a Club App",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ) : SizedBox(),
                  Session.shared.isLogedin() ? (isAdmin == false)
                      ? SizedBox()
                      : InkWell(
                          onTap: () {
                            print("Admin Login");
                            // Get.back();
                            Session.shared.openWebView(
                                title: 'Admin Dashboard', url: url_dashboard);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Config.kDefaultPadding * 2,
                                vertical: Config.kDefaultPadding),
                            child: Text(
                              "Admin Login (Web Dashboard)",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ) : SizedBox(),
                ],
              )),
              Session.shared.isLogedin() ? Row(
                children: [
                  InkWell(
                    onTap: () {
                      print("Logouttap");
                      // Get.back();
                      logout();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 0),
                      child: Text(
                        "Logout",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        logout();
                      }),
                ],
              ) : Row(
                children: [
                  InkWell(
                    onTap: () {
                      print("Logouttap");
                      // Get.back();
                      // logout();
                      Session.shared.logout();
                      Session.shared.changeRootViewToGuest();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 0),
                      child: Text(
                        "Login / Register",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.login,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // logout();
                        Session.shared.logout();
                        Session.shared.changeRootViewToGuest();
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  getListClubs() {
    List<Widget> listWidget = [];
    final ProfileController _controller = Get.find();
    print("_controller.userProfile.value ${_controller.userProfile.value.toJson()}");
    for (var i = 0; i < _controller.userProfile.value.clubs.length; i++) {
      var club = _controller.userProfile.value.clubs[i];
      listWidget.add(buildItemList(club));
    }
    return listWidget;
  }

  buildItemList(Clubs club) {
    return ListTile(
      title: Padding(
        padding:
            const EdgeInsets.only(left: 30, top: 10, bottom: 10, right: 10),
        child: Text(
          club.company,
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carkee/components/load_image_component.dart';
import 'package:carkee/components/search_bar_phung.dart';
import 'package:carkee/screen/v2/event_controller.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:carkee/components/debouncer.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/config/strings.dart';
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/models/ModelEventsResult.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:carkee/screen/news_details_web.dart';
import 'package:sticky_headers/sticky_headers.dart';
import './event_past_screen.dart';
import 'event_past_screen.dart';
import 'event_up_coming_screen.dart';
// import 'event_up_coming_screen.dart';

class EventTabScreen extends StatefulWidget {
  const EventTabScreen({Key key}) : super(key: key);
  @override
  _EventTabScreenState createState() => _EventTabScreenState();
}

class _EventTabScreenState extends State<EventTabScreen> {
  var sections = ["Upcoming Events", "Past Events"];
  final ProfileController profileController = Get.find();
  final searchTextController = TextEditingController();
  final Debouncer onSearchDebouncer = Debouncer(delay: Duration(seconds: 1));
  // var tabSelected = 0;
  final EventController logic = Get.put(EventController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          // iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.white,
          title: Text("Events", style: Styles.mclub_Tilte),
          elevation: 1,
          leading: IconButton(
            padding: EdgeInsets.only(left: 10),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu),
            iconSize: 30,
            color: Colors.black,
          ),
            actions: [
              GestureDetector(
                onTap: () {
                  if (Session.shared.isLogedin()) {
                    Session.shared.goProfileTab();
                  } else {
                    print("no login");
                  }
                },
                child: Session.shared.isLogedin() ? Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 20,
                      backgroundImage: NetworkImage(Session.shared
                          .getProfileController()
                          .getProfileImage())),
                ): SizedBox(),
              )
            ]
        ),
        body: RefreshIndicator(
          onRefresh: logic.reloadData,
          child: Column(
            children: [
              getSearchbar(),
              Flexible(
                child: Container(
                  color: Colors.white,
                  child: bodyTab(),
                ),
              )
              // bodyTab()
            ],
          ),
        ));
  }

  bodyTab() {
    print("rebuild");
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              child: Material(
                color: Colors.grey.shade300,
                child: TabBar(
                  tabs: [
                    //vừa có text hoặc icon đều OK!
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        sections[0],
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        sections[1],
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                  onTap: (tabIndex) {
                    setState(() {
                      logic.tabSelected = tabIndex;
                      print("tabSelected $tabIndex");
                    });
                    //selected tab tabIndex
                  },
                  indicator: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(2,
                                -4), //(0,-12) Bóng lên,(0,12) bóng xuống,, tuong tự cho trái phải
                            blurRadius: 4, //do bóng phủ xa
                            spreadRadius:
                                -6.0, ////giảm độ mờ của bóng lên -4 để bottom ko có bóng!
                            color: Colors.black87)
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10))),
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                EventUpComingScreen(),
                EventPastScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget loadingView() {
    return Center(child: CircularProgressIndicator());
  }

  getSearchbar() {
    return SearchBarPhung(
        searchTextController: logic.searchTextController,
        startSearching: (stringValue) {
          print(stringValue);
          //check search string which tab
          logic.searchTextString = stringValue;
          logic.callAPI(logic.tabSelected);
        },
        reload: () {
          logic.reloadData();
        });
  }
}

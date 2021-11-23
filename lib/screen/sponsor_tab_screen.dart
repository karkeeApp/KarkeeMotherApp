import 'package:cached_network_image/cached_network_image.dart';
import 'package:carkee/components/search_bar_phung.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:carkee/components/debouncer.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/components/slider_sponsor_tab_horizal.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/models/ModelEventsResult.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:carkee/models/ModelListingSponsorResult.dart';
import 'package:carkee/screen/news_details_web.dart';
import 'package:carkee/screen/sponsors_details_screen.dart';
import 'package:sticky_headers/sticky_headers.dart';
// import 'package:flutter_sticky_header/flutter_sticky_header.dart';

//backup


class SponsorTabScreen extends StatefulWidget {
  @override
  _SponsorTabScreenState createState() => _SponsorTabScreenState();
}

class _SponsorTabScreenState extends State<SponsorTabScreen> {
  // final ProfileController profileController = Get.find();
  var searchTextString = '';
  final searchTextController = TextEditingController();
  List<ModelListingSponsor> finalArray = List<ModelListingSponsor>();
  var isDone = false;
  final Debouncer onSearchDebouncer = Debouncer(delay: Duration(seconds: 1));

  Future reloadAPI() async {
    // await Future.delayed(Duration(seconds: 1));
    print('reloadAPI');
    setState(() {
      isDone = false;
      finalArray = [];
      searchTextString = '';
    });
    callAPIGetListingAll();
  }

  Future callAPIGetListingAll() async {
    print("start callAPIGetListingAll");
    var endpoint = url_listing_list_all;
    Map<String, dynamic> jsonQuery = {
      "account_id": Session.shared.HASH_ID,
      "keyword": searchTextString,
      // "access-token": await Session.shared.getToken(),
    };
    if (Session.shared.isLogedin()) {
      jsonQuery = {
        "account_id": Session.shared.HASH_ID,
        "keyword": searchTextString,
        "access-token": await Session.shared.getToken(),
      };
    }

    var network = NetworkAPI(endpoint: endpoint, jsonQuery: jsonQuery);
    var jsonBody = await network.callAPIGET(showLog: true, keepKeyboard: true);
    if (jsonBody["code"] == 100) {
      print(" => CALL API $endpoint OK");
      var _modelsResult = ModelListingSponsorResult.fromJson(jsonBody);
      setState(() {
        finalArray = _modelsResult.data;
        isDone = true;
      });
    } else {
      print(
          " => CALL API $endpoint FALSE: $jsonBody with jsonQuery $jsonQuery");
      Session.shared.showAlertPopupOneButtonWithCallback(
          content: jsonBody["message"] ?? "");
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callAPIGetListingAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          // iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.white,
          title: Text("Sponsors", style: Styles.mclub_Tilte),
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

        body: (isDone)
            ? buildBody(context)
            : loadingView());
  }

  Future _refreshData() async {
    // await Future.delayed(Duration(seconds: 1));
    callAPIGetListingAll();
  }

  Widget buildBody(BuildContext context) {
    print('buildBody SponsorTabScreen');
    // _refreshData();
    // controller.callAPI();
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Column(
          children: [
            getSearchbar(),
            getListView(),

          ],
        ),

      ),
    );
  }


  getListView(){
    return ListView.builder(
          shrinkWrap: true,
          // physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: finalArray.length,
          itemBuilder: (BuildContext context, int sectionIndex) {
            return StickyHeader(
              header: Container(
                color: Colors.white,
                // height: 50,
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '${finalArray[sectionIndex].name}',//header data from ModelListingSponsor
                    style: Styles.mclub_smallTilteBold,
                  ),
                ),
              ),
              content: SliderMemberSponsors(
                modelListings: finalArray[sectionIndex].data,
                didTap: (itemTapped) {
                  print(itemTapped);
                  Get.to(() => SponsorsDetailsScreen(modelListing: itemTapped));

                },
              ),
            );
          }
    );
  }

  Widget loadingView() {
    return Center(child: CircularProgressIndicator());
  }

  getSearchbar() {
    return SearchBarPhung(startSearching: (stringValue) {
      setState(() {
        searchTextString = stringValue;
      });
      callAPIGetListingAll();
    }, reload: () {
      reloadAPI();
    });
    // return Padding(
    //     padding: const EdgeInsets.symmetric(
    //         horizontal: Config.kDefaultPadding * 2, vertical: 10),
    //     child: Container(
    //       color: Colors.white,
    //       child: TextField(
    //         controller: searchTextController,
    //         onChanged: (value) {
    //           searchTextString = searchTextController.text;
    //           onSearchDebouncer.debounce(() {
    //             print(
    //                 "controller.searchTextController.text ${searchTextController.text}");
    //             callAPIGetListingAll();
    //           });
    //         },
    //         decoration: InputDecoration(
    //           hintText: 'Search',
    //           contentPadding:
    //               EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
    //           filled: true,
    //           fillColor: Color.fromARGB(255, 242, 242, 242),
    //           prefixIcon: Icon(Icons.search_sharp),
    //           border: InputBorder.none,
    //           focusedBorder: OutlineInputBorder(
    //             borderSide: BorderSide(width: 1, color: Config.secondColor),
    //             borderRadius: BorderRadius.circular(15),
    //           ),
    //           enabledBorder: OutlineInputBorder(
    //             borderSide: BorderSide(width: 1, color: Colors.white),
    //             borderRadius: BorderRadius.circular(15),
    //           ),
    //           labelText: '',
    //           suffixIcon: searchTextString != ""
    //               ? IconButton(
    //                   icon: Icon(Icons.close),
    //                   onPressed: () {
    //                     print("clear text");
    //                     searchTextController.text = '';
    //                     print("${searchTextString}");
    //                     searchTextString = '';
    //                     print("${searchTextString}");
    //                     reloadAPI();
    //                   },
    //                 )
    //               : SizedBox(),
    //         ),
    //       ),
    //     ));
  }
}

//backup

//
//
// class SponsorTabScreen extends StatefulWidget {
//   @override
//   _SponsorTabScreenState createState() => _SponsorTabScreenState();
// }
//
// class _SponsorTabScreenState extends State<SponsorTabScreen> {
//   final ProfileController profileController = Get.find();
//   var searchTextString = '';
//   final searchTextController = TextEditingController();
//   List<ModelListingSponsor> finalArray = List<ModelListingSponsor>();
//   var isDone = false;
//   final Debouncer onSearchDebouncer = Debouncer(delay: Duration(seconds: 1));
//
//   Future reloadAPI() async {
//     // await Future.delayed(Duration(seconds: 1));
//     print('reloadAPI');
//     setState(() {
//       isDone = false;
//       finalArray = [];
//       searchTextString = '';
//     });
//     callAPIGetListingAll();
//   }
//
//   Future callAPIGetListingAll() async {
//     print("start callAPIGetListingAll");
//     var endpoint = url_listing_list_all;
//     Map<String, dynamic> jsonQuery = {
//       "account_id": Session.shared.HASH_ID,
//       "keyword": searchTextString,
//       "access-token": await Session.shared.getToken(),
//     };
//     var network = NetworkAPI(endpoint: endpoint, jsonQuery: jsonQuery);
//     var jsonBody = await network.callAPIGET(showLog: true, keepKeyboard: true);
//     if (jsonBody["code"] == 100) {
//       print(" => CALL API $endpoint OK");
//       var modelsResult_ = ModelListingSponsorResult.fromJson(jsonBody);
//       setState(() {
//         finalArray = modelsResult_.data;
//         isDone = true;
//       });
//     } else {
//       print(
//           " => CALL API $endpoint FALSE: $jsonBody with jsonQuery $jsonQuery");
//       Session.shared.showAlertPopupOneButtonWithCallback(
//           content: jsonBody["message"] ?? "");
//     }
//   }
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     callAPIGetListingAll();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: PreferredSize(
//             preferredSize:
//             AppBarTabCenterTitleWithLeftHamberger().preferredSize,
//             child: AppBarTabCenterTitleWithLeftHamberger(
//               leftClicked: () {
//                 print("close clicked");
//                 print("open menu");
//                 Scaffold.of(context).openDrawer();
//               },
//               title: 'Sponsors',
//             )),
//         body: (isDone)
//             ? buildBody(context)
//             : loadingView());
//   }
//
//   Future _refreshData() async {
//     // await Future.delayed(Duration(seconds: 1));
//     callAPIGetListingAll();
//   }
//
//   Widget buildBody(BuildContext context) {
//     print('buildBody SponsorTabScreen');
//     // _refreshData();
//     // controller.callAPI();
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
//       child: Container(
//         color: Colors.white,
//         child: SafeArea(
//           child: Column(
//               children: [
//                 getSearchbar(),
//                 Expanded(
//                   child: RefreshIndicator(
//                     onRefresh: _refreshData,
//                     child: ListView.builder(
//                         shrinkWrap: true,
//                         physics: BouncingScrollPhysics(),
//                         scrollDirection: Axis.vertical,
//                         itemCount: finalArray.length,
//                         itemBuilder: (BuildContext context, int sectionIndex) {
//                           return StickyHeader(
//                             header: Container(
//                               // height: 50,
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey, width: 20),
//                                 color: Colors.white,
//                               ),
//                               // color: Colors.white,
//                               alignment: Alignment.centerLeft,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(0.0),
//                                 child: Text(
//                                   '${finalArray[sectionIndex].name}',//header data from ModelListingSponsor
//                                   style: Styles.mclub_smallTilteBold,
//                                 ),
//                               ),
//                             ),
//                             content: SliderMemberSponsors(
//                               modelListings: finalArray[sectionIndex].data,
//                               didTap: (itemTapped) {
//                                 print(itemTapped);
//                                 Get.to(() => SponsorsDetailsScreen(modelListing: itemTapped));
//
//                               },
//                             ),
//                           );
//                         }),
//                   ),
//                 ),
//               ]),
//         ),
//         // children: [],
//       ),
//     );
//   }
//
//   Widget loadingView() {
//     return Center(child: CircularProgressIndicator());
//   }
//
//   getSearchbar() {
//     return Padding(
//         padding: const EdgeInsets.symmetric(
//             horizontal: Config.kDefaultPadding * 2, vertical: 10),
//         child: Container(
//           color: Colors.white,
//           child: TextField(
//
//
//             controller: searchTextController,
//             onChanged: (value) {
//               searchTextString = searchTextController.text;
//
//               onSearchDebouncer.debounce(() {
//                 print(
//                     "controller.searchTextController.text ${searchTextController.text}");
//                 callAPIGetListingAll();
//               });
//             },
//             decoration: InputDecoration(
//               hintText: 'Search',
//               contentPadding:
//               EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
//               filled: true,
//               fillColor: Color.fromARGB(255, 242, 242, 242),
//               prefixIcon: Icon(Icons.search_sharp),
//               border: InputBorder.none,
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(width: 1, color: Config.secondColor),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(width: 1, color: Colors.white),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               labelText: '',
//               suffixIcon: searchTextString != ""
//                   ? IconButton(
//                 icon: Icon(Icons.close),
//                 onPressed: () {
//                   print("clear text");
//                   searchTextController.text = '';
//                   print("${searchTextString}");
//                   searchTextString = '';
//                   print("${searchTextString}");
//                   reloadAPI();
//                 },
//               )
//                   : SizedBox(),
//             ),
//           ),
//         ));
//   }
// }
//

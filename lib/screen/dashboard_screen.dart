import 'package:cached_network_image/cached_network_image.dart';
import 'package:carkee/models/ModelBottomAdsResult.dart';
import '../components/bottom_ads.dart';
import '../components/search_bar_phung.dart';
import '../config/strings.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import '../components/HeaderTitleClickable.dart';
import '../components/line_bottom_navigation.dart';
import '../components/network_api.dart';
import '../components/sliders_guest_sponsor.dart';
import '../components/sliders_item_listting_horizal.dart';
import '../components/sliders_news.dart';

import '../config/app_configs.dart';
import '../controllers/controllers.dart';
import '../controllers/main_tab_bar_controller.dart';

import '../models/ModelNewsResult.dart';
import '../screen/news_details_web.dart';
import '../screen/screens.dart';
import '../screen/sponsors_details_screen.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // final controller = Get.put(DashboardScreenController());

  final ProfileController profileController = Get.find();

  ModelBottomAdsResult modelBottomAdsResult;
  var modelNewsResult = ModelNewsResult();
  var searchTextString = '';
  List<ModelNews> finalArray = List<ModelNews>();
  var isDone_modelNewsResult = false;
  var page = 1;
  var isLasted = false;
  var isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callAPIGetListNews();
    callAPIGetBottomAds();//phase 3 enable!
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.white,
          title: Text("Home", style: Styles.mclub_Tilte),
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
              onTap: (){
                Session.shared.goProfileTab();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 20,
                    backgroundImage: NetworkImage(profileController.getProfileImage())
                ),
              ),
            ),
          ],
        ),
        body: (isDone_modelNewsResult) ? buildBody2() : loadingView());
  }

  Widget buildBody2() {
    return RefreshIndicator(onRefresh: _refreshData,
        child: Column(
          children: [
            Expanded(child: getBodySection()),
            if (profileController.getIsFreeMember() && modelBottomAdsResult != null) BottomAds(modelBottomAdsResult: modelBottomAdsResult,),
          ],
        )
    );
  }

  Future _refreshData() async {
    print('reloadAPI');
    await profileController.callAPIGetProfile();
    isDone_modelNewsResult = false;
    page = 1;
    isLasted = false;
    searchTextString = '';
    callAPIGetListNews();
    callAPIGetBottomAds();
  }

  callAPIGetBottomAds() async {
    ///phase 3 will enable this!
    print("start url_ads_list_random");
    var endpoint = url_ads_list_random;
    // Map<String, dynamic> jsonQuery = {
    //   // "access-token": await Session.shared.getToken(),
    // };
    //
    // if (!Session.shared.isLogedin()) {
    //   jsonQuery = {};
    // }

    // var network = NetworkAPI(endpoint: endpoint, jsonQuery: jsonQuery);
    var network = NetworkAPI(endpoint: endpoint);

    var jsonBody = await network.callAPIGET(showLog: false, keepKeyboard: false);
    if (jsonBody["code"] == 100) {
      print(" => CALL API $endpoint OK");
      var modelBottomAdsResult = ModelBottomAdsResult.fromJson(jsonBody);
      setState(() {
        this.modelBottomAdsResult = modelBottomAdsResult;
      });
    } else {
      print(
          " => CALL API $endpoint FALSE: $jsonBody");
      if (jsonBody["code"] ?? 102 != 102){
        Session.shared.showAlertPopupOneButtonWithCallback(
            content: jsonBody["message"] ?? "");
      } else {
        print("code 102 ads");
      }

    }
  }

  callAPIGetListNews() async {
    print("start url_news_list");
    var endpoint = url_news_list;
    Map<String, dynamic> jsonQuery = {
      "account_id": Session.shared.HASH_ID,
      "keyword": searchTextString,
      "access-token": await Session.shared.getToken(),
      "page": page
    };
    if (!(await Session.shared.isLogedin())) {
      jsonQuery = {
        "account_id": Session.shared.HASH_ID,
        "keyword": searchTextString,
        "page": page
      };
    }

    print("jsonQuery $url_news_list $jsonQuery");
    var network = NetworkAPI(endpoint: endpoint, jsonQuery: jsonQuery);
    isLoading = true;
    var jsonBody = await network.callAPIGET(showLog: true, keepKeyboard: false);
    if (jsonBody["code"] == 100) {
      print(" => CALL API $endpoint OK");
      var modelNewsResult_ = ModelNewsResult.fromJson(jsonBody);
      setState(() {
        modelNewsResult = modelNewsResult_;
        isDone_modelNewsResult = true;
        isLoading = false;
      });
  //get data
      if (page < 2) {
        //0,1 mean refresh!

        setState(() {
          finalArray = modelNewsResult.data;
        });

      } else {
        setState(() {
          finalArray.addAll(modelNewsResult.data);
        });
        //else have data

      }

      //check isLasted
      if (modelNewsResult.currentPage >=
          modelNewsResult.pageCount) {
        setState(() {
          isLasted = true;
          page = modelNewsResult.currentPage;
        });
      }
    } else {
      print(
          " => CALL API $endpoint FALSE: $jsonBody with jsonQuery $jsonQuery");
      Session.shared.showAlertPopupOneButtonWithCallback(
          content: jsonBody["message"] ?? "");
    }
  }



  Widget loadingView() {
    return Center(child: CircularProgressIndicator());
  }

  getBodySection() {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(profileController.userProfile.value.dashboardMessage ?? "approved account"),

          Obx(() {
             return profileController.userProfile.value.status != '3'
                 ? Padding(
               padding: const EdgeInsets.all(8.0),
               child: Html(
                   data: profileController
                       .userProfile.value.dashboardMessage ??
                       ""),
             )
                 : SizedBox();
          }),

          getSearchbar(),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Config.kDefaultPadding, vertical: Config.kDefaultPadding),
            child: Text(
              'What’s Happening?',
              style: Styles.mclub_smallTilteBold,
            ),
          ),
          getListNews(),
          // getSearchbar(),
          // Container(height: 100,width: Get.width, color: Colors.red,),

          // HeaderTitleClickable(
          //   title: 'What’s Happening',
          //   onTap: () {
          //     print('clicked What’s Happening See All');
          //     //self.currentTabBar?.setIndex(1) go tab 1.
          //     final MainTabbarController _controller = Get.find();
          //     _controller.changePage(1);
          //   },
          // ),
          // SliderNews(
          //   modelNews: controller.modelNewsResult.value.data,
          //   didTap: (itemTapped) {
          //     print('itemTapped newsId ${itemTapped.newsId}');
          //     print('itemTapped newsId ${itemTapped.toJson()}');
          //     print('itemTapped newsId ${itemTapped.toJson()}');
          //     Get.to(() => 
          //       DetailsNewsWeb(modelNews: itemTapped,newsType: NewsType.News, title: "News"),
          //     );
          //   },
          // ),
          // HeaderTitleClickable(
          //   title: 'Sponsors',
          //   onTap: () {
          //     print('clicked Sponsors See All');
          //     final MainTabbarController _controller = Get.find();
          //     if (profileController.getIsClubowner()) {//vendor 4 tab
          //       _controller.changePage(2);
          //     } else {
          //       _controller.changePage(3);//member 5 tab
          //     }
          //
          //   },
          // ),
          // SliderSponsor(
          //   modelListings: controller._guestScreenController.modeListingFeature.value.data,
          //   didTap: (itemTapped) {
          //     print('itemTapped newsId ${itemTapped.listingId}');
          //     Get.to(() => SponsorsDetailsScreen(modelListing: itemTapped));
          //     // Get.to(() => DemoScreen1());
          //
          //   },
          // ),

          // LazyLoadScrollView(
          //   isLoading: controller.isLoading.value,
          //   onEndOfPage: () => controller._loadMore(),
          //   child: SliderSponsor(
          //     modelListings: controller.modeListingFeature.value.data,
          //     didTap: (itemTapped) {
          //       print('itemTapped newsId ${itemTapped.listingId}');
          //       Get.to(() => SponsorsDetailsScreen(modelListing: itemTapped,));
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  getSearchbar() {
    return SearchBarPhung(startSearching: (stringValue) {
      setState(() {
        searchTextString = stringValue;
      });
      callAPIGetListNews(); //temp search not working.. need API! page , keyword..v.v
    }, reload: () {
      _refreshData();
    });
  }

  getListNews() {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: finalArray.length,
        itemBuilder: (BuildContext context, int itemIndex) {
          return GestureDetector(
            onTap: () {
              var itemTapped = finalArray[itemIndex];
              print('itemTapped newsId ${itemTapped.newsId}');

              //check if ads.
              finalArray[itemIndex].type == "ads" ? Session.shared.openWebView(title: "Ads", url: finalArray[itemIndex].url ?? "") :
              Get.to(() =>
                DetailsNewsWeb(
                    modelNews: itemTapped,
                    newsType: NewsType.News,
                    title: "News"),
              );
            },
            child: buildItemList2(itemIndex),
          );
        });
  }

  buildItemList2(int itemIndex) {
    return Container(
      // color: Colors.green,
      // height: 400,
      child: Stack(
        // height: 200,
        // color: Colors.blue,
        // crossAxisAlignment: CrossAxisAlignment.start,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            // color: Colors.yellow,
            // height: 800,
            // width: 800,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                //BOX
                Container(
                  margin: EdgeInsets.only(
                      bottom:
                      100), //khung xanh lá cách 1 doan trên 50., 50 cũng là 1/2 của các box cần dịch.. nên có thể gọi dây cũng la 1 cách
                  // color: Colors.green,
                  child: FadeInImage(
                      fit: BoxFit.cover,
                      // height: 230,
                      // width: (Get.width - 40),
                      image: ResizeImage(
                        CachedNetworkImageProvider(
                          finalArray[itemIndex].image,
                        ),
                        width: (Get.width).toInt(),
                      ),
                      placeholder: AssetImage(Strings.placeHolderImage),
                      // placeholder image until finish loading
                      imageErrorBuilder: (context, error, st) {
                        // return Text('Something went wrong $error');
                        return Icon(
                          Icons.error_outline,
                          size: 100,
                          color: Colors.red,
                        );
                      }),
                ),

                //check if is ads!
                finalArray[itemIndex].title == "" ? SizedBox() : Container(
                  height: 100,
                  width: Get.width - 40,
                  decoration: BoxDecoration(
                    //thêm bóng
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0,
                                1), //(0,-12) Bóng lên,(0,12) bóng xuống,, tuong tự cho trái phải
                            blurRadius: 5,
                            color: Colors.black26)
                      ],
                      //màu nền của View
                      color: Colors.white,
                      //độ tròn cong
                      borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.only(
                      bottom:
                      50),
                  // color: Colors.red,
                  child: Row(
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top : Config.kDefaultPadding * 2,
                                  left: Config.kDefaultPadding * 2,
                                  right: Config.kDefaultPadding *2 ,
                                  bottom: Config.kDefaultPadding),
                              child: Text(finalArray[itemIndex].title,
                                  maxLines: 1,
                                  style: Styles.mclub_smallTilteBold,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: Config.kDefaultPadding * 2,
                                  right: Config.kDefaultPadding *2 ,
                                  bottom: Config.kDefaultPadding * 2),
                              child: ExtendedText(
                                finalArray[itemIndex].summary,
                                maxLines: 2,
                                style: Styles.mclub_smallText,
                                // overflow: TextOverflow.ellipsis,
                                overflowWidget: TextOverflowWidget(
                                  maxHeight: 40,
                                  // maxHeight: double.infinity,
                                  //align: TextOverflowAlign.right,
                                  //fixedOffset: Offset.zero,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Text('\u2026 '),
                                      Text(
                                        "See more",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Config.secondColor),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: IconButton(icon: Icon(Icons.chevron_right,color: Config.secondColor, size: 30), onPressed: (){

                        },),
                      )
                    ],
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
  //
  // getHeader() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: [
  //       Expanded(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: [
  //             Text(
  //               profileController.getFullName(),
  //               style: Styles.mclub_Tilte,
  //             ),
  //             Text(
  //               profileController.userProfile.value.memberSince,
  //               style: Styles.mclub_smallText,
  //             ),
  //           ],
  //         ),
  //       ),
  //       GestureDetector(
  //         onTap: () {
  //           final MainTabbarController _controller = Get.find();
  //           _controller.goProfileTab();
  //         },
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(
  //               horizontal: Config.kDefaultPadding * 2),
  //           child: CircleAvatar(
  //             radius: 40.0,
  //             backgroundImage:
  //             NetworkImage(profileController.getProfileImage()),
  //             backgroundColor: Colors.transparent,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}

//final Controller _controller = Get.put(Controller());
//final Controller _controller = Get.find();
// class DashboardScreenController extends GetxController {
//   // final GuestScreenController _guestScreenController = Get.find();
//   // final _guestScreenController = Get.put(GuestScreenController());
//   var modelNewsResult = ModelNewsResult().obs;
//   var searchTextString = ''.obs;
//   // var modelItemListingResult = ModelItemListingResult().obs;
//   List<ModelNews> finalArray = List<ModelNews>().obs;
//   var isDone_modelNewsResult = false.obs;
//   var page = 1.obs;
//   var isLasted = false.obs;
//   var isLoading = false.obs;
//   // List<ModelItem> dataSourceSponsor = List<ModelItem>().obs;
//
//   @override
//   void onInit() {
//     // called immediately after the widget is allocated memory
//     // callAPIGetListNews();
//     super.onInit();
//   }
//
//   @override
//   void onClose() {
//     // called just before the Controller is deleted from memory
//     super.onClose();
//   }
//   //
//   // callAPIGetListNews() async {
//   //   print("start url_news_list");
//   //   var endpoint = url_news_list;
//   //   // var network = NetworkAPI(endpoint: endpoint, jsonQuery: {
//   //   //   "account_id": Session.shared.HASH_ID,
//   //   //   'access-token' : await Session.shared.getToken(),
//   //   // });
//   //   Map<String, dynamic> jsonQuery = {
//   //     "account_id": Session.shared.HASH_ID,
//   //     "keyword": searchTextString.value,
//   //     "access-token": await Session.shared.getToken(),
//   //     "page": page
//   //   };
//   //   var network = NetworkAPI(endpoint: endpoint, jsonQuery: jsonQuery);
//   //   isLoading.value = true;
//   //   var jsonBody = await network.callAPIGET(showLog: true, keepKeyboard: true);
//   //   // var jsonBody = await network.callAPIGET(showLog: true);
//   //   // if (jsonBody["code"] == 100) {
//   //   //   print(" ==> PURE JSON DATA $jsonBody");
//   //   //   modelNewsResult.value = ModelNewsResult.fromJson(jsonBody);
//   //   //   print('modelNewsResult.value ${modelNewsResult.value.data.first.toJson()}');
//   //   //   isDone_modelNewsResult.value = true;
//   //   // } else {
//   //   //   Session.shared.showAlertPopupOneButtonWithCallback(
//   //   //       content: jsonBody["message"] ?? "");
//   //   // }
//   //
//   //   if (jsonBody["code"] == 100) {
//   //     print(" => CALL API $endpoint OK");
//   //     var modelNewsResult_ = ModelNewsResult.fromJson(jsonBody);
//   //     modelNewsResult.value = modelNewsResult_;
//   //     //get data
//   //     if (page.value < 2) {
//   //       //0,1 mean refresh!
//   //
//   //
//   //       finalArray = modelNewsResult.value.data;
//   //     } else {
//   //       //else have data
//   //       finalArray.addAll(modelNewsResult.value.data);
//   //     }
//   //     //check isLasted
//   //     if (modelNewsResult.value.currentPage >=
//   //         modelNewsResult.value.pageCount) {
//   //       isLasted.value = true;
//   //       page.value = modelNewsResult.value.currentPage;
//   //     }
//   //     isDone_modelNewsResult.value = true;
//   //     isLoading.value = false;
//   //   } else {
//   //     print(
//   //         " => CALL API $endpoint FALSE: $jsonBody with jsonQuery $jsonQuery");
//   //     Session.shared.showAlertPopupOneButtonWithCallback(
//   //         content: jsonBody["message"] ?? "");
//   //   }
//   // }
//
//   _loadMore() async {
//     print("isLasted.value ${isLasted.value}");
//     print("isLoading.value ${isLoading.value}");
//     if (isLasted.value) {
//       print('no more load');
//     } else if (isLoading.value) {
//       print('data loading, not allow call API');
//     } else {
//       page += 1;
//       print('start load more page $page');
//       // callAPI_url_item_list_all();
//     }
//   }
//
//   //phase2
//   // callAPI_url_item_list_all() async {
//   //   print("start callAPI_url_item_list_all");
//   //   var endpoint = url_item_list_all;
//   //   var network = NetworkAPI(endpoint: endpoint, jsonQuery: {
//   //     "access-token": await Session.shared.getToken(),
//   //     "page": page.value
//   //   });
//   //   isLoading.value = true;
//   //   var jsonBody = await network.callAPIGET();
//   //
//   //   if (jsonBody["code"] == 100) {
//   //     print("result body data $jsonBody");
//   //     print(" => CALL API $endpoint OK");
//   //     modelItemListingResult.value = ModelItemListingResult.fromJson(jsonBody);
//   //     //get data
//   //     if (page.value < 2) {
//   //       //0,1 mean refresh!
//   //       dataSourceSponsor = modelItemListingResult.value.data;
//   //     } else {
//   //       //else have data
//   //       dataSourceSponsor.addAll(modelItemListingResult.value.data);
//   //     }
//   //     //check isLasted
//   //     if (modelItemListingResult.value.currentPage >=
//   //         modelItemListingResult.value.pageCount) {
//   //       isLasted.value = true;
//   //       page.value = modelItemListingResult.value.currentPage;
//   //     }
//   //     isDone_modelItemListingResult.value = true;
//   //     isLoading.value = false;
//   //   } else {
//   //     Session.shared.showAlertPopupOneButtonWithCallback(
//   //         content: jsonBody["message"] ?? "");
//   //   }
//   // }
// }
//
//

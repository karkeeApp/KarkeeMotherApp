import 'package:cached_network_image/cached_network_image.dart';
import 'package:carkee/components/load_image_component.dart';
import 'package:carkee/components/search_bar_phung.dart';
import 'package:carkee/util/utils.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:carkee/components/debouncer.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/config/strings.dart';
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/models/ModelNewsResult.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:carkee/screen/news_details_web.dart';

class NewsFeedScreen extends StatelessWidget {
  //
  // final ProfileController profileController = Get.find();
  NewsFeedScreen({Key key})
      : super(key: key); // phải add key để lưu state khi switch các tab
  final controller = Get.put(NewsFeedScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          centerTitle: true,
          // iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.white,
          title: Text("News", style: Styles.mclub_Tilte),
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
          // actions: [
          //   GestureDetector(
          //     onTap: (){
          //       Session.shared.goProfileTab();
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.only(right: 20),
          //       child: CircleAvatar(
          //           backgroundColor: Colors.transparent,
          //           radius: 20,
          //           backgroundImage: NetworkImage(Utils().getProfileController().getProfileImage())
          //       ),
          //     ),
          //   ),
          // ],
        ),
        body: Obx(() => (controller.isDone_modelNewsResult.value)
            ? buildBody(context)
            : loadingView()));
  }

  Future _refreshData() async {
    controller.callAPI();
  }

  Widget buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(children: [
            getSearchbar(),
            Expanded(
              child: LazyLoadScrollView(
                // scrollOffset : 0,
                isLoading: controller.isLoading.value,
                onEndOfPage: () {
                  controller._loadMore();
                },
                child: RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: controller.finalArray.length,
                      itemBuilder: (BuildContext context, int itemIndex) {
                        //each /3 = 0 then add 1 ads!
                        return GestureDetector(
                          onTap: () {
                            var itemTapped = controller.finalArray[itemIndex];
                            print('itemTapped newsId ${itemTapped.newsId}');
                            print('itemTapped ${itemTapped.toJson()}');
                            Get.to(() => 
                              DetailsNewsWeb(
                                  modelNews: itemTapped,
                                  newsType: NewsType.News,
                                  title: "News"),
                            );
                          },
                          child: buildItemListV2(itemIndex),
                        );
                      }),
                ),
              ),
            ),
          ]),
        ),
        // children: [],
      ),
    );
  }



  buildItemListV2(int itemIndex) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)), //,
                child: LoadImageFromUrl(controller.finalArray[itemIndex].image, boxFit: BoxFit.fitWidth,),
                // child: FadeInImage(
                //     fit: BoxFit.cover,
                //     // height: 230,
                //     width: (Get.width),
                //     image: ResizeImage(
                //       CachedNetworkImageProvider(
                //         controller.finalArray[itemIndex].image,
                //       ),
                //        width: (Get.width - 20).toInt(),
                //     ),
                //     placeholder: AssetImage(Strings.placeHolderImage),
                //     // placeholder image until finish loading
                //     imageErrorBuilder: (context, error, st) {
                //       // return Text('Something went wrong $error');
                //       return Icon(
                //         Icons.error_outline,
                //         size: 100,
                //         color: Colors.red,
                //       );
                //     }),
              ),
              Padding(
                padding: const EdgeInsets.all(Config.kDefaultPadding),
                child: Text(controller.finalArray[itemIndex].title,
                    maxLines: 1,
                    style: Styles.mclub_smallTilteBold,
                    overflow: TextOverflow.ellipsis),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: Config.kDefaultPadding,
                    right: Config.kDefaultPadding,
                    bottom: Config.kDefaultPadding * 2),
                child: ExtendedText(
                  controller.finalArray[itemIndex].summary,
                  maxLines: 2,
                  style: Styles.mclub_smallText,
                  // overflow: TextOverflow.ellipsis,
                  overflowWidget: TextOverflowWidget(
                    //maxHeight: double.infinity,
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
      ),
    );

  }

  Widget loadingView() {
    return Center(child: CircularProgressIndicator());
  }
  getSearchbar() {
    return SearchBarPhung(startSearching: (stringValue) {
      controller.searchTextString.value = stringValue;
      controller.callAPI();
    }, reload: () {
      controller.reloadAPI();
    });
    //return SearchBarPhung(controller: controller);

    // return Container(
    //
    //   child: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: Config.kDefaultPadding, vertical: 0),
    //       child: TextField(
    //
    //         controller: controller.searchTextController,
    //         onChanged: (value) {
    //           controller.searchTextString.value =
    //               controller.searchTextController.text;
    //           controller.onSearchDebouncer.debounce(() {
    //             print("controller.searchTextController.text ${controller.searchTextController.text}");
    //             controller.callAPI();
    //           });
    //         },
    //
    //         decoration: InputDecoration(
    //           hintText: 'Search',
    //           contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
    //           filled: true,
    //           fillColor: Colors.white,//Color.fromARGB(255, 242, 242, 242),
    //           prefixIcon: Icon(Icons.search_sharp),
    //           // border: InputBorder.none,
    //           focusedBorder: OutlineInputBorder(
    //             borderSide: BorderSide(width: 1, color: Config.secondColor),
    //             borderRadius: BorderRadius.circular(15),
    //
    //           ),
    //           enabledBorder: OutlineInputBorder(
    //             borderSide: BorderSide(width: 1,color: Colors.grey),
    //             borderRadius: BorderRadius.circular(15),
    //           ),
    //           labelText: '',
    //           suffixIcon: controller.searchTextString.value != ""
    //               ? IconButton(
    //                   icon: Icon(Icons.close),
    //                   onPressed: () {
    //                     print("clear text");
    //                     controller.searchTextController.text = '';
    //                     print("${controller.searchTextString.value}");
    //                     controller.searchTextString.value = '';
    //                     print("${controller.searchTextString.value}");
    //                     controller.reloadAPI();
    //                   },
    //                 )
    //               : SizedBox(),
    //         ),
    //       )
    //   ),
    // );
  }
}

class NewsFeedScreenController extends GetxController {
  // final ProfileController profileController = Get.find();

  var searchTextString = ''.obs;
  final searchTextController = TextEditingController();
  List<ModelNews> finalArray = List<ModelNews>().obs;
  var modelNewsResult = ModelNewsResult().obs;
  var isDone_modelNewsResult = false.obs;
  var page = 1.obs;
  var isLasted = false.obs;
  var isLoading = false.obs;

  // final Debouncer onSearchDebouncer = Debouncer(delay: Duration(seconds: 1));

  @override
  void onInit() {
    super.onInit();
    callAPI();
  }

  @override
  void onClose() {
    // called just before the Controller is deleted from memory
    super.onClose();
  }

  Future reloadAPI() async {
    // await Future.delayed(Duration(seconds: 1));
    print('reloadAPI');
    isDone_modelNewsResult.value = false;
    page.value = 1;
    isLasted.value = false;
    // isLoading.value = false;
    // finalArray = [];
    searchTextString.value = '';
    callAPI();
  }

  Future callAPI() async {
    //getProfileController
    if (Session.shared.isLogedin()) {
      var profileController = Utils().getProfileController();
      if (profileController.getIsCompany()) {
        print("call api list for vendor");
        callAPIGetListFeeds_Vendor();
      } else {
        print("call callAPIGetListFeeds list for members");
        callAPIGetListFeeds();
      }
    } else {
      print("call api list for callAPIGetListFeeds_GUEST");
      callAPIGetListFeeds_GUEST();
    }
  }

  _loadMore() async {
    print("isLasted.value ${isLasted.value}");
    print("isLoading.value ${isLoading.value}");
    if (isLasted.value) {
      print('no more load');
    } else if (isLoading.value) {
      print('data loading, not allow call API');
    } else {
      page += 1;
      print('start load more page $page');
      callAPI();
      // callAPIGetListFeeds_Vendor();
    }
  }

  Future callAPIGetListFeeds_Vendor() async {
    print("start callAPIGetListFeeds_Vendor");
    var endpoint = url_news_guest;
    Map<String, dynamic> jsonQuery = {
      "account_id": Session.shared.HASH_ID,
      "keyword": searchTextString.value,
      "access-token": await Session.shared.getToken(),
      "page": page
    };
    var network = NetworkAPI(endpoint: endpoint, jsonQuery: jsonQuery);
    isLoading.value = true;

    var jsonBody = await network.callAPIGET(showLog: false, keepKeyboard: true);

    if (jsonBody["code"] == 100) {
      print(" => CALL API $endpoint OK");
      var modelNewsResult_ = ModelNewsResult.fromJson(jsonBody);
      modelNewsResult.value = modelNewsResult_;
      //get data
      if (page.value < 2) {
        //0,1 mean refresh!
        finalArray = modelNewsResult.value.data;
      } else {
        //else have data
        finalArray.addAll(modelNewsResult.value.data);
      }
      //check isLasted
      if (modelNewsResult.value.currentPage >=
          modelNewsResult.value.pageCount) {
        isLasted.value = true;
        page.value = modelNewsResult.value.currentPage;
      }
      isDone_modelNewsResult.value = true;
      isLoading.value = false;
    } else {
      print(
          " => CALL API $endpoint FALSE: $jsonBody with jsonQuery $jsonQuery");
      Session.shared.showAlertPopupOneButtonWithCallback(
          content: jsonBody["message"] ?? "");
    }
  }

  Future callAPIGetListFeeds() async {
    print("start callAPIGetListFeeds");
    // var endpoint = url_news_feeds;// because new feeds now dont have data we fake url_news_list
    var endpoint = url_news_list;

    Map<String, dynamic> jsonQuery = {
      "account_id": Session.shared.HASH_ID,
      "keyword": searchTextString.value,
      "access-token": await Session.shared.getToken(),
      "page": page
    };
    var network = NetworkAPI(endpoint: endpoint, jsonQuery: jsonQuery);
    isLoading.value = true;

    var jsonBody = await network.callAPIGET(showLog: false, keepKeyboard: true);

    if (jsonBody["code"] == 100) {
      print(" => CALL API $endpoint OK");

      var modelNewsResult_ = ModelNewsResult.fromJson(jsonBody);
      modelNewsResult.value = modelNewsResult_;
      //get data
      if (page.value < 2) {
        //0,1 mean refresh!
        finalArray = modelNewsResult.value.data;
      } else {
        //else have data
        finalArray.addAll(modelNewsResult.value.data);
      }
      //check isLasted
      if (modelNewsResult.value.currentPage >=
          modelNewsResult.value.pageCount) {
        isLasted.value = true;
        page.value = modelNewsResult.value.currentPage;
      }
      isDone_modelNewsResult.value = true;
      isLoading.value = false;
    } else {
      print(
          " => CALL API $endpoint FALSE: $jsonBody with jsonQuery $jsonQuery");
      Session.shared.showAlertPopupOneButtonWithCallback(
          content: jsonBody["message"] ?? "");
    }
  }

  Future callAPIGetListFeeds_GUEST() async {
    print("start callAPIGetListFeeds_GUEST");
    // var endpoint = url_news_feeds;// because new feeds now dont have data we fake url_news_list
    var endpoint = url_news_list;

    Map<String, dynamic> jsonQuery = {
      "account_id": Session.shared.HASH_ID,
      "keyword": searchTextString.value,
      // "access-token": await Session.shared.getToken(),
      "page": page
    };
    var network = NetworkAPI(endpoint: endpoint, jsonQuery: jsonQuery);
    isLoading.value = true;

    var jsonBody = await network.callAPIGET(showLog: false, keepKeyboard: true);

    if (jsonBody["code"] == 100) {
      print(" => CALL API $endpoint OK");

      var modelNewsResult_ = ModelNewsResult.fromJson(jsonBody);
      modelNewsResult.value = modelNewsResult_;
      //get data
      if (page.value < 2) {
        //0,1 mean refresh!
        finalArray = modelNewsResult.value.data;
      } else {
        //else have data
        finalArray.addAll(modelNewsResult.value.data);
      }
      //check isLasted
      if (modelNewsResult.value.currentPage >=
          modelNewsResult.value.pageCount) {
        isLasted.value = true;
        page.value = modelNewsResult.value.currentPage;
      }
      isDone_modelNewsResult.value = true;
      isLoading.value = false;
    } else {
      print(
          " => CALL API $endpoint FALSE: $jsonBody with jsonQuery $jsonQuery");
      Session.shared.showAlertPopupOneButtonWithCallback(
          content: jsonBody["message"] ?? "");
    }
  }
}

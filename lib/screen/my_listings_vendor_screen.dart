import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carkee/components/appbar_custom.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/components/testbox.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/config/colors.dart';
import 'package:carkee/config/strings.dart';
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/models/ModelListingResult.dart';
import 'package:carkee/models/ModelMyListingResult.dart';
import 'package:carkee/screen/screens.dart';
import 'package:dio/dio.dart' as Dioo;
class MyListingsScreen extends StatefulWidget {
  @override
  _MyListingsScreenState createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {

  final MyListingsController _controller = Get.put(MyListingsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.callAPIGetLIST();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        // appBar: PreferredSize(
        //
        //     preferredSize: AppBarLeftBackRightIcon().preferredSize,
        //     child: AppBarLeftBackRightIcon(
        //       iconRight: Icon(Icons.add),
        //       rightClicked: () {
        //         print("rightClicked clicked");
        //         Get.to(() => AddListingScreen());
        //         // Get.to(() => Profile());
        //       },
        //       leftClicked: () {
        //         print("close clicked");
        //         Get.back();
        //       },
        //       title: 'My Listings',
        //     )),

        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text("My Listings", style: Styles.mclub_Tilte),
          elevation: 0,
          actions: [
            IconButton(icon: Icon(Icons.add), onPressed: (){
              print("clicked");
              Get.to(() => AddListingScreen());
            })
          ],
        ),
        body: Obx(() => _controller.isDone.value
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    // Feature item
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FadeInImage(
                          fit: BoxFit.cover,
                          // height: 230,
                          width: (Get.width),
                          image: ResizeImage(
                            CachedNetworkImageProvider(
                              _controller.modelMyListingResult?.value.primary?.primaryPhoto,
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
                    RowMyListingFeature(
                      modelListing: _controller.modelMyListingResult?.value.primary,
                    ),
                    //list other

                    fakeTopRadius(),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _controller.modelMyListingResult.value.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(children: [
                            RowMyListing(
                              index: index + 2,
                              modelListing: _controller.modelMyListingResult.value.data[index],
                              editClicked: () {
                                print('editClicked');
                                Get.to(() => EditListingScreen(modelListting: _controller.modelMyListingResult.value.data[index]));
                              },
                              setPrimaryClicked: () {
                                print('setPrimaryClicked');
                                _controller.callAPISetPrimary(_controller.modelMyListingResult.value.data[index].listingId);
                              },
                            ),
                            Divider(),
                          ]);
                        })
                    // PhungBox(height: 50),
                    // PhungBox(height: 300),
                    // PhungBox(height: 300),
                    // PhungBox(height: 300),
                    // PhungBox(height: 300),
                    // PhungBox(height: 300),
                  ],
                ),
              )
            : AppState()
        )
    );
  }

  Container fakeTopRadius() {
    return Container(
                    color: Config.kLightGreyBackgroundColor,
                    height: 30,
                    child: SizedBox(
                      height: 40,
                      child: Container(
                        // height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                            boxShadow: Config.kShadow
                        ),
                      ),
                    ),
                  );
  }

  Widget AppState() {
    return Center(
        child: Text(_controller.errorString)
    );
  }


  // List
  Widget ListViewDemo() {
    var list = new List<int>.generate(200, (i) => i + 1);
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        return Text('${list[index]}');
      },
    );
  }
}

class RowMyListingFeature extends StatelessWidget {
  final ModelListing modelListing;
  RowMyListingFeature({
    Key key,
    this.modelListing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Config.kLightGreyBackgroundColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Config.kDefaultPadding * 2),
            child: Text(
              '1. ${modelListing.title}',
              style: Styles.mclub_smallTilteBold,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )),
          IconButton(
              icon: Icon(Icons.lock),
              // icon: Image.asset('assets/images/ic_three_dot2.png'),
              onPressed: () {
                print("clicked");
                displayModalBottomSheetEditFeature(context);
              })
        ],
      ),
    );
  }

  //functions
  //   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void displayModalBottomSheetEditFeature(context) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text(modelListing.title),
            // message: Text(''),
            actions: [
              CupertinoActionSheetAction(
                child: Text(
                  'Edit',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Config.primaryColor),
                ),
                onPressed: () {
                  print('press Edit');
                  Navigator.of(context).pop();
                  Get.to(() => EditListingScreen(modelListting: modelListing,));

                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancel',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Config.primaryColor),
              ),
              onPressed: () {
                print('press Cancel');
                Navigator.of(context).pop();
              },
            ),
          );
        });
  }
}

class RowMyListing extends StatelessWidget {
  final int index;
  final ModelListing modelListing;
  final Function() editClicked;
  final Function() setPrimaryClicked;
  RowMyListing({
    Key key,
    this.modelListing,
    this.editClicked,
    this.setPrimaryClicked, this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Config.kDefaultPadding * 2),
            child: Text(
              '$index. ${modelListing.title}',
              style: Styles.mclub_smallTilteBold,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )),
          getIconStatus(),
          IconButton(
              // icon: Icon(Icons.menu),
              icon: Image.asset('assets/images/ic_three_dot2.png'),
              onPressed: () {
                print("clicked");
                if (modelListing.status == 2) {
                  displayModalBottomSheetForApprovedItem(context);
                } else {
                  displayModalBottomSheet(context);
                }
              })
        ],
      ),
    );
  }

  Text getStatusText() {
    return Text(
          modelListing.statusValue,
          style: getStyleFollowState(),
        );
  }
  getIconStatus() {

    var statusInt =  modelListing.status;
    switch(statusInt) {
      case 2: {
        return Icon(Icons.check,color: Color(0xFF0CCA7C),);
      }
      break;

      case 1: {
        return Icon(Icons.access_time,color: Color(0xFF304983),);
      }
      break;

      case 3: {
        return Icon(Icons.close,color: Colors.red,);
      }
      break;

      default: {
        return Icon(Icons.close,color: Colors.red,);
      }
      break;
    }
  }

  TextStyle getStyleFollowState(){
    //Styles.mclub_subTilteBlue,
    var statusInt =  modelListing.status;
    switch(statusInt) {
      case 2: {
        return TextStyle(color: Color(0xFF0CCA7C), fontWeight: FontWeight.bold);
      }
      break;

      case 1: {
        return TextStyle(color: Color(0xFF304983), fontWeight: FontWeight.bold);
      }
      break;

      case 3: {
        return TextStyle(color: Color(0xFFEEBC00), fontWeight: FontWeight.bold);
      }
      break;

      default: {
        return TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
      }
      break;
    }
  }

  //functions
  //   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void displayModalBottomSheet(context) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text(modelListing.title),
            // message: Text(''),
            actions: [
              CupertinoActionSheetAction(
                child: Text(
                  'Edit',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Config.primaryColor),
                ),
                onPressed: () {
                  print('press Edit');
                  Navigator.of(context).pop();
                  editClicked();

                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancel',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Config.primaryColor),
              ),
              onPressed: () {
                print('press Cancel');
                Navigator.of(context).pop();
              },
            ),
          );
        });
  }

  void displayModalBottomSheetForApprovedItem(context) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text(modelListing.title),
            // message: Text(''),
            actions: [
              CupertinoActionSheetAction(
                child: Text(
                  'Edit',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Config.primaryColor),
                ),
                onPressed: () {
                  print('press Edit');
                  Navigator.of(context).pop();
                  editClicked();

                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  'Set as featured listing',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Config.primaryColor),
                ),
                onPressed: () {
                  print('press Set as featured listing');
                  setPrimaryClicked();
                  Navigator.of(context).pop();

                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancel',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Config.primaryColor),
              ),
              onPressed: () {
                print('press Cancel');
                Navigator.of(context).pop();
              },
            ),
          );
        });
  }
}

//final Controller _controller = Get.find();
class MyListingsController extends GetxController {
  var modelMyListingResult = ModelMyListingResult().obs;
  var isDone = false.obs;
  var errorString = '';
  @override
  void onInit() { // called immediately after the widget is allocated memory
    super.onInit();
  }
  @override
  void onClose() { // called just before the Controller is deleted from memory
    super.onClose();
  }
  callAPIGetLIST() async {
    print("start callAPIGetLIST");
    var endpoint = url_listing_list;
    Map<String, dynamic> jsonQuery = {
      "account_id": Session.shared.HASH_ID,
      "access-token": await Session.shared.getToken(),
    };
    var network = NetworkAPI(endpoint: endpoint, jsonQuery: jsonQuery);
    var jsonBody = await network.callAPIGET(showLog: true);
    if (jsonBody["code"] == 100) {
      //ModelMyListingResult
      var _modelMyListingResult = ModelMyListingResult.fromJson(jsonBody);
      if (_modelMyListingResult.primary != null) {
        isDone.value = true;
        modelMyListingResult.value = _modelMyListingResult;
      }
      print(" => CALL API $endpoint OK");
    } else {
      print(
          " => CALL API $endpoint FALSE: $jsonBody with jsonQuery $jsonQuery");
      errorString = jsonBody["message"] ?? "";
    }
  }
  callAPIDeleteMyListing(int id) async {
      print("start callAPIDeleteMyListing");
      Dioo.FormData formData = new Dioo.FormData.fromMap({
        'listing_id' : id
      });
      Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
      var network = NetworkAPI(endpoint: url_listing_delete, formData: formData, jsonQuery: jsonQuery);
      var jsonBody = await network.callAPIPOST();
      if (jsonBody["code"] == 100) {
        print("success $jsonBody");
        callAPIGetLIST();
      } else {
        Session.shared.showAlertPopupOneButtonNoCallBack(
            title: "Error", content: jsonBody["message"]);
      }
  }
  callAPISetPrimary(int id) async {
    print("start callAPISetPrimary");
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      'listing_id' : id
    });
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(endpoint: url_listing_set_primary, formData: formData, jsonQuery: jsonQuery);
    var jsonBody = await network.callAPIPOST();
    if (jsonBody["code"] == 100) {
      print("success $jsonBody");
      callAPIGetLIST();
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }

}

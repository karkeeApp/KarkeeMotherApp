import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/components/sliders_guest_sponsor.dart';
import 'package:carkee/components/sliders_news_details.dart';
import 'package:carkee/components/web_view_section.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/config/strings.dart';
import 'package:carkee/models/ModelListingDetailsByIDResult.dart';
import 'package:carkee/models/ModelListingResult.dart';
import 'package:carkee/models/ModelNewsResult.dart';
import 'package:carkee/screen/web_view_in_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:map_launcher/map_launcher.dart';

class SponsorsDetailsScreen extends StatelessWidget {
  final SponsorsDetailsScreenController controller =
      Get.put(SponsorsDetailsScreenController());
  final ModelListing modelListing;
  SponsorsDetailsScreen({Key key, this.modelListing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.modelListing = modelListing;
    controller.callAPIListingViewByID();
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        // appBar: PreferredSize(
        //     preferredSize: AppBarCustomRightIcon().preferredSize,
        //     child: AppBarCustomRightIcon(
        //       leftClicked: () {
        //         print("close clicked");
        //         Get.back();
        //       },
        //       title: 'Sponsors',
        //     )),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(""),
          elevation: 0,
        ),
        //SliderNewsDetails(modelNews: modelNews,),
        body: ListView(padding: EdgeInsets.only(top: 0), children: [
          Stack(
            alignment: Alignment.centerRight,
            children: [
              section1_ImageFeature(),
              section1_IconLocationPhone(context),
            ],
          ),
          section2_info(context),
          section2_content(),
          Obx(() {
            return controller.isDone.value
                ? SliderSponsor(
                    modelListings:
                        controller.modelListingDetailsByIDResult.value.related,
                    didTap: (itemTapped) {
                      print('itemTapped newsId ${itemTapped.listingId}');
                      Route route = MaterialPageRoute(
                          builder: (context) =>
                              SponsorsDetailsScreen(modelListing: itemTapped));
                      Navigator.of(context).pushReplacement(route);
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          }),
          SizedBox(
            height: 30,
          ),
        ]));
  }

  Transform section2_content() {
    return Transform.translate(
      offset: Offset(0, -50),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Config.kDefaultPadding * 2),
        color: Colors.white,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Config.kDefaultPadding),
              child: Text(
                modelListing.title ?? "",
                style: Styles.mclub_Tilte,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: Config.kDefaultPadding),
              child: Text(
                modelListing.content ?? "",
                style: Styles.mclub_smallText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding section2_info(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Transform.translate(
          offset: Offset(0, -50),
          child: Container(
            height: 100,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              // alignment: Alignment.center,
              // height: 100, color: Colors.red.withOpacity(0.3),
              child: infoOwner(context),
            ),
          )),
    );
  }

  infoOwner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        alignment: Alignment.center,
        height: 100,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(
                  modelListing.vendorInfo.company_logo ??
                      ""), // imgProfile=> company_logo
              backgroundColor: Colors.transparent,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      modelListing.vendorInfo?.company ??
                          "", //vendorName => company
                      style: Styles.mclub_Tilte,
                    ),
                    Text(
                      'Approved Sponsor Since ${modelListing.vendorInfo?.approvedAt ?? ""}',
                      style: Styles.mclub_smallText,
                    ),
                  ],
                ),
              ),
            ),
            // GestureDetector(
            //   onTap: () {
            //     print('location tapped');
            //     displayModalBottomSheet(context);
            //   },
            //   child: ImageIcon(
            //     AssetImage("assets/images/location.png"),
            //     size: 30,
            //   ),
            // ),
            // SizedBox(
            //   width: 10,
            // ),
            // GestureDetector(
            //   onTap: () {
            //     print('phone tapped');
            //     controller._makePhoneCall();
            //   },
            //   child: ImageIcon(
            //     AssetImage("assets/images/phone.png"),
            //     size: 30,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  section1_IconLocationPhone(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          //only show if long, lat availabel

          //check later
          //  modelListing.vendorInfo.isEmptyLongLat() ? SizedBox() : GestureDetector(
          //   onTap: () {
          //     print('location tapped');
          //     displayModalBottomSheet(context);
          //   },
          //   child: Image.asset('assets/images/location.png', width: 40,)
          // ),
          GestureDetector(
              onTap: () {
                print('location tapped');
                displayModalBottomSheet(context);
              },
              child: Image.asset('assets/images/location.png', width: 40,)
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              print('phone tapped');
              controller._makePhoneCall();
            },
            child: Image.asset("assets/images/phone.png", width: 40)
          ),
        ],
      ),
    );
  }

  FadeInImage section1_ImageFeature() {
    return FadeInImage(
        fit: BoxFit.cover,
        // height: 230,
        width: Get.width,
        image: ResizeImage(
          CachedNetworkImageProvider(
            modelListing.primaryPhoto,
          ),
          width: Get.width.toInt(),
        ),
        placeholder: AssetImage(Strings.placeHolderImage),
        // placeholder image until finish loading
        imageErrorBuilder: (context, error, st) {
          return Text(error.toString());
        });
  }

  //functions
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void displayModalBottomSheet(context) {
    var address = modelListing.vendorInfo?.add1 ?? "";
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    address,
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(),
                ListTile(
                    leading: new Icon(Icons.map),
                    title: new Text('Open in Maps'),
                    onTap: () {
                      Get.back();
                      openMapsSheet(context);
                    }),
                Divider(),
                ListTile(
                  leading: new Icon(Icons.copy),
                  title: new Text('Copy'),
                  onTap: () {
                    Get.back();
                    Clipboard.setData(new ClipboardData(text: address));
                    Get.snackbar('Address', 'Copied');
                  },
                ),
              ],
            ),
          );
        });
  }

  openMapsSheet(context) async {
    //lat long
    var nameVendor =
        modelListing.vendorInfo.company ?? ""; // vendorName => company
    var lat = double.parse(modelListing.vendorInfo.latitude ?? "0");
    var long = double.parse(modelListing.vendorInfo.longitude ?? "0");
    try {
      final coords = Coords(lat, long);
      final title = nameVendor;
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                        ),
                        title: Text(map.mapName),
                        leading: Icon(Icons.map),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }
}

class SponsorsDetailsScreenController extends GetxController {
  ModelListing modelListing;
  var modelListingDetailsByIDResult = ModelListingDetailsByIDResult().obs;
  var isDone = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  callAPIListingViewByID() async {
    print("start callAPIListingViewByID");
    Map<String, dynamic> jsonQuery = {
    "listing_id": modelListing.listingId,
    // "access-token": await Session.shared.getToken()
    };
    if (Session.shared.isLogedin()) {
      jsonQuery = {
        "listing_id": modelListing.listingId,
        "access-token": await Session.shared.getToken()
      };
    }
    var network = NetworkAPI(endpoint: url_listing_by_id, jsonQuery: jsonQuery);
    var jsonBody = await network.callAPI(method: "GET", showLog: true);
    if (jsonBody["code"] == 100) {
      print("callAPIListingViewByID OK");
      modelListingDetailsByIDResult.value =
          ModelListingDetailsByIDResult.fromJson(jsonBody);
      isDone.value = true;
    } else {
      Session.shared.showAlertPopupOneButtonWithCallback(
          content: jsonBody["message"] ?? "");
    }
  }

  _makePhoneCall() async {
    var code = modelListing.vendorInfo.mobileCode ?? "";
    var number = modelListing.vendorInfo.mobile ?? "";
    var fullNumberFormakeCall = 'tel:$code$number';
    if (await canLaunch(fullNumberFormakeCall)) {
      await launch(fullNumberFormakeCall);
    } else {
      throw 'Could not launch $fullNumberFormakeCall';
    }
  }

  @override
  void onClose() {
    // modelListing = null;
    // called just before the Controller is deleted from memory
    super.onClose();
  }
}

//backup
//
// class SponsorsDetailsScreen extends StatelessWidget {
//   final SponsorsDetailsScreenController controller = Get.put(SponsorsDetailsScreenController());
//   final ModelListing modelListing;
//   SponsorsDetailsScreen({Key key, this.modelListing}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     controller.modelListing = modelListing;
//     controller.callAPIListingViewByID();
//     return Scaffold(
//       // appBar: PreferredSize(
//       //     preferredSize: AppBarCustomRightIcon().preferredSize,
//       //     child: AppBarCustomRightIcon(
//       //       leftClicked: () {
//       //         print("close clicked");
//       //         Get.back();
//       //       },
//       //       title: 'Sponsors',
//       //     )),
//         appBar: AppBar(
//           centerTitle: true,
//           backgroundColor: Colors.white,
//           title: Text("Sponsors"),
//           elevation: 1,
//         ),
//         //SliderNewsDetails(modelNews: modelNews,),
//         body: ListView(children: [
//           FadeInImage(
//               fit: BoxFit.cover,
//               height: 230,
//               width: Get.width,
//               image: ResizeImage(
//                 CachedNetworkImageProvider(
//                   modelListing.primaryPhoto,
//                 ),
//                 width: Get.width.toInt(),
//               ),
//               placeholder: AssetImage(Strings.placeHolderImage),
//               // placeholder image until finish loading
//               imageErrorBuilder: (context, error, st) {
//                 return Text(error.toString());
//               }),
//           Padding(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: Config.kDefaultPadding * 2),
//             child: Container(
//               height: 100,
//               // color: Colors.red,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   CircleAvatar(
//                     radius: 40.0,
//                     backgroundImage:
//                     NetworkImage(modelListing.vendorInfo.company_logo ?? ""), // imgProfile=> company_logo
//                     backgroundColor: Colors.transparent,
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             modelListing.vendorInfo?.company ?? "", //vendorName => company
//                             style: Styles.mclub_Tilte,
//                           ),
//                           Text(
//                             'Approved Sponser Since ${modelListing.vendorInfo?.approvedAt ?? ""}',
//                             style: Styles.mclub_smallText,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       print('location tapped');
//                       displayModalBottomSheet(context);
//                     },
//                     child: ImageIcon(
//                       AssetImage("assets/images/location.png"),
//                       size: 30,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       print('phone tapped');
//                       controller._makePhoneCall();
//                     },
//                     child: ImageIcon(
//                       AssetImage("assets/images/phone.png"),
//                       size: 30,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             padding:
//             EdgeInsets.symmetric(horizontal: Config.kDefaultPadding * 2),
//             color: Colors.white,
//             child: Column(
//               // mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding:
//                   EdgeInsets.symmetric(vertical: Config.kDefaultPadding),
//                   child: Text(
//                     modelListing.title ?? "",
//                     style: Styles.mclub_Tilte,
//                   ),
//                 ),
//                 Padding(
//                   padding:
//                   const EdgeInsets.only(bottom: Config.kDefaultPadding),
//                   child: Text(
//                     modelListing.content ?? "",
//                     style: Styles.mclub_smallText,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Obx(() {
//             return controller.isDone.value ? SliderSponsor(
//               modelListings: controller.modelListingDetailsByIDResult.value.related,
//               didTap: (itemTapped) {
//                 print('itemTapped newsId ${itemTapped.listingId}');
//                 Route route = MaterialPageRoute(builder: (context) => SponsorsDetailsScreen(modelListing: itemTapped));
//                 Navigator.of(context).pushReplacement(route);
//               },
//             ) : Center(child: CircularProgressIndicator(),);
//           }
//           ),
//         ]));
//   }
//   //functions
//   // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   void displayModalBottomSheet(context) {
//     var address = modelListing.vendorInfo?.add1 ?? "";
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext bc) {
//           return Container(
//             child: Wrap(
//               alignment: WrapAlignment.center,
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Text(address, textAlign: TextAlign.center,),
//                 ),
//                 Divider(),
//
//                 ListTile(
//                     leading: new Icon(Icons.map),
//                     title: new Text('Open in Maps'),
//                     onTap: () {
//                       Get.back();
//                       openMapsSheet(context);
//                     }),
//                 Divider(),
//                 ListTile(
//                   leading: new Icon(Icons.copy),
//                   title: new Text('Copy'),
//                   onTap: () {
//                     Get.back();
//                     Clipboard.setData(new ClipboardData(
//                         text: address));
//                     Get.snackbar('Address', 'Copied');
//                   },
//                 ),
//               ],
//             ),
//           );
//         }
//     );
//   }
//
//   openMapsSheet(context) async {
//     //lat long
//     var nameVendor = modelListing.vendorInfo.company ?? "";// vendorName => company
//     var lat = double.parse(modelListing.vendorInfo.latitude ?? "0");
//     var long = double.parse(modelListing.vendorInfo.longitude ?? "0");
//     try {
//       final coords = Coords(lat, long);
//       final title = nameVendor;
//       final availableMaps = await MapLauncher.installedMaps;
//
//       showModalBottomSheet(
//         context: context,
//         builder: (BuildContext context) {
//           return SafeArea(
//             child: SingleChildScrollView(
//               child: Container(
//                 child: Wrap(
//                   children: <Widget>[
//                     for (var map in availableMaps)
//                       ListTile(
//                         onTap: () => map.showMarker(
//                           coords: coords,
//                           title: title,
//                         ),
//                         title: Text(map.mapName),
//                         leading: Icon(Icons.map),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     } catch (e) {
//       print(e);
//     }
//   }
//
//
//
//
// }
//
// class SponsorsDetailsScreenController extends GetxController {
//
//   ModelListing modelListing;
//   var modelListingDetailsByIDResult = ModelListingDetailsByIDResult().obs;
//   var isDone = false.obs;
//   @override
//   void onInit() {
//     super.onInit();
//   }
//
//
//   callAPIListingViewByID() async {
//     print("start callAPIListingViewByID");
//     var network = NetworkAPI(
//         endpoint: url_listing_by_id,
//         jsonQuery: {"listing_id": modelListing.listingId,"access-token": await Session.shared.getToken()});
//     var jsonBody = await network.callAPI(method: "GET", showLog: true);
//     if (jsonBody["code"] == 100) {
//       print("callAPIListingViewByID OK");
//       modelListingDetailsByIDResult.value = ModelListingDetailsByIDResult.fromJson(jsonBody);
//       isDone.value = true;
//     } else {
//       Session.shared.showAlertPopupOneButtonWithCallback(
//           content: jsonBody["message"] ?? "");
//     }
//   }
//
//   _makePhoneCall() async {
//     var code = modelListing.vendorInfo.mobileCode ?? "";
//     var number = modelListing.vendorInfo.mobile ?? "";
//     var fullNumberFormakeCall = 'tel:$code$number';
//     if (await canLaunch(fullNumberFormakeCall)) {
//       await launch(fullNumberFormakeCall);
//     } else {
//       throw 'Could not launch $fullNumberFormakeCall';
//     }
//   }
//
//   @override
//   void onClose() {
//     // modelListing = null;
//     // called just before the Controller is deleted from memory
//     super.onClose();
//   }
// }

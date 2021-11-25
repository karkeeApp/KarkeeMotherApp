
import 'package:carkee/config/singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:carkee/components/network_api.dart';
import 'package:carkee/components/slider_guestscreen.dart';

import 'package:carkee/config/app_configs.dart';
import 'package:carkee/models/ModelBannerResult.dart';
import 'package:carkee/models/ModelErrorJson.dart';
import 'package:carkee/models/ModelListingResult.dart';
import 'package:carkee/models/ModelNewsResult.dart';

import 'package:carkee/screen/screens.dart';

import 'package:carkee/screen/start_loading.dart';



class GuestScreenV2 extends StatefulWidget {

  @override
  _GuestScreenV2State createState() => _GuestScreenV2State();
}

class _GuestScreenV2State extends State<GuestScreenV2> {
  final GuestScreenV2Controller controller = Get.put(GuestScreenV2Controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => (controller.isDone_callAPIGetBanner.value)
            ? buildBody()
            : loadingView()
        )

    );
  }

  Widget buildBody() {
    print("🍊 GuestScreenV2 here");
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: StartLoading.getAssetImage(), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          SliderGuestScreen(modelGalleries: controller.modelBannerResult.value.data),
          SafeArea(
            child: Column(children: [
              SizedBox(height: 60,),
              Image.asset("assets/images/logo.png"),
              // SliderGuestScreen(modelGalleries: controller.modelBannerResult.value.data),
              Expanded(
                child: SizedBox(),
              ),
              getFooter(),
            ]),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: SafeArea(
              child: IconButton(onPressed: (){
                print("click cancel");
                Session.shared.changeRootViewToDashBoard();
              }, icon: Icon(Icons.close)),
            ),
          ),
        ],
      ),
      // children: [],
    );
  }

  Widget loadingView() {
    //return Center(child: CircularProgressIndicator());
    return Container(
      // color: Colors.red,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/launch_image.png"), fit: BoxFit.cover),
      ),
    );
  }


  getFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlackButton(
              callbackOnPress: () {
                Session.shared.changeRootViewChooseRegister();
              },
              title: 'Register Now'),
          SizedBox(height: 10,),

          WhiteButton(
              callbackOnPress: () {
                // Session.shared.changeRootViewToLogin();// no more change root view!. show popup!
                //LoginScreenV2
                showPopupLogin2();

              },
              title: 'Login'),
          SizedBox(height: 30,),
          // sectionGoLogin(),
        ],
      ),
    );
  }

  showPopupLogin2() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          // return Wrap(children: [LoginScreenV2()]);
          return LoginScreen();
        });
  }



  sectionGoLogin() {
    return GestureDetector(
        onTap: () {
          print("go login now");
          Session.shared.changeRootViewToLogin();
        },
        child: Container(
          // color: Colors.red,
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Already a member?"),
              Text.rich(TextSpan(
                text: ' Log In',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Config.secondColor),
                children: <InlineSpan>[
                  TextSpan(
                    text: ' now.',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                  )
                ],
              ))
            ],
          ),
        )
    );
  }
}

//final Controller _controller = Get.put(Controller());
//final Controller _controller = Get.find();
class GuestScreenV2Controller extends GetxController {
  var modelBannerResult = ModelBannerResult().obs;
  var isDone_callAPIGetBanner = false.obs;//temp always true
  @override
  void onInit() {
    callAPIGetBanner();
    super.onInit();

  }

  @override
  void onClose() {
    // called just before the Controller is deleted from memory
    super.onClose();
  }

  callAPIGetBanner() async {
    print("start callAPIGetListGuest");
    var network = NetworkAPI(
        endpoint: url_banner_list,
        jsonQuery: {"account_id": Session.shared.HASH_ID});
    var jsonRespondBody = await network.callAPIGET();
    // var jsonRespondBody = await network.callAPI(method: "GET");
    if (jsonRespondBody["code"] == 100) {
      print('jsonRespondBody $jsonRespondBody');
      var modelBannerResult = ModelBannerResult.fromJson(jsonRespondBody);
      this.modelBannerResult.value = modelBannerResult;
      // isDone_callAPIGetBanner.value = true;
      return jsonRespondBody; //must return after get done asynx
    } else {
      // Session.shared.showAlertPopupOneButtonWithCallback(
      //     content: jsonRespondBody["message"] ?? "", callback: (){
      //   callAPIGetBanner();
      // });
      // isDone_callAPIGetBanner.value = false;
    }
    isDone_callAPIGetBanner.value = true;
  }
}

class GuestScreenController extends GetxController {
  var modelNewsResult = ModelNewsResult().obs;
  var modeListingFeature = ModelListingResult().obs;
  var isDone_modelNewsResult = false.obs;
  var isDone_modeListingFeature = true.obs;//temp always true

  @override
  void onInit() {
    callAPIGetListGuest();
    // callAPIGetListtingFeature();//temp disable cause don't have this API on carkee
    super.onInit();
  }

  @override
  void onClose() {
    // called just before the Controller is deleted from memory
    super.onClose();
  }

  callAPIGetListGuest() async {
    print("start callAPIGetListGuest");
    var network = NetworkAPI(
        endpoint: url_news_guest,
        jsonQuery: {"account_id": Session.shared.HASH_ID});
    var jsonBody = await network.callAPIGET();
    if (jsonBody["code"] == 100) {
      print("callAPIGetListGuest OK");
      modelNewsResult.value = ModelNewsResult.fromJson(jsonBody);
      isDone_modelNewsResult.value = true;
    } else {
      var modelErrorJson = ModelErrorJson.fromJson(jsonBody);
      Session.shared.showAlertPopupOneButtonWithCallback(
          content: modelErrorJson.getMessage());
    }
  }

  //callAPIGetListtingFeature
  callAPIGetListtingFeature() async {
    print("start callAPIGetListtingFeature");
    var network = NetworkAPI(
        endpoint: url_listing_featured,
        jsonQuery: {"account_id": Session.shared.HASH_ID});
    var jsonBody = await network.callAPIGET();
    if (jsonBody["code"] == 100) {
      print("callAPIGetListtingFeature OK");
      modeListingFeature.value = ModelListingResult.fromJson(jsonBody);
      isDone_modeListingFeature.value = true;
    } else {
      print("callAPIGetListtingFeature false");
      var modelErrorJson = ModelErrorJson.fromJson(jsonBody);
      Session.shared.showAlertPopupOneButtonWithCallback(
          content: modelErrorJson.getMessage());
    }
  }
}

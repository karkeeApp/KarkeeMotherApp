import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/components/sliders_gallery.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/models/ModelBannerResult.dart';
import 'package:carkee/screen/register_screen_company.dart';
import 'package:carkee/screen/screens.dart';

class ChooseTypeRegisterScreen extends StatefulWidget {
  @override
  _ChooseTypeRegisterScreenState createState() =>
      _ChooseTypeRegisterScreenState();
}

class _ChooseTypeRegisterScreenState extends State<ChooseTypeRegisterScreen> {
  ModelBannerResult modelBannerResult;
  var currentIndex = 0;
  var seletedCompany = false;
  var seletedPersonal = false;
  goRegisterPersonal(){
    // Get.offAll(() =>RegisterScreen());
    showRegisterScreen();
  }
  goRegisterCompany(){
    // Get.offAll(() =>RegisterScreenCompany());
    showRegisterCompanyScreen();
  }

  showRegisterScreen() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          // return Wrap(children: [LoginScreenV2()]);
          return RegisterScreen();
        });
  }
  showRegisterCompanyScreen() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          // return Wrap(children: [LoginScreenV2()]);
          return RegisterScreenCompany();
        });
  }


  Future callAPIGetBanner() async {
    print("start callAPIGetBanner");
    var network = NetworkAPI(
        endpoint: url_banner_list,
        jsonQuery: {"account_id": Session.shared.HASH_ID});
    var jsonRespondBody = await network.callAPIGET();
    if (jsonRespondBody["code"] == 100) {
      // print('jsonRespondBody $jsonRespondBody');
      var modelBannerResult = ModelBannerResult.fromJson(jsonRespondBody);
      this.modelBannerResult = modelBannerResult;
      return jsonRespondBody; //must return after get done asynx
    } else {
      Session.shared.showAlertPopupOneButtonWithCallback(
          content: jsonRespondBody["message"] ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild item');
    return Scaffold(
        // appBar: PreferredSize(
        //     preferredSize: AppBarCustomRightIcon().preferredSize,
        //     child: AppBarRightX(
        //       closeClicked: () {
        //         print("close clicked");
        //         Session.shared.changeRootViewToGuest();
        //       },
        //       title: '',
        //       subTitle: '',
        //     )
        // ),
          body: buildBodyContainer()
    );
  }

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    currentIndex = index;
    print('currentIndex $currentIndex');
  }

  Container buildBodyContainer() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/guest_bg.png"),
            fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 50,),
          Text(
            '\nWELCOME TO\n',
            style: Styles.mclub_UPCASETilte,
          ),
          Image.asset(
            "assets/images/logo.png",
            // width: 100,

            // fit: BoxFit.fitWidth,
          ),
          Spacer(),
          // Obx(() => Text("Data after get1 : ${_controller.modelBannerResult.value.code}")),
          Container(
            padding: EdgeInsets.all(Config.kDefaultPadding),
            child: Column(
              children: [
                SeletedButton(
                  isSelectedButton: seletedCompany,
                  title: "Join as a vendor / sponsor",
                  onpress: () {
                    setState(() {
                      print("clicked me ");
                      seletedCompany = true;
                      seletedPersonal = false;
                    });
                  },
                ),
                SizedBox(height: 20,),
                SeletedButton(
                  isSelectedButton: seletedPersonal,
                  title: "Join as an individual",
                  onpress: () {
                    setState(() {
                      print("clicked me ");
                      seletedCompany = false;
                      seletedPersonal = true;
                    });
                  },
                ),
                SizedBox(height: 80,),
                Row(
                  children: [
                    BackBlackButton(callbackOnPress: (){
                      print("back clicked");
                      Get.back();
                    }, title: "   Back  "),
                    Spacer(),
                    NextBlackButton(callbackOnPress: (){
                      print("next clicked, check selected and go");
                      if (seletedCompany) {
                        goRegisterCompany();
                      } else if (seletedPersonal){
                        goRegisterPersonal();
                      }
                    }, title: "  Next   ")
                  ],
                ),
                SizedBox(height: 50,),


              ],
            ),
          )
        ],
      ),
    );
  }
}

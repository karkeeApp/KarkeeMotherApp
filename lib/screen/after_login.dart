import 'package:carkee/screen/renew_membership_screen.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/controllers/main_tab_bar_controller.dart';
import 'package:carkee/screen/screens.dart';
import 'package:carkee/screen/update_part1_company.dart';
import 'package:carkee/screen/update_part1_personal.dart';
import 'package:carkee/screen/update_part2_company.dart';
import 'package:carkee/screen/update_part2_personal.dart';
import 'package:carkee/screen/update_part3_company.dart';
import 'package:carkee/screen/update_part3_personal.dart';

import 'start_loading.dart';
import 'welcome_screen_company.dart';

class AfterLoginScreen extends StatefulWidget {
  @override
  _AfterLoginScreenState createState() => _AfterLoginScreenState();
}

class _AfterLoginScreenState extends State<AfterLoginScreen> {
  // final afterLoginController = Get.put(AfterLoginController());
  final profileController = Get.put(ProfileController(), permanent: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FocusDetector(
        onFocusLost: () {
          logger.i(
            'Focus Lost.'
            '\nTriggered when either [onVisibilityLost] or [onForegroundLost] '
            'is called.'
            '\nEquivalent to onPause() on Android or viewDidDisappear() on iOS.',
          );
        },
        onFocusGained: () {
          logger.i(
            'Focus Gained.'
            '\nTriggered when either [onVisibilityGained] or [onForegroundGained] '
            'is called.'
            '\nEquivalent to onResume() on Android or viewDidAppear() on iOS.',
          );
          callAPIProfile();
        },
        onVisibilityLost: () {
          logger.i(
            'Visibility Lost.'
            '\nIt means the widget is no longer visible within your app.',
          );
        },
        onVisibilityGained: () {
          logger.i(
            'Visibility Gained.'
            '\nIt means the widget is now visible within your app.',
          );
        },
        onForegroundLost: () {
          logger.i(
            'Foreground Lost.'
            '\nIt means, for example, that the user sent your app to the '
            'background by opening another app or turned off the device\'s '
            'screen while your widget was visible.',
          );
        },
        onForegroundGained: () {
          logger.i(
            'Foreground Gained.'
            '\nIt means, for example, that the user switched back to your app '
            'or turned the device\'s screen back on while your widget was visible.',
          );
        },
        child: Material(
          color: Colors.white,
          child: Session.shared.getCenterLoadingIcon(),
        ),
      );

  callAPIProfile() async {
    await profileController.callAPIGetProfile();
    // profileController.userProfile.value;
    checkWhereToGo(); //make sure after profileController completed
  }

  checkWhereToGo() {
    print("checkWhereToGo");
    var currentStep = profileController.getProfileStep();
    if (currentStep == null) {
      print("something wrong~~~");
    } else {
      if (profileController.getIsCompany()) {
        print("companyGo");
        companyGo();
      } else {
        print("memberGo");
        memberGo();
      }
    }
  }

  memberGo() {
    var currentStep = profileController.getProfileStep();
    print("You are member only $currentStep");
    switch (currentStep) {
      case '1':
        {
          print('step1');
          Get.offAll(() => UpdatePart1Screen());
        }
        break;
      case '2':
        {
          //UpdatePart2Screen
          Get.offAll(() => UpdatePart2Screen());
          print('step2');
        }
        break;
      case '3':
        {
          Get.offAll(() => UpdatePart3Screen());
          print('step3');
        }
        break;
      case '4':
        {
          Get.offAll(() => UpdatePart4Screen());
          print('step4');
        }
        break;
      case '5':
        {
          Get.offAll(() => UpdatePart5Screen());
          print('step5');
        }
        break;
      default:
        {
          // Get.offAll(() =>UpdatePart5Screen());//fake to test
          // Session.shared.changeRootViewToDashBoard();
          // print('dashboard last');
          //step 6 chi~ la 1 la het han, sap het han hoac  la di tiep thoi^
          print("🌱 IsExpire : ${profileController.isExpire()}");
          print("🌱 isNearby : ${profileController.isNearbyExpire()}");
          //profileController.userProfile.value.status == "5" tức là đã submit 1 lần
          if (profileController.isExpire()) {
            print("ban da het han, can phan den trang gia han 1 nut OK!!");
            // 1 nut di thang renew!
            if (profileController.userProfile.value.status == "5") {
              print("đã gửi data gia hạn thì cho vào app luôn");
              Session.shared.changeRootViewToDashBoard();
            } else {
              print("chưa gửi renew gia hạn");
              Session.shared.showAlertPopupOneButtonWithCallback(
                  title: profileController.userProfile.value.headerTitle
                      .toString(),
                  content: profileController.userProfile.value.messageBody
                      .toString(),
                  callback: () {
                    print("ban da het han, can phan den trang gia han!");
                    Get.offAll(() => RenewMembershipScreen());
                  });
            }
          } else if (profileController.isNearbyExpire()) {
            print(
                "ban da SAP HET HAN , can phan den trang gia han hoac la KHong can den' 2 nut");
            //check if da gia han thi` ko can nua~
            if (profileController.userProfile.value.status == "5") {
              print("đã gửi data gia hạn thì cho vào app luôn");
              Session.shared.changeRootViewToDashBoard();
            } else {
              print("chưa gửi renew gia hạn thi` show goi y'");
              Session.shared.showAlertPopup2ButtonWithCallbackFullCustom(
                  titleButtonLeft: "Renew Now",
                  titleButtonRight: "Renew Later",
                  title: profileController.userProfile.value.headerTitle
                      .toString(),
                  content: profileController.userProfile.value.messageBody
                      .toString(),
                  callbackLeft: () {
                    print("callbackLeft clicked, ");
                    Get.offAll(() => RenewMembershipScreen());
                  },
                  callbackRight: () {
                    print("callbackRight clicked, ");
                    Session.shared.changeRootViewToDashBoard();
                  });
            }
          } else {
            print("account OK di den dashboard thoi^ ");
            Session.shared.changeRootViewToDashBoard();
          }
        }
        break;
    }
  }

  companyGo() {
    var currentStep = profileController.getProfileStep();
    print("You are vendor only step $currentStep");
    switch (currentStep) {
      case '1':
        {
          print('step1 company');
          Get.off(() => UpdatePart1CompanyScreen());
        }
        break;
      case '2':
        {
          //UpdatePart2Screen
          Get.off(() => UpdatePart2CompanyScreen());
          print('step2 company');
        }
        break;
      // case '3':
      //   {
      //    Get.off(UpdatePart3CompanyScreen());
      //     print('step3 company');
      //   }
      //   break;
      default: //after step 2 is Done!
        {
          // Get.off(UpdatePart2CompanyScreen());
          Session.shared.changeRootViewToDashBoard();
          print('dashboard last');
        }

        break;
    }
  }

// @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     // body: null,
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Session.shared.getCenterLoadingIcon(),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
//
// class AfterLoginController extends GetxController {
//   // final profileController = Get.put(ProfileController(), permanent: true);
//   var modelProfile = ModelUserProfile().obs;
//   @override
//   void onInit() {
//     // called immediately after the widget is allocated memory
//     super.onInit();
//     //callAPIProfile();
//
//   }
//
//   @override
//   void onReady() {
//     // TODO: implement onReady
//     super.onReady();
//   }
//
//
//
//   @override
//   void onClose() {
//     // called just before the Controller is deleted from memory
//     super.onClose();
//   }
// }

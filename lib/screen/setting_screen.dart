import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart' as Dioo;
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:carkee/components/item_menu_setting.dart';
import 'package:carkee/components/network_api.dart';

import 'package:carkee/config/app_configs.dart';
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/screen/screens.dart';
import 'package:carkee/screen/update_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  List<BiometricType> _availableBiometrics;
  bool _isProtectionEnabled = false;
  bool _isDeviceEnroll = false;

  var currentPassword = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkBiometrics();
    _checkIsProtectionEnabled();
  }

  final ProfileController profileController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //     preferredSize: AppBarCustomRightIcon().preferredSize,
      //     child: AppBarCustomRightIcon(
      //       leftClicked: () {
      //         print("close clicked");
      //         Get.back();
      //       },
      //       title: 'Settings',
      //     )),

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("Settings", style: Styles.mclub_Tilte),
        elevation: 1,
      ),
      //SliderNewsDetails(modelNews: modelNews,),
      body: Stack(children: [
        buildBODY_Obx(),
        Positioned(
          bottom: 0,right: 0,left: 0,
          child: Padding(
            padding: const EdgeInsets.all(Config.kDefaultPadding * 2),
            child: PrimaryButton(
                callbackOnPress: () {
                  print('logout');
                  Session.shared.logout();
                  Session.shared.changeRootViewToGuest();
                },
                title: 'Log Out'),
          ),
        ),
      ]),
      // body: SingleChildScrollView(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       buildBODY_Obx(),
      //       // Spacer(),
      //       Expanded(
      //
      //         child: Column(
      //           children: [
      //             // Spacer(),
      //             Padding(
      //               padding: const EdgeInsets.all(Config.kDefaultPadding * 2),
      //               child: PrimaryButton(
      //                   callbackOnPress: () {
      //                     print('logout');
      //                     Session.shared.logout();
      //                     Session.shared.changeRootViewToGuest();
      //                   },
      //                   title: 'Log Out'),
      //             ),
      //           ],
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }

  Obx buildBODY_Obx() {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(Config.kDefaultPadding * 2),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Allow Bio Log In',
                                  style: Styles.mclub_Tilte),
                              Wrap(children: [
                                Text(
                                    'All biometrics IDs stored on this device can be used for logging in to you account',
                                    style: Styles.mclub_normalBodyText)
                              ]),
                            ],
                          ),
                        ),
                        CupertinoSwitch(
                          value: _isProtectionEnabled,
                          onChanged: (bool value) {
                            // setState(() {
                            //   _isProtectionEnabled = value;
                            // });
                            print("_isDeviceEnroll $_isDeviceEnroll");
                            print("_canCheckBiometrics $_canCheckBiometrics");
                            print("_isProtectionEnabled $_isProtectionEnabled");
                            _authenticate();
                            print('clicked $value');
                          },
                        ),
                      ],
                    ),
                    MenuItemSetting(
                        title: 'Change Password',
                        onpress: () {
                          print('clicked Change Password');
                          Get.to(() => UpdatePasswordScreen());
                        }),
                    profileController.getIsCompany()
                        ? SizedBox()
                        : MenuItemSetting(
                            title: 'Update Vehicle',
                            onpress: () {
                              print('clicked Update Vehicle');
                              Get.to(() => UpdateVehicleScreen());
                            }),
                    profileController.getIsCompany()
                        ? MenuItemSetting(
                            title: 'Change PIN',
                            onpress: () {
                              print('clicked Change PIN');
                              Get.to(() => UpdatePINScreen());
                            })
                        : SizedBox(),
                    MenuItemSetting(
                        title: 'Contact',
                        subTitle: '${profileController.getFullMobile()}',
                        onpress: () {
                          print('clicked Contact');
                          //MenuItemSetting
                          Get.to(() => UpdatePhoneScreen());
                        }),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  _checkIsProtectionEnabled() {
    print("_checkIsProtectionEnabled");
    setState(() {
      _isProtectionEnabled = Session.shared.box.hasData('loginbio');
    });

    print("_checkIsProtectionEnabled $_isProtectionEnabled");
    // if (_isProtectionEnabled) {//if have login bio show ask bio right now!
    //   _authenticate();
    // }
  }

  _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      print("canCheckBiometrics $canCheckBiometrics");
      setState(() {
        _canCheckBiometrics = canCheckBiometrics;
      });
      _getAvailableBiometrics();
    } on PlatformException catch (e) {
      print("device mounted error $e");
      Session.shared.showAlertPopupOneButtonNoCallBack(content: e.message);
      // print(e);
    }
    print("something here true continue");
    if (!mounted) return;
    print("mounted true continue");
  }

  _getAvailableBiometrics() async {
    print("start _getAvailableBiometrics");
    if (_canCheckBiometrics) {
      print("start _getAvailableBiometrics _canCheckBiometrics");
      List<BiometricType> availableBiometrics;
      try {
        availableBiometrics = await auth.getAvailableBiometrics();

        if (Platform.isIOS) {
          if (availableBiometrics.contains(BiometricType.face)) {
            // Face ID. icon
            setState(() {
              _isDeviceEnroll = true;
              _availableBiometrics = availableBiometrics;
            });
          } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
            // Touch ID.
            setState(() {
              _isDeviceEnroll = true;
              _availableBiometrics = availableBiometrics;
            });
          }
        } else {
          //Android
          print(
              "this device is Android and availableBiometrics is: $availableBiometrics");
          //this device is Android and availableBiometrics is: [BiometricType.fingerprint]
          if (availableBiometrics.contains(BiometricType.fingerprint)) {
            // Touch ID.
            setState(() {
              _isDeviceEnroll = true;
              _availableBiometrics = availableBiometrics;
            });
          }
        }
      } on PlatformException catch (e) {
        print("error $e");
        print(e);
      }
      if (!mounted) return;
    }
  }

  _authenticate() async {
    print("start check bio from system");
    bool authenticated = false;
    try {
      // setState(() {
      //   _isAuthenticating = true;
      // });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason:
              'Scan your fingerprint or use your Face ID for a faster log in the next time you come back',
          useErrorDialogs: GetPlatform.isIOS ? true : false,
          stickyAuth: GetPlatform.isIOS ? true : false);
    } on PlatformException catch (e) {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "PlatformException",
          content:
              'Authentication could not start, because biometric authentication is not enrolled');
    }
    if (!mounted) return;
    //handle continue after authen,
    if (authenticated) {
      print("authen success");
      print(
          "current is $_isProtectionEnabled after authen OK will be ${!_isProtectionEnabled}");
      if (authenticated) {
        if (_isProtectionEnabled) {
          handleForInActiveBio(); //if _isProtectionEnabled current TRue => then set false and clear biologin

        } else {
          //if _isProtectionEnabled = false then set it handle call API if success then will set to true
          _showDialoghandleForActiveBio();
        }
        //after change state need action
      }
    }
  }

  _showDialoghandleForActiveBio() {
    var scrollController = ScrollController();
    var actionScrollController = ScrollController();
    var dia = CupertinoAlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text("Please verify with your account password"),
      ),
      content: CupertinoTextField(
        obscureText: true,
        onChanged: (value) {
          currentPassword = value;
        },
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          isDefaultAction: false,
          isDestructiveAction: false,
        ),
        CupertinoDialogAction(
          child: Text("Confirm"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            callAPI();
          },
          isDefaultAction: true,
          isDestructiveAction: false,
        ),
      ],
      scrollController: scrollController,
      actionScrollController: actionScrollController,
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return dia;
        });
    Session.shared
        .saveEmailForBioLogin(profileController.userProfile.value.email);
  }

  handleForInActiveBio() {
    setState(() {
      _isProtectionEnabled = false;
    });
    Session.shared.clearEmailForBioLogin();
  }

  callAPI() async {
    Session.shared.showLoading();
    print("start callAPI verify password");
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      "password": currentPassword,
    });
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(
        endpoint: url_member_verify_password,
        formData: formData,
        jsonQuery: jsonQuery);
    var jsonBody = await network.callAPIPOST();
    Session.shared.hideLoading();
    if (jsonBody["code"] == 100) {
      //after verify then save email for biologin
      setState(() {
        _isProtectionEnabled = true;
      });
      Session.shared
          .saveEmailForBioLogin(profileController.userProfile.value.email);
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }
}

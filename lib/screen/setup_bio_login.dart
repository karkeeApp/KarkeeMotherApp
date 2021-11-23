import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:carkee/components/PrimaryButton.dart';
import 'package:carkee/components/alertbox_custom.dart';
import 'package:carkee/components/testbox.dart';
import 'package:carkee/config/app_configs.dart';

class SetupBioLogin extends StatefulWidget {
  @override
  _SetupBioLoginState createState() => _SetupBioLoginState();
}

class _SetupBioLoginState extends State<SetupBioLogin> {
  //bio section
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  bool isFaceIDSupport = true;
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
            // Face ID.

            setState(() {
              isFaceIDSupport = true;
              _des =
              "Use your Face ID for a faster log in the next time you come back";
              _titleButton = "Allow quick log in with Face ID";
            });
          } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
            // Touch ID.
            setState(() {
              isFaceIDSupport = false;
              _des =
              "Use your Touch ID for a faster log in the next time you come back";
              _titleButton = "Allow quick log in with Touch ID";
            });
          }
        } else { //Android
          // Touch ID.for Android
          setState(() {
            isFaceIDSupport = true;
            _des =
            "Use your Touch ID for a faster log in the next time you come back";
            _titleButton = "Allow quick log in with Touch ID";
          });
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
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint or use your Face ID for a faster log in the next time you come back',
          useErrorDialogs: GetPlatform.isIOS ? true : false,
          stickyAuth: GetPlatform.isIOS ? true : false);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      _cancelAuthentication();
      userCancelAuthenBio(title: 'Authentication could not start, because biometric authentication is not enrolled');

    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
    //handle continue after authen,
    if (_authorized == 'Authorized') {
      print("authen success");
      getTextStatus(); //update UI text
      var emailFromLogin = Get.arguments;
      print("emailFromLogin:$emailFromLogin");
      Session.shared.saveEmailForBioLogin(emailFromLogin);
    }
  }

  void _cancelAuthentication() {
    auth.stopAuthentication();
  }

  var _isLoading = false;
  var _status = "";
  var _titleButton =
      "Allow quick log in with Face ID"; //Allow quick log in with Touch ID
  var _des =
      "Use your Face ID for a faster log in the next time you come back"; //"Use your Touch ID for a faster log in the next time you come back"

  var isShowCloseIcon = true;
  userCancelAuthenBio({String title = ""}) {
    //set skip value dot ask nexttime!
    Session.shared.box.write('skipBio',true);
    Get.dialog(
      AlertPopupOneButton(
          callbackAfterPressOK: () {
            Session.shared.changeRootViewAfterLogin();
          },
          title: title,
          content:
              "No worries! If you've changed your mind, you can turn it on anytime you want which can be found in the settings!"),
    );
  }


  isAuthorized() {
    return (_authorized == 'Authorized');
  }

  Widget getIcon() {
    //this fot IOS
    if (Platform.isIOS) {
      if (!isFaceIDSupport && isAuthorized()) {
        return Image.asset('assets/images/TouchIDChecked.png');
      } else if (!isFaceIDSupport && !isAuthorized()) {
        return Image.asset('assets/images/TouchIDActive.png');
      } else if (isFaceIDSupport && isAuthorized()) {
        return Image.asset('assets/images/faceIDChecked.png');
      } else if (isFaceIDSupport && !isAuthorized()) {
        return Image.asset('assets/images/faceIDLogin.png');
      } else {
        print("error undefine case");
        return Image.asset('assets/images/TouchIDActive.png');
      }
    } else {//this is for Android
      return Image.asset('assets/images/TouchIDActive.png');
    }

  }

  getTextStatus() {
    if (Platform.isIOS) {
      if (!isFaceIDSupport && isAuthorized()) {
        setState(() {
          _status = "Touch ID set up successfully!";
          _des =
          "You can now log in using Touch ID for an easier and quicker access";
          _titleButton = "Start exploring";
          isShowCloseIcon = false;
        });
      }
      if (isFaceIDSupport && isAuthorized()) {
        setState(() {
          _status = "Face ID set up successfully!";
          _des =
          "You can now log in using Face ID for an easier and quicker access";
          _titleButton = "Start exploring";
          isShowCloseIcon = false;
        });
      }
    } else {
      setState(() {
        _status = "Touch ID set up successfully!";
        _des =
        "You can now log in using Touch ID for an easier and quicker access";
        _titleButton = "Start exploring";
        isShowCloseIcon = false;
      });
    }
  }
  confirmButtonClicked() {
    if (!isShowCloseIcon) {
      print("did authen go dashboard");
      Session.shared.changeRootViewAfterLogin();
    } else {
      print("not yet authen go show authen system _authenticate");
      // _authenticate();
      _isAuthenticating ? _cancelAuthentication() : _authenticate();
    }
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    _checkBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild ");

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // title: Text('SetupBioLogin'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            isShowCloseIcon
                ? IconButton(
                    // padding: EdgeInsets.only(left: 10),
                    onPressed: () {
                      print("close clicked");
                      userCancelAuthenBio();
                    },
                    icon: Icon(Icons.close),
                    iconSize: 30,
                    color: Colors.black,
                  )
                : Session.shared.EmptyBox()
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(Config.kDefaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text('Can check biometrics: $_canCheckBiometrics\n'),
              // Text('Available biometrics check: $_availableBiometrics\n'),
              // Text('Current State: $_authorized\n'),
              // Text(_isAuthenticating ? 'Cancel' : 'Authenticate'),
              getIcon(),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: Config.kDefaultPadding),
                child: Text(_status, textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: Config.kDefaultPadding),
                child: Text(_des, textAlign: TextAlign.center),
              ),
              PrimaryButton(
                  callbackOnPress: () {
                    print("PrimaryButton click go function confirmButtonClicked");
                    confirmButtonClicked();
                  },
                  title: _titleButton,
                  isLoading: _isLoading),
              // RaisedButton(
              //   child: const Text('Check biometrics'),
              //   onPressed: _checkBiometrics,
              // ),
              // RaisedButton(
              //   child: const Text('Get available biometrics'),
              //   onPressed: _getAvailableBiometrics,
              // ),
            ],
          ),
        ));
  }
}

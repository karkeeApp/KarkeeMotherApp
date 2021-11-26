import 'dart:convert';
import 'dart:io';
// import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:carkee/models/ModelLoginSocialResult.dart';
import 'package:carkee/screen/choose_register_screen.dart';
import 'package:dio/dio.dart' as Dioo;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:carkee/components/PrimaryButton.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import '../components/TextFieldPhungNoBorder.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:get/get.dart';
import 'package:carkee/config/strings.dart';
import 'package:carkee/screen/screens.dart';
import 'package:carkee/screen/start_loading.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  BuildContext c;
  var isChecked = false.obs;
  String udid = "";
  // String email = "";
  // String password = "";
  final key = GlobalKey<FormState>();
  TextEditingController email_controller = TextEditingController();
  TextEditingController pass_controller = TextEditingController();

  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  List<BiometricType> _availableBiometrics;
  bool _isProtectionEnabled = false;
  bool _isDeviceEnroll = false;
  var _isAvailebleAppleIDLogin = false.obs;

  // var accountTypeController = TextEditingController();
  // _showPickerModal(BuildContext context) {
  //   Picker(
  //       adapter: PickerDataAdapter<String>(
  //           pickerdata: Session.shared.accounts.map((e) => e.value).toList()),
  //       changeToFirst: true,
  //       hideHeader: false,
  //       selectedTextStyle: TextStyle(color: Config.secondColor),
  //       onConfirm: (Picker picker, List value) {
  //         var valueString = Session.shared.accounts[value.first].value;
  //         accountTypeController.text = valueString;
  //       }).showModal(context); //_scaffoldKey.currentState);
  // }
  // bool _isAuthenticating = false;

  Padding buildLoginForm(BuildContext context) {
    this.c = context;
    return Padding(
      padding: const EdgeInsets.only(
          left: Config.kDefaultPadding * 2,
          right: Config.kDefaultPadding * 2,
          bottom: Config.kDefaultPadding * 2),
      child: Column(
        children: [
          Form(
            key: key,
            // initialValue: {'email': email, 'password': password},
            child: Column(
              children: [
                TextFieldPhungNoBorder(
                  controller: email_controller,
                  labelText: "Email",
                  hintText: "",
                  onChange: (value) {
                    print(value);
                    email_controller.text = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  notAllowEmpty: true,
                  requiredEmail: true,
                ),
                TextFieldPhungNoBorder(
                  controller: pass_controller,
                  labelText: "Password",
                  hintText: "",
                  onChange: (value) {
                    print(value);
                    pass_controller.text = value;
                  },
                  isPassword: true,
                  notAllowEmpty: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Config.kDefaultPadding * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Text("Forgot password?"),
                        onTap: () {
                          print("go forgot password");
                          Get.to(() => ForgotPasswordScreen());
                        },
                      ),
                      (_isDeviceEnroll && _isProtectionEnabled)
                          ? BioIcon()
                          : SizedBox()
                    ],
                  ),
                ),

                //remeber me checkbox
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Obx(() => Checkbox(
                        activeColor: Config.secondColor,
                        value: isChecked.value,
                        onChanged: (value) {
                          isChecked.value = !isChecked.value;

                          Session.shared.box.write(Strings.rememberme, isChecked.value);

                          print(value);
                        },
                      )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(children: [
                        Text("Remember me"),
                      ]
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          BlackButton(
            callbackOnPress: () {
              if (key.currentState.validate()) {
                print("call API here ");
                callAPILogin();
              } else {
                print('validation failed');
              }
            },
            title: "Log In",
          ),
          Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 50,
                child: SignInButton(
                  Buttons.GoogleDark,
                  onPressed: loginGoogle,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                    // side: BorderSide(color: Colors.red)
                  ),
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(
                height: 50,
                child: SignInButton(
                  Buttons.Facebook,
                  onPressed: loginFacebook,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                    // side: BorderSide(color: Colors.red)
                  ),
                ),
              ),

              SizedBox(height: 10,),
              //Apple
              Obx(() {
                return _isAvailebleAppleIDLogin.value
                    ? SizedBox(
                  height: 50,
                      child: SignInButton(
                          Buttons.AppleDark,
                          onPressed: loginApple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            // side: BorderSide(color: Colors.red)
                          ),
                        ),
                    )
                    : SizedBox();
              }),
            ],
          ),

          // sectionGoRegister()
        ],
      ),
    );
  }

  ///Unhandled Exception: SignInWithAppleAuthorizationError(AuthorizationErrorCode.unknown, The operation couldn’t be completed. (com.apple.AuthenticationServices.AuthorizationError error 1000
  ///fix error 1000. run on real device! will fixed it

  //https://codewithandrea.com/videos/apple-sign-in-flutter-firebase/
  Future loginApple() async {
    final AuthorizationResult result = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    print(result);
    switch (result.status) {
      case AuthorizationStatus.authorized:
      // Store user ID
        var user = result.credential.user;
        print(user);

        final appleIdCredential = result.credential;
        var accessToken =
        String.fromCharCodes(appleIdCredential.authorizationCode);
        var idToken = String.fromCharCodes(result.credential.identityToken);
        var fullname = appleIdCredential.fullName.familyName;
        var email = appleIdCredential.email;
        print("accessToken $accessToken");
        print("idToken $idToken");
        print("fullname $fullname");
        print("email $email");

        callAPI_LoginSocial(idToken, 3);
        break;

      case AuthorizationStatus.error:
        print("Sign in failed: ${result.error.localizedDescription}");
        EasyLoading.showError("Sign in failed");
        break;

      case AuthorizationStatus.cancelled:
        print('User cancelled');
        EasyLoading.showError("User cancelled");
        break;
    }
    //OLD
    // if (await AppleSignIn.isAvailable()) {
    //   final AuthorizationResult result = await AppleSignIn.performRequests([
    //     AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    //   ]);
    //   switch (result.status) {
    //     case AuthorizationStatus.authorized:
    //
    //       // Store user ID
    //       //   await FlutterSecureStorage()
    //       //       .write(key: "userId", value: result.credential.user);
    //
    //       var user = result.credential.user;
    //       print(user);
    //
    //       final appleIdCredential = result.credential;
    //       var accessToken =
    //           String.fromCharCodes(appleIdCredential.authorizationCode);
    //       var idToken = String.fromCharCodes(result.credential.identityToken);
    //       var fullname = appleIdCredential.fullName.familyName;
    //       var email = appleIdCredential.email;
    //       print("accessToken $accessToken");
    //       print("idToken $idToken");
    //       print("fullname $fullname");
    //       print("email $email");
    //
    //       callAPI_LoginSocial(idToken, 3);
    //       //idToken
    //
    //       // final oAuthProvider = OAuthProvider('apple.com');
    //       // final credential = oAuthProvider.credential(
    //       //   idToken: String.fromCharCodes(result.credential.identityToken),
    //       //   accessToken:
    //       //   String.fromCharCodes(appleIdCredential.authorizationCode),
    //       // );
    //       // final authResult = await _firebaseAuth.signInWithCredential(credential);
    //       // final firebaseUser = authResult.user;
    //       // if (scopes.contains(Scope.fullName)) {
    //       //   final displayName =
    //       //       '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
    //       //   await firebaseUser.updateProfile(displayName: displayName);
    //       // }
    //       // return firebaseUser;
    //
    //       // print("status=${result.status}");
    //       // print("email=${result.credential.email}");
    //       // print("fullname=${result.credential.fullName.familyName}");
    //       // print("fullname=${result.credential.fullName.givenName}");
    //       // print("user=${result.credential.user}");
    //       // print("realuserstatus=${result.credential.realUserStatus}");
    //       break; //All the required credentials
    //     case AuthorizationStatus.error:
    //       print("Sign in failed: ${result.error.localizedDescription}");
    //       break;
    //     case AuthorizationStatus.cancelled:
    //       print('User cancelled');
    //       break;
    //   }
    // } else {
    //   print('Apple SignIn is not available for your device');
    // }
  }

  //facebook login
  loginFacebook() async {
    // print("loginFacebook");
    final facebookLogin = FacebookLogin();
    // print("_show_login_facebook2");
    final result = await facebookLogin.logIn(['email']);
    // print("_show_login_facebook3");
    // final result = await facebookLogin.logInWithReadPermissions(['email']);
    print(result.status);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        callAPI_LoginSocial(
            result.accessToken.token, 1); //login_type (1 = fb, 2 = google)
        // _showLoggedInUI();
        break;
      case FacebookLoginStatus.cancelledByUser:
        // _showCancelledMessage();
        //   Session.shared.showAlertPopupOneButtonNoCallBack(content: "");
        break;
      case FacebookLoginStatus.error:
        facebookLogin.logOut();
        // _showErrorOnUI(result.errorMessage);
        Session.shared
            .showAlertPopupOneButtonNoCallBack(content: result.errorMessage);
        break;
    }
    // print(result.accessToken);
    // print(result.accessToken.token);
    // print(result.accessToken.expires);
    // print(result.accessToken.permissions);
    // print(result.accessToken.userId);
    // print(result.accessToken.isValid());
    //
    // print(facebookLoginResult.errorMessage);
    // print(facebookLoginResult.status);

    // final token = result.accessToken.token;

    /// for profile details also use the below code// ko can lấy cung dc
    // final graphResponse = await http.get(
    //     'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
    // final profile = json.decode(graphResponse.body);
    // print(profile);
    /*
    from profile you will get the below params
    {
     "name": "Iiro Krankka",
     "first_name": "Iiro",
     "last_name": "Krankka",
     "email": "iiro.krankka\u0040gmail.com",
     "id": "<user id here>"
    }
   */
  }

  /// function
  void loginGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        // you can add extras if you require
      ],
    );

    _googleSignIn.signIn().then((GoogleSignInAccount acc) async {
      // GoogleSignInAuthentication auth = await acc.authentication;
      // print(acc.id);
      // print(acc.email);
      // print(acc.displayName);
      // print(acc.photoUrl);

      acc.authentication.then((GoogleSignInAuthentication auth) async {
        print("idToken:\n");
        print(auth.idToken);
        print("\n");
        print("accessToken:\n");
        print(auth.accessToken);
        callAPI_LoginSocial(
            auth.accessToken, 2); //login_type (1 = fb, 2 = google)
      });
    });
  }

  callAPILogin() async {
    //clear all old data
    Session.shared.showLoading();
    udid = await Session.shared.getUIID();
    var jsonBodySent = {
      "email": email_controller.text,
      "password": pass_controller.text,
      "account_id": Session.shared.ACCOUNTID,
      "device_type": GetPlatform.isIOS ? "ios" : "android",
      "uiid": udid,
      'fcm_token' : Session.shared.getTokenFireBase(),
      'fcm_topics' : Session.shared.getTopicInt(),
    };
    Dioo.FormData formData = new Dioo.FormData.fromMap(jsonBodySent);
    print(jsonBodySent);
    var network = NetworkAPI(endpoint: url_login, formData: formData);
    var jsonBody = await network.callAPI();
    Session.shared.hideLoading();
    if (jsonBody["code"] == 100) {
      var token = jsonBody["accesstoken"];
      print("🍌 login success with $token from server");
      //save token if login success
      Session.shared.saveToken(token);
      checkIfNeedGoSetupBioLoginController(email_controller.text);
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }

  callAPILoginBio() async {
    Session.shared.showLoading();
    var bioEmail = Session.shared.getEmailForBioLogin();
    udid = await Session.shared.getUIID();
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      "email": bioEmail,
      "account_id": Session.shared.ACCOUNTID,
      "device_type": GetPlatform.isIOS ? "ios" : "android",
      "uiid": udid,
      'fcm_token' : Session.shared.getTokenFireBase(),
      'fcm_topics' : Session.shared.getTopicInt(),
    });
    var network = NetworkAPI(endpoint: "member/login-uiid", formData: formData);
    var jsonBody = await network.callAPIPOST();
    Session.shared.hideLoading();
    if (jsonBody["code"] == 100) {
      var token = jsonBody["accesstoken"];
      print(" callAPILoginBio save token if login success $token");
      //save token if login success
      Session.shared.saveToken(token);
      checkIfNeedGoSetupBioLoginController(email_controller.text);
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }

  checkIfNeedGoSetupBioLoginController(String currentEmail) {
    if (Session.shared.getEmailForBioLogin() != null) {
      Session.shared.changeRootViewAfterLogin();
    } else {
      //not yet have bio then ask them use bio by go SetupBioLogin with param
      if (Session.shared.box.hasData(Strings.skipBio)) {
        Session.shared.changeRootViewAfterLogin();
      } else {
        Get.offAll(() =>SetupBioLogin(), arguments: currentEmail);
      }
    }
  }

  GestureDetector BioIcon() {
    //ok check Android and ios icon bio
    if (Platform.isIOS) {
      if (_availableBiometrics.contains(BiometricType.face)) {
        // Face ID.
        return GestureDetector(
          //only
          child: Image.asset("assets/images/faceid.png"),
          onTap: () {
            print("faceid login, check");
            // callAPILoginBio();
            _authenticate();
          },
        );
      } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
        // Touch ID.
        return GestureDetector(
          //only
          child: Image.asset("assets/images/touchid.png"),
          onTap: () {
            print("touchid login, check");
            // callAPILoginBio();
            _authenticate();
          },
        );
      }
    } else {
      //Android
      //Touch ID.for Android
      return GestureDetector(
        //only
        child: Image.asset("assets/images/touchid.png"),
        onTap: () {
          print("touchid android login click, check bio");

          _authenticate();
          // callAPILoginBio();
        },
      );
    }
  }

  Padding sectionGoRegister() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Config.kDefaultPadding),
        child: GestureDetector(
          onTap: () {
            print("go choose type register");
            Session.shared.changeRootViewChooseRegister(c);
          },
          child: Column(
            children: [
              Text("Not a member yet?"),
              Text.rich(TextSpan(
                text: 'Register',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Config.secondColor),
                children: <InlineSpan>[
                  TextSpan(
                    text: ' now',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                  )
                ],
              ))
            ],
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    print("initState _isProtectionEnabled $_isProtectionEnabled");
    super.initState();
    // email_controller.text = 'iosc2@yopmail.com';
    // pass_controller.text = '111';
    _checkBiometrics();
    _checkIsProtectionEnabled();
    _checkIsAvailebleAppleIDLogin();
    // //temp revolk for testing//not working!, recheck
    // if(Platform.isIOS){
    //   //clear data check for ios if developing for both android & ios
    //   AppleSignIn.onCredentialRevoked.listen((_) {
    //     print("Credentials revoked");
    //   });
    //
    // }
    //show bio authen if have biologin
  }

  _checkIsAvailebleAppleIDLogin() async {
    var isOK = await TheAppleSignIn.isAvailable();
    setState(() {
      _isAvailebleAppleIDLogin.value = isOK;
    });
  }

  _checkIsProtectionEnabled() {
    setState(() {
      _isProtectionEnabled = Session.shared.box.hasData('loginbio');
    });
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
      print(e);
    }
    if (!mounted) return;
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
      // setState(() {
      //   _isAuthenticating = false;
      // });
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
      callAPILoginBio();
    }
  }

  Widget getHeader() {
    return AppNavigationV2(
        totalStep: 0,
        currentStep: 1,
        closeClicked: () {
          Get.back();
        },
        title: "Welcome Back!",
        subTitle: "Login now and check out the latest deals available!");
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
          if (_isProtectionEnabled) {
            logger.i('_isProtectionEnabled true, start authen auto');
            _authenticate();
          } else {
            logger.i('_isProtectionEnabled false');
          }
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
            color: Colors.transparent,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                reverse: false,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0,
                                -5), //(0,-12) Bóng lên,(0,12) bóng xuống,, tuong tự cho trái phải
                            blurRadius: 15, //do bóng phủ xa
                            color: Colors.black12)
                      ]),
                  // color: Colors.red.shade200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[getHeader(), buildLoginForm(context)],
                  ),
                ),
              ),
            )),
      );

  ////login_type (1 = fb, 2 = google, 3 appleid)
  callAPI_LoginSocial(String token, int _type) async {
    print("token: $token");
    Session.shared.showLoading();
    print("start _callAPIUploadImage");
    var bodyJson = {
      'login_type': _type,
      'sm_token': token,
      'fcm_token' : Session.shared.getTokenFireBase(),
      'fcm_topics' : Session.shared.getTopicInt(),
    };
    print(bodyJson);
    Dioo.FormData formData = new Dioo.FormData.fromMap(bodyJson);
    // Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    // var network = NetworkAPI(endpoint: url_member_social_media_check, formData: formData, jsonQuery: jsonQuery);
    var network =
        NetworkAPI(endpoint: url_member_social_media_check, formData: formData);
    var jsonBody = await network.callAPI(showLog: true);
    Session.shared.hideLoading();
    // await Future.delayed(const Duration(seconds: 2), () {});


    if (jsonBody["code"] == 100) {
      var modelLoginSocialResult = ModelLoginSocialResult.fromJson(jsonBody);
      print("success ${modelLoginSocialResult.toJson()}");
      //isNewAccount
      print("isNewAccount ${modelLoginSocialResult.isNewAccount()}");
      //check type
      // login_type (1 = fb, 2 = google)
      if (modelLoginSocialResult.isNewAccount()) {
        //new account
        switch (_type) {
          case 1:
            {
              print('this case facebook');
              Session.shared.social_media_type = '1';
              Session.shared.social_name =
                  modelLoginSocialResult.getNameFacebook();
              Session.shared.social_id =
                  modelLoginSocialResult.getIDFacebook();
              Session.shared.social_email = modelLoginSocialResult.getEmailFB();

              //
              // Route route = MaterialPageRoute(
              //     builder: (context) => ChooseTypeRegisterScreen());
              // Navigator.of(context).pushReplacement(route);
              // Session.shared.changeRootViewAfterLogin();
              //Nếu acc mới thì reg auto luôn
              callAPIAutoRegForSocial(
                  fullName: modelLoginSocialResult.getNameFacebook(),
                  email: modelLoginSocialResult.getEmailFB(),
                  // mobile: ""
              );
            }
            break;
          case 2:
            {
              print('google');
              Session.shared.social_media_type = '2';
              Session.shared.social_name =
                  modelLoginSocialResult.getNameGoogle();
              Session.shared.social_id =
                  modelLoginSocialResult.getIDGoogle();
              Session.shared.social_email =
                  modelLoginSocialResult.getEmailGoogle();
              //
              // Route route = MaterialPageRoute(
              //     builder: (context) => ChooseTypeRegisterScreen());
              // Navigator.of(context).pushReplacement(route);
              // Session.shared.changeRootViewAfterLogin();
              //Nếu acc mới thì reg auto luôn
              callAPIAutoRegForSocial(
                  fullName: modelLoginSocialResult.getNameGoogle(),
                  email: modelLoginSocialResult.getEmailGoogle(),
                  // mobile: ""
              );
            }
            break;

          case 3:
            {
              print('apple');
              Session.shared.social_media_type = '3';
              Session.shared.social_name =
                  modelLoginSocialResult.getNameApple();
              Session.shared.social_id =
                  modelLoginSocialResult.getIDApple();
              Session.shared.social_email =
                  modelLoginSocialResult.getEmailApple();

              // Route route = MaterialPageRoute(
              //     builder: (context) => ChooseTypeRegisterScreen());
              // Navigator.of(context).pushReplacement(route);
              // Session.shared.changeRootViewToDashBoard();// di thẳng luôn
              // Session.shared.changeRootViewAfterLogin();
              //Nếu acc mới thì reg auto luôn
              callAPIAutoRegForSocial(
                  fullName: modelLoginSocialResult.getNameApple(),
                  email: modelLoginSocialResult.getEmailApple(),
                  // mobile: ""
              );
            }
            break;
          default:
            {}
            break;
        }
      } else {
        //old account must save token
        print("old account get token and afterlogin now");
        Session.shared.saveToken(modelLoginSocialResult.getToken());
        Session.shared.changeRootViewAfterLogin();
      }

      //parse mobdel check in_db true/false
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }

  callAPIAutoRegForSocial({
      String fullName,
      String email,
      String mobile,}
      ) async {
    Session.shared.showLoading();
    print("start callAPI");
    var uiid = await Session.shared.getUIID();
    //hide keyboard!
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      "fullname": fullName,
      'email': email,
      'mobile_code': "+65",
      'mobile': mobile,
      "password": '123456',
      "password_confirm": '123456',
      "account_id": Session.shared.ACCOUNTID,
      "device_type": GetPlatform.isIOS ? "ios" : "android",
      'uiid': uiid,
      //for social , optional social_media_type, social_media_id
      'social_media_type' : Session.shared.social_media_type, //login_type (1 = fb, 2 = google, 3 = apple
      'social_media_id' : Session.shared.social_id,
    });
    var network = NetworkAPI(endpoint: url_register, formData: formData);
    var jsonBody = await network.callAPIPOST();
    Session.shared.hideLoading();
    if (jsonBody["code"] == 100) {
      var token = jsonBody["accesstoken"];
      print("save token if login success $token");
      //save token if register success
      Session.shared.saveToken(token);
      print('go Onboard for personal');
      Session.shared.resetSocialLoginInfo();
      Get.off(AfterLoginScreen());
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }


}

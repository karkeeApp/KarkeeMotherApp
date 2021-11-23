import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:carkee/config/config_setting.dart';
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/controllers/main_tab_bar_controller.dart';
import 'package:device_info/device_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:carkee/components/alertbox_custom.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/ModelEndpoint.dart';
import '../models/ModelSiteSettingResult.dart';
import '../screen/choose_register_screen.dart';

import '../screen/main_tab_bar.dart';
import '../screen/screens.dart';
import '../screen/web_view_in_app.dart';

import 'app_configs.dart';
import 'strings.dart';

class Session {
  static final Session _singleton = Session._internal();
  factory Session() {
    return _singleton;
  }
  Session._internal();
  //https://pub.dev/packages/get_storagephung
  //save, read remove listen...v.v.
  // final secureStorage =
  //     new FlutterSecureStorage(); //for saving token //https://pub.dev/packages/flutter_secure_storage
  final box = GetStorage();
  static Session get shared => _singleton;
  // variables
  var _baseURL = ConfigSetting.baseURLFirstload;
  var ACCOUNTID = 0;
  var HASH_ID = "987654321";

  //data for new login social., save name and email
  var social_name = '';
  var social_email = '';
  var social_id = '';
  var social_media_type = ''; ////login_type (1 = fb, 2 = google, 3 = apple

  //image picker
  File file;
  final picker = ImagePicker();
  var isLoged = false;
  resetSocialLoginInfo() {
    social_name = '';
    social_email = '';
    social_id = '';
    social_media_type = '';
  }

  // List<ModelAccounts> accounts = [];//no more
  //https://pub.dev/packages/intl
  //https://api.flutter.dev/flutter/intl/DateFormat-class.html
  String getFormatDateTime(DateTime dateTime) {
    //yMd : DateFormat.yMd([dynamic locale]) : DateFormat.yMd()             -> 7/10/1996
    var dateString = DateFormat.yMd().format(dateTime);
    return dateString;
  }

  getTokenFireBase() {
    return box.read('firebaseToken') ?? '';
  }

  getTopicsFireBase() {
    return box.read('topic') ?? '';
  }

  Color randomColor() {
    return Color(Random().nextInt(0xffffffff));
    // return Colors.teal[100 * (Random().nextInt() % 9.0)];
  }

  getBaseURL() {
    if (_baseURL.endsWith('/')) {
      return _baseURL;
    } else {
      return _baseURL + '/';
    }
  }

  get widthScreen => Get.width;

  saveModelEnpoint(ModelEndpoint model) {
    _baseURL = model.endpoint;
    //ACCOUNTID = model.account_id;
    HASH_ID = model.hash_id;
  }

  saveEmailForBioLogin(String emailLogBio) async {
    print("saveEmailForBioLogin emailLogBio: $emailLogBio");
    box.write(Strings.loginBio, emailLogBio);
    // secureStorage.
    // Write value
    // await secureStorage.write(key: Strings.loginBio, value: emailLogBio);
  }

  getEmailForBioLogin() {
    var emailforBio = box.read(Strings.loginBio);
    return emailforBio;
  }

  clearEmailForBioLogin() {
    box.remove('loginbio');
  }

  //remeber me!!
  saveEmailForRememberMe(String email) {
    print("save email: $email");
    box.write(Strings.email, email);
  }

  //email
  getEmailForRememberMe() {
    var email = box.read(Strings.email);
    return email;
  }

  //email
  clearEmailForRememberMe() {
    box.remove(Strings.email);
    box.remove(Strings.rememberme);
  }

  showLoading() {
    Get.dialog(Center(child: CircularProgressIndicator()),
        barrierDismissible: true);
  }

  hideLoading() {
    Get.back();
  }

  showAlertPopupOneButtonNoCallBack({String title = 'Error', String content}) {
    //check session expire
    if (content == "Your request was made with invalid credentials.") {
      showAlertPopupOneButtonWithCallback(
          title: "Session expire",
          content: "Please login again",
          callback: () {
            logout();
            // changeRootViewToGuest();
          });
    } else {
      Get.dialog(AlertPopupOneButton(title: title, content: content));
    }
  }

  showAlertPopup2ButtonWith2Callback(
      {String title = '',
      String content = '',
      Function() callbackButtonRight,
      Function() callbackButtonLeft,
      String titleButtonRight = "OK",
      String titleButtonLeft = "Cancel"}) {
    Get.dialog(AlertPopup2ButtonCallback(
        title: title,
        content: content,
        callbackButtonRight: callbackButtonRight,
        callbackButtonLeft: callbackButtonLeft,
        titleButtonRight: titleButtonRight,
        titleButtonLeft: titleButtonLeft));
  }

  showAlertPopupOneButtonWithCallback(
      {String title = 'Error', String content = '', Function callback}) {
    if (content == "Your request was made with invalid credentials.") {
      Get.dialog(AlertPopupOneButton(
          title: "Session expire",
          content: "Please login again",
          callbackAfterPressOK: () {
            logout();
            changeRootViewToGuest();
          }));
    } else {
      Get.dialog(AlertPopupOneButton(
          title: title, content: content, callbackAfterPressOK: callback));
    }
    //check session expire here !
  }

  showAlertPopup2ButtonWithCallback(
      {String title = '',
      String content = '',
      Function callback,
      String titleButtonRight = "OK",
      String titleButtonLeft = "Cancle"}) {
    Get.dialog(AlertPopup2Button(
        title: title,
        content: content,
        callbackAfterPressOK: callback,
        titleButtonRight: titleButtonRight,
        titleButtonLeft: titleButtonLeft));
  }

  showAlertPopup2ButtonWithCallbackFullCustom(
      {String title = '',
      String content = '',
      Function callbackLeft,
      Function callbackRight,
      String titleButtonRight,
      String titleButtonLeft}) {
    Get.dialog(AlertPopup2Button(
        title: title,
        content: content,
        callbackAfterLeftClick: callbackLeft,
        callbackAfterPressOK: callbackRight,
        titleButtonRight: titleButtonRight,
        titleButtonLeft: titleButtonLeft));
  }

  showAlertPopupWithCallbackTextFieldInput(
      {bool obscureText = false,
      String title = "",
      String cancleText = 'Cancle',
      String placeholder = '',
      String confirmText = 'OK',
      Function(String) callback}) {
    Get.dialog(AlertPopupWithTextField(
      title: title,
      obscureText: obscureText,
      placeholder: placeholder,
      confirmText: confirmText,
      cancleText: cancleText,
      callbackAfterPressOK: (textInput) {
        callback(textInput);
      },
    ));
  }

  getToken() async {
    final box = GetStorage();
    // String tk = await secureStorage.read(key: Strings.token);
    String tk = await box.read(Strings.token);
    print("✅ token from box $tk");
    isLoged = (tk != null && tk != "");
    print("isLoged isLoged isLoged $isLoged");
    return tk;
  }

  ProfileController getProfileController() {
    if (Get.isRegistered<ProfileController>()) {
      return Get.find<ProfileController>();
    } else {
      return Get.put(ProfileController(), permanent: true);
    }
  }

  // getToken() {
  //   // final box = GetStorage();
  //   secureStorage.read(key: Strings.token).then((value) {
  //     print("✅ token from box $value");
  //     return value;
  //   });
  //   //return tk_;
  // }
  // String getToken() {
  //   // final box = GetStorage();
  //   var token = box.read('token');
  //   print("✅ token from box $token");
  //   return (token ?? "");
  // }

  saveToken(String newToken) async {
    // final box = GetStorage();
    // await secureStorage.write(key: Strings.token, value: newToken);
    await box.write(Strings.token, newToken);
    print("🍎saved token to box! $newToken");
    // var token = await getToken();
    // print("token recheck $token");
  }
  // saveToken(String newToken) async {
  //   // final box = GetStorage();
  //   await box.write(Strings.token, newToken);
  //   print("saved token to box!");
  //   var token = getToken();
  //   print("token recheck $token");
  // }

  logout() async {
    // final box = GetStorage();
    // final ProfileController profileController = Get.find();
    // profileController.userProfile.value = null;
    // profileController.onDelete();
    await box.remove(Strings.token);
    // await secureStorage.delete(key: Strings.token);
    await box.remove(Strings.skipBio);
    clearEmailForBioLogin();
    clearEmailForRememberMe();
    //important
    isLoged = false;//important!1
    Get.reset();
    print("remove token out box!");
  }

  convertToInt({dynamic data}) {
    if (data is String) {
      return int.tryParse(data) ?? 0;
    }
    if (data is int) {
      return data;
    }
  }

  goProfileTab() {
    final MainTabbarController _controller = Get.find();
    _controller.goProfileTab();
  }

  goHomeTab() {
    final MainTabbarController _controller = Get.find();
    _controller.changePage(0);
  }

  goNewsTab() {
    final MainTabbarController _controller = Get.find();
    _controller.changePage(1);
  }

  goEventTab() {
    final MainTabbarController _controller = Get.find();
    _controller.changePage(2);
  }

  goSponsorTab() {
    final MainTabbarController _controller = Get.find();
    _controller.goSponsor();
  }

  getTopicInt() {
    var topicInt = box.read('notiType') ?? 3;
    return topicInt;
  }

  showImagePicker(context,
      {@required bool isHavePDFOption, @required Function(File) callback}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        imgFromGalleryV2(context, callback);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera(callback);
                      Navigator.of(context).pop();
                    },
                  ),
                  isHavePDFOption
                      ? ListTile(
                          leading: new Icon(Icons.picture_as_pdf),
                          title: new Text('PDF'),
                          onTap: () {
                            chooseFile(callback);
                            Navigator.of(context).pop();
                          },
                        )
                      : SizedBox(),
                ],
              ),
            ),
          );
        });
  }

  //HANDLE PICTURE UPLOAD
  chooseFile(@required Function(File) callback) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf']);
    if (result != null) {
      // _file = File(result.files.single.path);
      // _callAPIUploadImage();
      file = File(result.files.single.path);
      var fileType = lookupMimeType(result.files.single.path);
      print(fileType);
      if (fileType == 'application/pdf') {
        // _callAPIUploadImage();
        callback(file);
      } else {
        showAlertPopupOneButtonNoCallBack(content: "File not support");
      }
    } else {
      // User canceled the picker
      print('No file selected.');
    }
  }

  imgFromCamera(@required Function(File) callback) async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      print('upload now');
      file = File(pickedFile.path);
      cropImage(callback: callback);
      // _callAPIUploadImage();//no more call APi here, put after crop!
    } else {
      // Session.shared.hideLoading();
      print('No image selected.');
    }
  }

  // imgFromGallery(@required Function(File) callback) async {
  //   FilePickerResult result = await FilePicker.platform.pickFiles(
  //     allowMultiple: false,
  //     type: FileType.image,
  //   );
  //   if (result != null) {
  //     file = File(result.files.single.path);
  //     if (isFileSizeUnder5MB(file)) {
  //       // _callAPIUploadImage();
  //       cropImage(callback: callback);
  //     } else {
  //       file = null;
  //       showAlertPopupOneButtonNoCallBack(
  //           title: "Error", content: "File not allow > 5MB");
  //     }
  //   } else {
  //     print('No file selected.');
  //   }
  // }

  imgFromGalleryV2(BuildContext context, Function(File) callback) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      final pickedFile =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
      if (pickedFile != null) {
        file = File(pickedFile.path);
        // file = await assets.first.file;
        print('upload now');
        cropImage(callback: callback);
        // if (isFileSizeUnder5MB(file)) {
        //   cropImage(callback: callback);
        // } else {
        //   file = null;
        //   showAlertPopupOneButtonNoCallBack(
        //       title: "Error", content: "File not allow > 5MB");
        // }
      } else {
        print('No image selected.');
      }
    } else {
      if (Platform.isIOS) {
        showAlertPopup2ButtonWith2Callback(
            title: "Permission is required to access photos",
            content: "No file has been selected or permission was not granted!",
            titleButtonLeft: "OK",
            titleButtonRight: "Settings",
            callbackButtonRight: () {
              openAppSettings();
            });
      } else {
        PhotoManager.openSetting();
      }
      print('multiFromGalleryV2 No file selected.');
    }
  }

  //crop
  Future<Null> cropImage({Function(File) callback}) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      print('callback _cropImage');
      file = croppedFile; //update UI!
      callback(file);
    }
  }

  //
  // getTopicString(){
  //
  //   var topicInt = box.read('notiType') ?? 3;
  //   switch(topicInt) {
  //     case 0: {
  //       return 'none';
  //       print('step1');
  //     }
  //     break;
  //     case 1: {
  //       return 'events';
  //       print('step1');
  //     }
  //     break;
  //     case 2: {
  //       return 'news';
  //       print('step1');
  //     }
  //     break;
  //     case 3: {
  //       return 'all';
  //       print('step1');
  //     }
  //     break;
  //
  //     default: {
  //       return 'all';
  //     }
  //     break;
  //   }
  //
  // }

  bool isLogedin() {
    // String ≈ = await secureStorage.read(key: Strings.token);
    // print("✅ token from box $tk");

    //
    // var isLogFromFisk = (getToken() != "" && getToken() != null);
    // // var tk = await getToken();
    // // print("❌ tk $tk");
    // print("❌ isLogedin $isLog");
    // print("❌ getToken ${getToken()}");
    //
    // return isLog;
    // isLoged = isLogFromFisk;
    print("❌ isLoged $isLoged");
    return isLoged;
  }


  getUIID() async {
    var deviceInfo = DeviceInfoPlugin();
    if (GetPlatform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      // return iosDeviceInfo.identifierForVendor; // unique ID on iOS
      return iosDeviceInfo.identifierForVendor;
      // print("found udid : $udid");
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      // return androidDeviceInfo.androidId; // unique ID on Android
      return androidDeviceInfo.androidId;
      // print("found udid : $udid");
    }
  }

  //AfterLoginScreen

  changeRootViewAfterLogin() {
    print("changeRootViewAfterLogin");
    Get.offAll(() => AfterLoginScreen(), transition: Transition.noTransition);
  }

  changeRootViewChooseRegister() {
    print("changeRootViewChooseRegister");
    Get.to(() => ChooseTypeRegisterScreen());
  }

  changeRootViewToDashBoard() {
    print("changeRootViewToDashBoard");
    Get.offAll(() => MainTabbar());
  }

  bool isValidEmail(String email) {
    // var email = "tony@starkindustries.com"
    // bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool isFileSizeUnder5MB(File file) {
    //Note: The size returned is in bytes.
    //1MB = 1048576 bytes
    //5MB = 5242880 bytes
    var size = file.lengthSync();
    print("size: ${(size / 1048576).toStringAsFixed(2)} MB");
    //
    return (size < 5242880);
  }

  changeRootViewToLogin() {
    // Get.offAll(() =>LoginScreen());
    //Get.off(LoginScreen());
    // Get.to(() => TestScreen());
    // no more change rootview to login
    changeRootViewToGuest();
  }

  changeRootViewToRegister() {
    Get.offAll(() => RegisterScreen());
  }

  changeRootViewToGuest() {
    Get.offAll(() => GuestScreenV2(), transition: Transition.leftToRight);
  }

  openWebView({String title, String url}) async {
    print("url: $url");
    // await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
    await canLaunch(url)
        ? await launch(url)
        : showAlertPopupOneButtonNoCallBack(
            title: "Something went wrong", content: 'Could not launch $url');
  }

  int getMinAllowYear() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy');
    String formattedDate = formatter.format(now);
    int formattedYearInterger = int.parse(formattedDate);
    return formattedYearInterger - 18;
  }

  showPickerDate(BuildContext context, Function(DateTime) afterPick) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1900, 1, 1),
        maxTime: DateTime.now(),
        // maxTime: DateTime(Session.shared.getMinAllowYear(), 31, 12),
        // theme: DatePickerTheme(
        //     // headerColor: Colors.orange,
        //     // backgroundColor: Colors.blue,
        //     // itemStyle: TextStyle(
        //     //     color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        //     // doneStyle: TextStyle(color: Colors.white, fontSize: 16)
        // ),
        onChanged: (date) {
      print('change $date in time zone ' +
          date.timeZoneOffset.inHours.toString());
      // controller.handleAfterPickerDate(date);
    }, onConfirm: (date) {
      print('confirm $date');
      afterPick(date);
      // controller.handleAfterPickerDate(date);
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  showPickerDateNoMax(BuildContext context, Function(DateTime) afterPick) {
    DatePicker.showDatePicker(context,
        showTitleActions: true, minTime: DateTime(1900, 1, 1),
        // maxTime: DateTime(Session.shared.getMinAllowYear(), 31, 12),
        // theme: DatePickerTheme(
        //     // headerColor: Colors.orange,
        //     // backgroundColor: Colors.blue,
        //     // itemStyle: TextStyle(
        //     //     color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        //     // doneStyle: TextStyle(color: Colors.white, fontSize: 16)
        // ),
        onChanged: (date) {
      print('change $date in time zone ' +
          date.timeZoneOffset.inHours.toString());
      // controller.handleAfterPickerDate(date);
    }, onConfirm: (date) {
      print('confirm $date');
      afterPick(date);
      // controller.handleAfterPickerDate(date);
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  Widget getCenterLoadingIcon() {
    return Center(child: CircularProgressIndicator());
  }

  Widget EmptyBox() {
    return SizedBox();
  }
}

import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carkee/components/bottom_next_back_register.dart';
import 'package:carkee/components/item_upload.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/components/network_api.dart';
import 'package:dio/dio.dart' as Dioo;
import 'package:carkee/config/strings.dart';
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/screen/screens.dart';
import 'package:mime/mime.dart';
//check later
//todo
//https://stackoverflow.com/questions/63205269/push-screen-bottom-on-top-of-keyboard-in-flutter-when-textfield-or-textformfield
class UpdatePart4Screen extends StatelessWidget {
  final UpdatePart4Controller controller = Get.put(UpdatePart4Controller());

  // showImagePicker(context, @required bool isHavePDFOption, @required String type) {
  //   controller.typeUpload = type;
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return SafeArea(
  //           child: Container(
  //             child: Wrap(
  //               children: <Widget>[
  //                 ListTile(
  //                     leading: new Icon(Icons.photo_library),
  //                     title: new Text('Photo Library'),
  //                     onTap: () {
  //                       controller._imgFromGallery();
  //                       Navigator.of(context).pop();
  //                     }),
  //                 ListTile(
  //                   leading: new Icon(Icons.photo_camera),
  //                   title: new Text('Camera'),
  //                   onTap: () {
  //                     controller._imgFromCamera();
  //                     Navigator.of(context).pop();
  //                   },
  //                 ),
  //                 isHavePDFOption
  //                     ? ListTile(
  //                         leading: new Icon(Icons.picture_as_pdf),
  //                         title: new Text('PDF'),
  //                         onTap: () {
  //                           controller._chooseFile();
  //                           Navigator.of(context).pop();
  //                         },
  //                       )
  //                     : SizedBox(),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
  @override
  Widget build(BuildContext context) {
    print('Start build');
    return image_background(context);
  }
  Widget body_view(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          child: Column(children: [
            // LineStepRegister(totalStep: 6, currentStep: 4),
            AppNavigationV2(
              closeClicked: () {
                print("close clicked");
                Session.shared.changeRootViewToGuest();
              },
              title: "Please bare with us",
              subTitle: 'Please upload the necessary documents',
              totalStep: 6,
              currentStep: 4,
            ),
            Expanded(
              child: ListView(
                children: [buildBody(context)],
              ),
            ),
            BottomNextBackRegister(
              isShowBack: true,
              nextClicked: () => controller.callAPIUpdate(),
              backClicked: () => Get.offAll(() =>UpdatePart3Screen(),
                  transition: Transition.leftToRight),
            )
          ]),

          // children: [],
        ),
      ),
    );
  }

  Widget image_background(BuildContext context) {
    //return Center(child: CircularProgressIndicator());
    return Material(
      child: Container(
        // color: Colors.red,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg_2.png"), fit: BoxFit.cover),
          ),
          child : blur_background(context)
      ),
    );
  }

  Widget blur_background(BuildContext context) {
    //return Center(child: CircularProgressIndicator());
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
        ),
        child: body_view(context),
      ),
    );
  }

  Padding buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Config.kDefaultPadding * 2),
      child: Container(
        //final ProfileController controller = Get.put(ProfileController());
        //Obx(() => Text('fullname is: ${controller.userProfile.value.fullname}'))
        // Obx(() {
        // print("listening");
        // var numberItem = (controller.modelMemberOptionsResult?.value.salaries?.length != null);
        // return numberItem ? Text('salaryOptions co : ${controller.modelMemberOptionsResult?.value.salaries?.length}') : Text('null');
        // }),
        child: Column(

            children: [

          Obx(() => XibItemUpload(
              line1: 'Profile Image',
              line3: "Jpeg, jpg, png, gif (Max. 5MB)",
              urlImage:
                  controller.profileController.userProfile.value.imgProfile,
              fileType: controller
                  .profileController.userProfile.value.imgProfileMimeType,
              onTap: () {
                print('show Popup choose source upload');
                // showImagePicker(context, false, Strings.img_profile);
                controller.typeUpload = Strings.img_profile;
                Session.shared.showImagePicker(context, isHavePDFOption: false, callback: (file){
                  controller._file = file;
                  controller._callAPIUploadImage();
                });

              })
          ),
          BottomLineMclub(),
          Obx(() => XibItemUpload(
              line1: 'Your Driving Licence / NRIC',
              urlImage: controller.profileController.userProfile.value.imgNric,
              fileType: controller
                  .profileController.userProfile.value.imgNricMimeType,
              onTap: () {
                print('show Popup choose source upload');
                // showImagePicker(context, true, Strings.img_nric);
                controller.typeUpload = Strings.img_nric;
                Session.shared.showImagePicker(context, isHavePDFOption: false, callback: (file){
                  controller._file = file;
                  controller._callAPIUploadImage();
                });
              })
          ),
          BottomLineMclub(),

          Obx(() => XibItemUpload(
              line1: 'Vehicle Insurance Certificate',
              urlImage:
                  controller.profileController.userProfile.value.imgInsurance,
              fileType: controller
                  .profileController.userProfile.value.imgInsuranceMimeType,
              onTap: () {
                print('show Popup choose source upload');
                // showImagePicker(context, true, Strings.img_insurance);
                controller.typeUpload = Strings.img_insurance;
                Session.shared.showImagePicker(context, isHavePDFOption: false, callback: (file){
                  controller._file = file;
                  controller._callAPIUploadImage();
                });
              })),
          BottomLineMclub(),
          Obx(() => XibItemUpload(
              line1: 'Registration Log Card (Issued by LTA)',
              urlImage:
                  controller.profileController.userProfile.value.imgLogCard,
              fileType: controller
                  .profileController.userProfile.value.imgLogCardMimeType,
              onTap: () {
                print('show Popup choose source upload');
                // showImagePicker(context, true, Strings.img_log_card);
                controller.typeUpload = Strings.img_log_card;
                Session.shared.showImagePicker(context, isHavePDFOption: false, callback: (file){
                  controller._file = file;
                  controller._callAPIUploadImage();
                });
              })),

          BottomLineMclub(),

          //Authorisation Letter (If you are not the owner), only owner = 1 then show this!
          getAutho(context),
        ]),
      ),
    );
  }

  getAutho(BuildContext context) {
    if (controller.profileController.userProfile.value.areYouOwner == '1') {
      return SizedBox();
    } else {
      return Column(
        children: [
          Obx(() => XibItemUpload(
              line1: 'Authorisation Letter (If you are not the owner)',
              urlImage: controller
                  .profileController.userProfile.value.imgAuthorization,
              fileType: controller
                  .profileController.userProfile.value.imgAuthorizationMimeType,
              onTap: () {
                print('show Popup choose source upload');
                // showImagePicker(context, true, Strings.img_authorization);
                controller.typeUpload = Strings.img_authorization;
                Session.shared.showImagePicker(context, isHavePDFOption: false, callback: (file){
                  controller._file = file;
                  controller._callAPIUploadImage();
                });
              })
          ),
          BottomLineMclub(),
        ],
      );
    }
  }
}

class UpdatePart4Controller extends GetxController {
  final ProfileController profileController = Get.find();
  String typeUpload;
  File _file;
  final picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    print('onInit UpdatePart4Controller');
  }

  callAPIUpdate() async {
    print("start callAPIUpdate");
    Session.shared.showLoading();
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      'step': 4,
    });
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(
        endpoint: url_member_update_profile,
        formData: formData,
        jsonQuery: jsonQuery);
    var jsonBody = await network.callAPIPOST();
    Session.shared.hideLoading();
    if (jsonBody["code"] == 100) {
      print("success ");
      await profileController.callAPIGetProfile();
      Get.offAll(() =>UpdatePart5Screen());
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }
  //
  // //HANDLE PDF UPLOAD
  // _chooseFile() async {
  //   FilePickerResult result = await FilePicker.platform.pickFiles(
  //       allowMultiple: false,
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf']);
  //   if (result != null) {
  //     // _file = File(result.files.single.path);
  //     //
  //     // _callAPIUploadImage();
  //     _file = File(result.files.single.path);
  //     var fileType = lookupMimeType(result.files.single.path);
  //     print(fileType);
  //     if (fileType == 'application/pdf') {
  //       _callAPIUploadImage();
  //     } else {
  //       Session.shared.showAlertPopupOneButtonNoCallBack(content : "File not support");
  //     }
  //   } else {
  //     // User canceled the picker
  //     Session.shared.hideLoading();
  //     print('No file selected.');
  //   }
  // }
  //
  //
  // _imgFromGallery() async {
  //   FilePickerResult result = await FilePicker.platform.pickFiles(
  //     allowMultiple: false,
  //     type: FileType.image,
  //   );
  //   if (result != null) {
  //     // _file = File(result.files.single.path);
  //     // _callAPIUploadImage();
  //     _file = File(result.files.single.path);
  //     if (Session.shared.isFileSizeUnder5MB(_file)) {
  //       var fileType = lookupMimeType(result.files.single.path);
  //       print(fileType);
  //       _callAPIUploadImage();
  //
  //     } else {
  //       _file = null;
  //       Session.shared.showAlertPopupOneButtonNoCallBack(title: "Error", content: "File not allow > 5MB");
  //     }
  //   } else {
  //     print('No file selected.');
  //   }
  // }
  //
  // _imgFromCamera() async {
  //   final pickedFile =
  //       await picker.getImage(source: ImageSource.camera, imageQuality: 50);
  //   if (pickedFile != null) {
  //     print('upload now');
  //     _file = File(pickedFile.path);
  //     // _callAPIUploadImage();
  //     if (Session.shared.isFileSizeUnder5MB(_file)) {
  //       print('upload now');
  //       //upload now
  //       _callAPIUploadImage();
  //     } else {
  //
  //       Session.shared.showAlertPopupOneButtonNoCallBack(title: "Error", content: "File not allow > 5MB");
  //     }
  //
  //   } else {
  //     Session.shared.hideLoading();
  //     print('No image selected.');
  //   }
  // }
  //
  // _imgFromGallery() async {
  //
  //   final pickedFile =
  //       await picker.getImage(source: ImageSource.gallery, imageQuality: 100);
  //   if (pickedFile != null) {
  //     _file = File(pickedFile.path);
  //     print("🤣 filesize: ");
  //     print(_file.lengthSync());
  //     // print (await _file.length());
  //     // var compressedFile = resizeImage(pickedFile);
  //     // _file = File(compressedFile.path);
  //
  //     if (Session.shared.isFileSizeUnder5MB(_file)) {
  //       print('upload now');
  //       //upload now
  //       _callAPIUploadImage();
  //     } else {
  //
  //       Session.shared.showAlertPopupOneButtonNoCallBack(title: "Error", content: "File not allow > 5MB");
  //     }
  //
  //   } else {
  //     Session.shared.hideLoading();
  //     print('No image selected.');
  //   }
  // }


  //check later
  // resizeImage(PickedFile pickedFile) async {
  //   var resizeWidth = 400;
  //   var file = File(pickedFile.path);
  //   ImageProperties properties = await FlutterNativeImage.getImageProperties(pickedFile.path);
  //   File compressedFile = await FlutterNativeImage.compressImage(file.path, quality: 80,
  //       targetWidth: resizeWidth,
  //       targetHeight: (properties.height * resizeWidth / properties.width).round());
  //   return compressedFile;
  // }

  _callAPIUploadImage() async {
    // Session.shared.showLoading();
    print("start _callAPIUploadImage");
    //get Type
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      "file":
          await Dioo.MultipartFile.fromFile(_file.path, filename: _file.name),
      'field': typeUpload,
    });
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(
        endpoint: url_member_upload_doc,
        formData: formData,
        jsonQuery: jsonQuery);
    // var jsonBody = await network.callAPIPOST();
    // Session.shared.hideLoading();
    var jsonBody = await network.callAPI(method: "POST", percent: (percent){
      print(percent);
      if (percent != 1) {
        EasyLoading.showProgress(percent, status: 'Uploading..');
      } else {
        EasyLoading.dismiss(animation: true);
      }
    });
    if (jsonBody["code"] == 100) {
      print("success $jsonBody");
      profileController.callAPIGetProfile(); //refresh
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}

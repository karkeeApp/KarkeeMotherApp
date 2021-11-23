import 'dart:io';
import 'dart:ui';
import 'package:carkee/screen/welcome_screen.dart';
import 'package:carkee/screen/welcome_screen_company.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carkee/components/bottom_next_back_register.dart';
import 'package:carkee/components/item_upload.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/components/network_api.dart';
import 'package:dio/dio.dart' as Dioo;
import 'package:carkee/config/strings.dart';
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/models/ModelMemberOptionsResult.dart';
import 'package:carkee/screen/screens.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:mime/mime.dart';

//check later
//todo
//https://stackoverflow.com/questions/63205269/push-screen-bottom-on-top-of-keyboard-in-flutter-when-textfield-or-textformfield
class UpdatePart5Screen extends StatelessWidget {
  final UpdatePart5Controller controller = Get.put(UpdatePart5Controller());
  //
  // showPicker(context, @required bool isHavePDFOption, @required String type) {
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
      // appBar: PreferredSize(
      //     preferredSize: AppBarRightX().preferredSize,
      //     child: AppBarRightX(
      //       closeClicked: () {
      //         print("close clicked");
      //         Session.shared.changeRootViewToGuest();
      //       },
      //       title: "Just one final step!",
      //       subTitle: 'Membership payment',
      //     )),
      //
      body: SafeArea(
        child: Container(
          child: Column(children: [
            // LineStepRegister(totalStep: 6, currentStep: 5),
            AppNavigationV2(
              closeClicked: () {
                print("close clicked");
                Session.shared.changeRootViewToGuest();
              },
              title: "Just one final step!",
              subTitle: 'Membership payment',
              totalStep: 6,
              currentStep: 5,
            ),
            Obx(
              () => (controller.isLoadedMemberOptionsResult.value)
                  ? Expanded(
                      child: ListView(
                        children: [buildBody(context)],
                      ),
                    )
                  : Expanded(child: Center(child: CircularProgressIndicator())),
            ),
            BottomNextBackRegister(
              titleNext: 'Submit',
              isShowBack: true,
              nextClicked: () => controller.callAPIUpdate(),
              backClicked: () => Get.offAll(() => UpdatePart4Screen(),
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
          child: blur_background(context)),
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Amount payable:',
            style: Styles.mclub_TilteBlue,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
            decoration: BoxDecoration(
              color: Color(0xFF3C3C43).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Details:',
                        style: Styles.mclub_smallTilteBold,
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //member entri fee, fisr array
                      children: [
                        Flexible(
                            child: Html(
                                data: controller.modelMemberOptionsResult?.value
                                        ?.details?.first?.label ??
                                    "")),
                        // Text(
                        //   controller.modelMemberOptionsResult?.value?.details?.first?.label ?? "",
                        //   style: Styles.mclub_smallText,
                        // ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            controller.modelMemberOptionsResult?.value?.details
                                    ?.first?.amount ??
                                "",
                            style: Styles.mclub_smallText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //member entri fee, fisr array
                      children: [
                        (controller.modelMemberOptionsResult?.value?.details
                                    .isNull ==
                                false)
                            ? Flexible(
                                child: Html(
                                    data: controller.modelMemberOptionsResult
                                            ?.value?.details[1].label ??
                                        ""))
                            : SizedBox(),
                        // Flexible(child: Html(data: controller.modelMemberOptionsResult?.value?.details[1].label ?? "")),
                        SizedBox(
                          width: 80,
                          child: !controller.modelMemberOptionsResult?.value
                                  ?.details.isNull
                              ? Text(
                                  controller.modelMemberOptionsResult?.value
                                          ?.details[1]?.amount ??
                                      "",
                                  style: Styles.mclub_smallText,
                                )
                              : SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //member entri fee, fisr array
                      children: [
                        Spacer(),
                        Text(
                          'Total payable:',
                          style: Styles.mclub_smallTilteBold,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            controller.modelMemberOptionsResult?.value
                                    ?.totalPayable ??
                                "",
                            style: Styles.mclub_smallTilteBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Transaction Details',
              style: Styles.mclub_TilteBlue,
            ),
          ),
          Text(
            '1. Club Account',
            style: Styles.mclub_subTilteBlue,
          ),
          Text(
            "All membership fees payment can be transfered via PayNow to our club's account stated below:",
            style: Styles.mclub_normalText,
          ),
          Row(
            children: [
              Text(
                'Entity UEN: ${controller.modelMemberOptionsResult?.value?.entityEun ?? ""}',
                style: Styles.mclub_smallTilteBold,
              ),
              IconButton(
                  icon: Icon(
                    Icons.auto_awesome_motion,
                    color: Config.secondColor,
                  ),
                  onPressed: () {
                    Clipboard.setData(new ClipboardData(
                        text: controller
                                .modelMemberOptionsResult?.value?.entityEun ??
                            ""));
                    Get.snackbar('Entity UEN', 'Copied');
                  })
            ],
          ),
          Text(
            'Entity Name: ${controller.modelMemberOptionsResult?.value?.entityName ?? ""}',
            style: Styles.mclub_smallTilteBold,
          ),
          BottomLineMclub(),
          Text(
            '2. Your Reference Code',
            style: Styles.mclub_subTilteBlue,
          ),
          Text(
            "You MUST enter your reference code in the 'Reference number' text box on the transfer page. Otherwise, we won't be able to match your transfer to your account.",
            style: Styles.mclub_normalText,
          ),
          Obx(() => Row(
                children: [
                  Text(
                    controller.modelMemberOptionsResult?.value?.memberId ?? "",
                    style: Styles.mclub_smallTilteBold,
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.auto_awesome_motion,
                        color: Config.secondColor,
                      ),
                      onPressed: () {
                        print('Copy clipboard');
                        Clipboard.setData(new ClipboardData(
                            text: controller.modelMemberOptionsResult?.value
                                    ?.memberId ??
                                ""));
                        Get.snackbar('Your Reference Code', 'Copied');
                      })
                ],
              )),
          BottomLineMclub(),
          Text(
            '3. Upload Screenshot',
            style: Styles.mclub_subTilteBlue,
          ),
          Obx(() => XibItemUpload(
              line1:
                  'Upload Screenshot of the transaction \nwith full Transaction view',
              urlImage: controller
                  .profileController.userProfile.value.transferScreenshot,
              fileType: controller.profileController.userProfile.value
                  .transferScreenshotMimeType,
              onTap: () {
                print('show Popup choose source upload');
                // showPicker(context, true, Strings.transfer_screenshot);
                controller.typeUpload = Strings.transfer_screenshot;
                Session.shared.showImagePicker(context, isHavePDFOption: false,
                    callback: (file) {
                  controller._file = file;
                  controller._callAPIUploadImage();
                });
              })),
        ]),
      ),
    );
  }
}

class UpdatePart5Controller extends GetxController {
  var modelMemberOptionsResult = ModelMemberOptionsResult().obs;
  var isLoadedMemberOptionsResult = false.obs;
  final ProfileController profileController = Get.find();
  String typeUpload;
  File _file;
  final picker = ImagePicker();
  loadOldData() {}
  @override
  void onInit() {
    super.onInit();
    print('onInit UpdatePart5Controller');
    callApgetMemberOptions();
    loadOldData();
  }

  callApgetMemberOptions() async {
    print("UpdatePart1Controller start callApi");
    var network = NetworkAPI(
        endpoint: url_member_options,
        jsonQuery: {"access-token": await Session.shared.getToken()});
    var jsonRespondBody = await network.callAPIGET();
    if (jsonRespondBody["code"] == 100) {
      // print('jsonRespondBody $jsonRespondBody');
      isLoadedMemberOptionsResult.value = true;
      modelMemberOptionsResult.value =
          ModelMemberOptionsResult.fromJson(jsonRespondBody);
    } else {
      Session.shared.showAlertPopupOneButtonWithCallback(
          content: jsonRespondBody["message"] ?? "");
    }
  }

  callAPIUpdate() async {
    print("start callAPIUpdate part5");
    Session.shared.showLoading();
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      'step': 5,
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
      // await profileController.callAPIGetProfile();
      //Get.offAll(() =>MainTabbar());
      //go welcome
      Get.offAll(() => WelComeScreen(
            welcomeText: jsonBody["message"],
          ));
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }
  //
  // //HANDLE PICTURE UPLOAD
  // _chooseFile() async {
  //   FilePickerResult result = await FilePicker.platform.pickFiles(
  //       allowMultiple: false,
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf']);
  //   if (result != null) {
  //     // _file = File(result.files.single.path);
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
  //   await picker.getImage(source: ImageSource.camera, imageQuality: 50);
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

  // _imgFromGallery() async {
  //
  //   final pickedFile =
  //   await picker.getImage(source: ImageSource.gallery, imageQuality: 100);
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
    var jsonBody = await network.callAPI(
        method: "POST",
        percent: (percent) {
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

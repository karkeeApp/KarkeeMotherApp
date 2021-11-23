import 'dart:io';
import 'package:carkee/components/appbar_custom.dart';
import 'package:carkee/components/bottom_next_back_register.dart';
import 'package:carkee/components/item_upload.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/colors.dart';
import 'package:carkee/config/singleton.dart';
import 'package:carkee/config/styles.dart';
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/models/ModelMemberOptionsResult.dart';
import 'package:carkee/networks_app/url_app.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dio/dio.dart' as Dioo;

import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

import 'main_tab_bar.dart';

//check later
//todo
//https://stackoverflow.com/questions/63205269/push-screen-bottom-on-top-of-keyboard-in-flutter-when-textfield-or-textformfield
class RenewMembershipScreen extends StatefulWidget {
  final int code;
  RenewMembershipScreen({Key key, this.code}) : super(key: key);

  @override
  _RenewMembershipScreenState createState() => _RenewMembershipScreenState();
}

class _RenewMembershipScreenState extends State<RenewMembershipScreen> {
  final RenewMembershipController controller =
      Get.put(RenewMembershipController());

  File _file;
  String _fileType = "";
  File _logcard;
  String _logcardType = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: AppBarRightX().preferredSize,
          child: AppBarRightX(
            closeClicked: () {
              print("close clicked");
              if (Get.find<ProfileController>().isExpire()) {
                //expire thi` da ra ngoa`i
                Session.shared.changeRootViewToGuest();
              } else {
                Session.shared.changeRootViewToDashBoard();
              }
            },
            title: "",
            subTitle: 'Membership Renewal',
          )),
      body: Container(
        child: Column(children: [
          LineStepRegister(totalStep: 6, currentStep: 5),
          Expanded(
            child: ListView(
              children: [buildBody(context)],
            ),
          ),
          BottomNextBackRegister(
            titleNext: 'Submit',
            isShowBack: true,
            nextClicked: () =>
                controller.callAPISubmitRenew(_file, _logcard), //
            backClicked: () {
              if (widget.code == 123) {
                //is expire  = 123
                print('renew should not see me');
                Session.shared.changeRootViewToGuest(); //back is go guest
              } else if (widget.code == 321) {
                //nearby expire  = 321
                Session.shared.changeRootViewToDashBoard();
              } else {
                print('renew should not see me');
              }
              //neu nearby thi` vao app, neu expire thi` di vao login
            }, // back thi vao
          ),
        ]),

        // children: [],
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //member entri fee, fisr array
                    children: [
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Membership Renewal Rate"),
                      )),

                      // Flexible(child: Html(data: controller.modelMemberOptionsResult?.value?.details[1].label ?? "")),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          Get.find<ProfileController>()
                                  .userProfile
                                  .value
                                  .renewalFee
                                  .toString() ??
                              "",
                          style: Styles.mclub_smallText,
                        ),
                      ),
                    ],
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
          Obx(
            () => Row(
              children: [
                Text(
                  'Entity UEN: ${controller.modelMemberOptionsResult?.value?.entityEun ?? ""}',
                  style: Styles.mclub_smallTilteBold,
                ),
                IconButton(
                    icon: Icon(Icons.auto_awesome_motion),
                    onPressed: () {
                      Clipboard.setData(new ClipboardData(
                          text: controller
                                  .modelMemberOptionsResult?.value?.entityEun ??
                              ""));
                      Get.snackbar('Entity UEN', 'Copied');
                    })
              ],
            ),
          ),
          Obx(
            () => Text(
              'Entity Name: ${controller.modelMemberOptionsResult?.value?.entityName ?? ""}',
              style: Styles.mclub_smallTilteBold,
            ),
          ),
          BottomLineMclub(),
          Text(
            '2. Your Reference Code',
            style: Styles.mclub_subTilteBlue,
          ),
          Text(
            "Please input your car License Plate number into the reference field of your transfer.",
            style: Styles.mclub_normalText,
          ),
          // Obx(
          //   () => controller.isLoadedMemberOptionsResult.value ? Row(
          //     children: [
          //       Text(
          //         controller.modelMemberOptionsResult?.value?.memberId ?? "",
          //         style: Styles.mclub_smallTilteBold,
          //       ),
          //       IconButton(
          //           icon: Icon(Icons.auto_awesome_motion),
          //           onPressed: () {
          //             print('Copy clipboard');
          //             Clipboard.setData(new ClipboardData(
          //                 text: controller.modelMemberOptionsResult?.value
          //                     ?.memberId ??
          //                     ""));
          //             Get.snackbar('Your Reference Code', 'Copied');
          //           })
          //     ],
          //   ) : SizedBox(),
          // ),
          BottomLineMclub(),
          Text(
            '3. Upload Screenshot',
            style: Styles.mclub_subTilteBlue,
          ),
          XibItemUploadLater(
              line1:
                  'Upload Screenshot of the transaction \nwith full Transaction view',
              file: this._file,
              fileType: this._fileType,
              onTap: () {
                print('show Popup choose source upload');
                // showPicker(context, true, "");
                Session.shared.showImagePicker(context, isHavePDFOption: true,
                    callback: (file) {
                  //check extension
                  final extension = p.extension(file.path); // '.dart'
                  if (extension.toLowerCase() != ".pdf") {
                    setState(() {
                      _file = file;
                      _fileType = "";
                    });
                  } else {
                    setState(() {
                      _file = file;
                      _fileType = "application/pdf";
                    });
                  }
                });
                // Session.shared.sho
              }),
          BottomLineMclub(),
          Text(
            '4. Upload Log Card',
            style: Styles.mclub_subTilteBlue,
          ),
          XibItemUploadLater(
              line1: 'Registration Log Card (Issued by LTA)',
              file: this._logcard,
              fileType: this._logcardType,
              onTap: () {
                print('show Popup choose source upload');
                // showPicker(context, true, "");
                Session.shared.showImagePicker(context, isHavePDFOption: true,
                    callback: (file) {
                  final extension = p.extension(file.path); // '.dart'
                  if (extension.toLowerCase() != ".pdf") {
                    setState(() {
                      _logcard = file;
                      _logcardType = "";
                    });
                  } else {
                    setState(() {
                      _logcard = file;
                      _logcardType = "application/pdf";
                    });
                  }
                });

                // Session.shared.sho
              }),
        ]),
      ),
    );
  }
}

class RenewMembershipController extends GetxController {
  var modelMemberOptionsResult = ModelMemberOptionsResult().obs;
  var isLoadedMemberOptionsResult = false.obs;
  // final ProfileController profileController = Get.find();
  String typeUpload;
  final picker = ImagePicker();
  loadOldData() {}
  @override
  void onInit() {
    super.onInit();
    print('onInit RenewMembershipController');
    callApgetMemberOptions();
    loadOldData();
  }

  Future callApgetMemberOptions() async {
    print("Update Renew Controller start callApi");
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(
        endpoint: url_member_options,
    jsonQuery: jsonQuery);
    var jsonRespondBody = await network.callAPIGET();
    if (jsonRespondBody["code"] == 100) {
      // print('jsonRespondBody $jsonRespondBody');
      loadOldData();
      isLoadedMemberOptionsResult.value = true;
      modelMemberOptionsResult.value =
          ModelMemberOptionsResult.fromJson(jsonRespondBody);
    } else {
      Session.shared.showAlertPopupOneButtonWithCallback(
          content: jsonRespondBody["message"] ?? "");
    }
  }

  callAPISubmitRenew(File file, File logcard) async {
    if (file != null) {
      print("start callAPISubmitRenew");
      Session.shared.showLoading();
      Dioo.FormData formData = new Dioo.FormData.fromMap({
        "file":
        await Dioo.MultipartFile.fromFile(file.path, filename: file.name),
        "log_card": await Dioo.MultipartFile.fromFile(logcard.path,
            filename: logcard.name),
      });
      print("logcard.nam ${logcard.name}");
      print("file ${file.name}");
      Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
      var network = NetworkAPI(
          endpoint: url_member_renew, formData: formData, jsonQuery: jsonQuery);
      var jsonBody = await network.callAPIPOST(showLog: true);
      Session.shared.hideLoading();
      print("jsonBody $jsonBody");
      var code = jsonBody["code"] ?? 0;
      if (code == 100) {
        Session.shared.showAlertPopupOneButtonWithCallback(
            title: "Membership Renewal",
            content: jsonBody["message"],
            callback: () {
              Get.offAll(MainTabbar());
            });
        print("success ");
        // await profileController.callAPIGetProfile();
      } else {
        //check is 102 thi cho vao "code": 102,
        // I/flutter (19188): │ 🐛   "message": "We are now processing your renewal."
        if (code == 102) {
          Session.shared.showAlertPopupOneButtonWithCallback(
              title: "Membership Renewal",
              content: jsonBody["message"],
              callback: () {
                Get.offAll(MainTabbar());
              });
        } else {
          Session.shared.showAlertPopupOneButtonNoCallBack(
              title: "Error", content: jsonBody["message"]);
        }
      }
    } else {
      print("khong co file ko goi api");
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}

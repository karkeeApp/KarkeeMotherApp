import 'dart:io';
import 'dart:ui';
import 'package:carkee/models/ModelEventsResult.dart';
import 'package:carkee/models/ModelEventsResultV2.dart';
import 'package:carkee/screen/welcome_screen.dart';
import 'package:carkee/screen/welcome_screen_company.dart';
import 'package:carkee/util/utils.dart';
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
import 'package:path/path.dart' as p;
//check later
//todo
//https://stackoverflow.com/questions/63205269/push-screen-bottom-on-top-of-keyboard-in-flutter-when-textfield-or-textformfield
class UploadPaymentEvent extends StatefulWidget {
  final ModelEvent modelEvent;

  UploadPaymentEvent({Key key, this.modelEvent}) : super(key: key);

  @override
  _UploadPaymentEventState createState() => _UploadPaymentEventState();
}

class _UploadPaymentEventState extends State<UploadPaymentEvent> {
  final UploadPaymentEventController controller = Get.put(UploadPaymentEventController());

  @override
  Widget build(BuildContext context) {
    print('Start build');
    return image_background(context);
  }

  Widget body_view(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      // appBar: PreferredSize(
      //     preferredSize: AppBarRightX().preferredSize,
      //     child: AppBarRightX(
      //       closeClicked: () {
      //         print("close clicked");
      //         // Session.shared.changeRootViewToGuest();
      //       },
      //       title: "Event fee payment",
      //       subTitle: '',
      //     )),
      //
      appBar: AppBar(
        title: Text(
          "Join event",
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          child: Column(children: [
            // LineStepRegister(totalStep: 6, currentStep: 5),
            // AppNavigationV2(
            //   closeClicked: () {
            //     print("close clicked");
            //     Session.shared.changeRootViewToGuest();
            //   },
            //   title: "Just one final step!",
            //   subTitle: 'Membership payment',
            //   totalStep: 6,
            //   currentStep: 5,
            // ),
            // Obx(
            //   () => (true)
            //       ? Expanded(
            //           child: ListView(
            //             children: [buildBody(context)],
            //           ),
            //         )
            //       : Expanded(child: Center(child: CircularProgressIndicator())),
            // ),
            Expanded(
                child: ListView(
                  children: [buildBody(context)],
                ),
            ),

            BottomNextBackRegister(
              titleNext: 'Submit',
              isShowBack: true,
              nextClicked: () {
                print("clicked submit");
                controller.callAPIJoinEventwithImage(widget.modelEvent);
              },
              backClicked: () {
                Get.back();
              },
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //member entri fee, fisr array
                    children: [
                      Flexible(child: Html(data: 'Event fee payment ')),
                      // Flexible(
                      //     child: Html(
                      //         data: controller.modelMemberOptionsResult?.value
                      //                 ?.details?.first?.label ??
                      //             "")),
                      // Text(
                      //   controller.modelMemberOptionsResult?.value?.details?.first?.label ?? "",
                      //   style: Styles.mclub_smallText,
                      // ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          // "SGD 5000",
                          "SGD ${widget.modelEvent.eventFee}",
                          style: Styles.mclub_smallText,
                          textAlign: TextAlign.right,

                        ),
                      ),
                    ],
                  ),
                ),
                // Obx(
                //   () => Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 5),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       //member entri fee, fisr array
                //       children: [
                //
                //         Flexible(child: Html(data: "SGD 5000")),
                //         // SizedBox(
                //         //   width: 80,
                //         //   child: Text(
                //         //     "SGD 5000",
                //         //     style: Styles.mclub_smallText,
                //         //   ),
                //         // ),
                //       ],
                //     ),
                //   ),
                // ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                            // "SGD 5000",
                            "SGD ${widget.modelEvent.eventFee}",
                            style: Styles.mclub_smallTilteBold,
                            textAlign: TextAlign.right,
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
            "Event fee payment can be transfered via PayNow to our club's account stated below:",
            style: Styles.mclub_normalText,
          ),
          Row(
            children: [
              Text(
                'Club Account: ${widget.modelEvent.clubAccount}',
                style: Styles.mclub_smallTilteBold,
              ),
              // IconButton(
              //     icon: Icon(
              //       Icons.auto_awesome_motion,
              //       color: Config.secondColor,
              //     ),
              //     onPressed: () {
              //       Clipboard.setData(new ClipboardData(
              //           text: controller
              //               .modelMemberOptionsResult?.value?.entityEun ??
              //               ""));
              //       Get.snackbar('Entity UEN', 'Copied');
              //     })
            ],
          ),
          Text(
            'Account Id: ${widget.modelEvent.accountId}',
            style: Styles.mclub_smallTilteBold,
          ),
          // BottomLineMclub(),
          // Text(
          //   '2. Your Reference Code',
          //   style: Styles.mclub_subTilteBlue,
          // ),
          // Text(
          //   "You MUST enter your reference code in the 'Reference number' text box on the transfer page. Otherwise, we won't be able to match your transfer to your account.",
          //   style: Styles.mclub_normalText,
          // ),
          // Obx(() => Row(
          //       children: [
          //         Text(
          //           controller.modelMemberOptionsResult?.value?.memberId ?? "",
          //           style: Styles.mclub_smallTilteBold,
          //         ),
          //         IconButton(
          //             icon: Icon(
          //               Icons.auto_awesome_motion,
          //               color: Config.secondColor,
          //             ),
          //             onPressed: () {
          //               print('Copy clipboard');
          //               Clipboard.setData(new ClipboardData(
          //                   text: controller.modelMemberOptionsResult?.value
          //                           ?.memberId ??
          //                       ""));
          //               Get.snackbar('Your Reference Code', 'Copied');
          //             })
          //       ],
          //     )),
          // BottomLineMclub(),
          Text(
            '2. Upload Payment',
            style: Styles.mclub_subTilteBlue,
          ),
          // Obx(() => XibItemUpload(
          //     line1:
          //         'Upload Screenshot of the transaction \nwith full Transaction view',
          //     urlImage: "",
          //     fileType: "",
          //     onTap: () {
          //       print('show Popup choose source upload');
          //       // showPicker(context, true, Strings.transfer_screenshot);
          //       controller.typeUpload = Strings.transfer_screenshot;
          //       Session.shared.showImagePicker(context, isHavePDFOption: false,
          //           callback: (file) {
          //         controller._file = file;
          //         controller._callAPIUploadImage();
          //       });
          //     })),
          // Obx(() => XibItemUpload(
          //     line1:
          //     'Upload Screenshot of the transaction \nwith full Transaction view',
          //     urlImage: "",
          //     fileType: "",
          //     onTap: () {
          //       print('show Popup choose source upload');
          //       // showPicker(context, true, Strings.transfer_screenshot);
          //       controller.typeUpload = Strings.transfer_screenshot;
          //       Session.shared.showImagePicker(context, isHavePDFOption: false,
          //           callback: (file) {
          //             controller._file = file;
          //             controller._callAPIUploadImage();
          //           });
          //     })),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            // child: XibItemUpload(
            //     line1:
            //     'Upload Screenshot of the transaction \nwith full Transaction view',
            //     urlImage: "",
            //     fileType: "",
            //     onTap: () {
            //       print('show Popup choose source upload');
            //       // showPicker(context, true, Strings.transfer_screenshot);
            //       controller.typeUpload = Strings.transfer_screenshot;
            //       Session.shared.showImagePicker(context, isHavePDFOption: false,
            //           callback: (file) {
            //             controller._file = file;
            //             controller._callAPIUploadImage();
            //           });
            //     }),
            child : XibItemUploadLater(
                line1:
                'Upload Screenshot of the transaction \nwith full Transaction view',
                file: controller._file,
                fileType: "",
                onTap: () {
                  print('show Popup choose source upload');
                  // showPicker(context, true, "");
                  Session.shared.showImagePicker(context, isHavePDFOption: true,
                      callback: (file) {
                        //check extension
                        final extension = p.extension(file.path); // '.dart'

                        if (extension.toLowerCase() != ".pdf") {

                          setState(() {
                            controller._file = file;
                            controller.typeUpload = "";
                          });

                        } else {
                          setState(() {
                            controller._file = file;
                            controller.typeUpload = "application/pdf";
                          });

                        }
                      });
                  // Session.shared.sho
                }),
          ),
        ]),
      ),
    );
  }
}

class UploadPaymentEventController extends GetxController {
  var modelMemberOptionsResult = ModelMemberOptionsResult().obs;
  var isLoadedMemberOptionsResult = false.obs;
  // final ProfileController profileController = Get.find();
  String typeUpload;
  File _file;
  final picker = ImagePicker();
  loadOldData() {}
  @override
  void onInit() {
    super.onInit();
    print('onInit UpdatePart5Controller');
    // callApgetMemberOptions();
    loadOldData();
  }

  callAPIJoinEventwithImage(ModelEvent model) async {

    //check if file null not allow

    if (_file == null) {
      return;
    }

    // Session.shared.showLoading();
    print("start callAPIJoinEventwithImage");
    //get Type
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      "file":
          await Dioo.MultipartFile.fromFile(_file.path, filename: _file.name),
      'event_id' : model.eventId
    });
    Map<String, dynamic> jsonQuery = {
      "access-token": await Session.shared.getToken()
    };
    var network = NetworkAPI(
        endpoint: 'event/join-with-image',
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
      EasyLoading.showSuccess(jsonBody["message"]);
      Utils().getEventController().modelEvent.value.isAttendee = jsonBody["is_attendee"];
      Utils().getEventController().modelEvent.refresh();
      Get.back();
      // profileController.callAPIGetProfile(); //refresh
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

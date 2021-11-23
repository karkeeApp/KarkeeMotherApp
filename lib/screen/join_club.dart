// import 'dart:io';
// import 'dart:ui';
//
// import 'package:carkee/components/bottom_next_back_register.dart';
// import 'package:carkee/components/item_upload.dart';
// import 'package:carkee/config/strings.dart';
// import 'package:carkee/screen/welcome_screen_company.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:carkee/components/TextFieldPhungNoBorder.dart';
// import 'package:carkee/config/app_configs.dart';
// import 'package:carkee/components/network_api.dart';
// import 'package:dio/dio.dart' as Dioo;
// import 'package:carkee/controllers/controllers.dart';
//
// class JoinClub extends StatefulWidget {
//   @override
//   _JoinClubState createState() => _JoinClubState();
// }
//
// class _JoinClubState extends State<JoinClub> {
//   TextEditingController textController = TextEditingController();
//   var club_code = TextEditingController();
//   var club_answer1 = TextEditingController();
//   var club_answer2 = TextEditingController();
//   final ProfileController profileController = Get.find();
//   String typeUpload = Strings.club_logo;
//   File _file;
//   final picker = ImagePicker();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('Start build');
//     return image_background(context);
//   }
//
//   Widget image_background(BuildContext context) {
//     //return Center(child: CircularProgressIndicator());
//     return Material(
//       child: Container(
//           // color: Colors.red,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage("assets/images/bg_2.png"), fit: BoxFit.cover),
//           ),
//           child: blur_background(context)),
//     );
//   }
//
//   Widget blur_background(BuildContext context) {
//     //return Center(child: CircularProgressIndicator());
//     return BackdropFilter(
//       filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.8),
//         ),
//         child: body_view(context),
//       ),
//     );
//   }
//
//   Widget body_view(BuildContext context) {
//     print('Start build');
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: SafeArea(
//         child: Container(
//           child: Column(children: [
//             // LineStepRegister(totalStep: 4, currentStep: 1),
//             AppNavigationV2(
//               closeClicked: () {
//                 print("close clicked");
//                 Get.back(); //if onboard then
//               },
//               title: "Membership Application",
//               subTitle: 'Submit the information we need to set your app up!',
//               totalStep: 0,
//               //hide it
//               currentStep: 3,
//             ),
//             Expanded(
//               child: ListView(
//                 children: [section1(context)],
//               ),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
//
//   Widget section1(BuildContext context) {
//     return Padding(
//       padding:
//           const EdgeInsets.symmetric(horizontal: Config.kDefaultPadding * 2),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             children: [
//               TextFieldPhungNoBorder(
//                 controller: club_code,
//                 labelText: "Club Code",
//                 hintText: "",
//                 onChange: (value) {
//                   print(value);
//                   club_code.text = value;
//                 },
//                 notAllowEmpty: true,
//               ),
//             ],
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 10),
//                 child: Wrap(children: [
//                   Text(
//                     'Question 1: ',
//                     style: Styles.mclub_UPCASETilte,
//                   ),
//                   Text(
//                     'Where are you ?',
//                     style: Styles.mclub_UPCASETilte,
//                   )
//                 ]),
//               ),
//               TextFieldPhungNoBorder(
//                 controller: club_answer1,
//                 labelText: "Answer",
//                 hintText: "",
//                 onChange: (value) {
//                   print(value);
//                   club_answer1.text = value;
//                 },
//                 notAllowEmpty: true,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 10),
//                 child: Wrap(children: [
//                   Text(
//                     'Question 2: ',
//                     style: Styles.mclub_UPCASETilte,
//                   ),
//                   Text(
//                     'How are you ?',
//                     style: Styles.mclub_UPCASETilte,
//                   )
//                 ]),
//               ),
//               TextFieldPhungNoBorder(
//                 controller: club_answer2,
//                 labelText: "Answer",
//                 hintText: "",
//                 onChange: (value) {
//                   print(value);
//                   club_answer2.text = value;
//                 },
//                 notAllowEmpty: true,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 10, bottom: 10),
//                 child: Text(
//                   'Take a photo of your car',
//                   style: Styles.mclub_UPCASETilte,
//                 ),
//               ),
//               Obx(() => XibItemUpload(
//                   line1: 'Upload',
//                   urlImage: profileController.userProfile.value.club_logo,
//                   fileType:
//                       profileController.userProfile.value.imgProfileMimeType,
//                   line3: "Jpeg, jpg, png, gif (Max. 5MB)",
//                   onTap: () {
//                     print('show Popup choose source upload');
//                     // showImagePicker(context, false, Strings.club_logo);
//                     typeUpload = Strings.club_logo;
//                     Session.shared.showImagePicker(context,
//                         isHavePDFOption: false, callback: (file) {
//                       print("callback ddddddd");
//                       _callAPIUploadImage();
//                       setState(() {
//                         _file = file;
//                       });
//                       // _callAPIUploadImage();
//                     });
//                   })),
//               BottomLineMclub(),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                     vertical: Config.kDefaultPadding),
//                 child: BlackButton(
//                   callbackOnPress: () {
//                     FocusScope.of(context).unfocus();
//                     print('Register Member CLub');
//                   },
//                   title: "Submit",
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   callAPIJoin_Club() async {
//     Session.shared.showLoading();
//     print("start ");
//     Dioo.FormData formData =
//         new Dioo.FormData.fromMap({'club_code': club_code.text,
//         'answers[]' :  club_answer1.text,
//           'answers[]': club_answer2.text,
//
//         });
//     Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
//     var network = NetworkAPI(
//         endpoint: url_member_join_club,
//         formData: formData,
//         jsonQuery: jsonQuery);
//     var jsonBody = await network.callAPIPOST();
//     Session.shared.hideLoading();
//     if (jsonBody["code"] == 100) {
//       print("success $jsonBody go next Thanks You");
//       Get.offAll(() => WelComeCompanyScreen());
//     } else {
//       Session.shared.showAlertPopupOneButtonNoCallBack(
//           title: "Error", content: jsonBody["message"]);
//     }
//   }
//
//   _callAPIUploadImage() async {
//     // Session.shared.showLoading();
//     print("start _callAPIUploadImage");
//     //get Type
//     Dioo.FormData formData = new Dioo.FormData.fromMap({
//       "file":
//           await Dioo.MultipartFile.fromFile(_file.path, filename: _file.name),
//       'field': typeUpload,
//     });
//     Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
//     var network = NetworkAPI(
//         endpoint: url_member_upload_doc,
//         formData: formData,
//         jsonQuery: jsonQuery);
//     var jsonBody = await network.callAPI(
//         method: "POST",
//         percent: (percent) {
//           print(percent);
//           if (percent != 1) {
//             EasyLoading.showProgress(percent, status: 'Uploading..');
//           } else {
//             EasyLoading.dismiss(animation: true);
//           }
//         });
//     // Session.shared.hideLoading();
//     if (jsonBody["code"] == 100) {
//       print("success $jsonBody");
//       profileController.callAPIGetProfile(); //refresh
//     } else {
//       Session.shared.showAlertPopupOneButtonNoCallBack(
//           title: "Error", content: jsonBody["message"]);
//     }
//   }
// }

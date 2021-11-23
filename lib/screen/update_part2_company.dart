// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:country_picker/country_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_picker/flutter_picker.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:carkee/components/TextFieldPhungNoBorder.dart';
// import 'package:carkee/components/bottom_next_back_register.dart';
// import 'package:carkee/config/app_configs.dart';
// import 'package:carkee/components/network_api.dart';
// import 'package:dio/dio.dart' as Dioo;
// import 'package:carkee/controllers/controllers.dart';
// import 'package:carkee/models/ModelMemberOptionsResult.dart';
// import 'package:carkee/screen/update_part1_company.dart';
// import 'package:carkee/screen/update_part2_personal.dart';
//
// class UpdatePart2CompanyScreen extends StatelessWidget {
//   final UpdatePart2CompanyController controller = Get.put(UpdatePart2CompanyController());
//   @override
//   Widget build(BuildContext context) {
//     print('Start build');
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: AppBarRightX().preferredSize,
//           child: AppBarRightX(
//             closeClicked: () {
//               print("close clicked");
//               Session.shared.changeRootViewToGuest();
//             },
//             title: "Representative Details",
//             subTitle:
//                 'Tell us more by providing the following basic personal details.',
//           )),
//       body: Container(
//         child: Column(children: [
//           LineStepRegister(totalStep: 4, currentStep: 2),
//           Expanded(
//             child: ListView(
//               children: [
//                 //section1
//                 section2(context),
//                 // section1(context),
//
//                 // buildFormBuilder(context)
//                 // buildBody(context)
//               ],
//             ),
//           ),
//           BottomNextBackRegister(
//             isShowBack: true,
//             backClicked: () => Get.off(UpdatePart1CompanyScreen(), transition: Transition.leftToRight),
//             nextClicked: () => controller.callAPIUpdate(),
//           )
//         ]),
//
//         // children: [],
//       ),
//     );
//   }
//
//   // Widget section1(BuildContext context) {
//   //   return Padding(
//   //     padding: const EdgeInsets.symmetric(horizontal: Config.kDefaultPadding * 2),
//   //     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//   //       Text(
//   //         'Residential Address',
//   //         style: Styles.mclub_Tilte,
//   //       ),
//   //       //country picker
//   //       PickerMclub(
//   //         controller: controller.countryController,
//   //         titleValue: 'Country',
//   //         onTap: () {
//   //           _showPickerCountry(context);
//   //         },
//   //       ),
//   //       Row(
//   //         children: [
//   //           Expanded(
//   //             child: FormBuilderTextField(
//   //               initialValue: controller.postal_code,
//   //               autocorrect: false,
//   //               name: 'postal_code',
//   //               decoration: InputDecoration(
//   //                   labelText: "Postal Code",
//   //                   labelStyle: Styles.mclub_inputTextStyle),
//   //               onChanged: (value) {
//   //                 controller.postal_code = value;
//   //                 print(value);
//   //               },
//   //               // validator: FormBuilderValidators.compose([
//   //               //   FormBuilderValidators.required(context),
//   //               // ]),
//   //               keyboardType: TextInputType.number,
//   //             ),
//   //           ),
//   //           SizedBox(
//   //             width: 5,
//   //           ),
//   //           Expanded(
//   //             child: FormBuilderTextField(
//   //               initialValue: controller.unit_no,
//   //               autocorrect: false,
//   //               name: 'unit_no',
//   //               decoration: InputDecoration(
//   //                   labelText: "Unit No",
//   //                   labelStyle: Styles.mclub_inputTextStyle),
//   //               onChanged: (value) {
//   //                 controller.unit_no = value;
//   //                 print(value);
//   //               },
//   //               // validator: FormBuilderValidators.compose([
//   //               //   FormBuilderValidators.required(context),
//   //               // ]),
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //       FormBuilderTextField(
//   //         initialValue: controller.add_1,
//   //         autocorrect: false,
//   //         name: 'add_1',
//   //         decoration: InputDecoration(
//   //             labelText: "Address Line 1",
//   //             labelStyle: Styles.mclub_inputTextStyle),
//   //         onChanged: (value) {
//   //           controller.add_1 = value;
//   //           print(value);
//   //         },
//   //         // validator: FormBuilderValidators.compose([
//   //         //   FormBuilderValidators.required(context),
//   //         // ]),
//   //       ),
//   //       FormBuilderTextField(
//   //         initialValue: controller.add_2,
//   //         autocorrect: false,
//   //         name: 'add_2',
//   //         decoration: InputDecoration(
//   //             labelText: "Address Line 2",
//   //             labelStyle: Styles.mclub_inputTextStyle),
//   //         onChanged: (value) {
//   //           controller.add_2 = value;
//   //           print(value);
//   //         },
//   //       )
//   //     ]
//   //     ),
//   //   );
//   // }
//
//   Widget section2(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(Config.kDefaultPadding * 2),
//       child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             Text(
//               'Personal Details',
//               style: Styles.mclub_Tilte,
//             ),
//             SizedBox(height: 10,),
//             FormBuilderRadioGroup(
//               initialValue: controller.gender == 'm'
//                   ? 'Male'
//                   : (controller.gender == 'f' ? 'Female' : ""),
//
//               decoration: InputDecoration(
//                   labelText: 'Gender', contentPadding: EdgeInsets.zero),
//               name: 'gender',
//               onChanged: (currentValue) {
//                 print(currentValue);
//                 if (currentValue == 'Male') {
//                   controller.gender = 'm';
//                 } else if (currentValue == 'Female') {
//                   controller.gender = 'f';
//                 }
//               },
//               // validator: FormBuilderValidators.required(context),
//               options: [
//                 'Male',
//                 'Female',
//               ]
//                   .map((lang) => FormBuilderFieldOption(value: lang))
//                   .toList(growable: false),
//             ),
//
//             //Date of birth Picker
//             PickerMclub(
//               // initialValue : controller.birthday,
//               controller: controller.birthdayController,
//               titleValue: 'Date of Birth',
//               onTap: () {
//                 // _showPickerDate(context);
//                 Session.shared.showPickerDate(context, (date) {
//                   controller.handleAfterPickerDate(date);
//                 });
//               },
//             ),
//             TextFieldPhungNoBorder(
//               controller: controller.nric,
//               labelText: "NRIC",
//               hintText: "",
//               onChange: (value) {
//                 print(value);
//                 controller.nric.text = value;
//               },
//             ),
//         ]),
//     );
//   }
//
//   // _showPickerDate(BuildContext context) {
//   //   Picker(
//   //       hideHeader: true,
//   //       adapter: DateTimePickerAdapter(
//   //           yearBegin: 1900, yearEnd: Session.shared.getMinAllowYear()),
//   //       selectedTextStyle: TextStyle(color: Config.secondColor),
//   //       onConfirm: (Picker picker, List value) {
//   //         DateTime chooseDate = (picker.adapter as DateTimePickerAdapter).value;
//   //         print(chooseDate);
//   //         controller.handleAfterPickerDate(chooseDate);
//   //       }).showDialog(context);
//   // }
//
//   _showPickerCountry(BuildContext context) {
//     showCountryPicker(
//       //Có thể sau này dùng lại loic showCountryPicker xem trong source và chôm lại ý tưởng!
//       context: context,
//       showPhoneCode:
//       true, // optional. Shows phone code before the country name.
//       onSelect: (Country country) {
//         print('Select country: ${country.displayName}');
//         print('Select Code: ${country.countryCode}');
//         var contrySelected = country.name;
//         controller.countryController.text = contrySelected;
//         // controller.country = contrySelected;
//         // print('codeMobile $codeMobile');
//       },
//     );
//   }
// }
//
// class UpdatePart2CompanyController extends GetxController {
//   final ProfileController profileController = Get.find();
//
//   final countryController = TextEditingController();
//   final birthdayController = TextEditingController();
//   final salaryController = TextEditingController();
//   var postal_code = TextEditingController();
//   var unit_no = TextEditingController();
//   var add_1 = TextEditingController();
//   var add_2 = TextEditingController();
//   var gender = '';
//   var nric = TextEditingController();
//   var profession = TextEditingController();
//   var company = TextEditingController();
//   var isHaveDataMemberOptions = false.obs;
//
//   var modelMemberOptionsResult = ModelMemberOptionsResult().obs;
//   final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
//
//   @override
//   void onInit() {
//     loadOldData();
//     super.onInit();
//   }
//
//   loadOldData() {
//     countryController.text = profileController.userProfile.value.country;
//     postal_code.text = profileController.userProfile.value.postalCode;
//     unit_no.text = profileController.userProfile.value.unitNo;
//     add_1.text = profileController.userProfile.value.add1;
//     add_2.text = profileController.userProfile.value.add2;
//     gender = profileController.userProfile.value.gender;
//     birthdayController.text = profileController.userProfile.value.birthday;
//     nric.text = profileController.userProfile.value.nric;
//     print(profileController.userProfile.value.toJson());
//   }
//
//   handleAfterPickerDate(DateTime chooseDate) {
//     var formatter = new DateFormat('yyyy-MM-dd');
//     String formattedDate = formatter.format(chooseDate);
//     birthdayController.text = formattedDate;
//     // birthday = formattedDate;
//   }
//
//   callAPIUpdate() async {
//     Session.shared.showLoading();
//     print("start callAPIUpdate");
//     //hide keyboard!
//     Dioo.FormData formData = new Dioo.FormData.fromMap({
//       'step': 2,
//       "country": countryController.text,
//       'postal_code': postal_code,
//       'unit_no': unit_no,
//       'add_1': add_1,
//       "add_2": add_2,
//       "gender": gender,
//       "birthday": birthdayController.text,
//       "nric": nric,
//     });
//     Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
//     var network = NetworkAPI(
//         endpoint: url_update_company_onboarding,
//         formData: formData,
//         jsonQuery: jsonQuery);
//     var jsonBody = await network.callAPIPOST();
//     Session.shared.hideLoading();
//     if (jsonBody["code"] == 100) {
//       print("success callAPIUpdate");
//       await profileController.callAPIGetProfile();
//       // Get.offAll(() =>UpdatePart2Screen());
//     } else {
//       Session.shared.showAlertPopupOneButtonNoCallBack(
//           title: "Error", content: jsonBody["message"]);
//     }
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//   }
// }
//
// var LISTDEMO = ['1', '2', '3'];

import 'dart:io';
import 'dart:ui';
import 'package:carkee/components/TextFieldPhungNoBorder.dart';
import 'package:carkee/screen/update_part1_company.dart';
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

import 'add_director_screen.dart';
import 'update_part3_company.dart';

//check later
//todo
//https://stackoverflow.com/questions/63205269/push-screen-bottom-on-top-of-keyboard-in-flutter-when-textfield-or-textformfield
class UpdatePart2CompanyScreen extends StatefulWidget {
  @override
  _UpdatePart2CompanyScreenState createState() =>
      _UpdatePart2CompanyScreenState();
}

class _UpdatePart2CompanyScreenState extends State<UpdatePart2CompanyScreen> {
  final UpdatePart2CompanyController controller =
      Get.put(UpdatePart2CompanyController());
  showPopupAddDirector({Directors director}) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          // return Wrap(children: [LoginScreenV2()]);
          return AddDirectorScreen(
            director: director,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print('Start build');
    return image_background(context);
  }

  directorItem(BuildContext context, int index) {
    var item = controller.profileController.userProfile.value.directors[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Config.primaryColor, width: 0.5)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Full name"),
                    Spacer(),
                    IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          print("delete clicked");
                          var id = item.directorId;
                          Session.shared.showAlertPopup2ButtonWithCallback(
                              title: "Delete id $id",
                              content: "Are you sure?",
                              callback: () {
                                controller.callAPIDelete(id);
                              });
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.edit,
                        ),
                        onPressed: () {
                          print("edit clicked");
                          showPopupAddDirector(director: item);
                        }),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    controller.profileController.userProfile.value
                        .directors[index].fullname,
                    style: Styles.mclub_subTilteBlackBoldItalic,
                  ),
                ),
                Text("Email"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    controller.profileController.userProfile.value
                        .directors[index].email,
                    style: Styles.mclub_subTilteBlackBoldItalic,
                  ),
                ),
                Text("Phone"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    getFullPhoneDirector(index),
                    style: Styles.mclub_subTilteBlackBoldItalic,
                  ),
                ),
                Text("Type"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    getTypeDirector(index),
                    style: Styles.mclub_subTilteBlackBoldItalic,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  getFullPhoneDirector(int index) {
    var c = controller
        .profileController.userProfile.value.directors[index].mobileCode;
    var p = controller
        .profileController.userProfile.value.directors[index].mobileNo;
    return "$c$p";
  }

  getTypeDirector(int index) {
    var isDirector = controller
        .profileController.userProfile.value.directors[index].isDirector;
    var isShareholder = controller
        .profileController.userProfile.value.directors[index].isShareholder;
    return isDirector ? "Director" : (isShareholder ? "Shareholder" : "");
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
              totalStep: 4,
              currentStep: 2,
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
              titleNext: 'Next',
              isShowBack: true,
              nextClicked: () => controller.callAPIUpdate(),
              backClicked: () => Get.offAll(() =>UpdatePart1CompanyScreen(),
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

                Obx(() {
                   return Padding(
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
                   );
                }),

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
          SizedBox(
            height: 10,
          ),
          Obx(() => XibItemUpload(
              line1: 'Club/Company Logo',
              urlImage:
                  controller.profileController.userProfile.value.company_logo,
              fileType: controller
                  .profileController.userProfile.value.imgProfileMimeType,
              onTap: () {
                print('show Popup choose source upload');
                // showPicker(context, false, Strings.company_logo);
                controller.typeUpload = Strings.company_logo;
                Session.shared.showImagePicker(context, isHavePDFOption: false,
                    callback: (file) {
                  controller._file = file;
                  controller._callAPIUploadImage();
                });
              })),
          SizedBox(
            height: 10,
          ),
          Obx(() => XibItemUpload(
              line1: 'Copy of ACRA Business Profile (BizFile)',
              urlImage: controller.profileController.userProfile.value.imgAcra,
              fileType: controller
                  .profileController.userProfile.value.imgAcraMimeType,
              onTap: () {
                print('show Popup choose source upload');
                // showPicker(context, true, Strings.img_acra);
                controller.typeUpload = Strings.img_acra;
                Session.shared.showImagePicker(context, isHavePDFOption: true,
                    callback: (file) {
                  controller._file = file;
                  controller._callAPIUploadImage();
                });
              })),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Director/Shareholder',
              style: Styles.mclub_TilteBlue,
            ),
          ),

          OutlineButton(
            onPressed: () {
              showPopupAddDirector();
              print('Received click');
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                side: BorderSide(color: Colors.red)),
            child: Row(children: [
              Icon(Icons.add),
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text('Add'),
              )
            ]),
          ),
          //List builder
          if (controller.profileController.userProfile.value.directors != null) Obx(() {
            return getListDirector();
          }),
        ]),
      ),
    );
  }

  getListDirector() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount:
            controller.profileController.userProfile.value.directors.length,
        // itemCount: 20,//controller.profileController.userProfile.value.directors.length,
        itemBuilder: (context, index) {
          // return  Text('Some text');
          return directorItem(context, index);
        });
  }
}

class UpdatePart2CompanyController extends GetxController {
  var modelMemberOptionsResult = ModelMemberOptionsResult().obs;
  var isLoadedMemberOptionsResult = false.obs;
  final ProfileController profileController = Get.find();
  String typeUpload;
  File _file;
  final picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    print('onInit UpdatePart5Controller');
    callApgetMemberOptions();
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
    print("start callAPIUpdate part2");
    Session.shared.showLoading();
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      'step': 2,
    });
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(
        endpoint: url_update_company_onboarding,
        formData: formData,
        jsonQuery: jsonQuery);
    var jsonBody = await network.callAPIPOST();
    Session.shared.hideLoading();
    if (jsonBody["code"] == 100) {
      print("success ");
      // await profileController.callAPIGetProfile();
      //Get.offAll(() =>MainTabbar());
      //go welcome
      Get.offAll(() =>UpdatePart3CompanyScreen());
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }

  callAPIDelete(int id) async {
    //clear all old data
    Session.shared.showLoading();
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      'director_id': id.toString(),
    });
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(
        endpoint: url_member_delete_director,
        formData: formData,
        jsonQuery: jsonQuery);
    var jsonBody = await network.callAPIPOST();
    Session.shared.hideLoading();
    if (jsonBody["code"] == 100) {
      print("callAPIDelete success, refresh list");
      await profileController.callAPIGetProfile();
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          content: jsonBody["message"] ?? "Something went wrong");
    }
  }

  //HANDLE PICTURE UPLOAD
  _chooseFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf']);
    if (result != null) {
      // _file = File(result.files.single.path);
      // _callAPIUploadImage();
      _file = File(result.files.single.path);
      var fileType = lookupMimeType(result.files.single.path);
      print(fileType);
      if (fileType == 'application/pdf') {
        _callAPIUploadImage();
      } else {
        Session.shared
            .showAlertPopupOneButtonNoCallBack(content: "File not support");
      }
    } else {
      // User canceled the picker
      print('No file selected.');
    }
  }

  _imgFromGallery() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (result != null) {
      // _file = File(result.files.single.path);
      // _callAPIUploadImage();
      _file = File(result.files.single.path);
      if (Session.shared.isFileSizeUnder5MB(_file)) {
        var fileType = lookupMimeType(result.files.single.path);
        print(fileType);
        _callAPIUploadImage();
      } else {
        _file = null;
        Session.shared.showAlertPopupOneButtonNoCallBack(
            title: "Error", content: "File not allow > 5MB");
      }
    } else {
      print('No file selected.');
    }
  }

  //
  _imgFromCamera() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      print('upload now');
      _file = File(pickedFile.path);
      // _callAPIUploadImage();
      if (Session.shared.isFileSizeUnder5MB(_file)) {
        print('upload now');
        //upload now
        _callAPIUploadImage();
      } else {
        Session.shared.showAlertPopupOneButtonNoCallBack(
            title: "Error", content: "File not allow > 5MB");
      }
    } else {
      Session.shared.hideLoading();
      print('No image selected.');
    }
  }
  //
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

import 'dart:ui';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:carkee/components/TextFieldPhungNoBorder.dart';
import 'package:carkee/components/bottom_next_back_register.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/components/network_api.dart';
import 'package:dio/dio.dart' as Dioo;
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/models/ModelMemberOptionsResult.dart';
import 'package:carkee/screen/screens.dart';

class UpdatePart3Screen extends StatelessWidget {
  final UpdatePart3Controller controller = Get.put(UpdatePart3Controller());


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
            // LineStepRegister(totalStep: 6, currentStep: 3),
            AppNavigationV2(
              closeClicked: () {
                print("close clicked");
                Session.shared.changeRootViewToGuest();
              },
              title: "Let us know who to contact",
              subTitle: 'In an emergency, tell us who we can contact.',
              totalStep: 6,
              currentStep: 3,
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Config.kDefaultPadding * 2),
                    child: buildFormBuilder(context),
                  ),
                  Obx(() {
                    print("listening");
                    var numberItem = (controller?.modelMemberOptionsResult?.value
                        ?.relationships?.length?.isNullOrBlank ==
                        false);
                    return numberItem
                        ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: FormBuilderRadioGroup(
                        initialValue: controller.getRelationship_textFromID(controller.relationship_id),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          border: InputBorder.none,
                        ),
                        orientation: OptionsOrientation.vertical,
                        // name: 'are_you_owner',
                        onChanged: (currentValue) {
                          print(currentValue);
                          var item = controller
                              ?.modelMemberOptionsResult?.value?.relationships
                              ?.firstWhere(
                                  (element) => element.value == currentValue);
                          controller.relationship_id = item.id;
                          // print('id get ${controller.are_you_owner}');
                        },
                        options: getListOptions_Widget(),
                      ),
                    )
                        : Session.shared.EmptyBox();
                  }),

                ],

              ),
            ),
            BottomNextBackRegister(
              isShowBack: true,
              nextClicked: () => controller.callAPIUpdate(),
              backClicked: () => Get.offAll(() =>UpdatePart2Screen(),
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


  _showPickerCountry(BuildContext context) {
    showCountryPicker(
      //Có thể sau này dùng lại loic showCountryPicker xem trong source và chôm lại ý tưởng!
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        print('Select country: ${country.displayName}');
        print('Select Code: ${country.countryCode}');
        var codeSelected = country.phoneCode;
        controller.emergencyCodeController.text = '+$codeSelected';
        // controller.country = contrySelected;
        // print('codeMobile $codeMobile');
      },
    );
  }

  List<FormBuilderFieldOption> getListOptions_Widget() {
    List<FormBuilderFieldOption> list = [];
    var list_ = controller.modelMemberOptionsResult?.value.relationships;
    for (var i = 0; i < list_.length; i++) {
      var item = FormBuilderFieldOption(
        value: list_[i].value,
        child: Text(list_[i].value),
      );
      list.add(item);
    }
    return list;
  }

  FormBuilder buildFormBuilder(BuildContext context) {
    return FormBuilder(
      key: controller._fbKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emergency Contact Details',
            style: Styles.mclub_Tilte,
          ),
          SizedBox(
            height: 10,
          ),

          TextFieldPhungNoBorder(
            controller: controller.contact_person,
            labelText: "Name of person to contact in case of emergency",
            hintText: "",
            onChange: (value) {
              print(value);
              controller.contact_person.text = value;
            },
          ),

          //PHONE

          Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
            SizedBox(
              width: 100,
              child: PickerMclub(
                controller: controller.emergencyCodeController,
                titleValue: 'Country Code',
                onTap: () {
                  _showPickerCountry(context);
                },
              ),
            ),
            SizedBox(width: 5,),
            Flexible(
              child: SizedBox(
                child: TextFieldPhungNoBorder(
                  keyboardType: TextInputType.number,
                  controller: controller.emergency_no,
                  labelText: "Emergency Contact No.",
                  hintText: "",
                  onChange: (value) {
                    print(value);
                    controller.emergency_no.text = value;
                  },
                ),
              ),
            ),

          ]),
          Text(
            'Emergency contact should preferably not be a regular companion/participant at club activities.',
            style: Styles.mclub_normalBodyText,
          ),
        ],
      ),
    );
  }
}

class UpdatePart3Controller extends GetxController {
  final ProfileController profileController = Get.find();
  final emergencyCodeController = TextEditingController();
  // final regDateController = TextEditingController();
  var contact_person = TextEditingController();
  var emergency_no = TextEditingController();
  // var emergency_code = '';
  // var registration_code = '';

  int relationship_id;
  var relationship_text = '';
  var modelMemberOptionsResult = ModelMemberOptionsResult().obs;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  loadOldData() {
    // regDateController.text = profileController.userProfile.value.registrationCode;
    contact_person.text = profileController.userProfile.value.contactPerson;
    emergency_no.text = profileController.userProfile.value.emergencyNo;
    emergencyCodeController.text =
        profileController.getEmergencyCode();
    relationship_id = profileController.getRelationshipInt();
    print('start debug');
    print(profileController.userProfile.value.relationship);
    print(relationship_text);
  }
  getRelationship_textFromID(int id) {
    if (relationship_id.isNullOrBlank == false) {
      var item = modelMemberOptionsResult.value.relationships.firstWhere((element) => element.id == id);
      return item.value;
    } else {
      return null;

    }
  }

  @override
  void onInit() {
    super.onInit();
    print('onInit UpdatePart3Controller');
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
      modelMemberOptionsResult.value =
          ModelMemberOptionsResult.fromJson(jsonRespondBody);
    } else {
      Session.shared.showAlertPopupOneButtonWithCallback(
          content: jsonRespondBody["message"] ?? "");
    }
  }

  callAPIUpdate() async {
    Session.shared.showLoading();
    print("start callAPIUpdate");
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      'step': 3,
      "contact_person": contact_person.text,
      'emergency_no': emergency_no.text,
      'emergency_code': emergencyCodeController.text,
      'relationship': relationship_id
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
      // print(jsonBody);//for debug
      //after save refresh data
      await profileController.callAPIGetProfile();
      Get.offAll(() =>UpdatePart4Screen());

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

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:carkee/components/TextFieldPhungNoBorder.dart';
import 'package:carkee/components/bottom_next_back_register.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/components/network_api.dart';
import 'package:dio/dio.dart' as Dioo;
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/models/ModelMemberOptionsResult.dart';
import 'package:carkee/screen/update_part1_personal.dart';
import 'package:carkee/screen/update_part3_personal.dart';

class UpdatePart2Screen extends StatelessWidget {
  final UpdatePart2Controller controller = Get.put(UpdatePart2Controller());

  _showPickerDate(BuildContext context) {
    Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(),
        selectedTextStyle: TextStyle(color: Config.secondColor),
        onConfirm: (Picker picker, List value) {
          DateTime chooseDate = (picker.adapter as DateTimePickerAdapter).value;
          print(chooseDate);
          controller.handleAfterPickerDate(chooseDate);
        }).showDialog(context);
  }

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
            // LineStepRegister(totalStep: 6, currentStep: 2),
            AppNavigationV2(
              closeClicked: () {
                print("close clicked");
                Session.shared.changeRootViewToGuest();
              },
              title: "Provide car details",
              subTitle:
              'Help us know you better by providing details to your car.',
              totalStep: 6,
              currentStep: 2,
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Config.kDefaultPadding * 2),
                    child: buildFormBuilder(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Obx(() {
                      print("listening");
                      var isHaveData = (controller?.modelMemberOptionsResult?.value?.ownerOptions?.isNullOrBlank == false);
                      return isHaveData ? FormBuilderRadioGroup(
                        initialValue: controller.getAreYouOwnerTextFromID(controller.are_you_owner_id),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          border: InputBorder.none,
                        ),
                        orientation: OptionsOrientation.vertical,
                        // name: 'are_you_owner',
                        onChanged: (currentValue) {
                          print(currentValue);
                          var item = controller.modelMemberOptionsResult.value.ownerOptions.firstWhere((element) => element.value == currentValue);
                          controller.are_you_owner_id = item.id;
                          controller.are_you_owner_text = item.value;
                          // print('id get ${controller.are_you_owner}');
                        },
                        options: getListOptions_Widget(),
                      ) : Session.shared.EmptyBox();
                    }),
                  ),
                ],
              ),
            ),
            BottomNextBackRegister(
              isShowBack: true,
              nextClicked: () => controller.callAPIUpdate(),
              backClicked: () => Get.offAll(() =>UpdatePart1Screen(), transition: Transition.leftToRight),
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

  List<FormBuilderFieldOption> getListOptions_Widget() {
    List<FormBuilderFieldOption> list = [];
    var listOwnerOptions = controller?.modelMemberOptionsResult?.value?.ownerOptions;
    for (var i = 0; i < listOwnerOptions.length; i++) {
      var item = FormBuilderFieldOption(
        value: listOwnerOptions[i].value,
        child: Text(listOwnerOptions[i].value),
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
            'Car Details',
            style: Styles.mclub_Tilte,
          ),
          SizedBox(
            height: 10,
          ),

          TextFieldPhungNoBorder(
            controller: controller.chasis_number,
            labelText: "Chassis Number",
            hintText: "",
            onChange: (value) {
              print(value);
              controller.chasis_number.text = value;
            },
          ),

          TextFieldPhungNoBorder(
            controller: controller.plate_no,
            labelText: "Car Plate No.",
            hintText: "",
            onChange: (value) {
              print(value);
              controller.plate_no.text = value;
            },
          ),
          TextFieldPhungNoBorder(
            controller: controller.car_model,
            labelText: "Model",
            hintText: "",
            onChange: (value) {
              print(value);
              controller.car_model.text = value;
            },
          ),

          //country picker

          PickerMclub(
            controller: controller.regDateController,
            titleValue: 'Registration Date',
            onTap: () {
              // _showPickerDate(context);
              Session.shared.showPickerDate(context, (date) {
                controller.handleAfterPickerDate(date);
              });
            },
          ),
          //section 2
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Are you the registered owner of this car?',
              style: Styles.mclub_Tilte,
            ),
          ),
          Text(
            'In case you are not the registered owner of the registered car, you need to send an authorisation letter from the owner of the car allowing you to drive the car and participate with it in the club activities.',
            style: Styles.mclub_normalBodyText,
          ),



        ],
      ),
    );
  }

}

class UpdatePart2Controller extends GetxController {
  final ProfileController profileController = Get.find();
  final regDateController = TextEditingController();
  var chasis_number = TextEditingController();
  var plate_no = TextEditingController();
  var car_model = TextEditingController();
  // var registration_code = '';
  int are_you_owner_id;
  var are_you_owner_text = '';
  var modelMemberOptionsResult = ModelMemberOptionsResult().obs;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  getAreYouOwnerTextFromID(int id) {
    if (are_you_owner_id.isNullOrBlank == false) {
      var item = modelMemberOptionsResult.value.ownerOptions.firstWhere((element) => element.id == id);
      return item.value;
    } else {
      return null;

    }
  }


  loadOldData(){
    print('loadOldData step2');
    regDateController.text = profileController.userProfile.value.registrationCode;
    chasis_number.text = profileController.userProfile.value.chasisNumber;
    plate_no.text = profileController.userProfile.value.plateNo;
    car_model.text = profileController.userProfile.value.carModel;
    are_you_owner_id = profileController.getAreYouOwnerID();
    print('step2 ...');
    print(profileController.userProfile.value.toJson());

  }
  @override
  void onInit() {
    super.onInit();
    callApgetMemberOptions();
    loadOldData();
  }

  handleAfterPickerDate(DateTime chooseDate) {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(chooseDate);
    regDateController.text = formattedDate;
    // registration_code = formattedDate;
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
      'step': 2,
      "chasis_number": chasis_number.text,
      'plate_no' : plate_no.text,
      'car_model' : car_model.text,
      'registration_code' : regDateController.text,
      'are_you_owner' : are_you_owner_id,
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
      Get.offAll(() =>UpdatePart3Screen());
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


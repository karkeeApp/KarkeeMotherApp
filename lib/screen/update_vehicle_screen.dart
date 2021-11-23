import 'package:carkee/components/TextFieldPhungNoBorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:dio/dio.dart' as Dioo;
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/screen/screens.dart';

import 'start_loading.dart';

class UpdateVehicleScreen extends StatefulWidget {
  // final UpdateVehicleScreenController controller =
  //     Get.put(UpdateVehicleScreenController());

  @override
  _UpdateVehicleScreenState createState() => _UpdateVehicleScreenState();
}

class _UpdateVehicleScreenState extends State<UpdateVehicleScreen> {
  final ProfileController profileController = Get.find();

  final regDateController = TextEditingController();

  var chasis_number = TextEditingController();

  var plate_no = TextEditingController();

  var car_model = TextEditingController();


  callAPI() async {

    var bodyJson = {
      "registration_code": regDateController.text,
      "chasis_number": chasis_number.text,
      "plate_no": plate_no.text,
      "car_model": car_model.text,
    };
    // logger.d(bodyJson);
    print(bodyJson);

    Dioo.FormData formData = new Dioo.FormData.fromMap(bodyJson);
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(
        endpoint: url_update_vehicle, formData: formData, jsonQuery: jsonQuery);
    var jsonBody = await network.callAPI(showLog: true);
    if (jsonBody["code"] == 100) {
      Session.shared.showAlertPopupOneButtonWithCallback(
          title: 'Success',
          content: jsonBody["message"],
          callback: () {
            print("success url_update_vehicle");
            profileController.callAPIGetProfile();
            Get.back();
          });
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }



  loadOldData() {
    regDateController.text =
        profileController.userProfile.value.registrationCode;
    chasis_number.text = profileController.userProfile.value.chasisNumber;
    plate_no.text = profileController.userProfile.value.plateNo;
    car_model.text = profileController.userProfile.value.carModel;
  }

  handleAfterPickerDate(DateTime chooseDate) {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(chooseDate);
    regDateController.text = formattedDate;
    // registration_code = formattedDate;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadOldData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: PreferredSize(
        //     preferredSize: AppBarCustomRightIcon().preferredSize,
        //     child: AppBarCustomRightIcon(
        //       leftClicked: () {
        //         print("close clicked");
        //         Get.back();
        //       },
        //       title: 'Update New Password',
        //     )),
        // //SliderNewsDetails(modelNews: modelNews,),
        appBar: AppBar(
          centerTitle: true,

          backgroundColor: Colors.white,
          title: Text("Update Vehicle", style: Styles.mclub_Tilte),
          elevation: 1,
        ),
        body: Padding(
          padding: const EdgeInsets.all(Config.kDefaultPadding * 2),
          child: Container(
            child: ListView(
              children: [
                TextFieldPhungNoBorder(
                  controller: chasis_number,
                  labelText: "Chassis Number",
                  hintText: "",
                  onChange: (value) {
                    print(value);
                    chasis_number.text = value;
                  },
                ),

                TextFieldPhungNoBorder(
                  controller: plate_no,
                  labelText: "Car Plate No.",
                  hintText: "",
                  onChange: (value) {
                    print(value);
                    plate_no.text = value;
                  },
                ),

                TextFieldPhungNoBorder(
                  controller: car_model,
                  labelText: "Model",
                  hintText: "",
                  onChange: (value) {
                    print(value);
                    car_model.text = value;
                  },
                ),
                PickerMclub(
                  controller: regDateController,
                  titleValue: 'Registration Date',
                  onTap: () {
                    // _showPickerDate(context);
                    Session.shared.showPickerDate(context, (date) {
                      handleAfterPickerDate(date);
                    });
                  },
                ),
                // // Obx(() => FormBuilderTextField(
                // //       initialValue: chasis_number,
                // //       autocorrect: false,
                // //       name: 'chasis_number',
                // //       decoration: InputDecoration(
                // //           labelText: "Chassis Number",
                // //           labelStyle: Styles.mclub_inputTextStyle),
                // //       onChanged: (value) {
                // //         controller.chasis_number.value = value;
                // //         print(value);
                // //       },
                // //     )),
                // FormBuilderTextField(
                //   initialValue: controller.plate_no.value,
                //   autocorrect: false,
                //   name: 'plate_no',
                //   decoration: InputDecoration(
                //       labelText: "Car Plate No.",
                //       labelStyle: Styles.mclub_inputTextStyle),
                //   onChanged: (value) {
                //     controller.plate_no.value = value;
                //     print(value);
                //   },
                // ),
                // FormBuilderTextField(
                //   initialValue: controller.car_model.value,
                //   autocorrect: false,
                //   name: 'car_model',
                //   decoration: InputDecoration(
                //       labelText: "Model",
                //       labelStyle: Styles.mclub_inputTextStyle),
                //   onChanged: (value) {
                //     controller.car_model.value = value;
                //     print(value);
                //   },
                // ),
                // //country picker
                //
                // PickerMclub(
                //   controller: controller.regDateController,
                //   titleValue: 'Registration Date',
                //   onTap: () {
                //     // _showPickerDate(context);
                //     Session.shared.showPickerDate(context, (date) {
                //       controller.handleAfterPickerDate(date);
                //     });
                //   },
                // ),
                SizedBox(height: 30,),
                PrimaryButton(
                  callbackOnPress: () {
                    callAPI();
                  },
                  title: "Save",
                ),
              ],
            ),
          ),
        ));
  }
}
//
// class UpdateVehicleScreenController extends GetxController {
//   final ProfileController profileController = Get.find();
//   final regDateController = TextEditingController();
//   var chasis_number = ''.obs;
//   var plate_no = ''.obs;
//   var car_model = ''.obs;
//   @override
//   void onInit() {
//     super.onInit();
//     loadOldData();
//   }
//
//   callAPI() async {
//     Dioo.FormData formData = new Dioo.FormData.fromMap({
//       "registration_code": regDateController.text,
//       "chasis_number": chasis_number,
//       "plate_no": plate_no,
//       "car_model": car_model,
//     });
//     Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
//     var network = NetworkAPI(
//         endpoint: url_update_vehicle, formData: formData, jsonQuery: jsonQuery);
//     var jsonBody = await network.callAPIPOST();
//     if (jsonBody["code"] == 100) {
//       Session.shared.showAlertPopupOneButtonWithCallback(
//           title: 'Success',
//           content: jsonBody["message"],
//           callback: () {
//             print("success url_update_vehicle");
//             Get.back();
//           });
//     } else {
//       Session.shared.showAlertPopupOneButtonNoCallBack(
//           title: "Error", content: jsonBody["message"]);
//     }
//   }
//
//   loadOldData() {
//     regDateController.text =
//         profileController.userProfile.value.registrationCode;
//     chasis_number.value = profileController.userProfile.value.chasisNumber;
//     plate_no.value = profileController.userProfile.value.plateNo;
//     car_model.value = profileController.userProfile.value.carModel;
//   }
//
//   handleAfterPickerDate(DateTime chooseDate) {
//     var formatter = new DateFormat('yyyy-MM-dd');
//     String formattedDate = formatter.format(chooseDate);
//     regDateController.text = formattedDate;
//     // registration_code = formattedDate;
//   }
//
//   @override
//   void onClose() {
//     // emailTextController?.dispose();
//     super.onClose();
//   }
// }

import 'package:carkee/components/TextFieldPhungNoBorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:dio/dio.dart' as Dioo;

class UpdatePINScreen extends StatelessWidget {
  var pin = TextEditingController();
  var pin_confirm = TextEditingController();


  void callApi() async {

    Session.shared.showLoading();

    Dioo.FormData formData = new Dioo.FormData.fromMap({
      "pin" : pin.text,
      "pin_confirm": pin_confirm.text,

    });

    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(endpoint: url_member_update_pin, formData: formData, jsonQuery: jsonQuery);
    var jsonBody = await network.callAPIPOST();
    Session.shared.hideLoading();
    if (jsonBody["code"] == 100) {
      print(jsonBody);
      Session.shared.showAlertPopupOneButtonWithCallback(title: 'Success', content: jsonBody["message"], callback: () {
        print("success url_member_update_password");
        Get.back();
      });
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }
  //
  //
  // final UpdatePINScreenController _controller = Get.put(UpdatePINScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text('Edit PIN', style: Styles.mclub_Tilte),
          elevation: 1,
        ),
        // appBar: PreferredSize(
        //     preferredSize: AppBarCustomRightIcon().preferredSize,
        //     child: AppBarCustomRightIcon(
        //       leftClicked: () {
        //         print("close clicked");
        //         Get.back();
        //       },
        //       title: 'Edit PIN',
        //     )),
        body: Padding(
          padding: const EdgeInsets.all(Config.kDefaultPadding * 2),
          child: Container(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SingleChildScrollView(
                      child: FormBuilder(
                        child: Column(
                          children: [
                            TextFieldPhungNoBorder(
                              controller: pin,
                              labelText: "New PIN",
                              hintText: "",
                              onChange: (value) {
                                print(value);
                                pin.text = value;
                              },
                              isPassword: true,
                              notAllowEmpty: true,
                              keyboardType: TextInputType.number,
                            ),
                            TextFieldPhungNoBorder(
                              controller: pin_confirm,
                              labelText: "Confirm New PIN",
                              hintText: "",
                              onChange: (value) {
                                print(value);
                                pin_confirm.text = value;
                              },
                              isPassword: true,
                              notAllowEmpty: true,
                              keyboardType: TextInputType.number,
                            ),

                          ],
                        ),
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 30,),
                PrimaryButton(
                  callbackOnPress: () {
                    FocusScope.of(context).unfocus();
                    callApi();
                  },
                  title: "Save",
                ),
              ],
            ),
          ),
        )
    );
  }
}

//
//
// class UpdatePINScreenController extends GetxController {
//   var pin = '';
//   var pin_confirm = '';
//   @override
//   void onInit() {
//     super.onInit();
//   }
//   void callApi() async {
//
//     Session.shared.showLoading();
//
//     Dioo.FormData formData = new Dioo.FormData.fromMap({
//       "pin" : pin,
//       "pin_confirm": pin_confirm,
//
//     });
//
//     Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
//     var network = NetworkAPI(endpoint: url_member_update_pin, formData: formData, jsonQuery: jsonQuery);
//     var jsonBody = await network.callAPIPOST();
//     Session.shared.hideLoading();
//     if (jsonBody["code"] == 100) {
//       print(jsonBody);
//       Session.shared.showAlertPopupOneButtonWithCallback(title: 'Success', content: jsonBody["message"], callback: () {
//         print("success url_member_update_password");
//         Get.back();
//       });
//     } else {
//       Session.shared.showAlertPopupOneButtonNoCallBack(
//           title: "Error", content: jsonBody["message"]);
//     }
//   }
//
//   @override
//   void onClose() {
//     // emailTextController?.dispose();
//     super.onClose();
//   }
// }

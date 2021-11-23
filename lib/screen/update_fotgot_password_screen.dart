import 'package:carkee/components/TextFieldPhungNoBorder.dart';
import 'package:carkee/screen/start_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:dio/dio.dart' as Dioo;
import 'package:carkee/screen/screens.dart';

class UpdateForgotPasswordScreen extends StatelessWidget {
  final String email;
  var reset_code = TextEditingController();
  var password_new = TextEditingController();
  var password_confirm = TextEditingController();
  var account_id = '';

  UpdateForgotPasswordScreen({Key key, this.email}) : super(key: key);

  void callApi() async {
    Session.shared.showLoading();

    var _jsonBody = {
      "email": email,
      "reset_code": reset_code.text,
      "password_new": password_new.text,
      "password_confirm": password_confirm.text,
      "account_id": Session.shared.ACCOUNTID,
    };
    Dioo.FormData formData = new Dioo.FormData.fromMap(_jsonBody);
    logger.d(_jsonBody);
    var network = NetworkAPI(endpoint: url_forgotPasswordUpdate, formData: formData);
    var jsonBody = await network.callAPI(showLog: true);
    Session.shared.hideLoading();
    if (jsonBody["code"] == 100) {
      print(jsonBody);
      Session.shared.showAlertPopupOneButtonWithCallback(title: 'Success', content: jsonBody["message"], callback: () {
        print("success goResetCodeScreen to enter PIn and update new password, go back to login screen");
        Session.shared.changeRootViewToLogin();
      });
      //todo
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }
  // final UpdateForgotPasswordScreenController _controller = Get.put(UpdateForgotPasswordScreenController());
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: PreferredSize(
        //     preferredSize: AppBarCustom().preferredSize,
        //     child: AppBarCustom(
        //       leftClicked: () {
        //         print("close clicked");
        //         Get.back();
        //       },
        //       title: 'Update New Password',
        //     )),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text('Update New Password', style: Styles.mclub_Tilte),

          elevation: 1,
        ),
        body: Padding(
          padding: const EdgeInsets.all(Config.kDefaultPadding * 2),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    TextFieldPhungNoBorder(
                      controller: reset_code,
                      labelText: "Reset Password Code",
                      hintText: "",
                      onChange: (value) {
                        print(value);
                        reset_code.text = value;
                      },
                      isPassword: true,
                      notAllowEmpty: true,
                    ),
                    TextFieldPhungNoBorder(
                      controller: password_new,
                      labelText: "New Password",
                      hintText: "",
                      onChange: (value) {
                        print(value);
                        password_new.text = value;
                      },
                      isPassword: true,
                      notAllowEmpty: true,
                    ),
                    TextFieldPhungNoBorder(
                      controller: password_confirm,
                      labelText: "Confirm New Password",
                      hintText: "",
                      onChange: (value) {
                        print(value);
                        password_confirm.text = value;
                      },
                      isPassword: true,
                      notAllowEmpty: true,
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

              ],
            ),
          ),
        )
    );
  }
}

//
//
// class UpdateForgotPasswordScreenController extends GetxController {
//   final ForgotPasswordScreenController _forgotPasswordScreenController = Get.find();
//   var reset_code = '';
//   var password_new = '';
//   var password_confirm = '';
//   var account_id = '';
//   final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
//   @override
//   void onInit() {
//     super.onInit();
//   }
//   void callApi() async {
//     Session.shared.showLoading();
//     Dioo.FormData formData = new Dioo.FormData.fromMap({
//       "reset_code": reset_code,
//       "email": _forgotPasswordScreenController.email,
//       "password_new": password_new,
//       "password_confirm": password_confirm,
//       "account_id": Session.shared.ACCOUNTID,
//     });
//     var network = NetworkAPI(endpoint: url_forgotPasswordUpdate, formData: formData);
//     var jsonBody = await network.callAPIPOST();
//     Session.shared.hideLoading();
//     if (jsonBody["code"] == 100) {
//       print(jsonBody);
//       Session.shared.showAlertPopupOneButtonWithCallback(title: 'Success', content: jsonBody["message"], callback: () {
//         print("success goResetCodeScreen to enter PIn and update new password, go back to login screen");
//         Session.shared.changeRootViewToLogin();
//       });
//       //todo
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

import 'package:carkee/components/TextFieldPhungNoBorder.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:dio/dio.dart' as Dioo;
import 'package:carkee/screen/update_fotgot_password_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  TextEditingController email_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text('Forgot Password'),
          elevation: 1,
        ),
        // appBar: PreferredSize(
        //     preferredSize: AppBarCustom().preferredSize,
        //     child: AppBarCustom(
        //       leftClicked: () {
        //         print("close clicked");
        //         Get.back();
        //       },
        //       title: 'Forgot Password',
        //     )),
        body: Padding(
          padding: const EdgeInsets.all(Config.kDefaultPadding * 2),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextNormal(
                    textContent: 'Please enter your email to reset password'),
                //add at top
                //final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
                Column(
                  children: [
                    TextFieldPhungNoBorder(
                      controller: email_controller,
                      labelText: "Email",
                      hintText: "",
                      onChange: (value) {
                        print(value);
                        email_controller.text = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      notAllowEmpty: true,
                    ),
                    SizedBox(height: 30,),
                    PrimaryButton(
                      callbackOnPress: () {
                        callApi();
                      },
                      title: "Retrieve Password",
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  callApi() async {
    Session.shared.showLoading();
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      "email": email_controller.text,
      "account_id": Session.shared.ACCOUNTID,
    });
    var network = NetworkAPI(endpoint: url_forgot_password, formData: formData);
    var jsonBody = await network.callAPIPOST();
    Session.shared.hideLoading();
    if (jsonBody["code"] == 100) {
      print(jsonBody);
      Session.shared.showAlertPopupOneButtonWithCallback(
          title: 'Success', content: jsonBody["message"], callback: () {
        print("success goResetCodeScreen to enter PIn and update new password");
        Get.to(() => UpdateForgotPasswordScreen(email: email_controller.text));
      });
      //todo
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }
}

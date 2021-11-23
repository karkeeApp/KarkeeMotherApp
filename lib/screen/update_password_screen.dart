import 'package:carkee/components/TextFieldPhungNoBorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:dio/dio.dart' as Dioo;

class UpdatePasswordScreen extends StatefulWidget {
  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  // final UpdatePasswordScreenController _controller =
  //     Get.put(UpdatePasswordScreenController());

  var password_current = TextEditingController();
  var password_new = TextEditingController();
  var password_confirm = TextEditingController();
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
        // appBar: AppBar(
        //   centerTitle: true,
        //   backgroundColor: Colors.white,
        //   title: Text('Update New Password'),
        //   elevation: 1,
        // ),
        appBar: getAppBar('Update New Password'),
        body: bodyForm(context));
  }

  SingleChildScrollView bodyForm(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Config.kDefaultPadding * 2),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    TextFieldPhungNoBorder(
                      controller: password_current,
                      labelText: "Current Password",
                      hintText: "",
                      onChange: (value) {
                        print(value);
                        password_current.text = value;
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
                )
              ],
            ),
          ),
        ),
      );
  }


  void callApi() async {
    Session.shared.showLoading();

    Dioo.FormData formData = new Dioo.FormData.fromMap({
      "password_current": password_current.text,
      "password_new": password_new.text,
      "password_confirm": password_confirm.text,
    });

    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(
        endpoint: url_member_update_password,
        formData: formData,
        jsonQuery: jsonQuery);
    var jsonBody = await network.callAPIPOST();
    Session.shared.hideLoading();
    if (jsonBody["code"] == 100) {
      print(jsonBody);
      Session.shared.showAlertPopupOneButtonWithCallback(
          title: 'Success',
          content: jsonBody["message"],
          callback: () {
            print("success url_member_update_password");
            Get.back();
          });
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }

}
//
// class UpdatePasswordScreenController extends GetxController {
//
//   @override
//   void onInit() {
//     super.onInit();
//   }
//
//   @override
//   void onClose() {
//     // emailTextController?.dispose();
//     super.onClose();
//   }
// }

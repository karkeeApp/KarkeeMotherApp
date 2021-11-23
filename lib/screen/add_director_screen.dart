import 'dart:io';
import 'package:carkee/controllers/controllers.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart' as Dioo;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:local_auth/local_auth.dart';
import 'package:carkee/components/PrimaryButton.dart';
import '../components/TextFieldPhungNoBorder.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:get/get.dart';
import 'package:carkee/config/strings.dart';
import 'package:carkee/screen/screens.dart';
import 'package:carkee/screen/start_loading.dart';
import 'package:flutter_picker/flutter_picker.dart';

class AddDirectorScreen extends StatefulWidget {
  final Directors director;
  AddDirectorScreen({Directors this.director});

  @override
  _AddDirectorScreenState createState() => _AddDirectorScreenState();
}

class _AddDirectorScreenState extends State<AddDirectorScreen> {

  List<String> _status = ["Director", "Shareholder"];
  final ProfileController profileController = Get.find();
  // final key = GlobalKey<FormState>();
  TextEditingController fullname_controller = TextEditingController();

  TextEditingController mobile_code_controller = TextEditingController();
  TextEditingController mobile_no_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();

  var is_director = false;
  var is_shareholder = false;

  String _verticalGroupValue = "";

  buildRadio(){
    return RadioGroup<String>.builder(
      horizontalAlignment : MainAxisAlignment.start,
      direction: Axis.horizontal,
      groupValue: _verticalGroupValue,//default value
      onChanged: (value) => setState(() {
        _verticalGroupValue = value;
        is_director = (value == _status[0]);
        is_shareholder = (value == _status[1]);
      }),
      items: _status,
      itemBuilder: (item) => RadioButtonBuilder(
        item,
      ),
    );
  }
  builRadioPart(){
    print('buildBody buildgenderPart');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Config.kDefaultPadding * 2, vertical: 0),
          child: Text(
            'Type',
            style: Styles.mclub_normalText,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child : buildRadio()
        ),
      ],
    );
  }
  _showPickerTelephoneCode(BuildContext context) {
    showCountryPicker(
      //Có thể sau này dùng lại loic showCountryPicker xem trong source và chôm lại ý tưởng!
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        print('Select country: ${country.displayName}');
        print('Select Code: ${country.countryCode}');
        var codeSelected = country.phoneCode;
        mobile_code_controller.text = '+$codeSelected';
      },
    );
  }

  callAPIAdd() async {
    //clear all old data
    Session.shared.showLoading();
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      "fullname": fullname_controller.text,
      "email": email_controller.text,
      'mobile_code': mobile_code_controller.text,
      'mobile_no': mobile_no_controller.text,
      // 'mobile_code': '+65',
      // 'mobile_no': '11223344',
      'is_director' : is_director,
      'is_shareholder' : is_shareholder,
      // 'director_id' : director_id,
    });
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(endpoint: url_member_add_director, formData: formData, jsonQuery: jsonQuery);
    var jsonBody = await network.callAPIPOST();
    Session.shared.hideLoading();
    if (jsonBody["code"] == 100) {
      await profileController.callAPIGetProfile();
      Get.back();

    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(content: jsonBody["message"] ?? "Something went wrong");
    }
  }
  callAPIEdit() async {
    //clear all old data
    Session.shared.showLoading();
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      "fullname": fullname_controller.text,
      "email": email_controller.text,
      'mobile_code': mobile_code_controller.text,
      'mobile_no': mobile_no_controller.text,
      'is_director' : is_director,
      'is_shareholder' : is_shareholder,
      'director_id' : widget.director.directorId,
    });
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(endpoint: url_member_update_director, formData: formData, jsonQuery: jsonQuery);
    var jsonBody = await network.callAPIPOST();
    Session.shared.hideLoading();
    if (jsonBody["code"] == 100) {
      await profileController.callAPIGetProfile();
        Get.back();
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(content: jsonBody["message"] ?? "Something went wrong");
    }
  }

  Padding buildSection1(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: Config.kDefaultPadding * 2,
          right: Config.kDefaultPadding * 2,
          bottom: Config.kDefaultPadding * 2),
      child: Column(
        children: [
          TextFieldPhungNoBorder(
            // key: ValueKey(4),
            controller: fullname_controller,
            labelText: "Full Name",
            hintText: "",
            onChange: (value) {
              // print(value);
              fullname_controller.text = value;
            },
            // keyboardType: TextInputType.emailAddress,
            // notAllowEmpty: true,
          ),
          TextFieldPhungNoBorder(
            // key: ValueKey(3),

            controller: email_controller,
            labelText: "Email Address",
            hintText: "",
            onChange: (value) {
              // print(value);
              email_controller.text = value;
            },
            keyboardType: TextInputType.emailAddress,
          ),
          //PHONE
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            SizedBox(
              width: 140,
              child: PickerMclub(
                // key: ValueKey(1),
                controller: mobile_code_controller,
                titleValue: 'Country Code',
                onTap: () {
                  _showPickerTelephoneCode(context);
                },
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Flexible(
              child: SizedBox(
                child: TextFieldPhungNoBorder(
                  // key: ValueKey(2),
                  controller: mobile_no_controller,
                  labelText: "Mobile No.",
                  hintText: "",
                  onChange: (value) {
                    // print(value);
                    mobile_no_controller.text = value;
                  },
                  keyboardType: TextInputType.number,
                  notAllowEmpty: true,
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.director != null) {
      print("fill old data");
      fullname_controller.text = widget.director.fullname;
      email_controller.text = widget.director.email;
      mobile_code_controller.text = widget.director.mobileCode;
      mobile_no_controller.text = widget.director.mobileNo;
      is_director = widget.director.isDirector;
      is_shareholder = widget.director.isShareholder;
      _verticalGroupValue = is_director ? "Director" : (is_shareholder ? "Shareholder" : "");
    } else {
      // fullname_controller.text = 'aaaaa';//for test
      // email_controller.text = 'heheh@hehe.net';//for test
      // mobile_no_controller.text = '11223344';//for test
      mobile_code_controller.text = '+65';

      print("add new case");
    }
  }



  void dispose() {
    super.dispose();

  }

  Widget getHeader() {
    return AppNavigationV2(
        totalStep: 0,
        currentStep: 1,
        closeClicked: () {
          Get.back();
        },
        title: "Add Director / Shareholder",
        subTitle: "");
  }

  @override
  Widget build(BuildContext context) => FocusDetector(
        onFocusLost: () {
          logger.i(
            'Focus Lost.'
            '\nTriggered when either [onVisibilityLost] or [onForegroundLost] '
            'is called.'
            '\nEquivalent to onPause() on Android or viewDidDisappear() on iOS.',


          );
        },
        onFocusGained: () {
          logger.i(
            'Focus Gained.'
            '\nTriggered when either [onVisibilityGained] or [onForegroundGained] '
            'is called.'
            '\nEquivalent to onResume() on Android or viewDidAppear() on iOS.',
          );
        },
        onVisibilityLost: () {
          logger.i(
            'Visibility Lost.'
            '\nIt means the widget is no longer visible within your app.',
          );
        },
        onVisibilityGained: () {
          logger.i(
            'Visibility Gained.'
            '\nIt means the widget is now visible within your app.',
          );
        },
        onForegroundLost: () {
          logger.i(
            'Foreground Lost.'
            '\nIt means, for example, that the user sent your app to the '
            'background by opening another app or turned off the device\'s '
            'screen while your widget was visible.',
          );
        },
        onForegroundGained: () {
          logger.i(
            'Foreground Gained.'
            '\nIt means, for example, that the user switched back to your app '
            'or turned the device\'s screen back on while your widget was visible.',
          );
        },
        child: Material(
            color: Colors.transparent,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                reverse: true,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0,
                                -12), //(0,-12) Bóng lên,(0,12) bóng xuống,, tuong tự cho trái phải
                            blurRadius: 15, //do bóng phủ xa
                            color: Colors.black.withOpacity(0.5))
                      ]),
                  // color: Colors.red.shade200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      getHeader(),
                      buildSection1(context),
                      builRadioPart(),


                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: BlackButton(
                          callbackOnPress: () {
                            if (widget.director != null) {
                              print("call API here ");
                              callAPIEdit();
                            } else {
                              callAPIAdd();
                            }
                          },
                          title: "Submit",
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            )),
      );
}

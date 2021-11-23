import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:intl/intl.dart';
import 'package:carkee/components/TextFieldPhungNoBorder.dart';
import 'package:carkee/components/bottom_next_back_register.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/components/network_api.dart';
import 'package:dio/dio.dart' as Dioo;
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/models/ModelMemberOptionsResult.dart';
import 'package:carkee/screen/update_part2_personal.dart';

class UpdatePart1Screen extends StatefulWidget {
  @override
  _UpdatePart1ScreenState createState() => _UpdatePart1ScreenState();
}

class _UpdatePart1ScreenState extends State<UpdatePart1Screen> {
  final UpdatePart1Controller controller = Get.put(UpdatePart1Controller());

  //gender radio
  List<String> _status = ["Male", "Female"];
  String _verticalGroupValue = "";
  buildRadio() {
    return RadioGroup<String>.builder(
      horizontalAlignment: MainAxisAlignment.start,
      direction: Axis.horizontal,
      groupValue: controller.gender == 'm'
          ? 'Male'
          : (controller.gender == 'f' ? 'Female' : ""), //default value
      onChanged: (value) => setState(() {
        _verticalGroupValue = value;
        if (value == 'Male') {
          controller.gender = 'm';
        } else if (value == 'Female') {
          controller.gender = 'f';
        }
      }),
      items: _status,
      itemBuilder: (item) => RadioButtonBuilder(
        item,
      ),
    );
  }

  _showPickerModal(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: controller
                .profileController.modelMemberOptionsResult.value.salaries
                .map((e) => e.value)
                .toList()),
        changeToFirst: true,
        hideHeader: false,
        selectedTextStyle: TextStyle(color: Config.secondColor),
        onConfirm: (Picker picker, List value) {
          var valueString = controller.profileController
              .modelMemberOptionsResult.value.salaries[value.first].value;
          controller.salaryController.text = valueString;
        }).showModal(context); //_scaffoldKey.currentState);
  }

  _showPickerDate(BuildContext context) {
    Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(
            yearBegin: 1900, yearEnd: Session.shared.getMinAllowYear()),
        selectedTextStyle: TextStyle(color: Config.secondColor),
        onConfirm: (Picker picker, List value) {
          DateTime chooseDate = (picker.adapter as DateTimePickerAdapter).value;
          print(chooseDate);
          controller.handleAfterPickerDate(chooseDate);
        }).showDialog(context);
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
        var contrySelected = country.name;
        controller.countryController.text = contrySelected;
        // controller.country = contrySelected;
        // print('codeMobile $codeMobile');
      },
    );
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
            // LineStepRegister(totalStep: 6, currentStep: 1),
            AppNavigationV2(
              closeClicked: () {
                print("close clicked");
                Session.shared.changeRootViewToGuest();
              },
              title: "Provide basic details",
              subTitle:
                  'Help us know you better by providing your basic personal details',
              totalStep: 6,
              currentStep: 1,
            ),
            Expanded(
              child: ListView(
                children: [
                  //section1
                  section1(context),
                  builGenderPart(),
                  section2(context),
                  // buildFormBuilder(context)
                  // buildBody(context)
                ],
              ),
            ),
            BottomNextBackRegister(
              isShowBack: false,
              nextClicked: () => controller.callAPIUpdate(),
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

  Widget section1(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Config.kDefaultPadding * 2),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Residential Address',
          style: Styles.mclub_Tilte,
        ),

        //country picker
        PickerMclub(
          controller: controller.countryController,
          titleValue: 'Country',
          onTap: () {
            _showPickerCountry(context);
          },
        ),
        Row(
          children: [
            Expanded(
              child: TextFieldPhungNoBorder(
                controller: controller.postal_code,
                labelText: "Postal Code",
                hintText: "",
                onChange: (value) {
                  print(value);
                  controller.postal_code.text = value;
                },
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: TextFieldPhungNoBorder(
                controller: controller.unit_no,
                labelText: "Unit No",
                hintText: "",
                onChange: (value) {
                  print(value);
                  controller.unit_no.text = value;
                },
              ),
            ),
          ],
        ),
        TextFieldPhungNoBorder(
          controller: controller.add_1,
          labelText: "Address Line 1",
          hintText: "",
          onChange: (value) {
            print(value);
            controller.add_1.text = value;
          },
        ),
        TextFieldPhungNoBorder(
          controller: controller.add_2,
          labelText: "Address Line 2",
          hintText: "",
          onChange: (value) {
            print(value);
            controller.add_2.text = value;
          },
        ),
      ]),
    );
  }

  Widget builGenderPart() {
    print('buildBody buildgenderPart');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: Config.kDefaultPadding * 2,
              right: Config.kDefaultPadding * 2,
              top: 0,
              bottom: 10),
          child: Text(
            'Personal Details',
            style: Styles.mclub_Tilte,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Config.kDefaultPadding * 2, vertical: 0),
          child: Text(
            'Gender',
            style: Styles.mclub_normalText,
          ),
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
          child: buildRadio(),
        )


        //gender
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        //   child: FormBuilderRadioGroup(
        //     decoration: InputDecoration(
        //       contentPadding: EdgeInsets.all(0),
        //       border: InputBorder.none,),
        //     initialValue:
        //     controller.gender == 'm' ? 'Male' : (controller.gender == 'f' ? 'Female' : ""),
        //     name: 'gender',
        //     onChanged: (currentValue) {
        //       print(currentValue);
        //       if (currentValue == 'Male') {
        //         controller.gender = 'm';
        //       } else if (currentValue == 'Female') {
        //         controller.gender = 'f';
        //       }
        //     },
        //     options: [
        //       'Male',
        //       'Female',
        //     ]
        //         .map((lang) => FormBuilderFieldOption(value: lang))
        //         .toList(growable: false),
        //   ),
        // ),
      ],
    );
  }

  Widget section2(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Config.kDefaultPadding * 2),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //Date of birth Picker
        PickerMclub(
          // initialValue : controller.birthday,
          controller: controller.birthdayController,
          titleValue: 'Date of Birth',
          onTap: () {
            // _showPickerDate(context);
            Session.shared.showPickerDate(context, (date) {
              controller.handleAfterPickerDate(date);
            });
          },
        ),
        TextFieldPhungNoBorder(

          controller: controller.nric,
          labelText: "NRIC",
          hintText: "",
          onChange: (value) {
            print(value);
            controller.nric.text = value;
          },
        ),

        TextFieldPhungNoBorder(
          controller: controller.profession,
          labelText: "Profession",
          hintText: "",
          onChange: (value) {
            print(value);
            controller.profession.text = value;
          },
        ),
        TextFieldPhungNoBorder(
          controller: controller.company,
          labelText: "Company Name",
          hintText: "",
          onChange: (value) {
            print(value);
            controller.company.text = value;
          },
        ),

        PickerMclub(
          controller: controller.salaryController,
          titleValue: 'Annual Salary',
          onTap: () {
            _showPickerModal(context);
          },
        ),
      ]),
    );
  }
}

class UpdatePart1Controller extends GetxController {
  final ProfileController profileController = Get.find();

  final countryController = TextEditingController();
  final birthdayController = TextEditingController();
  final salaryController = TextEditingController();
  var postal_code = TextEditingController();
  var unit_no = TextEditingController();
  var add_1 = TextEditingController();
  var add_2 = TextEditingController();
  var gender = "";
  var nric = TextEditingController();
  var profession = TextEditingController();
  var company = TextEditingController();
  var isHaveDataMemberOptions = false.obs;

  @override
  void onInit() {
    profileController.callApiGetMemberOptions();
    loadOldData();
    super.onInit();
  }

  loadOldData() {
    countryController.text = profileController.userProfile.value.country;
    postal_code.text = profileController.userProfile.value.postalCode;
    unit_no.text = profileController.userProfile.value.unitNo;
    add_1.text = profileController.userProfile.value.add1;
    add_2.text = profileController.userProfile.value.add2;
    gender = profileController.userProfile.value.gender;
    birthdayController.text = profileController.userProfile.value.birthday;
    nric.text = profileController.userProfile.value.nric;
    company.text = profileController.userProfile.value.company;
    profession.text = profileController.userProfile.value.profession;
    salaryController.text =
        profileController.getAnnualSalary(); //anti '' for dropdown
    print(profileController.userProfile.value.toJson());
  }

  handleAfterPickerDate(DateTime chooseDate) {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(chooseDate);
    birthdayController.text = formattedDate;
    // birthday = formattedDate;
  }

  callAPIUpdate() async {
    Session.shared.showLoading();
    print("start callAPIUpdate");
    //hide keyboard!
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      'step': 1,
      "country": countryController.text,
      'postal_code': postal_code.text,
      'unit_no': unit_no.text,
      'add_1': add_1.text,
      "add_2": add_2.text,
      "gender": gender,
      "birthday": birthdayController.text,
      "nric": nric.text.toUpperCase(),
      'profession': profession.text,
      'company': company.text,
      'annual_salary': salaryController.text
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
      await profileController.callAPIGetProfile();
      Get.offAll(() =>UpdatePart2Screen());
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

var LISTDEMO = ['1', '2', '3'];

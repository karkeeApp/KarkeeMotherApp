import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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
import 'package:carkee/screen/update_part2_company.dart';
import 'package:carkee/screen/update_part2_personal.dart';

class UpdatePart1CompanyScreen extends StatelessWidget {
  final UpdatePart1CompanyController controller = Get.put(UpdatePart1CompanyController());

  @override
  Widget build(BuildContext context) {
    print('Start build');
    return image_background(context);
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
  Widget body_view(BuildContext context) {
    print('Start build');
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          child: Column(children: [
            // LineStepRegister(totalStep: 4, currentStep: 1),
            AppNavigationV2(
              closeClicked: () {
                print("close clicked");
                Session.shared.changeRootViewToGuest();
              },
              title: "Tell us more about you!",
              subTitle:
              'We’ll need some additional details before we complete the registration process.',
              totalStep: 4,
              currentStep: 1,
            ),
            Expanded(
              child: ListView(
                children: [
                  //section1
                  builGenderPart(),
                  section1(context),
                  section2(context),
                  section3(context)
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
  // _showPickerDate(BuildContext context) {
  //   Picker(
  //       hideHeader: true,
  //       adapter: DateTimePickerAdapter(
  //           yearBegin: 1900, yearEnd: Session.shared.getMinAllowYear()),
  //       selectedTextStyle: TextStyle(color: Config.secondColor),
  //       onConfirm: (Picker picker, List value) {
  //         DateTime chooseDate = (picker.adapter as DateTimePickerAdapter).value;
  //         print(chooseDate);
  //         controller.handleAfterPickerDate(chooseDate);
  //       }).showDialog(context);
  // }
  // _showPickerDate(BuildContext context) {
  //   DatePicker.showDatePicker(context,
  //       showTitleActions: true,
  //       minTime: DateTime(1900, 1, 1),
  //       maxTime: DateTime(Session.shared.getMinAllowYear(), 31, 12),
  //       // theme: DatePickerTheme(
  //       //     // headerColor: Colors.orange,
  //       //     // backgroundColor: Colors.blue,
  //       //     // itemStyle: TextStyle(
  //       //     //     color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
  //       //     // doneStyle: TextStyle(color: Colors.white, fontSize: 16)
  //       // ),
  //       onChanged: (date) {
  //         print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
  //         // controller.handleAfterPickerDate(date);
  //       }, onConfirm: (date) {
  //         print('confirm $date');
  //         controller.handleAfterPickerDate(date);
  //       }, currentTime: DateTime.now(), locale: LocaleType.en);
  // }

  Widget section1(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Config.kDefaultPadding * 2 ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //Date of birth Picker
        PickerMclub(
          // initialValue : controller.birthday,
          controller: controller.birthdayController,
          titleValue: 'Date of Birth',
          onTap: () {
            Session.shared.showPickerDate(context, (date) {
              controller.handleAfterPickerDate(date);
            });
            // _showPickerDate(context);
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

        // Text(
        //   'Company Contact Details',
        //   style: Styles.mclub_Tilte,
        // ),
        //
        //
        // //PHONE CODE
        // Row(
        //     crossAxisAlignment: CrossAxisAlignment.end,
        //     children: [
        //       SizedBox(
        //         width: 100,
        //         child: PickerMclub(
        //           controller: controller.telephone_code,
        //           titleValue: 'Country Code',
        //           onTap: () {
        //             _showPickerTelephoneCode(context);
        //           },
        //         ),
        //       ),
        //       SizedBox(
        //         width: 5,
        //       ),
        //       Flexible(
        //         child: SizedBox(
        //           child: TextFieldPhungNoBorder(
        //             controller: controller.telephone_no,
        //             labelText: "Representative Mobile No.",
        //             hintText: "",
        //             onChange: (value) {
        //               print(value);
        //               controller.telephone_no.text = value;
        //             },
        //           ),
        //         ),
        //       ),
        //     ]),
        //
        // TextFieldPhungNoBorder(
        //   controller: controller.company_email,
        //   labelText: "Email Address",
        //   hintText: "",
        //   onChange: (value) {
        //     print(value);
        //     controller.company_email.text = value;
        //   },
        //   notAllowEmpty: true,
        //   requiredEmail: true,
        //   keyboardType: TextInputType.emailAddress,
        // ),
        //country picker
      ]
      ),
    );
  }

  Widget section2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Config.kDefaultPadding * 2 ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(top: Config.kDefaultPadding),
          child: Text(
            'About your club/company',
            style: Styles.mclub_Tilte,
          ),
        ),
        //Date of birth Picker
        // PickerMclub(
        //   // initialValue : controller.birthday,
        //   controller: controller.birthdayController,
        //   titleValue: 'Date of Birth',
        //   onTap: () {
        //     _showPickerDate(context);
        //   },
        // ),
        TextFieldPhungNoBorder(
          controller: controller.company_name,
          labelText: "Club / company name",
          hintText: "",
          onChange: (value) {
            print(value);
            controller.company_name.text = value;
          },
        ),

        TextFieldPhungNoBorder(
          controller: controller.company_uen,
          labelText: "Company Registration No. (UEN)",
          hintText: "",
          onChange: (value) {
            print(value);
            controller.company_uen.text = value;
          },
        ),
        TextFieldPhungNoBorder(
          controller: controller.company_about,
          labelText: "Tell us more about your club / company",
          hintText: "",
          onChange: (value) {
            print(value);
            controller.company_about.text = value;
          },
        ),
        TextFieldPhungNoBorder(
          controller: controller.company_number_members,
          labelText: "No. of members",
          hintText: "",
          onChange: (value) {
            print(value);
            controller.company_number_members.text = value;
          },
          keyboardType: TextInputType.number,
        ),
        // Text(
        //   'Company Contact Details',
        //   style: Styles.mclub_Tilte,
        // ),
        //
        //
        // //PHONE CODE
        // Row(
        //     crossAxisAlignment: CrossAxisAlignment.end,
        //     children: [
        //       SizedBox(
        //         width: 100,
        //         child: PickerMclub(
        //           controller: controller.telephone_code,
        //           titleValue: 'Country Code',
        //           onTap: () {
        //             _showPickerTelephoneCode(context);
        //           },
        //         ),
        //       ),
        //       SizedBox(
        //         width: 5,
        //       ),
        //       Flexible(
        //         child: SizedBox(
        //           child: TextFieldPhungNoBorder(
        //             controller: controller.telephone_no,
        //             labelText: "Representative Mobile No.",
        //             hintText: "",
        //             onChange: (value) {
        //               print(value);
        //               controller.telephone_no.text = value;
        //             },
        //           ),
        //         ),
        //       ),
        //     ]),
        //
        // TextFieldPhungNoBorder(
        //   controller: controller.company_email,
        //   labelText: "Email Address",
        //   hintText: "",
        //   onChange: (value) {
        //     print(value);
        //     controller.company_email.text = value;
        //   },
        //   notAllowEmpty: true,
        //   requiredEmail: true,
        //   keyboardType: TextInputType.emailAddress,
        // ),
        //country picker
      ]
      ),
    );
  }

  Widget section3(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Config.kDefaultPadding * 2 ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.only(top: Config.kDefaultPadding),
              child: Text(
                'Club / Company address',
                style: Styles.mclub_Tilte,
              ),
            ),

            //Date of birth Picker
            PickerMclub(
              // initialValue : controller.birthday,
              controller: controller.company_country,
              titleValue: 'Country',
              onTap: () {
                _showPickerCountry(context);
              },
            ),

            Row(
              children: [
                Expanded(
                  child: TextFieldPhungNoBorder(
                    controller: controller.company_postal_code,
                    labelText: "Postal Code",
                    hintText: "",
                    onChange: (value) {
                      print(value);
                      controller.company_postal_code.text = value;
                    },
                    keyboardType: TextInputType.number,

                  ),
                ),

                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: TextFieldPhungNoBorder(
                    controller: controller.company_unit_no,
                    labelText: "Unit No",
                    hintText: "",
                    onChange: (value) {
                      print(value);
                      controller.company_unit_no.text = value;
                    },
                  ),
                ),

              ],
            ),
            TextFieldPhungNoBorder(
              controller: controller.company_add_1,
              labelText: "Address Line 1",
              hintText: "",
              onChange: (value) {
                print(value);
                controller.company_add_1.text = value;
              },
            ),
            TextFieldPhungNoBorder(
              controller: controller.company_add_2,
              labelText: "Address Line 2",
              hintText: "",
              onChange: (value) {
                print(value);
                controller.company_add_2.text = value;
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
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.only(left: Config.kDefaultPadding * 2, right: Config.kDefaultPadding * 2, top: 0,bottom: 10),
          child: Text(
            'Club/Company Representative’s Details',
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          child: FormBuilderRadioGroup(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              border: InputBorder.none,),
            initialValue:
            controller.gender == 'm' ? 'Male' : (controller.gender == 'f' ? 'Female' : ""),
            // name: 'gender',
            onChanged: (currentValue) {
              print(currentValue);
              if (currentValue == 'Male') {
                controller.gender = 'm';
              } else if (currentValue == 'Female') {
                controller.gender = 'f';
              }
            },
            options: [
              'Male',
              'Female',
            ]
                .map((lang) => FormBuilderFieldOption(value: lang))
                .toList(growable: false),
          ),
        ),
      ],
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
        var contrySelected = country.name;
        controller.company_country.text = contrySelected;
        // controller.country = contrySelected;
        // print('codeMobile $codeMobile');
      },
    );
  }
  //
  // _showPickerTelephoneCode(BuildContext context) {
  //   showCountryPicker(
  //     //Có thể sau này dùng lại loic showCountryPicker xem trong source và chôm lại ý tưởng!
  //     context: context,
  //     showPhoneCode:
  //     true, // optional. Shows phone code before the country name.
  //     onSelect: (Country country) {
  //       print('Select country: ${country.displayName}');
  //       print('Select Code: ${country.countryCode}');
  //       var codeSelected = country.phoneCode;
  //       controller.telephone_code.text = '+$codeSelected';;
  //     },
  //   );
  // }

}

class UpdatePart1CompanyController extends GetxController {
  final ProfileController profileController = Get.find();

  // var telephone_code = TextEditingController();
  // var telephone_no = TextEditingController();
  var company_email = TextEditingController();
  //Company Registration No. (UEN)
  var company_name = TextEditingController();
  var company_uen = TextEditingController();
  //Tell us more about your club / company
  var company_about = TextEditingController();
  //No. of members
  var company_number_members = TextEditingController();
  var company_country = TextEditingController();
  var company_postal_code = TextEditingController();
  var company_unit_no = TextEditingController();
  var company_add_1 = TextEditingController();
  var company_add_2 = TextEditingController();

  var gender = '';
  var nric = TextEditingController();
  var birthdayController = TextEditingController();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  void onInit() {
    super.onInit();
    loadOldData();
  }

  loadOldData() {
    // telephone_code.text = profileController.getCompanyTelePhoneCode();
    // telephone_no.text = profileController.userProfile.value.telephoneNo;
    //section 1
    gender = profileController.userProfile.value.gender;
    birthdayController.text = profileController.userProfile.value.birthday;
    nric.text = profileController.userProfile.value.nric;

    // company_email.text = profileController.userProfile.value.companyEmail;
    company_name.text = profileController.userProfile.value.company;
    company_uen.text = profileController.userProfile.value.eun;
    company_about.text = profileController.userProfile.value.about;
    company_number_members.text = profileController.userProfile.value.numberOfEmployees;


    company_country.text = profileController.getCompanyCountry();
    company_postal_code.text = profileController.userProfile.value.companyPostalCode;
    company_unit_no.text = profileController.userProfile.value.companyUnitNo;

    company_add_1.text = profileController.userProfile.value.companyAdd1;
    company_add_2.text = profileController.userProfile.value.companyAdd2;

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
      //section1 Club/Company
      // Representative’s Details
      'step': 1,
      "gender": gender,
      "birthday": birthdayController.text,
      "nric": nric.text.toUpperCase(),
      //section2 About your club/company
      'company': company_name.text,
      'eun' : company_uen.text,
      'about' : company_about.text,
      'number_of_employees' : company_number_members.text,
      //section 3 Club/company address
      "company_country": company_country.text,
      'company_postal_code': company_postal_code.text,
      'company_unit_no': company_unit_no.text,
      'company_add_1': company_add_1.text,
      "company_add_2": company_add_2.text,
      // 'telephone_code' : telephone_code.text,
      // 'telephone_no' : telephone_no.text,
      // 'company_email' : company_email.text
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
      await profileController.callAPIGetProfile();
      Get.offAll(() =>UpdatePart2CompanyScreen());
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


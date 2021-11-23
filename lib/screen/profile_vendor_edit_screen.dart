import 'dart:io';

import 'package:carkee/components/TextFieldPhungNoBorder.dart';
import 'package:country_picker/country_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// ProfileVendorEditScreen
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:carkee/components/debouncer.dart';
import 'package:carkee/components/infoItemHorizal.dart';
import 'package:carkee/components/item_menu_setting.dart';
import 'package:carkee/components/item_upload.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/controllers/controllers.dart';
import 'package:dio/dio.dart' as Dioo;
import 'package:mime/mime.dart';

class ProfileVendorEditScreen extends StatefulWidget {
  @override
  _ProfileVendorEditScreenState createState() =>
      _ProfileVendorEditScreenState();
}

class _ProfileVendorEditScreenState extends State<ProfileVendorEditScreen> {
  final ProfileController profileController = Get.find();

  // final telephone_code = TextEditingController();
  // var telephone_no = '';

  //gender radio
  List<String> _status = ["Male", "Female"];
  String _verticalGroupValue = "";
  // var company_email = '';
  var company_name = TextEditingController();
  var company_about = TextEditingController();
  var company_uen = TextEditingController();
  var company_number_members = TextEditingController();

  var fullname =  TextEditingController();

  var countryCompanyController = TextEditingController();
  var countryController = TextEditingController();
  var birthdayController = TextEditingController();
  var email = TextEditingController();
  // var salaryController = TextEditingController();
  // var postal_code = '';
  // var postal_code_company = '';
  // var unit_no = '';
  // var unit_no_company = '';
  // var add_1_company = '';
  // var add_2_company = '';
  // var add_1 = '';
  // var add_2 = '';
  var gender = '';
  var nric = TextEditingController();
  var company_postal_code = TextEditingController();
  var company_unit_no = TextEditingController();
  var company_add_1 = TextEditingController();
  var company_add_2 = TextEditingController();
  // var profession = '';
  // var company = TextEditingController();
  var mobile = TextEditingController();
  var mobile_code = TextEditingController();

  // var emergencyCodeController = TextEditingController();
  // var contact_person = '';
  // var emergency_no = '';
  // int relationship_id;
  // var relationship_text = '';

  String typeUpload;
  File _file;
  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileController.callApiGetMemberOptions();
    loadOldData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: PreferredSize(
        //     preferredSize: AppBarLeftRightIcon().preferredSize,
        //     child: AppBarLeftRightIcon(
        //       // iconRight: Icon(Icons.edit),
        //       widgetRight: GestureDetector(
        //         onTap: () {
        //           print("callapi saved");
        //           callAPIUpdate();
        //         },
        //         child: Padding(
        //           padding: const EdgeInsets.all(10),
        //           child: Text(
        //             'Done',
        //             style: Styles.mclub_normalText,
        //           ),
        //         ),
        //       ),
        //       leftClicked: () {
        //         print("close clicked");
        //         Get.back();
        //       },
        //       title: 'Edit Profile',
        //     )),

        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text("Edit Profile"),
          elevation: 1,
          actions: [
            IconButton(icon: Icon(Icons.check), onPressed: (){
              print("callapi saved");
              callAPIUpdate();
            })
          ],
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            buildBody(context),
            builGenderPart(),
            buildBodyPart2(context),
            SizedBox(height: 30,)
            // buildBodyResidentAddress(context),
          ]),
        ));
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
        mobile_code.text = '+$codeSelected';
      },
    );
  }

  Widget buildBody(BuildContext context) {
    print('buildBody ProfileVendorEditScreen');
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        padding: EdgeInsets.all(Config.kDefaultPadding * 2),
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              buildTitleHeader(title: 'Company Contact Details'),

              // FormBuilderTextField(
              //   initialValue: company,
              //   autocorrect: false,
              //   name: 'company',
              //   decoration: InputDecoration(
              //       labelText: "Club / Company Name",
              //       labelStyle: Styles.mclub_inputTextStyle),
              //   onChanged: (value) {
              //     company = value;
              //     print(company);
              //   },
              // ),
              //
              //     TextFieldPhungNoBorder(
              //       controller: company,
              //       labelText: "Club / Company Name)",
              //       hintText: "",
              //       onChange: (value) {
              //         print(value);
              //         company.text = value;
              //       },
              //       keyboardType: TextInputType.text,
              //       notAllowEmpty: true,
              //     ),

                  TextFieldPhungNoBorder(
                    controller: company_name,
                    labelText: "Club / company name",
                    hintText: "",
                    onChange: (value) {
                      print(value);
                      company_name.text = value;
                    },
                  ),

                  //PHONE CODE
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 140,
                          child: PickerMclub(
                            controller: mobile_code,
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
                              controller: mobile,
                              labelText: "Representative Mobile No.",
                              hintText: "",
                              onChange: (value) {
                                print(value);
                                mobile.text = value;
                              },
                              notAllowEmpty: true,
                            ),
                          ),
                        ),
                      ]),


              //
              // Row(children: [
              //   SizedBox(
              //     width: 100,
              //     child: PickerMclub(
              //       controller: telephone_code,
              //       titleValue: 'Country Code',
              //       onTap: () {
              //         _showPickerTelephoneCode(context);
              //       },
              //     ),
              //   ),
              //   SizedBox(
              //     width: 5,
              //   ),
              //   Flexible(
              //     child: SizedBox(
              //       child: FormBuilderTextField(
              //         initialValue: telephone_no,
              //         keyboardType: TextInputType.number,
              //         autocorrect: false,
              //         name: 'telephone_no',
              //         decoration: InputDecoration(
              //             contentPadding: EdgeInsets.zero,
              //             labelText: "Telephone No.",
              //             labelStyle: Styles.mclub_inputTextStyle),
              //         onChanged: (value) {
              //           telephone_no = value;
              //           print(value);
              //         },
              //       ),
              //     ),
              //   ),
              // ]),
              //
              // FormBuilderTextField(
              //   initialValue: company_email,
              //   autocorrect: false,
              //   name: 'email',
              //   decoration: InputDecoration(
              //       labelText: "Email Address",
              //       labelStyle: Styles.mclub_inputTextStyle),
              //   onChanged: (value) {
              //     company_email = value;
              //     print(value);
              //   },
              //   keyboardType: TextInputType.emailAddress,
              // ),

                  TextFieldPhungNoBorder(
                    controller: email,
                    labelText: "E-mail Address",
                    hintText: "",
                    onChange: (value) {
                      print(value);
                      email.text = value;
                    },
                    notAllowEmpty: true,
                    requiredEmail: true,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFieldPhungNoBorder(
                    controller: company_uen,
                    labelText: "Company Registration No. (UEN)",
                    hintText: "",
                    onChange: (value) {
                      print(value);
                      company_uen.text = value;
                    },
                  ),
                  TextFieldPhungNoBorder(
                    controller: company_about,
                    labelText: "Tell us more about your club / company",
                    hintText: "",
                    onChange: (value) {
                      print(value);
                      company_about.text = value;
                    },
                  ),
                  TextFieldPhungNoBorder(
                    controller: company_number_members,
                    labelText: "No. of members",
                    hintText: "",
                    onChange: (value) {
                      print(value);
                      company_number_members.text = value;
                    },
                    keyboardType: TextInputType.number,

                  ),

              SizedBox(
                height: Config.kDefaultPadding,
              ),
              buildTitleHeader(title: 'Company Address'),

              PickerMclub(
                controller: countryCompanyController,
                titleValue: 'Country',
                onTap: () {
                  _showPickerCountryCompany(context);
                },
              ),

                  Row(
                    children: [
                      Expanded(
                        child: TextFieldPhungNoBorder(
                          controller: company_postal_code,
                          labelText: "Postal Code",
                          hintText: "",
                          onChange: (value) {
                            print(value);
                            company_postal_code.text = value;
                          },
                          keyboardType: TextInputType.number,

                        ),
                      ),

                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: TextFieldPhungNoBorder(
                          controller: company_unit_no,
                          labelText: "Unit No",
                          hintText: "",
                          onChange: (value) {
                            print(value);
                            company_unit_no.text = value;
                          },
                        ),
                      ),

                    ],
                  ),
                  TextFieldPhungNoBorder(
                    controller: company_add_1,
                    labelText: "Address Line 1",
                    hintText: "",
                    onChange: (value) {
                      print(value);
                      company_add_1.text = value;
                    },
                  ),
                  TextFieldPhungNoBorder(
                    controller: company_add_2,
                    labelText: "Address Line 2",
                    hintText: "",
                    onChange: (value) {
                      print(value);
                      company_add_2.text = value;
                    },
                  ),

              SizedBox(
                height: 20,
              ),
              buildTitleHeader(title: 'Personal Details'),
                  TextFieldPhungNoBorder(
                    controller: fullname,
                    labelText: "Representative’s Full Name (as per NRIC)",
                    hintText: "",
                    onChange: (value) {
                      print(value);
                      fullname.text = value;
                    },
                    keyboardType: TextInputType.text,
                    notAllowEmpty: true,
                  ),


              //     FormBuilderTextField(
              //   initialValue: fullname,
              //   autocorrect: false,
              //   name: 'fullname',
              //   decoration: InputDecoration(
              //       labelText: "Full Name",
              //       labelStyle: Styles.mclub_inputTextStyle),
              //   onChanged: (value) {
              //     fullname = value;
              //     print(value);
              //   },
              // ),
            ]),
          ),
        ),
        // children: [],
      ),
    );
  }

  //gender part
  Widget builGenderPart() {
    print('buildBody buildgenderPart');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Config.kDefaultPadding * 2),
          child: Text(
            'Gender',
            style: Styles.mclub_normalText,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: buildRadio(),
          // child: FormBuilderRadioGroup(
          //   decoration: InputDecoration(
          //     contentPadding: EdgeInsets.zero,
          //     border: InputBorder.none,
          //   ),
          //   initialValue:
          //       gender == 'm' ? 'Male' : (gender == 'f' ? 'Female' : ""),
          //   name: 'gender',
          //   onChanged: (currentValue) {
          //     print(currentValue);
          //     if (currentValue == 'Male') {
          //       gender = 'm';
          //     } else if (currentValue == 'Female') {
          //       gender = 'f';
          //     }
          //   },
          //   options: [
          //     'Male',
          //     'Female',
          //   ]
          //       .map((lang) => FormBuilderFieldOption(value: lang))
          //       .toList(growable: false),
          // ),
        ),
      ],
    );
  }
  buildRadio() {
    return RadioGroup<String>.builder(
      horizontalAlignment: MainAxisAlignment.start,
      direction: Axis.horizontal,
      groupValue: gender == 'm'
          ? 'Male'
          : (gender == 'f' ? 'Female' : ""), //default value
      onChanged: (value) => setState(() {
        _verticalGroupValue = value;
        if (value == 'Male') {
          gender = 'm';
        } else if (value == 'Female') {
          gender = 'f';
        }
      }),
      items: _status,
      itemBuilder: (item) => RadioButtonBuilder(
        item,
      ),
    );
  }

  //builder body part2
  Widget buildBodyPart2(BuildContext context) {
    print('buildBody ProfileVendorEditScreen');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Config.kDefaultPadding * 2),
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //Date of birth Picker
        PickerMclub(
          // initialValue : controller.birthday,
          controller: birthdayController,
          titleValue: 'Date of Birth',
          onTap: () {
            // _showPickerDate(context);
            Session.shared.showPickerDate(context, (date) {
              handleAfterPickerDate(date);
            });
          },
        ),
        // FormBuilderTextField(
        //   initialValue: nric,
        //   autocorrect: false,
        //   name: 'nric',
        //   decoration: InputDecoration(
        //       labelText: "NRIC", labelStyle: Styles.mclub_inputTextStyle),
        //   onChanged: (value) {
        //     nric = value;
        //     print(value);
        //   },
        // ),
        TextFieldPhungNoBorder(
          controller: nric,
          labelText: "NRIC",
          hintText: "",
          onChange: (value) {
            print(value);
            nric.text = value;
          },
        ),

        //PHONE
      ]),
      // children: [],
    );
  }
  //
  // Widget buildBodyResidentAddress(BuildContext context) {
  //   print('buildBody buildBodyResidentAddress');
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: Config.kDefaultPadding * 2),
  //     color: Colors.white,
  //     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //       SizedBox(
  //         height: 20,
  //       ),
  //       buildTitleHeader(title: 'Residential Address'),
  //       PickerMclub(
  //         controller: countryController,
  //         titleValue: 'Country',
  //         onTap: () {
  //           _showPickerCountryMember(context);
  //         },
  //       ),
  //       Row(
  //         children: [
  //           Expanded(
  //             child: FormBuilderTextField(
  //               initialValue: postal_code,
  //               autocorrect: false,
  //               name: 'postal_code',
  //               decoration: InputDecoration(
  //                   labelText: "Postal Code",
  //                   labelStyle: Styles.mclub_inputTextStyle),
  //               onChanged: (value) {
  //                 postal_code = value;
  //                 print(value);
  //               },
  //               // validator: FormBuilderValidators.compose([
  //               //   FormBuilderValidators.required(context),
  //               // ]),
  //               keyboardType: TextInputType.number,
  //             ),
  //           ),
  //           SizedBox(
  //             width: 5,
  //           ),
  //           Expanded(
  //             child: FormBuilderTextField(
  //               initialValue: unit_no,
  //               autocorrect: false,
  //               name: 'unit_no',
  //               decoration: InputDecoration(
  //                   labelText: "Unit No",
  //                   labelStyle: Styles.mclub_inputTextStyle),
  //               onChanged: (value) {
  //                 unit_no = value;
  //                 print(value);
  //               },
  //               // validator: FormBuilderValidators.compose([
  //               //   FormBuilderValidators.required(context),
  //               // ]),
  //             ),
  //           ),
  //         ],
  //       ),
  //       FormBuilderTextField(
  //         initialValue: add_1,
  //         autocorrect: false,
  //         name: 'add_1',
  //         decoration: InputDecoration(
  //             labelText: "Address Line 1",
  //             labelStyle: Styles.mclub_inputTextStyle),
  //         onChanged: (value) {
  //           add_1 = value;
  //           print(value);
  //         },
  //         // validator: FormBuilderValidators.compose([
  //         //   FormBuilderValidators.required(context),
  //         // ]),
  //       ),
  //       FormBuilderTextField(
  //         initialValue: add_2,
  //         autocorrect: false,
  //         name: 'add_2',
  //         decoration: InputDecoration(
  //             labelText: "Address Line 2",
  //             labelStyle: Styles.mclub_inputTextStyle),
  //         onChanged: (value) {
  //           add_2 = value;
  //           print(value);
  //         },
  //       )
  //       //PHONE
  //     ]),
  //     // children: [],
  //   );
  // }

  // List<FormBuilderFieldOption> getListOptions_Widget() {
  //   List<FormBuilderFieldOption> list = [];
  //   var list_ = profileController.modelMemberOptionsResult?.value.relationships;
  //   for (var i = 0; i < list_.length; i++) {
  //     var item = FormBuilderFieldOption(
  //       value: list_[i].value,
  //       child: Text(list_[i].value),
  //     );
  //     list.add(item);
  //   }
  //   return list;
  // }

  // getListOptions_Widget() {
  //   var list_ = profileController.modelMemberOptionsResult?.value.relationships;
  //   return RadioGroup<String>.builder(
  //     horizontalAlignment: MainAxisAlignment.start,
  //     direction: Axis.horizontal,
  //     groupValue: controller.gender == 'm'
  //         ? 'Male'
  //         : (controller.gender == 'f' ? 'Female' : ""), //default value
  //     onChanged: (value) => setState(() {
  //       _verticalGroupValue = value;
  //       if (value == 'Male') {
  //         controller.gender = 'm';
  //       } else if (value == 'Female') {
  //         controller.gender = 'f';
  //       }
  //     }),
  //     items: _status,
  //     itemBuilder: (item) => RadioButtonBuilder(
  //       item,
  //     ),
  //   );
  // }
  //




  _callAPIUploadImage() async {
    // Session.shared.showLoading();
    print("start _callAPIUploadImage");
    //get Type
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      "file":
          await Dioo.MultipartFile.fromFile(_file.path, filename: _file.name),
      'field': typeUpload,
    });
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(
        endpoint: url_member_upload_doc,
        formData: formData,
        jsonQuery: jsonQuery);
    // var jsonBody = await network.callAPIPOST();
    // Session.shared.hideLoading();
    var jsonBody = await network.callAPI(method: "POST", percent: (percent){
      print(percent);
      if (percent != 1) {
        EasyLoading.showProgress(percent, status: 'Uploading..');
      } else {
        EasyLoading.dismiss(animation: true);
      }
    });
    if (jsonBody["code"] == 100) {
      print("success $jsonBody");
      profileController.callAPIGetProfile(); //refresh
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }

  //HANDLE PICTURE UPLOAD
  _chooseFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf']);
    if (result != null) {
      // _file = File(result.files.single.path);
      // _callAPIUploadImage();
      _file = File(result.files.single.path);
      var fileType = lookupMimeType(result.files.single.path);
      print(fileType);
      if (fileType == 'application/pdf') {
        _callAPIUploadImage();
      } else {
        Session.shared.showAlertPopupOneButtonNoCallBack(content : "File not support");
      }
    } else {
      // User canceled the picker
      print('No file selected.');
    }
  }

  loadOldData() {
    company_name.text = profileController.userProfile.value.company;
    mobile_code.text = profileController.userProfile.value.mobileCode;
    mobile.text = profileController.userProfile.value.mobile;
    fullname.text = profileController.userProfile.value.fullname;
    // company_email = profileController.userProfile.value.companyEmail;
    email.text = profileController.userProfile.value.email;
    company_uen.text = profileController.userProfile.value.eun;
    company_about.text = profileController.userProfile.value.about;
    company_number_members.text = profileController.userProfile.value.numberOfEmployees;


    //company address section
    countryCompanyController.text = profileController.getCompanyCountry();
    company_postal_code.text = profileController.userProfile.value.companyPostalCode;
    company_unit_no.text = profileController.userProfile.value.companyUnitNo;
    company_add_1.text = profileController.userProfile.value.companyAdd1;
    company_add_2.text = profileController.userProfile.value.companyAdd2;


    // countryController.text = profileController.userProfile.value.country;
    // postal_code = profileController.userProfile.value.postalCode;
    // unit_no = profileController.userProfile.value.unitNo;
    // add_1 = profileController.userProfile.value.add1;
    // add_2 = profileController.userProfile.value.add2;
    gender = profileController.userProfile.value.gender;
    birthdayController.text = profileController.userProfile.value.birthday;
    nric.text = profileController.userProfile.value.nric;

  }

  _showPickerCountryCompany(BuildContext context) {
    showCountryPicker(
      //Có thể sau này dùng lại loic showCountryPicker xem trong source và chôm lại ý tưởng!
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        print('Select country: ${country.displayName}');
        print('Select Code: ${country.countryCode}');
        var contrySelected = country.name;
        countryCompanyController.text = contrySelected;
        // controller.country = contrySelected;
        // print('codeMobile $codeMobile');
      },
    );
  }

  _showPickerCountryMember(BuildContext context) {
    showCountryPicker(
      //Có thể sau này dùng lại loic showCountryPicker xem trong source và chôm lại ý tưởng!
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        print('Select country: ${country.displayName}');
        print('Select Code: ${country.countryCode}');
        var contrySelected = country.name;
        countryController.text = contrySelected;
        // controller.country = contrySelected;
        // print('codeMobile $codeMobile');
      },
    );
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
          handleAfterPickerDate(chooseDate);
        }).showDialog(context);
  }

  handleAfterPickerDate(DateTime chooseDate) {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(chooseDate);
    birthdayController.text = formattedDate;
    // birthday = formattedDate;
  }
  //
  // _showPickerModal(BuildContext context) {
  //   Picker(
  //       adapter: PickerDataAdapter<String>(
  //           pickerdata: profileController
  //               .modelMemberOptionsResult.value.salaries
  //               .map((e) => e.value)
  //               .toList()),
  //       changeToFirst: true,
  //       hideHeader: false,
  //       selectedTextStyle: TextStyle(color: Config.secondColor),
  //       onConfirm: (Picker picker, List value) {
  //         var valueString = profileController
  //             .modelMemberOptionsResult.value.salaries[value.first].value;
  //         salaryController.text = valueString;
  //       }).showModal(context); //_scaffoldKey.currentState);
  // }

  buildTitleHeader({String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Text(
        title,
        style: Styles.mclub_Tilte,
      ),
    );
  }

  callAPIUpdate() async {
    print("start callAPIUpdate");
    var jsonBody = {
      'mobile_code' : mobile_code.text,
      'mobile' : mobile.text,
      'company': company_name.text,
      'eun' : company_uen.text,
      'number_of_employees' : company_number_members.text,
      'company_email': email.text,
      'company_country': countryCompanyController.text,
      'company_postal_code': company_postal_code.text,
      'company_unit_no': company_unit_no.text,
      'company_add_1': company_add_1.text,
      "company_add_2": company_add_2.text,
      'about': company_about.text,
      'fullname' : fullname.text,
      'gender': gender,
      'birthday': birthdayController.text,
      'nric': nric.text.toUpperCase(),

      //temp hide it personal info
      // 'country': countryController.text,
      // 'postal_code': postal_code,
      // 'unit_no': unit_no,
      // "add_1": add_1,
      // "add_2": add_2,
      // 'telephone_code': telephone_code.text,
      // 'telephone_no': telephone_no,

    };
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    Dioo.FormData formData = new Dioo.FormData.fromMap(jsonBody);
    var network = NetworkAPI(
        endpoint: url_member_update_vendor_profile,
        formData: formData,
        jsonQuery: jsonQuery);
    print(jsonBody);
    var jsonResult = await network.callAPIPOST(showLog: true);
    if (jsonResult["code"] == 100) {
      print("success $jsonBody");
      Session.shared.showAlertPopupOneButtonWithCallback(
          title: jsonResult["message"],
          callback: () {
            profileController.callAPIGetProfile();
            Get.back();
          });
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonResult["message"]);
    }
  }
}

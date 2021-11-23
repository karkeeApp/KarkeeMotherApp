import 'dart:io';

import 'package:carkee/components/TextFieldPhungNoBorder.dart';
import 'package:country_picker/country_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:carkee/components/item_upload.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/config/strings.dart';
import 'package:carkee/controllers/controllers.dart';
import 'package:dio/dio.dart' as Dioo;
import 'package:mime/mime.dart';

class ProfileMemberEditScreen extends StatefulWidget {
  @override
  _ProfileMemberEditScreenState createState() =>
      _ProfileMemberEditScreenState();
}

class _ProfileMemberEditScreenState extends State<ProfileMemberEditScreen> {
  final ProfileController profileController = Get.find();
  var fullname = TextEditingController();
  var countryController = TextEditingController();
  var birthdayController = TextEditingController();
  var salaryController = TextEditingController();
  var postal_code = TextEditingController();
  var unit_no = TextEditingController();
  var add_1 = TextEditingController();
  var add_2 = TextEditingController();
  var gender = '';
  var nric = TextEditingController();
  var profession = TextEditingController();
  var company = TextEditingController();

  var emergencyCodeController = TextEditingController();
  var contact_personControler = TextEditingController();
  var emergency_noController = TextEditingController();
  int relationship_id;
  var relationship_text = '';

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
            IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
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
            buildBodyPart3(),
            buildDocumentPart(),
          ]),
        ));
  }

  Widget buildBody(BuildContext context) {
    print('buildBody ProfileMemberEditScreen');
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        padding: EdgeInsets.all(Config.kDefaultPadding * 2),
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              buildTitleHeader(title: 'Personal Details'),
              // FormBuilderTextField(
              //   initialValue: fullname,
              //   autocorrect: false,
              //   name: 'fullname',
              //   decoration: InputDecoration(
              //       labelText: "Full Name",
              //       labelStyle: Styles.mclub_inputTextStyle),
              //   onChanged: (value) {
              //     fullname = value;
              //     print(fullname);
              //   },
              // ),
              TextFieldPhungNoBorder(
                // key: ValueKey(4),
                controller: fullname,
                labelText: "Full Name",
                hintText: "",
                onChange: (value) {
                  // print(value);
                  fullname.text = value;
                },
                // keyboardType: TextInputType.emailAddress,
                // notAllowEmpty: true,
              ),

              PickerMclub(
                controller: countryController,
                titleValue: 'Country',
                onTap: () {
                  _showPickerCountry(context);
                },
              ),

              Row(
                children: [
                  Expanded(
                    child: TextFieldPhungNoBorder(
                      controller: postal_code,
                      labelText: "Postal Code",
                      hintText: "",
                      onChange: (value) {
                        print(value);
                        postal_code.text = value;
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextFieldPhungNoBorder(
                      controller: unit_no,
                      labelText: "Unit No",
                      hintText: "",
                      onChange: (value) {
                        print(value);
                        unit_no.text = value;
                      },
                    ),
                  ),
                ],
              ),
              //address line 1,2
              TextFieldPhungNoBorder(
                controller: add_1,
                labelText: "Address Line 1",
                hintText: "",
                onChange: (value) {
                  print(value);
                  add_1.text = value;
                },
              ),
              TextFieldPhungNoBorder(
                controller: add_2,
                labelText: "Address Line 2",
                hintText: "",
                onChange: (value) {
                  print(value);
                  add_2.text = value;
                },
              ),
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
          child: FormBuilderRadioGroup(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
            initialValue:
                gender == 'm' ? 'Male' : (gender == 'f' ? 'Female' : ""),
            name: 'gender',
            onChanged: (currentValue) {
              print(currentValue);
              if (currentValue == 'Male') {
                gender = 'm';
              } else if (currentValue == 'Female') {
                gender = 'f';
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

  //builder body part2
  Widget buildBodyPart2(BuildContext context) {
    print('buildBody ProfileMemberEditScreen');
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

        TextFieldPhungNoBorder(
          controller: nric,
          labelText: "NRIC",
          hintText: "",
          onChange: (value) {
            print(value);
            nric.text = value;
          },
        ),

        TextFieldPhungNoBorder(
          controller: profession,
          labelText: "Profession",
          hintText: "",
          onChange: (value) {
            print(value);
            profession.text = value;
          },
        ),
        TextFieldPhungNoBorder(
          controller: company,
          labelText: "Company Name",
          hintText: "",
          onChange: (value) {
            print(value);
            company.text = value;
          },
        ),
        PickerMclub(
          controller: salaryController,
          titleValue: 'Annual Salary',
          onTap: () {
            _showPickerModal(context);
          },
        ),

        //SECTION EMERGENCY
        buildTitleHeader(title: 'Emergency Contact Details'),
        // FormBuilderTextField(
        //   initialValue: contact_person,
        //   autocorrect: false,
        //   name: 'contact_person',
        //   decoration: InputDecoration(
        //       labelText: "Name of person to contact in case of emergency",
        //       labelStyle: Styles.mclub_inputTextStyle),
        //   onChanged: (value) {
        //     contact_person = value;
        //     print(value);
        //   },
        // ),
        TextFieldPhungNoBorder(
          controller: contact_personControler,
          labelText: "Name of person to contact in case of emergency",
          hintText: "",
          onChange: (value) {
            print(value);
            contact_personControler.text = value;
          },
        ),

        //PHONE

        Row(children: [
          SizedBox(
            width: 100,
            child: PickerMclub(
              controller: emergencyCodeController,
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
              // child: FormBuilderTextField(
              //   initialValue: emergency_no,
              //   keyboardType: TextInputType.number,
              //   autocorrect: false,
              //   name: 'emergency_no',
              //   decoration: InputDecoration(
              //       contentPadding: EdgeInsets.zero,
              //       labelText: "Emergency Contact No.",
              //       labelStyle: Styles.mclub_inputTextStyle),
              //   onChanged: (value) {
              //     emergency_no = value;
              //     print(value);
              //   },
              // ),
              child: TextFieldPhungNoBorder(
                controller: emergency_noController,
                labelText: "Emergency Contact No.",
                hintText: "",
                onChange: (value) {
                  print(value);
                  emergency_noController.text = value;
                },
              ),
            ),
          ),
        ]),
        buildTitleHeader(title: 'Relationship'),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: Config.kDefaultPadding),
          child: Text(
            'Emergency contact should preferably not be a regular companion/participant at club activities.',
            style: Styles.mclub_normalBodyText,
          ),
        ),
      ]),
      // children: [],
    );
  }

  Widget buildBodyPart3() {
    print('buildBody ProfileMemberEditScreen');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: FormBuilderRadioGroup(
        initialValue: profileController
            .getRelationshipText(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
        orientation: OptionsOrientation.vertical,
        // name: 'are_you_owner',
        onChanged: (currentValue) {
          print(currentValue);
          relationship_id =
              profileController.getRelationshipIDFromText(currentValue);
        },
        options: getListOptions_Widget(),
      ),
    );
  }

  Widget buildDocumentPart() {
    print('buildDocumentPart');
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Config.kDefaultPadding * 2,
          vertical: Config.kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitleHeader(title: 'Documents'),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: Config.kDefaultPadding),
            child: Obx(() => XibItemUpload(
                line1: 'Your Driving Licence / NRIC',
                urlImage: profileController.userProfile.value.imgNric,
                fileType: profileController.userProfile.value.imgNricMimeType,
                onTap: () {
                  print('show Popup choose source upload');
                  typeUpload = Strings.img_nric;
                  Session.shared.showImagePicker(context, isHavePDFOption: true,
                      callback: (file) {
                    print("callback ddddddd");
                    setState(() {
                      _file = file;
                    });
                    _callAPIUploadImage();
                  });
                  // showImagePicker(context, true, Strings.img_nric);
                })),
          ),
          BottomLineMclub(),
          Obx(() => XibItemUpload(
              line1: 'Vehicle Insurance Certificate',
              urlImage: profileController.userProfile.value.imgInsurance,
              fileType:
                  profileController.userProfile.value.imgInsuranceMimeType,
              onTap: () {
                print('show Popup choose source upload');
                // showImagePicker(context, true, Strings.img_insurance);
                typeUpload = Strings.img_insurance;
                Session.shared.showImagePicker(context, isHavePDFOption: true,
                    callback: (file) {
                  print("callback ddddddd");
                  setState(() {
                    _file = file;
                  });
                  _callAPIUploadImage();
                });
              })),
          BottomLineMclub(),
          Obx(() => XibItemUpload(
              line1: 'Registration Log Card (Issued by LTA)',
              urlImage: profileController.userProfile.value.imgLogCard,
              fileType: profileController.userProfile.value.imgLogCardMimeType,
              onTap: () {
                print('show Popup choose source upload');
                // showImagePicker(context, true, Strings.img_log_card);
                typeUpload = Strings.img_log_card;
                Session.shared.showImagePicker(context, isHavePDFOption: true,
                    callback: (file) {
                  print("callback ddddddd");
                  setState(() {
                    _file = file;
                  });
                  _callAPIUploadImage();
                });
              })),

          BottomLineMclub(),

          //Authorisation Letter (If you are not the owner), only owner = 1 then show this!
          getAutho(context),
        ],
      ),
    );
  }

  getAutho(BuildContext context) {
    if (profileController.userProfile.value.areYouOwner == '1') {
      return SizedBox();
    } else {
      return Column(
        children: [
          Obx(() => XibItemUpload(
              line1: 'Authorisation Letter (If you are not the owner)',
              urlImage: profileController.userProfile.value.imgAuthorization,
              fileType:
                  profileController.userProfile.value.imgAuthorizationMimeType,
              onTap: () {
                print('show Popup choose source upload');
                // showImagePicker(context, true, Strings.img_authorization);

                typeUpload = Strings.img_authorization;
                Session.shared.showImagePicker(context, isHavePDFOption: true,
                    callback: (file) {
                  print("callback ddddddd");
                  setState(() {
                    _file = file;
                  });
                  _callAPIUploadImage();
                });
              })),
          BottomLineMclub(),
        ],
      );
    }
  }

  showImagePicker(
      context, @required bool isHavePDFOption, @required String type) {
    typeUpload = type;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                  isHavePDFOption
                      ? ListTile(
                          leading: new Icon(Icons.picture_as_pdf),
                          title: new Text('PDF'),
                          onTap: () {
                            _chooseFile();
                            Navigator.of(context).pop();
                          },
                        )
                      : SizedBox(),
                ],
              ),
            ),
          );
        });
  }

  List<FormBuilderFieldOption> getListOptions_Widget() {
    List<FormBuilderFieldOption> list = [];
    var list_ = profileController.modelMemberOptionsResult?.value.relationships;
    for (var i = 0; i < list_.length; i++) {
      var item = FormBuilderFieldOption(
        value: list_[i].value,
        child: Text(list_[i].value),
      );
      list.add(item);
    }
    return list;
  }
  //

  _imgFromGallery() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (result != null) {
      // _file = File(result.files.single.path);
      // _callAPIUploadImage();
      setState(() {
        _file = File(result.files.single.path);
      });
      if (Session.shared.isFileSizeUnder5MB(_file)) {
        var fileType = lookupMimeType(result.files.single.path);
        print(fileType);
        _callAPIUploadImage();
      } else {
        _file = null;
        Session.shared.showAlertPopupOneButtonNoCallBack(
            title: "Error", content: "File not allow > 5MB");
      }
    } else {
      print('No file selected.');
    }
  }

  //
  _imgFromCamera() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      print('upload now');
      setState(() {
        _file = File(pickedFile.path);
      });

      _callAPIUploadImage();
    } else {
      Session.shared.hideLoading();
      print('No image selected.');
    }
  }
  //
  // _imgFromGallery() async {
  //   final pickedFile =
  //       await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
  //   if (pickedFile != null) {
  //     _file = File(pickedFile.path);
  //     print('upload now');
  //     //upload now
  //     _callAPIUploadImage();
  //   } else {
  //     Session.shared.hideLoading();
  //     print('No image selected.');
  //   }
  // }

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
    var jsonBody = await network.callAPI(
        method: "POST",
        percent: (percent) {
          print(percent);
          if (percent != 1) {
            EasyLoading.showProgress(percent, status: 'Uploading..');
          } else {
            EasyLoading.dismiss(animation: true);
          }
        });
    // Session.shared.hideLoading();
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
      _file = File(result.files.single.path);
      var fileType = lookupMimeType(result.files.single.path);
      print(fileType);
      if (fileType == 'application/pdf') {
        _callAPIUploadImage();
      } else {
        Session.shared
            .showAlertPopupOneButtonNoCallBack(content: "File not support");
      }
    } else {
      // User canceled the picker
      print('No file selected.');
    }
  }

  loadOldData() {
    fullname.text = profileController.getFullName();
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

    contact_personControler.text =
        profileController.userProfile.value.contactPerson;
    emergency_noController.text =
        profileController.userProfile.value.emergencyNo;
    emergencyCodeController.text = profileController.getEmergencyCode();
    relationship_id = profileController.getRelationshipInt();
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
        countryController.text = contrySelected;
        // controller.country = contrySelected;
        // print('codeMobile $codeMobile');
      },
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
        emergencyCodeController.text = '+$codeSelected';
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

  _showPickerModal(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: profileController
                .modelMemberOptionsResult.value.salaries
                .map((e) => e.value)
                .toList()),
        changeToFirst: true,
        hideHeader: false,
        selectedTextStyle: TextStyle(color: Config.secondColor),
        onConfirm: (Picker picker, List value) {
          var valueString = profileController
              .modelMemberOptionsResult.value.salaries[value.first].value;
          salaryController.text = valueString;
        }).showModal(context); //_scaffoldKey.currentState);
  }

  buildTitleHeader({String title}) {
    return Text(
      title,
      style: Styles.mclub_Tilte,
    );
  }

  callAPIUpdate() async {
    print("start callAPIUpdate");
    var jsonBody = {
      'fullname': fullname.text,
      'country': countryController.text,
      'postal_code': postal_code.text,
      'unit_no': unit_no.text,
      "add_1": add_1.text,
      "add_2": add_2.text,
      'gender': gender,
      'birthday': birthdayController.text,
      'nric': nric.text.toUpperCase(),
      'profession': profession.text,
      'company': company.text,
      'annual_salary': salaryController.text,
      'contact_person': contact_personControler.text,
      'emergency_code': emergencyCodeController.text,
      'emergency_no': emergency_noController.text,
      'relationship': relationship_id.toString(),
    };
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    Dioo.FormData formData = new Dioo.FormData.fromMap(jsonBody);
    var network = NetworkAPI(
        endpoint: url_member_update_personal_profile,
        formData: formData,
        jsonQuery: jsonQuery);
    print(jsonBody);
    // var jsonResult = await network.callAPIPOST(showLog: true);
    var jsonResult = await network.callAPI(method: "POST", showLog: true);
    if (jsonResult["code"] == 100) {
      print("success $jsonBody");
      Session.shared.showAlertPopupOneButtonWithCallback(
          title: jsonResult["message"],
          callback: () async {
           await profileController.callAPIGetProfile();
            Get.back();
          });
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonResult["message"]);
    }
  }
}

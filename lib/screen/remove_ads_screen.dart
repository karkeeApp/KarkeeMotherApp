import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:carkee/components/item_upload.dart';
// import 'package:carkee/components/slider_guestscreen.dart';
import 'package:carkee/config/strings.dart';
// import 'package:carkee/models/ModelBannerResult.dart';
import 'package:carkee/screen/welcome_screen_company.dart';
// import 'package:country_picker/country_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_picker/flutter_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:carkee/components/TextFieldPhungNoBorder.dart';
// import 'package:carkee/components/bottom_next_back_register.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/components/network_api.dart';
import 'package:dio/dio.dart' as Dioo;
import 'package:carkee/controllers/controllers.dart';
import 'package:mime/mime.dart';
// import 'package:carkee/models/ModelMemberOptionsResult.dart';
// import 'package:carkee/screen/update_part2_company.dart';
// import 'package:carkee/screen/update_part2_personal.dart';

class RemoveAdsScreen extends StatefulWidget {
  @override
  _RemoveAdsScreenState createState() => _RemoveAdsScreenState();
}

class _RemoveAdsScreenState extends State<RemoveAdsScreen> {
  var fileType = '';

  var statusAdsMessage = "";
  TextEditingController textController = TextEditingController();
  final ProfileController profileController = Get.find();
  String typeUpload;
  File _file;
  final picker = ImagePicker();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessageText();
  }

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

  Widget body_view(BuildContext context) {
    print('Start build');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.white,
        title: Text("Ad removal", style: Styles.mclub_Tilte),
        elevation: 1,
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          child: Column(children: [
            // LineStepRegister(totalStep: 4, currentStep: 1),
            // AppNavigationV2(
            //   closeClicked: () {
            //     print("close clicked");
            //     Get.back();
            //   },
            //   title: "Get Started",
            //   subTitle:
            //   'Submit the information we need to set your app up!',
            //   totalStep: 0,//hide it
            //   currentStep: 3,
            // ),
            Expanded(
              child: ListView(
                children: [section1(context)],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  getMessageText() {
    print("start getMessageText");
    var statusAds = profileController.userProfile.value.premium_status;
    switch (statusAds) {
      case '0':
        {
          //free
          setState(() {
            statusAdsMessage =
                "Please upload a complete screenshot of your transaction for us to remove the adverts.";
          });
        }
        break;

      case '1':
        {
          //pending
          setState(() {
            statusAdsMessage =
                profileController.userProfile.value.premium_message ?? "";
          });

          print("statusAdsMessage $statusAdsMessage");
        }
        break;
      case '3':
        {
          setState(() {
            statusAdsMessage =
                profileController.userProfile.value.premium_message ?? "";
          });

          print("statusAdsMessage $statusAdsMessage");
        }
        break;
      default:
        {}
        break;
    }
  }

  Widget section1(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Config.kDefaultPadding * 2),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                statusAdsMessage,
                style: Styles.mclub_smallTilteBold,
              ),
            ),

            //
            // Obx(() => XibItemUpload(
            //     line1: 'Club Logo',
            //
            //     urlImage:
            //     profileController.userProfile.value.club_logo,
            //     fileType: profileController.userProfile.value.imgProfileMimeType,
            //     line3: "Jpeg, jpg, png, gif (Max. 5MB)",
            //     onTap: () {
            //       print('show Popup choose source upload');
            //       showImagePicker(context, false, Strings.club_logo);
            //     })),

            // BottomLineMclub(),

            Obx(() => XibItemImageFile(
                line1:
                    'Upload Screenshot of the transaction \nwith full Transaction view',
                line3: 'Jpeg, jpg, png, gif (Max. 5MB)',
                imageWidget: _file == null
                    ? Image.asset('assets/images/plusIcon.png')
                    : Image.file(_file),
                fileType:
                    profileController.userProfile.value.brand_guide_mime_type,
                onTap: () {
                  print('show Popup choose source upload');
                  // showImagePicker(context, false, Strings.brand_guide);
                  typeUpload = Strings.brand_guide;
                  Session.shared.showImagePicker(context, isHavePDFOption: false, callback: (file) {
                    print("callback ddddddd");
                    setState(() {
                      _file = file;
                    });
                  });
                })),

            BottomLineMclub(),

            TextFieldPhungNoBorder(
              controller: textController,
              labelText: "Description",
              hintText: "",
              onChange: (value) {
                print(value);
                textController.text = value;
              },
              notAllowEmpty: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: BlackButton(
                  callbackOnPress: () {
                    print('clicked~!');
                    _callAPIUpload();
                  },
                  title: "Submit"),
            )
          ],
        )
      ]),
    );
  }

  //HANDLE PDF UPLOAD
  //
  // showImagePicker(
  //     context, @required bool isHavePDFOption, @required String type) {
  //   typeUpload = type;
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return SafeArea(
  //           child: Container(
  //             child: Wrap(
  //               children: <Widget>[
  //                 ListTile(
  //                     leading: new Icon(Icons.photo_library),
  //                     title: new Text('Photo Library'),
  //                     onTap: () {
  //                       _imgFromGallery();
  //                       Navigator.of(context).pop();
  //                     }),
  //                 ListTile(
  //                   leading: new Icon(Icons.photo_camera),
  //                   title: new Text('Camera'),
  //                   onTap: () {
  //                     _imgFromCamera();
  //                     Navigator.of(context).pop();
  //                   },
  //                 ),
  //                 isHavePDFOption
  //                     ? ListTile(
  //                         leading: new Icon(Icons.picture_as_pdf),
  //                         title: new Text('PDF'),
  //                         onTap: () {
  //                           _chooseFile();
  //                           Navigator.of(context).pop();
  //                         },
  //                       )
  //                     : SizedBox(),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
  //
  // _chooseFile() async {
  //   FilePickerResult result = await FilePicker.platform.pickFiles(
  //       allowMultiple: false,
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf']);
  //   if (result != null) {
  //     // _file = File(result.files.single.path);
  //     // _callAPIUploadImage();
  //     setState(() {
  //       _file = File(result.files.single.path);
  //     });
  //
  //     var fileType = lookupMimeType(result.files.single.path);
  //     print(fileType);
  //     setState(() {
  //       this.fileType = fileType;
  //     });
  //     if (fileType == 'application/pdf') {
  //       // _callAPIUploadImage();
  //     } else {
  //       Session.shared
  //           .showAlertPopupOneButtonNoCallBack(content: "File not support");
  //     }
  //   } else {
  //     // User canceled the picker
  //     Session.shared.hideLoading();
  //     print('No file selected.');
  //   }
  // }
  //
  // _imgFromCamera() async {
  //   final pickedFile =
  //       await picker.getImage(source: ImageSource.camera, imageQuality: 50);
  //   if (pickedFile != null) {
  //     print('upload now');
  //     setState(() {
  //       _file = File(pickedFile.path);
  //     });
  //
  //     if (Session.shared.isFileSizeUnder5MB(_file)) {
  //       var fileType = lookupMimeType(_file.path);
  //       print(fileType);
  //       setState(() {
  //         this.fileType = fileType;
  //       });
  //     } else {
  //       _file = null;
  //       Session.shared.showAlertPopupOneButtonNoCallBack(
  //           title: "Error", content: "File not allow > 5MB");
  //     }
  //   } else {
  //     print('No image selected.');
  //   }
  // }
  //
  // _imgFromCamera() async {
  //   FilePickerResult result = await FilePicker.platform.pickFiles(
  //       allowMultiple: false,
  //       type: FileType.image,
  //       );
  //   if (result != null) {
  //     // _file = File(result.files.single.path);
  //     // _callAPIUploadImage();
  //     setState(() {
  //       _file = File(result.files.single.path);
  //
  //     });
  //     if (Session.shared.isFileSizeUnder5MB(_file)) {
  //       var fileType = lookupMimeType(result.files.single.path);
  //       print(fileType);
  //       setState(() {
  //         this.fileType = fileType;
  //       });
  //     } else {
  //       _file = null;
  //       Session.shared.showAlertPopupOneButtonNoCallBack(title: "Error", content: "File not allow > 5MB");
  //     }
  //   } else {
  //     print('No file selected.');
  //   }
  // }
  //
  // _imgFromGallery() async {
  //   FilePickerResult result = await FilePicker.platform.pickFiles(
  //     allowMultiple: false,
  //     type: FileType.image,
  //   );
  //   if (result != null) {
  //     // _file = File(result.files.single.path);
  //     // _callAPIUploadImage();
  //     setState(() {
  //       _file = File(result.files.single.path);
  //     });
  //     if (Session.shared.isFileSizeUnder5MB(_file)) {
  //       var fileType = lookupMimeType(result.files.single.path);
  //       print(fileType);
  //       setState(() {
  //         this.fileType = fileType;
  //       });
  //     } else {
  //       _file = null;
  //       Session.shared.showAlertPopupOneButtonNoCallBack(
  //           title: "Error", content: "File not allow > 5MB");
  //     }
  //   } else {
  //     print('No file selected.');
  //   }
  // }

  _callAPIUpload() async {
    print("start _callAPIUploadImage");
    var fileTypeArray = lookupMimeType(_file.path);
    // fileType = lookupMimeType(_file.path);
    // print(fileType);
    var fileType = fileTypeArray.split('/');
    var mediaType = MediaType(fileType[0], fileType[1]);
    print(mediaType);
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      "file": await Dioo.MultipartFile.fromFile(_file.path,
          filename: _file.name, contentType: mediaType),
      'description': textController.text,
    });
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(
        endpoint: url_userpayment_remove_ads,
        formData: formData,
        jsonQuery: jsonQuery);
    var jsonBody = await network.callAPI(
        showLog: true,
        method: "POST",
        percent: (percent) {
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
      //message
      Session.shared.showAlertPopupOneButtonWithCallback(
          title: "",
          content: jsonBody["message"],
          callback: () {
            Get.back();
          });
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }
}

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carkee/components/input_text_app.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart' as Dioo;
import 'package:carkee/screen/my_listings_vendor_screen.dart';
import 'package:mime/mime.dart';
class AddListingScreen extends StatefulWidget {
  @override
  _AddListingScreenState createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  var titleListingController = TextEditingController();
  var desListingController = TextEditingController();
  File _image;
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: PreferredSize(
        // preferredSize: AppBarLeftRightIcon().preferredSize,
        // child: AppBarLeftRightIcon(
        //   iconRight: Icon(Icons.delete, color: Colors.red),
        //   leftClicked: () {
        //     print("close clicked");
        //     Get.back();
        //   },
        //   title: 'Add Listings',
        // )),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Add Listings"),
          elevation: 0,
        ),
        body: body(context));
  }

  Widget body(BuildContext context) {
    return SingleChildScrollView(

      child: Column(
        children: [
          _image != null
              ? GestureDetector(
                  onTap: () {
                    print("image tap");
                    // showImagePicker(context);
                    Session.shared.showImagePicker(context, isHavePDFOption: false, callback: (file) {
                      print("callback ddddddd");
                      setState(() {
                        // _file = file;
                        _image = file;
                      });
                      callAPIAddListing();
                      // _callAPIUploadImage();
                    });
                  },
                  child: Image.file(
                    _image,
                    // height: 230,
                  ),
                )
              : EmptyPicture(),
          Padding(
            padding: const EdgeInsets.all(Config.kDefaultPadding * 2),
            child: InputTextApp(
                title: 'Listing Title',
                controller: titleListingController,
                placeholder: "Name your listing"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Config.kDefaultPadding * 2),
            child: InputTextApp(
                maxLines: 5,
                title: 'Description',
                controller: desListingController,
                placeholder: "Tell us more!"),
          ),
          Padding(
            padding: const EdgeInsets.all(Config.kDefaultPadding * 2),
            child: PrimaryButton(
                callbackOnPress: () {
                  print(titleListingController.text);
                  callAPIAddListing();
                },
                title: 'Save'),
          )
        ],
      ),
    );
  }

  Widget EmptyPicture() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 80),
          width: Get.width,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),

          // color: Colors.yellow,

          child: Column(children: [
            IconButton(
              padding: EdgeInsets.all(10),
              // onPressed: () => showImagePicker(context),
              onPressed: () {
                Session.shared.showImagePicker(context, isHavePDFOption: false, callback: (file){
                  print("callback ddddddd");
                  setState(() {
                    _image = file;
                  });
                });
              },
              icon: Icon(Icons.add_photo_alternate),
              iconSize: 40,
              color: Colors.black,
            ),
            // Text(
            //   'Add Image',
            //   style: Styles.mclub_normalText,
            // )
          ]),
        ),
      ),
    );
  }
  //
  // showImagePicker(BuildContext context) {
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
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
  //
  // _imgFromCamera() async {
  //   final pickedFile =
  //       await picker.getImage(source: ImageSource.camera, imageQuality: 50);
  //   if (pickedFile != null) {
  //     print('upload now');
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   } else {
  //     // Session.shared.hideLoading();
  //     print('No image selected.');
  //   }
  // }

/*
  _imgFromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      Session.shared.hideLoading();
      print('No image selected.');
    }
  }
*/
  // _imgFromGallery() async {
  //   FilePickerResult result = await FilePicker.platform.pickFiles(
  //     allowMultiple: false,
  //     type: FileType.image,
  //   );
  //   if (result != null) {
  //     // _file = File(result.files.single.path);
  //     // _callAPIUploadImage();
  //     setState(() {
  //       _image = File(result.files.single.path);
  //
  //     });
  //     if (Session.shared.isFileSizeUnder5MB(_image)) {
  //       var fileType = lookupMimeType(result.files.single.path);
  //       print(fileType);
  //     } else {
  //       _image = null;
  //       Session.shared.showAlertPopupOneButtonNoCallBack(title: "Error", content: "File not allow > 5MB");
  //     }
  //   } else {
  //     print('No file selected.');
  //   }
  // }


  callAPIAddListing() async {
    FocusScope.of(context).unfocus();//hide keyboard
    // Session.shared.showLoading();
      print("start _callAPIUploadImage");
      Dioo.FormData formData = new Dioo.FormData.fromMap({
        "imageFiles[0]": await Dioo.MultipartFile.fromFile(_image.path,filename: "_image.jpg"),
        'title' : titleListingController.text,
        'content' : desListingController.text
      });
      Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
      var network = NetworkAPI(endpoint: url_listing_add, formData: formData, jsonQuery: jsonQuery);
    var jsonBody = await network.callAPI(method: "POST", percent: (percent){
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
        final MyListingsController _controller = Get.find();
        _controller.callAPIGetLIST();
        Session.shared.showAlertPopupOneButtonWithCallback(title: "Success", content: jsonBody["message"],callback: (){
          Get.back();
        });
      } else {
        Session.shared.showAlertPopupOneButtonNoCallBack(
            title: "Error", content: jsonBody["message"]);
      }
  }
}

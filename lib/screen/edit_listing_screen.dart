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
import 'package:carkee/config/strings.dart';
import 'package:carkee/models/ModelListingResult.dart';
import 'package:carkee/screen/my_listings_vendor_screen.dart';
import 'package:mime/mime.dart';

class EditListingScreen extends StatefulWidget {
  final ModelListing modelListting;

  const EditListingScreen({Key key, this.modelListting}) : super(key: key);
  @override
  _EditListingScreenState createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  var titleListingController = TextEditingController();
  var desListingController = TextEditingController();
  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      titleListingController.text = widget.modelListting.title;
      desListingController.text = widget.modelListting.content;
    });

    print("item to edit ${widget.modelListting.toJson()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: PreferredSize(
        //     preferredSize: AppBarLeftRightIcon().preferredSize,
        //     child: AppBarLeftRightIcon(
        //       widgetRight: GestureDetector(
        //         onTap: (){
        //           print("ask confirm b4 call api delete");
        //           Session.shared.showAlertPopup2ButtonWithCallback(
        //               title: 'Confirm Delete',
        //               content: 'Are you sure?',
        //               titleButtonLeft: "Cancel",
        //               titleButtonRight: "Delete",
        //             callback: (){
        //                 final MyListingsController _controller = Get.find();
        //                 Session.shared.showLoading();
        //                 _controller.callAPIDeleteMyListing(widget.modelListting.listingId);
        //                 Session.shared.hideLoading();
        //                 Get.back();
        //             }
        //           );
        //         },
        //         child: Padding(
        //           padding: const EdgeInsets.symmetric(horizontal: Config.kDefaultPadding * 2),
        //           child: Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
        //         ),
        //       ),
        //       leftClicked: () {
        //         print("close clicked");
        //         Get.back();
        //       },
        //       title: 'Add Listings',
        //     )),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Edit Listing"),
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
                    showImagePicker(context);
                    Session.shared.showImagePicker(context, isHavePDFOption: false, callback: (file){
                      setState(() {
                        _image = file;
                      });
                      callAPIUpdateImage();
                    });
                  },
                  child: Image.file(
                    _image,
                    // height: 230,
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    print("image tap");
                    showImagePicker(context);
                  },
                  child: FadeInImage(
                      fit: BoxFit.cover,
                      // height: 230,
                      width: (Get.width),
                      image: ResizeImage(
                        CachedNetworkImageProvider(
                          widget.modelListting.primaryPhoto,
                        ),
                        width: (Get.width).toInt(),
                      ),
                      placeholder: AssetImage(Strings.placeHolderImage),
                      // placeholder image until finish loading
                      imageErrorBuilder: (context, error, st) {
                        // return Text('Something went wrong $error');
                        return Icon(
                          Icons.error_outline,
                          size: 100,
                          color: Colors.red,
                        );
                      }),
                ),
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
                  callAPIEditListing();
                },
                title: 'Update'),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
            child: PrimaryButton(
                colorButton: Config.secondColor,
                callbackOnPress: () {
                  Session.shared.showAlertPopup2ButtonWithCallback(
                      title: 'Confirm Delete',
                      content: 'Are you sure?',
                      titleButtonLeft: "Cancel",
                      titleButtonRight: "Delete",
                      callback: () {
                        final MyListingsController _controller = Get.find();
                        Session.shared.showLoading();
                        _controller.callAPIDeleteMyListing(
                            widget.modelListting.listingId);
                        Session.shared.hideLoading();
                        Get.back();
                      });
                },
                title: 'Delete Listing'),
          ),
        ],
      ),
    );
  }

  showImagePicker(BuildContext context) {
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
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      print('upload now');
      setState(() {
        _image = File(pickedFile.path);
      });
      callAPIUpdateImage();
    } else {
      // Session.shared.hideLoading();
      print('No image selected.');
    }
  }
  //


  //
  // _imgFromGallery() async {
  //   final pickedFile =
  //       await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //     callAPIUpdateImage();
  //   } else {
  //     Session.shared.hideLoading();
  //     print('No image selected.');
  //   }
  // }

  _imgFromGallery() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (result != null) {
      _image = File(result.files.single.path);
      if (Session.shared.isFileSizeUnder5MB(_image)) {
        callAPIUpdateImage();
      } else {
        _image = null;
        Session.shared.showAlertPopupOneButtonNoCallBack(title: "Error", content: "File not allow > 5MB");
      }
    } else {
      print('No file selected.');
    }
  }

  callAPIEditListing() async {
    FocusScope.of(context).unfocus(); //hide keyboard
    // Session.shared.showLoading();
    print("start _callAPIUploadImage");
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      'title': titleListingController.text,
      'content': desListingController.text,
      'status': '1',
      'listing_id': widget.modelListting.listingId
    });
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(
        endpoint: url_listing_edit, formData: formData, jsonQuery: jsonQuery);
    // var jsonBody = await network.callAPIPOST();

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
      Session.shared.showAlertPopupOneButtonWithCallback(
          title: "Success",
          content: jsonBody["message"],
          callback: () {
            Get.back();
          });
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }

  callAPIUpdateImage() async {
    print("start _callAPIUploadImage");
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      "imageFile": await Dioo.MultipartFile.fromFile(_image.path,
          filename: "_image.jpg"),
      'id': widget.modelListting.gallery.first.id
    });
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(
        endpoint: url_listing_replace_image,
        formData: formData,
        jsonQuery: jsonQuery);
    // var jsonBody = await network.callAPIPOST();
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
      final MyListingsController _controller = Get.find();
      _controller.callAPIGetLIST();
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }
}

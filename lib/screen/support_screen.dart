import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:dio/dio.dart' as Dioo;
class SupportScreen extends StatelessWidget {
  var content = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: AppBarCustomRightIcon().preferredSize,
          child: AppBarCustomRightIcon(
            leftClicked: () {
              print("close clicked");
              Get.back();
            },
            title: 'Support',
          )),
      //SliderNewsDetails(modelNews: modelNews,),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(Config.kDefaultPadding * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('How can we help?', style: Styles.mclub_Tilte),
                      SizedBox(
                        height: 10,
                      ),
                      Wrap(children: [
                        Text(
                            'Do let us know how we can assist you on your enquires and issues.',
                            style: Styles.mclub_normalBodyText)
                      ]),
                      SizedBox(
                        height: 10,
                      ),
                      FormBuilderTextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          print(value);
                          content = value;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Config.kDefaultPadding * 2),
              child: PrimaryButton(
                  callbackOnPress: () {
                    print('callapi $content');
                    callAPI(context);
                  },
                  title: 'Submit'),
            )
          ],
        ),
      ),
    );
  }
  //body

  callAPI(BuildContext context) async {
    FocusScope.of(context).unfocus();//hide keyboard
    Session.shared.showLoading();
    print("start _callAPIUploadImage");
    Dioo.FormData formData = new Dioo.FormData.fromMap({
      "message": content,
    });
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(endpoint: url_support_inquire, formData: formData, jsonQuery: jsonQuery);
    var jsonBody = await network.callAPIPOST();
    Session.shared.hideLoading();
    if (jsonBody["code"] == 100) {
      print("success $jsonBody");
      Session.shared.showAlertPopupOneButtonWithCallback(title: '', content: jsonBody['message'],callback: (){
        //go back
        Get.back();
      });
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }
}





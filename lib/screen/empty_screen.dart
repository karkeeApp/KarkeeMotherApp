import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carkee/config/app_configs.dart';

class EmptyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: AppBarCustomRightIcon().preferredSize,
          child: AppBarCustomRightIcon(
            leftClicked: () {
              print("close clicked");
              Get.back();
            },
            title: 'Settings',
          )),
      //SliderNewsDetails(modelNews: modelNews,),
      body: null,
    );
  }
}

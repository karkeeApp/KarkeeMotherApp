import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/controllers/controllers.dart';

class WelComeScreen extends StatefulWidget {
  final String welcomeText;

  const WelComeScreen({Key key, this.welcomeText}) : super(key: key);

  @override
  _WelComeScreenState createState() => _WelComeScreenState();
}

class _WelComeScreenState extends State<WelComeScreen> {
  // final ProfileController profileController = Get.find();
  final profileController = Get.put(ProfileController());
  ModelUserProfile model;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    //for test
    // if (profileController == null){
    //   final profileController = Get.put(ProfileController());
    //   model = profileController.userProfile.value;
    // } else {
    //   ProfileController profileController = Get.find();
    //   model = profileController.userProfile.value;
    // }
    //
    profileController.callAPIGetProfile();
    setState(() {
      model = profileController.userProfile.value;
    });

  }


  @override
  Widget build(BuildContext context) {
    return image_background();
  }

  Widget image_background() {
    //return Center(child: CircularProgressIndicator());
    return Material(
      child: Container(
        // color: Colors.red,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg_2.png"), fit: BoxFit.cover),
        ),
        child : blur_background()
      ),
    );
  }

  Widget blur_background() {
    //return Center(child: CircularProgressIndicator());
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
        ),
        child: body_view(),
      ),
    );
  }

  Widget body_view() {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 30,),
          title_welcome(),
          SizedBox(height: 100,),
          shape_Container(),

        ],
      ),
    );
  }

  Widget title_welcome() {
    //return Center(child: CircularProgressIndicator());
    return Center(child: Text("Welcome,\n${model?.fullname != null ? model.fullname : ""}", style: Styles.bigerHeader30Bold, textAlign: TextAlign.center,));
  }

  Widget title_body() {
    //return Center(child: CircularProgressIndicator());
    return Center(child: Text(widget.welcomeText, style: Styles.mclub_normalText, textAlign: TextAlign.center,));
  }

  Widget shape_Container() {
    //return Center(child: CircularProgressIndicator());
    return Expanded(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
              )
          ),
          avatarCircle(),
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: Column(
              children: [
                title_body(),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: BlackButton(callbackOnPress: (){
                    Session.shared.changeRootViewToDashBoard();
                  }, title: "Start Exploring"),
                )
              ],
            ),
          ),

          // Spacer(),
          // BlackButton(callbackOnPress: (){}, title: "Start Exploring")


        ],
      ),
    );
  }

  Widget avatarCircle() {
    //return Center(child: CircularProgressIndicator());
    return  Transform.translate(
      offset: Offset(0,
          -100),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 100,
        backgroundImage: NetworkImage(profileController.userProfile.value.imgProfile)
      ),
    );
  }
}

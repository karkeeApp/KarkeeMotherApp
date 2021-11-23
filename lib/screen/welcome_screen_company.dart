import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/app_configs.dart';
import '../controllers/controllers.dart';

class WelComeCompanyScreen extends StatefulWidget {

  @override
  _WelComeCompanyScreenState createState() => _WelComeCompanyScreenState();
}

class _WelComeCompanyScreenState extends State<WelComeCompanyScreen> {
  final ProfileController profileController = Get.find();
  ModelUserProfile model;

  @override
  void initState() {
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
    model = profileController.userProfile.value;
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
          color: Colors.white.withOpacity(0.7),
        ),
        child: body_view(),
      ),
    );
  }

  Widget body_view() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 20,),
            title_welcome(),
            SizedBox(height: 30,),
            avatarCircle(),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(child: Text('Thanks for your application! We’re getting the app ready and you’ll be notified as soon as it’s done!', textAlign: TextAlign.center,)),
            ),
            Spacer(),
            BlackButton(callbackOnPress: (){
              print("clicked back to home");
              Session.shared.changeRootViewToDashBoard();
            }, title: "Back to Home"),
          ],
        ),
      ),
    );
  }

  // Widget title_welcome() {
  //   //return Center(child: CircularProgressIndicator());
  //   return Center(child: Text("Welcome,\n${model?.fullname != null ? model.fullname : ""}", style: Styles.bigerHeader30Bold, textAlign: TextAlign.center,));
  // }
  Widget title_welcome() {
    //return Center(child: CircularProgressIndicator());
    return Center(child: Text("Thank You!", style: Styles.bigerHeader30Bold, textAlign: TextAlign.center,));
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
          avatarCircle()
        ],
      ),
    );
  }

  Widget avatarCircle() {
    //return Center(child: CircularProgressIndicator());
    return CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 90,
        backgroundImage: NetworkImage(profileController.userProfile.value.club_logo)
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/controllers/controllers.dart';


class MainTabProfileScreen extends StatelessWidget {
  // final ProfileController controller = Get.put(ProfileController()); //load xpong onClose() called , deleted from memory ko show len duoc!
  final profileController = Get.put<ProfileController>(ProfileController(), permanent: true);
  //"ProfileController" has been marked as permanent, SmartManagement is not authorized to delete it.
  // final ProfileController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
      ),
      body: Column(children: [
        //final ProfileController controller = Get.put(ProfileController());


        Obx(() => Text('fullname is: ${profileController.userProfile.value.fullname}')),
        // ObxText('fullname is: ${controller.userProfile.value.isVendor}'),
        RaisedButton(
          onPressed: () {
            print("logout");
            //clear token
            Session.shared.logout();
            Session.shared.changeRootViewToGuest();
          },
          child: Text("Logout"),
        ),
        RaisedButton(
          onPressed: () {
            print("clear bio");
            //clear token
            Session.shared.clearEmailForBioLogin();
            Session.shared.changeRootViewToGuest();
          },
          child: Text("Clear Bio"),
        )
      ]),
    );
  }


}

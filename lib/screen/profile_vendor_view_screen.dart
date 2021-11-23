import 'package:flutter/material.dart';
// ProfileVendorViewScreen
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:carkee/components/debouncer.dart';
import 'package:carkee/components/infoItemHorizal.dart';
import 'package:carkee/components/item_menu_setting.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/models/ModelNewsResult.dart';
import 'package:carkee/screen/photo_view.dart';
import 'package:carkee/screen/screens.dart';

class ProfileVendorViewScreen extends StatefulWidget {
  @override
  _ProfileVendorViewScreenState createState() =>
      _ProfileVendorViewScreenState();
}

class _ProfileVendorViewScreenState extends State<ProfileVendorViewScreen> {
  final ProfileController profileController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    await profileController.callApiGetMemberOptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: PreferredSize(
        //     preferredSize: AppBarLeftRightIcon().preferredSize,
        //     child: AppBarLeftRightIcon(
        //       iconRight: Icon(Icons.edit),
        //       rightClicked: () {
        //         print("rightClicked clicked");
        //         Get.to(() => ProfileVendorEditScreen());
        //       },
        //       leftClicked: () {
        //         print("close clicked");
        //         Get.back();
        //       },
        //       title: 'My Profile',
        //     )),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text("My Profile"),
          elevation: 1,
          actions: [
            IconButton(icon: Icon(Icons.edit), onPressed: (){
              print("clicked");
              Get.to(() => ProfileVendorEditScreen());
            })
          ],
        ),
        body: Obx(() => buildBody(context)));
  }

  Widget buildBody(BuildContext context) {
    print('buildBody ProfileVendorViewScreen');
    print('owner ${profileController.userProfile.value.areYouOwner}');
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              buildTitleHeader(title: 'Company Contact Details'),
              infoItemHorizalForProfileView(
                  title: 'Club / Company Name',
                  value: profileController.userProfile.value.company),
              infoItemHorizalForProfileView(
                  title: 'Contact', value: profileController.getFullMobile()),
              infoItemHorizalForProfileView(
                  title: 'Email Address', value: profileController.getEmail()),
              infoItemHorizalForProfileView(
                  title: 'About',
                  value: profileController.userProfile.value.about),
              buildTitleHeader(title: 'Company Address'),
              infoItemHorizalForProfileView(
                  title: 'Country',
                  value: profileController.getCompanyCountry()),
              infoItemHorizalForProfileView(
                  title: 'Postal Code',
                  value: profileController.userProfile.value.companyPostalCode),
              infoItemHorizalForProfileView(
                  title: 'Unit No',
                  value: profileController.userProfile.value.companyUnitNo),
              infoItemHorizalForProfileView(
                  title: 'Address Line 1',
                  value: profileController.userProfile.value.companyAdd1),
              infoItemHorizalForProfileView(
                  title: 'Address Line 2',
                  value: profileController.userProfile.value.companyAdd2),
              buildTitleHeader(title: 'Personal Details'),
              infoItemHorizalForProfileView(
                  title: 'Gender', value: profileController.getGenderString()),
              infoItemHorizalForProfileView(
                  title: 'Date of Birth',
                  value: profileController.getBirthday()),
              infoItemHorizalForProfileView(
                  title: 'NRIC', value: profileController.getNric()),
              // buildTitleHeader(title: 'Residential Address'),
              // infoItemHorizalForProfileView(
              //     title: 'Country',
              //     value: profileController.userProfile.value.country),
              // infoItemHorizalForProfileView(
              //     title: 'Postal Code',
              //     value: profileController.userProfile.value.postalCode),
              // infoItemHorizalForProfileView(
              //     title: 'Unit No',
              //     value: profileController.userProfile.value.unitNo),
              // infoItemHorizalForProfileView(
              //     title: 'Address Line 1',
              //     value: profileController.userProfile.value.add1),
              // infoItemHorizalForProfileView(
              //     title: 'Address Line 2',
              //     value: profileController.userProfile.value.add2),
            ]),
          ),
        ),
        // children: [],
      ),
    );
  }

  handleGoFUllScreen(String link, bool isPDF) {
    if (isPDF) {
      print('open webpage view PDF file');
      // goPDFViewScreen("http://africau.edu/images/default/sample.pdf");//work
      goPDFViewScreen(link);
    } else {
      print('open view Image');
      goFullScreen(link);
    }
  }

  goFullScreen(String link) {
    Get.to(() => FullImageDetailsNews(
      galleryItems: [Galleries(id: 0, url: link)],
      initialIndex: 0,
      scrollDirection: Axis.horizontal,
      backgroundDecoration: const BoxDecoration(
        color: Colors.black,
      ),
    ));
  }

  //PDFViewScreen
  goPDFViewScreen(String link) {
    Get.to(() => PDFViewScreen(linkpdf: link));
  }

  Padding buildTitleHeader({String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: Config.kDefaultPadding),
      child: Text(
        title,
        style: Styles.mclub_Tilte,
      ),
    );
  }
}

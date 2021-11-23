import 'package:flutter/material.dart';
// ProfileMemberViewScreen
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

class ProfileMemberViewScreen extends StatefulWidget {
  @override
  _ProfileMemberViewScreenState createState() =>
      _ProfileMemberViewScreenState();
}

class _ProfileMemberViewScreenState extends State<ProfileMemberViewScreen> {
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
        //         Get.to(() => ProfileMemberEditScreen());
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
              Get.to(() => ProfileMemberEditScreen());
            })
          ],
        ),
        body: Obx(() => buildBody(context)));
  }

  Widget buildBody(BuildContext context) {
    print('buildBody ProfileMemberViewScreen');
    print('owner ${profileController.userProfile.value.areYouOwner}');
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              buildTitleHeader(title: 'Personal Details'),
              infoItemHorizalForProfileView(
                  title: 'Username', value: profileController.getFullName()),
              infoItemHorizalForProfileView(
                  title: 'Gender', value: profileController.getGenderString()),
              infoItemHorizalForProfileView(
                  title: 'Date of Birth',
                  value: profileController.getBirthday()),
              infoItemHorizalForProfileView(
                  title: 'NRIC', value: profileController.getNric()),
              infoItemHorizalForProfileView(
                  title: 'Email', value: profileController.getEmail()),
              infoItemHorizalForProfileView(
                  title: 'Contact',
                  value: profileController.getContactPerson()),
              infoItemHorizalForProfileView(
                  title: 'Profession',
                  value: profileController.userProfile.value.profession),
              infoItemHorizalForProfileView(
                  title: 'Company Name',
                  value: profileController.userProfile.value.company),
              infoItemHorizalForProfileView(
                  title: 'Address', value: profileController.getAddress()),
              buildTitleHeader(title: 'Uploaded Documents'),
              infoItemImageHorizalForProfileView(
                title: 'Your Driving Licence / NRIC',
                urlImage: profileController.userProfile.value.imgNric,
                typeImage: profileController.userProfile.value.imgNricMimeType,
                onPress: (link, isPDF) {
                  handleGoFUllScreen(link,isPDF);
                },
              ),
              infoItemImageHorizalForProfileView(
                title: 'Vehicle Insurance Certificate',
                urlImage: profileController.userProfile.value.imgInsurance,
                typeImage:
                    profileController.userProfile.value.imgInsuranceMimeType,
                onPress: (link, isPDF) {
                  handleGoFUllScreen(link,isPDF);
                },
              ),
              infoItemImageHorizalForProfileView(
                title: 'Registration Log Card',
                urlImage: profileController.userProfile.value.imgLogCard,
                typeImage:
                    profileController.userProfile.value.imgLogCardMimeType,
                onPress: (link, isPDF) {
                  handleGoFUllScreen(link,isPDF);
                },
              ),
              profileController.userProfile.value.areYouOwner == "1"
                  ? SizedBox()
                  : infoItemImageHorizalForProfileView(
                      title: 'Authorisation Letter',
                      urlImage:
                          profileController.userProfile.value.imgAuthorization,
                      typeImage: profileController
                          .userProfile.value.imgAuthorizationMimeType,
                      onPress: (link, isPDF) {
                        handleGoFUllScreen(link,isPDF);
                      },
                    ),
              buildTitleHeader(title: 'Emergency Contact Details'),
              infoItemHorizalForProfileView(
                title: 'Name',
                value: profileController.getContactPerson(),
              ),
              infoItemHorizalForProfileView(
                  title: 'Contact No.',
                  value: profileController.getEmergencyNumber()),
              profileController.isHaveModelMemberOptionsResult.value
                  ? infoItemHorizalForProfileView(
                      title: 'Relationship',
                      value: profileController.getRelationshipText())
                  : SizedBox(),
              buildTitleHeader(title: 'Car Details'),
              infoItemHorizalForProfileView(
                  title: 'Chassis No.',
                  value: profileController.userProfile.value.chasisNumber),
              infoItemHorizalForProfileView(
                  title: 'Car Plate No.',
                  value: profileController.userProfile.value.plateNo),
              infoItemHorizalForProfileView(
                  title: 'Model',
                  value: profileController.userProfile.value.carModel),
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

  goFullScreen(String link){
    Get.to(() => FullImageDetailsNews(
      galleryItems: [Galleries(id: 0,url: link)],
      initialIndex: 0,
      scrollDirection: Axis.horizontal,
      backgroundDecoration: const BoxDecoration(
        color: Colors.black,
      ),
    ));
  }
  //PDFViewScreen
  goPDFViewScreen(String link){
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

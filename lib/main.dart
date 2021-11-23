
import 'package:carkee/config/config_setting.dart';
import 'package:carkee/screen/update_part5_personal.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flavor/flavor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


import 'package:carkee/screen/start_loading.dart';
import 'package:carkee/config/colors.dart';

import 'package:flutter/rendering.dart';

import 'screen/upload_payment_event.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await StartLoading.preload();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //check if QA
    return MainApp();
    // return kReleaseMode ? MainApp() : MainWithBanner();
  }

}
class MainApp extends StatelessWidget {
  const MainApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: EasyLoading.init(
          builder: (BuildContext context, Widget child) {
            final MediaQueryData data = MediaQuery.of(context);
            return MediaQuery(
              data: data.copyWith(
                  textScaleFactor: data.textScaleFactor > 2.0 ? 2.0 : data.textScaleFactor),
              child: child,
            );
          }
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.transparent,
        primarySwatch: Colors.blueGrey,
        primaryColor: Config.primaryColor,
        primaryIconTheme: const IconThemeData.fallback().copyWith(
            color: Colors.black
        ),

        primaryTextTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.black
            )
        ),
        accentColor: Config.secondColor,
        textTheme: Theme.of(context).textTheme.apply(
          fontSizeFactor: 1.0,
        ),

      ),
      // home: StartLoading(), //if use getPages don't need set initialRoute

//WelComeScreen
      initialRoute: '/',
      getPages: [
        //ListImageView
        // GetPageBottomBarStateless.dart(name: '/', page: () => StartLoading()),
        GetPage(
          name: '/',
          page: () => StartLoading(),
        ),
        // //UpdatePart5Screen
        // GetPage(
        //   name: '/',
        //   page: () => UploadPaymentEvent(),
        // ),
      ],
    );
  }
}
//chon ducoment_phung_flutter/ flutter de ve ver 1.22.6 khi setting sdk
//flutter clean --> khi can doi~ cer hoac thay doi gi lien quan den android
//flutter run --profile
//flutter run --debug
//flutter build apk --split-per-abi --no-shrink
//open build/app/outputs/flutter-apk/
//open .
//TestScreen(notificationAppLaunchDetails: notificationAppLaunchDetails),
//https://flutter.dev/docs/deployment/android#signing-the-app
//flutter build app
//The release bundle for your app is created at <app dir>/build/app/outputs/bundle/release/app.aab.
// By default, the app bundle contains your Dart code and the Flutter runtime compiled for armeabi-v7a (ARM 32-bit),
// arm64-v8a (ARM 64-bit), and x86-64 (x86 64-bit).
//setup version pubsec
//flutter build apk --release  ==> build ap ko chay dc!!
//build release : ==> flutter build appbundle
//min sdk ./android/app/build.gradle
//version pubspec.yaml
//flutter run --release // chay OK
//save trước khi up 2.0
//stable_1.22.6
//branch flutter check trong folk chay ver cu la` branch này local..
//remove all data xcode
//cd ~
//ls
//bash xcode-clean.sh -a
//Clearing archives in /Users/phungdu/Library/Developer/Xcode/Archives/* (freeing 397M disk space)
//after flutter clean run flutter run --debug

///
/// TEST NEW APK
//may M1 2021
// rm -rf build/app/outputs/bundle/release/*.*
// flutter build appbundle
// open build/app/outputs/bundle/release/
//bundletool build-apks --bundle=build/app/outputs/bundle/release/app-release.aab --output=/Users/phungdu/Downloads/carkee.apks --ks=/Users/phungdu/Documents/KEYS/key_carkee/keyCarkee.jks --ks-key-alias=key --key-pass=pass:123456 --mode=universal --overwrite
// /nhap pass
/*

123456

mv /Users/phungdu/Downloads/carkee.apks /Users/phungdu/Downloads/carkee.zip

open /Users/phungdu/Downloads/
*/


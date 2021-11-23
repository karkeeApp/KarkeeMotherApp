
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/screen/v2/event_controller.dart';
import 'package:get/get.dart';


class Utils {
  static final Utils _Utils = Utils._internal();

  factory Utils() {
    return _Utils;
  }

  Utils._internal();
  // final ProfileController profileController = Get.find();
  ProfileController getProfileController() {
    if (!Get.isRegistered<ProfileController>())
      Get.put(ProfileController(), permanent: true);
    return Get.find<ProfileController>();
  }
  EventController getEventController() {
    if (!Get.isRegistered<EventController>())
      Get.put(EventController());
    return Get.find<EventController>();
  }

}

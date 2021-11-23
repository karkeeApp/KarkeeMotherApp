import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/models/ModelEventsResultV2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class EventController extends GetxController {
  var modelEvent = ModelEvent().obs; //for switch state after booking
  var finalArray_Ongoing = <ModelEvent>[].obs;
  var finalArray_Past = <ModelEvent>[].obs;
  var searchTextController = TextEditingController();

  var isDone_eventOngoing = false.obs;
  var isDone_eventPast = false.obs;
  var page = 1;
  var isLasted = false.obs;

  var page_past = 1;
  var isLasted_past = false.obs;
  var searchTextString = '';

  var isLoading = false;
  var isDoneCallAPI = false.obs;
  var isDoneCallAPIPast = false.obs;
  var tabSelected = 0;
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    callAPIGetList_Upcoming();
    callAPIGetList_PastEvent();
  }

  @override
  void onInit() {
    // called immediately after the widget is allocated memory
    super.onInit();
  }

  @override
  void onClose() {
    // called just before the Controller is deleted from memory
    super.onClose();
  }

  Future callAPI(int tabSelected) {
    if (tabSelected == 0) {
      //đang chọn tab upcoming
      callAPIGetList_Upcoming();
    } else {
      //đang chọn tab past
      callAPIGetList_PastEvent();
    }
  }
  //
  // Future reloadData() {
  //   // if (tabSelected == 0) {
  //   //   //đang chọn tab upcoming
  //   //   isLasted.value = false;
  //   //   page = 1;
  //   //   isLasted.value = false;
  //   //   finalArray_Ongoing.clear();
  //   //   callAPIGetList_Upcoming();
  //   // } else {
  //   //   page_past = 1;
  //   //   isLasted_past.value = false;
  //   //   finalArray_Past.clear();
  //   //   callAPIGetList_PastEvent();
  //   //   //đang chọn tab past
  //   // }
  //   isLasted.value = false;
  //   page = 1;
  //   isLasted.value = false;
  //   finalArray_Ongoing.clear();
  //   callAPIGetList_Upcoming();
  //   page_past = 1;
  //   isLasted_past.value = false;
  //   finalArray_Past.clear();
  //   callAPIGetList_PastEvent();
  // }

  Future reloadData() async {
    searchTextController.text = "";
    searchTextString = "";
    isLasted.value = false;
    page = 1;
    isLasted.value = false;
    finalArray_Ongoing.clear();
    callAPIGetList_Upcoming();
  }

  Future reloadData_Past() async {
    searchTextController.text = "";
    searchTextString = "";
    page_past = 1;
    isLasted_past.value = false;
    finalArray_Past.clear();
    callAPIGetList_PastEvent();
  }

  Future callAPIGetList_Upcoming() async {
    print("start callAPIGetList_Upcoming");
    EasyLoading.show();
    var endpoint = url_event_ongoing;
    Map<String, dynamic> jsonQuery = {
      "account_id": Session.shared.HASH_ID,
      "keyword": searchTextString,
      "page": page,
      // "access-token": await Session.shared.getToken(),
    };
    if (Session.shared.isLogedin()) {
      jsonQuery = {
        "account_id": Session.shared.HASH_ID,
        "keyword": searchTextString,
        "page": page,
        "access-token": await Session.shared.getToken(),
      };
    }
    var network = NetworkAPI(endpoint: endpoint, jsonQuery: jsonQuery);
    var jsonBody = await network.callAPIGET(showLog: true, keepKeyboard: true);
    EasyLoading.dismiss();
    if (jsonBody["code"] == 100) {
      print(" => CALL API $endpoint OK");
      var modelEventsResult_ = ModelEventsResultV2.fromJson(jsonBody);
      if (page < 2) {
        //0,1 mean refresh!
        finalArray_Ongoing.value = modelEventsResult_.data;
      } else {
        //else have data
        finalArray_Ongoing.addAll(modelEventsResult_.data);
      }
      if (modelEventsResult_.currentPage >= modelEventsResult_.pageCount) {
        isLasted.value = true;
        page = modelEventsResult_.currentPage;
      }
      isLoading = false;
      isDone_eventOngoing.value = true;
    } else {
      print(
          " => CALL API $endpoint FALSE: $jsonBody with jsonQuery $jsonQuery");
      EasyLoading.showError(jsonBody["message"] ?? "");
    }
  }

  Future callAPIGetList_PastEvent() async {
    print("start url_event_pass");
    EasyLoading.show();
    var endpoint = url_event_pass;
    Map<String, dynamic> jsonQuery = {
      "account_id": Session.shared.HASH_ID,
      "keyword": searchTextString,
      "page": page_past,
    };

    if (Session.shared.isLogedin()) {
      jsonQuery = {
        "account_id": Session.shared.HASH_ID,
        "keyword": searchTextString,
        "page": page_past,
        "access-token": await Session.shared.getToken(),
      };
    }
    var network = NetworkAPI(endpoint: endpoint, jsonQuery: jsonQuery);
    var jsonBody = await network.callAPIGET(showLog: true, keepKeyboard: true);
    EasyLoading.dismiss();
    if (jsonBody["code"] == 100) {
      print(" => CALL API $endpoint OK");
      var modelEventsResult_ = ModelEventsResultV2.fromJson(jsonBody);
      if (page_past < 2) {
        //0,1 mean refresh!
        finalArray_Past.value = modelEventsResult_.data;
      } else {
        //else have data
        finalArray_Past.addAll(modelEventsResult_.data);
      }
      if (modelEventsResult_.currentPage >= modelEventsResult_.pageCount) {
        isLasted_past.value = true;
        page_past = modelEventsResult_.currentPage;
      }
      isLoading = false;
      isDone_eventPast.value = true;
    } else {
      print(
          " => CALL API $endpoint FALSE: $jsonBody with jsonQuery $jsonQuery");
      EasyLoading.showError(jsonBody["message"] ?? "");
    }
  }

  loadMore_past() async {
    print("_loadMore_past. lasted value ${isLasted_past}");
    print("_loadMore_past.value ${isLoading}");
    if (isLoading) {
      print('data loading, not allow call API');
    } else if (isLasted_past.value) {
      print('no more load _loadMore_past');
    } else {
      page_past += 1;
      print('start load more page $page_past');
      callAPIGetList_PastEvent();
    }
  }

  loadMore_upcoming() async {
    print("isLasted.value ${isLasted.value}");
    print("isLoading.value ${isLoading}");
    if (isLasted.value) {
      print('no more load _loadMore_upcoming');
    } else if (isLoading) {
      print('data loading, not allow call API');
    } else {
      page += 1;
      print('start load more page ${page}');
      callAPIGetList_Upcoming();
    }
  }
}

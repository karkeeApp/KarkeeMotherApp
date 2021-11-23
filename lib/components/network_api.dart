import 'dart:convert';
import 'package:carkee/config/config_setting.dart';
import 'package:dio/dio.dart';
import 'package:carkee/components/alertbox_custom.dart';
import 'package:carkee/config/singleton.dart';
import 'package:get/get.dart' as getMe;
import 'package:carkee/models/ModelErrorJson.dart';
import 'package:flutter/services.dart';
import 'package:carkee/screen/start_loading.dart';

class NetworkAPI {
  var endpoint = "";
  Map<String, dynamic> jsonQuery;
  FormData formData;
  NetworkAPI({
    this.endpoint,
    this.jsonQuery,
    this.formData,
  });
  var dio = Dio(
    BaseOptions(
        baseUrl: Session.shared.getBaseURL(),
        connectTimeout: 5000,
        receiveTimeout: 3000),
  );

  Future callAPIGetSetting() async {
    print("callAPIGetSetting");
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    var username = ConfigSetting.username;
    var password = ConfigSetting.password;
    var basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);
    Response response;
    dio.options.headers = {'authorization': basicAuth};
    print("callAPIGetSetting body jsonQuery: $jsonQuery");
    // print("FullURL: ${Session.shared.getBaseURL()}$endpoint");
    var fullUrl = '${Session.shared.getBaseURL()}$endpoint';
    print("FullURL: $fullUrl");
    try {
      response = await dio.get(endpoint, queryParameters: jsonQuery);
      // response = await dio.get(endpoint + "aa", queryParameters: jsonQuery);//404 test error url
      // print(response.realUri);
      print("🥦 ${response.realUri}");
      if (response.statusCode == 200) {
        // print("code 200 OK");
        logger.d(response.data);
        return response.data;
      } else {
        // return handleAPIError(response);
        print("GET $fullUrl response.data ❌ => ${response.data}");
        var modelErrorJson = ModelErrorJson.fromJson(response.data);
        print("GET $fullUrl ❌ => ${modelErrorJson.toJson()}");
        logger.d(modelErrorJson.toJson());
        return modelErrorJson;
      }
    } on DioError catch (e) {
      // var model = ModelDioError.fromJson(e.response.data);
      if (e.response.statusCode == 401) {
        Session.shared.logout();
        Session.shared.showAlertPopupOneButtonNoCallBack(
            content: "$fullUrl ${e.response.statusCode } Not found");

      } else {
        print("$fullUrl ❌❌ => ${e.response.data}");//for showing only here
        return e.response.data;
      }
      print("$fullUrl ❌❌ => ${e.response.data}");//for showing only here
      return e.response.data;

    }
  }
  Future callAPIGET({showLog = false, keepKeyboard = false}) async {
    return callAPI(showLog: showLog,keepKeyboard: keepKeyboard, method: "GET");
  }

  Future callAPIPOST({showLog = false, keepKeyboard = false}) async {
    return callAPI(showLog: showLog,keepKeyboard: keepKeyboard);

  }

  Future callAPI({method = "POST", showLog = true, keepKeyboard = true, Function(double) percent}) async {
    if (keepKeyboard == false) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }

    Response response;
    var fullUrl = '${Session.shared.getBaseURL()}$endpoint';
    print("FullURL: $fullUrl");
    // print("🥦 ${response.realUri ?? "realUri null"}");
    try {
      if (method == "POST") {
        response =
        await dio.post(endpoint, queryParameters: jsonQuery, data: formData,
          onSendProgress: (int sent, int total) {
          if (percent != null) {
            var perCent = sent.toDouble()/total.toDouble();
            percent(perCent);
          }
            // print('$sent/$total');
            // print('$sent/$total');
            // var perCent = sent.toDouble()/total.toDouble();
            // percent(perCent);
          },
        );
      } else {
        response = await dio.get(endpoint, queryParameters: jsonQuery);
      }

      if (showLog) {
        // logger.d(response.request.data.toString());
        logger.d(jsonQuery);
        logger.d(response.data);
      }
      // return response.data;
      if (response.statusCode == 200) {
        print("$fullUrl ✅");
        return response.data;
      } else {
        // return handleAPIError(response);
        var modelErrorJson = ModelErrorJson.fromJson(response.data);
        print("POST $fullUrl ❌ => ${modelErrorJson.getMessage()}");
        if (showLog) {
          //jsonQuery
          logger.d(modelErrorJson.toJson());
        }

        return modelErrorJson;
      }
    } on DioError catch (e) {
      //map error data to json
      //
      // if (e.response.statusCode == 404) {
      //   Session.shared.showAlertPopupOneButtonNoCallBack(
      //       content: "$fullUrl ${e.response.statusCode } Not found");
      //
      // } else {
      //   // var model = ModelErrorJson.fromJson(e.response.data);
      //   print("$method $fullUrl ❌❌ => ${e.response.data}");//for showing only here
      //   return e.response.data;
      //
      // }
      if (e.response.statusCode == 401) {
        Session.shared.showAlertPopupOneButtonNoCallBack(
            content: e.response.data['message']);

      } else {
        // var model = ModelErrorJson.fromJson(e.response.data);
        print("$method $fullUrl ❌❌ => ${e.response.data}");//for showing only here
        return e.response.data;

      }
      print("$method $fullUrl ❌❌ => ${e.response.data}");//for showing only here
      return e.response.data;
    }
  }


}

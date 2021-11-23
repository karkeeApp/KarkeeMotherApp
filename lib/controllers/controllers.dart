//final Controller _controller = Get.put(Controller());
//final Controller _controller = Get.find();
import 'package:carkee/models/safe_convert.dart';
import 'package:carkee/screen/start_loading.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/models/ModelMemberOptionsResult.dart';

class ProfileController extends GetxController {
  var isHaveUserProfile = false.obs;
  var userProfile = ModelUserProfile().obs;
  var modelMemberOptionsResult = ModelMemberOptionsResult().obs;
  var isHaveModelMemberOptionsResult = false.obs;
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

  callAPIGetProfile() async {
    print("start callAPIGetProfile");
    // Session.shared.showLoading();
    // var _token = await Session.shared.getToken();
    // print("_token $_token");
    var query = {"access-token": await Session.shared.getToken()};
    var network = NetworkAPI(endpoint: url_member_info, jsonQuery: query);
    print("query $query");
    var jsonRespondBody = await network.callAPI(showLog: true, method: "GET");

    if (jsonRespondBody["code"] == 100) {
      userProfile.value = ModelProfileResult.fromJson(jsonRespondBody).data;
      print("success callAPIGetProfile");
      // Session.shared.hideLoading();
      isHaveUserProfile.value = true;
      userProfile.refresh();
    } else {
      print("error callAPIGetProfile");
      isHaveUserProfile.value = false;
      if (jsonRespondBody["code"] == 0) {
        Session.shared.showAlertPopupOneButtonWithCallback(
            title: "Session Expire",
            content: "Please try login again",
            callback: () {
              Session.shared.logout();
              Session.shared.changeRootViewToGuest();
            });
      } else {
        Session.shared.showAlertPopupOneButtonNoCallBack(
            content: jsonRespondBody["message"] ?? "");
      }
    }
  }

  callAPIUpdateTopic() async {
    print("start callAPIUpdateTopic");
    // Session.shared.showLoading();
    var jsonquery_ = {
      "access-token": await Session.shared.getToken(),
      "topic": Session.shared.getTopicInt(),
    };
    var network =
        NetworkAPI(endpoint: url_member_update_topic, jsonQuery: jsonquery_);

    print('jsonquery_ $jsonquery_');
    var jsonRespondBody = await network.callAPI(showLog: true, method: "GET");

    if (jsonRespondBody["code"] == 100) {
      // userProfile.value = ModelProfileResult.fromJson(jsonRespondBody).data;
      print("success callAPIUpdateTopic");
      print(jsonRespondBody);
      // Session.shared.hideLoading();
    } else {
      print("error callAPIGetProfile");
      // Session.shared.hideLoading();
      Session.shared.showAlertPopupOneButtonWithCallback(
          content: jsonRespondBody["message"] ?? "");
    }
  }

  callApiGetMemberOptions() async {
    if (isHaveModelMemberOptionsResult.value == false) {
      print("callApiGetMemberOptions ProfileController");
      var network = NetworkAPI(
          endpoint: url_member_options,
          jsonQuery: {"access-token": await Session.shared.getToken()});
      var jsonRespondBody = await network.callAPIGET();
      if (jsonRespondBody["code"] == 100) {
        // print('jsonRespondBody $jsonRespondBody');
        modelMemberOptionsResult.value =
            ModelMemberOptionsResult.fromJson(jsonRespondBody);
        isHaveModelMemberOptionsResult.value = true;
      } else {
        EasyLoading.showError(jsonRespondBody["message"] ?? "");
        // Session.shared.showAlertPopupOneButtonWithCallback(
        //     content: jsonRespondBody["message"] ?? "");
      }
    } else {
      print("isHaveModelMemberOptionsResult true already, no need to call");
    }
  }

  String getProfileStep() {
    return userProfile.value.step;
  }

  getProfileImage(){
    //for dynamic should check here
    // if (getIsCompany()) {
    //   return userProfile.value.company_logo ?? "";
    // } else {
    //   return userProfile.value.imgProfile ?? "";
    // }
    if (Session.shared.isLogedin()){
      if (getIsCompany()) {
        return userProfile.value.company_logo ?? "";
      } else {
        return userProfile.value.imgProfile ?? "";
      }
    } else {
      return "";
    }
  }

  bool getIsCompany() {
    return (userProfile.value.isVendor == '1');
  }

  bool getIsFreeMember() {
    //premium_status = 0,1,2,3 => free, pending, approved, reject
    return userProfile.value.premium_status == '0' ||
        userProfile.value.premium_status == '1' ||
        userProfile.value.premium_status == '3';
  }

  getEmail() {
    return userProfile.value.email;
  }

  getContactPerson() {
    return userProfile.value.contactPerson;
  }

  getEmergencyNumber() {
    var e_c = userProfile.value.emergencyCode ?? "";
    var e_m = userProfile.value.emergencyNo ?? "";

    var emergency_no = "$e_c$e_m";
    return emergency_no;
  }

  getAddress() {
    return "${userProfile.value.add1}\n${userProfile.value.add2}";
  }

  getBirthday() {
    return userProfile.value.birthday;
  }

  getNric() {
    return userProfile.value.nric;
  }

  getFullName() {
    return getIsCompany()
        ? userProfile.value.company
        : userProfile.value.fullname;
  }

  getAreYouOwnerID() {
    //server return "" or text;
    if (userProfile.value.areYouOwner.isNotEmpty) {
      return int.parse(userProfile.value.areYouOwner);
    } else {
      return null;
    }
  }

  getGenderString() {
    var g = userProfile.value.gender;
    if (g == "m") {
      return "Male";
    } else {
      return "Female";
    }
  }

  getFullMobile() {
    var c = '';
    var p = '';
    if (!userProfile.value.mobileCode.isNullOrBlank) {
      c = (userProfile.value.mobileCode);
    }
    if (!userProfile.value.mobile.isNullOrBlank) {
      p = (userProfile.value.mobile);
    }
    return "$c$p";
  }

  //emergencyCode
  getEmergencyCode() {
    //default = +65
    if (userProfile.value.emergencyCode.isNotEmpty) {
      return (userProfile.value.emergencyCode);
    } else {
      return '+65';
    }
  }

  getCompanyTelePhoneCode() {
    //default = +65
    if (userProfile.value.telephoneCode.isNotEmpty) {
      return (userProfile.value.telephoneCode);
    } else {
      return '+65';
    }
  }

  getCompanyCountry() {
    //default = Singapore
    if (userProfile.value.companyCountry.isNotEmpty) {
      return (userProfile.value.companyCountry);
    } else {
      return 'Singapore';
    }
  }

  getFullTelephoneOneLine() {
    var c = userProfile.value.telephoneCode;
    var n = userProfile.value.telephoneNo;
    return '$c$n';
  }

  getRelationshipInt() {
    //server return "" or text;
    if (userProfile.value.relationship.isNotEmpty) {
      return int.parse(userProfile.value.relationship);
    } else {
      return 0;
    }
  }

  getRelationshipText() {
    print('aaaaaa');
    var idInput = getRelationshipInt();
    print('getRelationshipInt $idInput');
    if (modelMemberOptionsResult != null) {
      print('modelMemberOptionsResult != null có ${modelMemberOptionsResult.value.relationships.length}');
      logger.d(modelMemberOptionsResult.toJson());
      if (modelMemberOptionsResult.value.relationships.length > 0) {
        var item = modelMemberOptionsResult.value.relationships.firstWhere((element) {
          return idInput == element.id;
        });
        // var item = modelMemberOptionsResult.value
        //     .firstWhere((element) => element.id == idInput);
        print('modelMemberOptionsResult found ');
        return item.value;
        return "";
      } else {
        print('modelMemberOptionsResult not found ');
        return "";
      }
    } else {
      print('modelMemberOptionsResult NULL');
      return "";
    }

  }

  getRelationshipIDFromText(String stringInput) {
    // var relationshipID = getRelationshipInt();
    // print('relationshipID $relationshipID');
    // return "haha";
    if (isHaveModelMemberOptionsResult.value == false) {
      callApiGetMemberOptions();
      if (stringInput != null && isHaveModelMemberOptionsResult.value) {
        var item = modelMemberOptionsResult.value.relationships
            .firstWhere((element) => element.value == stringInput);
        return item.id;
      }
    } else {
      if (stringInput != null && isHaveModelMemberOptionsResult.value) {
        var item = modelMemberOptionsResult.value.relationships
            .firstWhere((element) => element.value == stringInput);
        return item.id;
      }
    }
  }

  getAnnualSalary() {
    if (userProfile.value.annualSalary != '') {
      return userProfile.value.annualSalary;
    } else {
      return 'Please Select';
    }
  }

  isExpire() {
    return userProfile.value.is_membership_expire ?? true;
  }

  isNearbyExpire() {
    return userProfile.value.nearExpiry ?? true;
  }
}

class ModelProfileResult {
  int code;

  ModelUserProfile data;

  ModelProfileResult({this.code, this.data});

  ModelProfileResult.fromJson(Map<String, dynamic> json) {
    code = json['code'];

    data = json['data'] != null
        ? new ModelUserProfile.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;

    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class ModelUserProfile {
  List<Clubs> clubs = [];
  bool is_membership_expire = false;
  bool nearExpiry = false;
  int renewalFee = 0;
  String headerTitle = "";
  String messageBody = "";

  String userId;
  String username;
  String email;
  String status;
  String createdAt;
  String updatedAt;
  String accountId;
  String mobile;
  String gender;
  String birthday;
  String firstname;
  String lastname;
  String mobileCode;
  String country;
  String postalCode;
  String unitNo;
  String add1;
  String add2;
  String nric;
  String profession;
  String company;
  String annualSalary;
  String chasisNumber;
  String plateNo;
  String carModel;
  String registrationCode;
  String areYouOwner;
  String contactPerson;
  String emergencyCode;
  String emergencyNo;
  String relationship;
  String imgProfile;
  String imgNric;
  String imgInsurance;
  String imgAuthorization;
  String imgLogCard;
  String imgVendor;
  String company_logo;
  //company_logo
  //club_logo
  String club_logo;
  String brand_guide;

  String transferNo;
  String transferBankingNick;
  String transferDate;
  String transferAmount;
  String transferScreenshot;
  String step;
  String isVendor;
  String is_member;
  String is_club_owner;
  String vendorName;
  String vendorDescription;
  String about;
  String iosUiid;
  String androidUiid;
  String iosBiometric;
  String androidBiometric;
  String telephoneNo;
  String foundedDate;
  String memberType;
  String carkeeMemberType;
  String telephoneCode;
  String fullname;
  String eun;
  String numberOfEmployees;
  String imgAcra;
  String imgMemorandum;
  String imgCarFront;
  String imgCarBack;
  String imgCarLeft;
  String imgCarRight;
  String resetCode;
  String longitude;
  String latitude;
  String memberExpire;
  String approvedBy;
  String confirmedBy;
  String role;
  String companyMobileCode;
  String companyMobile;
  String companyEmail;
  String companyCountry;
  String companyPostalCode;
  String companyUnitNo;
  String companyAdd1;
  String companyAdd2;
  String level;
  String carkeeLevel;
  String approvedAt;
  String statusValue;
  String memberSince;
  String isMember;
  String is_company;
  //is_premium
  String premium_status;
  //premium_message
  String premium_message;

  String memberId;
  String dashboardMessage;
  String imgProfileMimeType;
  String club_logo_mime_type;
  String brand_guide_mime_type;
  String imgNricMimeType;
  String imgInsuranceMimeType;
  String imgAuthorizationMimeType;
  String imgLogCardMimeType;
  String transferScreenshotMimeType;
  String imgVendorMimeType;
  String imgAcraMimeType;
  String imgMemorandumMimeType;
  String imgCarFrontMimeType;
  String imgCarBackMimeType;
  String imgCarLeftMimeType;
  String imgCarRightMimeType;
  List<Directors> directors;
  SocialMedia socialMedia;
  ModelUserProfile({
    this.clubs,
    this.is_membership_expire,
    this.nearExpiry,
    this.renewalFee,
    this.headerTitle,
    this.messageBody,
    this.userId,
    this.premium_status,
    this.username,
    this.email,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.accountId,
    this.mobile,
    this.gender,
    this.birthday,
    this.firstname,
    this.lastname,
    this.mobileCode,
    this.country,
    this.postalCode,
    this.unitNo,
    this.add1,
    this.add2,
    this.nric,
    this.profession,
    this.company,
    this.annualSalary,
    this.chasisNumber,
    this.plateNo,
    this.carModel,
    this.registrationCode,
    this.areYouOwner,
    this.contactPerson,
    this.emergencyCode,
    this.emergencyNo,
    this.relationship,
    this.imgProfile,
    this.imgNric,
    this.imgInsurance,
    this.imgAuthorization,
    this.club_logo_mime_type,
    this.brand_guide_mime_type,
    this.imgLogCard,
    this.company_logo,
    //company_logo
    this.club_logo,
    this.brand_guide,
    this.imgVendor,
    this.transferNo,
    this.transferBankingNick,
    this.transferDate,
    this.transferAmount,
    this.transferScreenshot,
    this.step,
    this.isVendor,
    this.is_member,
    this.is_company,
    //is_company

    this.is_club_owner,
    this.vendorName,
    this.vendorDescription,
    this.about,
    this.iosUiid,
    this.androidUiid,
    this.iosBiometric,
    this.androidBiometric,
    this.telephoneNo,
    this.foundedDate,
    this.memberType,
    this.carkeeMemberType,
    this.telephoneCode,
    this.fullname,
    this.eun,
    this.numberOfEmployees,
    this.imgAcra,
    this.imgMemorandum,
    this.imgCarFront,
    this.imgCarBack,
    this.imgCarLeft,
    this.imgCarRight,
    this.resetCode,
    this.longitude,
    this.latitude,
    this.memberExpire,
    this.approvedBy,
    this.confirmedBy,
    this.role,
    this.companyMobileCode,
    this.companyMobile,
    this.companyEmail,
    this.companyCountry,
    this.companyPostalCode,
    this.companyUnitNo,
    this.companyAdd1,
    this.companyAdd2,
    this.level,
    this.carkeeLevel,
    this.approvedAt,
    this.statusValue,
    this.memberSince,
    this.isMember,
    this.memberId,
    this.dashboardMessage,
    this.imgProfileMimeType,
    this.imgNricMimeType,
    this.imgInsuranceMimeType,
    this.imgAuthorizationMimeType,
    this.imgLogCardMimeType,
    this.transferScreenshotMimeType,
    this.imgVendorMimeType,
    this.imgAcraMimeType,
    this.imgMemorandumMimeType,
    this.imgCarFrontMimeType,
    this.imgCarBackMimeType,
    this.imgCarLeftMimeType,
    this.imgCarRightMimeType,
    this.directors,
    this.socialMedia,
    this.premium_message,
  });

  ModelUserProfile.fromJson(Map<String, dynamic> json) {
    //premium_message
    is_membership_expire =
        SafeManager.parseBoolean(json, 'is_membership_expire');
    nearExpiry = SafeManager.parseBoolean(json, 'near_expiry');
    renewalFee = SafeManager.parseInt(json, 'renewal_fee');
    headerTitle = SafeManager.parseString(json, 'header_title');
    messageBody = SafeManager.parseString(json, 'message_body');
    premium_message = json['premium_message'];
    premium_status = json['premium_status'];
    userId = json['user_id'];
    username = json['username'];
    email = json['email'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    accountId = json['account_id'];
    mobile = json['mobile'];
    gender = json['gender'];
    birthday = json['birthday'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    mobileCode = json['mobile_code'];
    country = json['country'];
    postalCode = json['postal_code'];
    unitNo = json['unit_no'];
    add1 = json['add_1'];
    add2 = json['add_2'];
    nric = json['nric'];
    profession = json['profession'];
    company = json['company'];
    annualSalary = json['annual_salary'];
    chasisNumber = json['chasis_number'];
    plateNo = json['plate_no'];
    carModel = json['car_model'];
    //company_logo
    company_logo = json['company_logo'];
    club_logo = json['club_logo'];
    brand_guide = json['brand_guide'];

    registrationCode = json['registration_code'];
    areYouOwner = json['are_you_owner'];
    contactPerson = json['contact_person'];
    emergencyCode = json['emergency_code'];
    emergencyNo = json['emergency_no'];
    relationship = json['relationship'];
    imgProfile = json['img_profile'];
    imgNric = json['img_nric'];
    imgInsurance = json['img_insurance'];
    imgAuthorization = json['img_authorization'];
    club_logo_mime_type = json['club_logo_mime_type'];
    brand_guide_mime_type = json['brand_guide_mime_type'];
    imgLogCard = json['img_log_card'];
    imgVendor = json['img_vendor'];
    transferNo = json['transfer_no'];
    transferBankingNick = json['transfer_banking_nick'];
    transferDate = json['transfer_date'];
    transferAmount = json['transfer_amount'];
    transferScreenshot = json['transfer_screenshot'];
    step = json['step'];
    isVendor = json['is_vendor'];
    is_member = json['is_member'];
    //is_company
    is_company = json['is_company'];
    is_club_owner = json['is_club_owner'];
    vendorName = json['vendor_name'];
    vendorDescription = json['vendor_description'];
    about = json['about'];
    iosUiid = json['ios_uiid'];
    androidUiid = json['android_uiid'];
    iosBiometric = json['ios_biometric'];
    androidBiometric = json['android_biometric'];
    telephoneNo = json['telephone_no'];
    foundedDate = json['founded_date'];
    memberType = json['member_type'];
    carkeeMemberType = json['carkee_member_type'];
    telephoneCode = json['telephone_code'];
    fullname = json['fullname'];
    eun = json['eun'];
    numberOfEmployees = json['number_of_employees'];
    imgAcra = json['img_acra'];
    imgMemorandum = json['img_memorandum'];
    imgCarFront = json['img_car_front'];
    imgCarBack = json['img_car_back'];
    imgCarLeft = json['img_car_left'];
    imgCarRight = json['img_car_right'];
    resetCode = json['reset_code'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    memberExpire = json['member_expire'];
    approvedBy = json['approved_by'];
    confirmedBy = json['confirmed_by'];
    role = json['role'];
    companyMobileCode = json['company_mobile_code'];
    companyMobile = json['company_mobile'];
    companyEmail = json['company_email'];
    companyCountry = json['company_country'];
    companyPostalCode = json['company_postal_code'];
    companyUnitNo = json['company_unit_no'];
    companyAdd1 = json['company_add_1'];
    companyAdd2 = json['company_add_2'];
    level = json['level'];
    carkeeLevel = json['carkee_level'];
    approvedAt = json['approved_at'];
    statusValue = json['status_value'];
    memberSince = json['member_since'];
    isMember = json['is_member'];
    memberId = json['member_id'];
    dashboardMessage = json['dashboard_message'];
    imgProfileMimeType = json['img_profile_mime_type'];
    imgNricMimeType = json['img_nric_mime_type'];
    imgInsuranceMimeType = json['img_insurance_mime_type'];
    imgAuthorizationMimeType = json['img_authorization_mime_type'];
    imgLogCardMimeType = json['img_log_card_mime_type'];
    transferScreenshotMimeType = json['transfer_screenshot_mime_type'];
    imgVendorMimeType = json['img_vendor_mime_type'];
    imgAcraMimeType = json['img_acra_mime_type'];
    imgMemorandumMimeType = json['img_memorandum_mime_type'];
    imgCarFrontMimeType = json['img_car_front_mime_type'];
    imgCarBackMimeType = json['img_car_back_mime_type'];
    imgCarLeftMimeType = json['img_car_left_mime_type'];
    imgCarRightMimeType = json['img_car_right_mime_type'];
    if (json['clubs'] != null) {
      clubs = SafeManager.parseList(json, 'clubs')
          ?.map((e) => Clubs.fromJson(e))
          ?.toList();
    }

    if (json['directors'] != null) {
      directors = new List<Directors>();
      json['directors'].forEach((v) {
        directors.add(new Directors.fromJson(v));
      });
    }
    socialMedia = json['social_media'] != null
        ? new SocialMedia.fromJson(json['social_media'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //premium_message
    data['is_membership_expire'] = this.is_membership_expire;
    data['near_expiry'] = this.nearExpiry;
    data['renewal_fee'] = this.renewalFee;
    data['header_title'] = this.headerTitle;
    data['message_body'] = this.messageBody;
    data['premium_message'] = this.premium_message;
    data['user_id'] = this.userId;
    data['is_premium'] = this.premium_status;
    data['username'] = this.username;
    data['email'] = this.email;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['account_id'] = this.accountId;
    data['mobile'] = this.mobile;
    data['company_logo'] = this.company_logo;
    data['club_logo'] = this.club_logo;
    data['brand_guide'] = this.brand_guide;
    //company_logo

    data['gender'] = this.gender;
    data['birthday'] = this.birthday;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['mobile_code'] = this.mobileCode;
    data['country'] = this.country;
    data['postal_code'] = this.postalCode;
    data['unit_no'] = this.unitNo;
    data['add_1'] = this.add1;
    data['add_2'] = this.add2;
    data['nric'] = this.nric;
    data['profession'] = this.profession;
    data['company'] = this.company;
    data['annual_salary'] = this.annualSalary;
    data['chasis_number'] = this.chasisNumber;
    data['plate_no'] = this.plateNo;
    data['car_model'] = this.carModel;
    data['is_company'] = this.is_company;
    //is_company

    data['registration_code'] = this.registrationCode;
    data['are_you_owner'] = this.areYouOwner;
    data['contact_person'] = this.contactPerson;
    data['emergency_code'] = this.emergencyCode;
    data['emergency_no'] = this.emergencyNo;
    data['relationship'] = this.relationship;
    data['img_profile'] = this.imgProfile;
    data['img_nric'] = this.imgNric;
    data['img_insurance'] = this.imgInsurance;
    data['img_authorization'] = this.imgAuthorization;
    data['img_log_card'] = this.imgLogCard;
    data['img_vendor'] = this.imgVendor;
    data['transfer_no'] = this.transferNo;
    data['transfer_banking_nick'] = this.transferBankingNick;
    data['transfer_date'] = this.transferDate;
    data['transfer_amount'] = this.transferAmount;
    data['transfer_screenshot'] = this.transferScreenshot;
    data['step'] = this.step;
    data['is_vendor'] = this.isVendor;
    data['is_member'] = this.is_member;
    data['is_club_owner'] = this.is_club_owner;
    data['vendor_name'] = this.vendorName;
    data['vendor_description'] = this.vendorDescription;
    data['about'] = this.about;
    data['ios_uiid'] = this.iosUiid;
    data['android_uiid'] = this.androidUiid;
    data['ios_biometric'] = this.iosBiometric;
    data['android_biometric'] = this.androidBiometric;
    data['telephone_no'] = this.telephoneNo;
    data['founded_date'] = this.foundedDate;
    data['member_type'] = this.memberType;
    data['carkee_member_type'] = this.carkeeMemberType;
    data['telephone_code'] = this.telephoneCode;
    data['fullname'] = this.fullname;
    data['eun'] = this.eun;
    data['number_of_employees'] = this.numberOfEmployees;
    data['img_acra'] = this.imgAcra;
    data['img_memorandum'] = this.imgMemorandum;
    data['img_car_front'] = this.imgCarFront;
    data['img_car_back'] = this.imgCarBack;
    data['img_car_left'] = this.imgCarLeft;
    data['img_car_right'] = this.imgCarRight;
    data['reset_code'] = this.resetCode;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['member_expire'] = this.memberExpire;
    data['approved_by'] = this.approvedBy;
    data['confirmed_by'] = this.confirmedBy;
    data['role'] = this.role;
    data['company_mobile_code'] = this.companyMobileCode;
    data['company_mobile'] = this.companyMobile;
    data['company_email'] = this.companyEmail;
    data['company_country'] = this.companyCountry;
    data['company_postal_code'] = this.companyPostalCode;
    data['company_unit_no'] = this.companyUnitNo;
    data['company_add_1'] = this.companyAdd1;
    data['company_add_2'] = this.companyAdd2;
    data['level'] = this.level;
    data['carkee_level'] = this.carkeeLevel;
    data['approved_at'] = this.approvedAt;
    data['status_value'] = this.statusValue;
    data['member_since'] = this.memberSince;
    data['is_member'] = this.isMember;
    data['member_id'] = this.memberId;
    data['dashboard_message'] = this.dashboardMessage;
    data['img_profile_mime_type'] = this.imgProfileMimeType;
    data['img_nric_mime_type'] = this.imgNricMimeType;
    data['img_insurance_mime_type'] = this.imgInsuranceMimeType;
    data['img_authorization_mime_type'] = this.imgAuthorizationMimeType;
    data['img_log_card_mime_type'] = this.imgLogCardMimeType;
    data['transfer_screenshot_mime_type'] = this.transferScreenshotMimeType;
    data['img_vendor_mime_type'] = this.imgVendorMimeType;
    data['img_acra_mime_type'] = this.imgAcraMimeType;
    data['img_memorandum_mime_type'] = this.imgMemorandumMimeType;
    data['img_car_front_mime_type'] = this.imgCarFrontMimeType;
    data['img_car_back_mime_type'] = this.imgCarBackMimeType;
    data['img_car_left_mime_type'] = this.imgCarLeftMimeType;
    data['img_car_right_mime_type'] = this.imgCarRightMimeType;

    if (this.clubs != null) {
      data['clubs'] = this.clubs.map((v) => v.toJson()).toList();
    }
    if (this.directors != null) {
      data['directors'] = this.directors.map((v) => v.toJson()).toList();
    }

    if (this.socialMedia != null) {
      data['social_media'] = this.socialMedia.toJson();
    }
    return data;
  }
}

class Directors {
  int directorId;
  int userId;
  String fullname;
  String email;
  String mobileCode;
  String mobileNo;
  bool isDirector;
  bool isShareholder;
  String createdAt;
  int status;
  int accountId;

  Directors(
      {this.directorId,
      this.userId,
      this.fullname,
      this.email,
      this.mobileCode,
      this.mobileNo,
      this.isDirector,
      this.isShareholder,
      this.createdAt,
      this.status,
      this.accountId});

  Directors.fromJson(Map<String, dynamic> json) {
    directorId = json['director_id'];
    userId = json['user_id'];
    fullname = json['fullname'];
    email = json['email'];
    mobileCode = json['mobile_code'];
    mobileNo = json['mobile_no'];
    isDirector = json['is_director'];
    isShareholder = json['is_shareholder'];
    createdAt = json['created_at'];
    status = json['status'];
    accountId = json['account_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['director_id'] = this.directorId;
    data['user_id'] = this.userId;
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    data['mobile_code'] = this.mobileCode;
    data['mobile_no'] = this.mobileNo;
    data['is_director'] = this.isDirector;
    data['is_shareholder'] = this.isShareholder;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    data['account_id'] = this.accountId;
    return data;
  }
}

class SocialMedia {
  int id;
  String socialMediaId;
  int socialMediaType;

  SocialMedia({this.id, this.socialMediaId, this.socialMediaType});

  SocialMedia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    socialMediaId = json['social_media_id'];
    socialMediaType = json['social_media_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['social_media_id'] = this.socialMediaId;
    data['social_media_type'] = this.socialMediaType;
    return data;
  }
}

class Clubs {
  int accountId = 0;
  String company = "";
  int status = 0;
  Object clubCode;
  Object confirmedBy;
  Object approvedBy;
  Object approvedAt;
  int isOneApproval = 0;
  int enableAds = 0;
  int skipApproval = 0;
  Object memberExpiry;
  int renewalAlert = 0;
  String createdAt = "";
  String updatedAt = "";
  String companyFullName = "";
  String address = "";
  String contactName = "";
  String email = "";
  String logo = "";
  String hashId = "";
  String prefix = "";
  int userId = 0;
  String logoUrl = "";

  Clubs({
    this.accountId,
    this.company,
    this.status,
    this.clubCode,
    this.confirmedBy,
    this.approvedBy,
    this.approvedAt,
    this.isOneApproval,
    this.enableAds,
    this.skipApproval,
    this.memberExpiry,
    this.renewalAlert,
    this.createdAt,
    this.updatedAt,
    this.companyFullName,
    this.address,
    this.contactName,
    this.email,
    this.logo,
    this.hashId,
    this.prefix,
    this.userId,
    this.logoUrl,
  });

  Clubs.fromJson(Map<String, dynamic> json)
      : accountId = SafeManager.parseInt(json, 'account_id'),
        company = SafeManager.parseString(json, 'company'),
        status = SafeManager.parseInt(json, 'status'),
        clubCode = json['club_code'],
        confirmedBy = json['confirmed_by'],
        approvedBy = json['approved_by'],
        approvedAt = json['approved_at'],
        isOneApproval = SafeManager.parseInt(json, 'is_one_approval'),
        enableAds = SafeManager.parseInt(json, 'enable_ads'),
        skipApproval = SafeManager.parseInt(json, 'skip_approval'),
        memberExpiry = json['member_expiry'],
        renewalAlert = SafeManager.parseInt(json, 'renewal_alert'),
        createdAt = SafeManager.parseString(json, 'created_at'),
        updatedAt = SafeManager.parseString(json, 'updated_at'),
        companyFullName = SafeManager.parseString(json, 'company_full_name'),
        address = SafeManager.parseString(json, 'address'),
        contactName = SafeManager.parseString(json, 'contact_name'),
        email = SafeManager.parseString(json, 'email'),
        logo = SafeManager.parseString(json, 'logo'),
        hashId = SafeManager.parseString(json, 'hash_id'),
        prefix = SafeManager.parseString(json, 'prefix'),
        userId = SafeManager.parseInt(json, 'user_id'),
        logoUrl = SafeManager.parseString(json, 'logo_url');

  Map<String, dynamic> toJson() => {
        'account_id': this.accountId,
        'company': this.company,
        'status': this.status,
        'club_code': this.clubCode,
        'confirmed_by': this.confirmedBy,
        'approved_by': this.approvedBy,
        'approved_at': this.approvedAt,
        'is_one_approval': this.isOneApproval,
        'enable_ads': this.enableAds,
        'skip_approval': this.skipApproval,
        'member_expiry': this.memberExpiry,
        'renewal_alert': this.renewalAlert,
        'created_at': this.createdAt,
        'updated_at': this.updatedAt,
        'company_full_name': this.companyFullName,
        'address': this.address,
        'contact_name': this.contactName,
        'email': this.email,
        'logo': this.logo,
        'hash_id': this.hashId,
        'prefix': this.prefix,
        'user_id': this.userId,
        'logo_url': this.logoUrl,
      };
}

import 'dart:async';
import 'package:carkee/models/ModelEventsResultV2.dart';
import 'package:carkee/screen/list_image_view.dart';
import 'package:carkee/screen/upload_payment_event.dart';
import 'package:carkee/util/utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/components/sliders_events_details.dart';
import 'package:carkee/components/sliders_news_details.dart';
import 'package:carkee/components/web_view_section.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/models/ModelEventsResult.dart';
import 'package:carkee/models/ModelNewsResult.dart';
import 'package:carkee/screen/web_view_in_app.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dio/dio.dart' as Dioo;

class DetailsNewsWeb extends StatefulWidget {
  final ModelNews modelNews;
  final ModelEvent modelEvent;
  final NewsType newsType;
  final String title;

  DetailsNewsWeb(
      {Key key,
      this.modelNews,
      this.newsType = NewsType.News,
      this.title = 'Latest News',
      this.modelEvent})
      : super(key: key);

  @override
  _DetailsNewsWebState createState() => _DetailsNewsWebState();
}

class _DetailsNewsWebState extends State<DetailsNewsWeb> {


  var controller = Utils().getEventController();
  // var isShowGradientView = false;




  getBottomButton() {
    // print("widget.modelNews ${widget.modelNews.toJson()}");
    switch (widget.newsType) {
      case NewsType.Event:
        {
          //todo
          print('Event check isAttendee later');
          return Container(
            // height: 100,
            color: Colors.white,
            padding: EdgeInsets.all(20),
            // color: Colors.red,
            child: controller.modelEvent.value.isPast
                ? SizedBox()
                : Obx(
                () => PrimaryButton(
                      colorButton: controller.modelEvent.value.isAttendee
                          ? Colors.red
                          : Config.primaryColor,
                      callbackOnPress: () {
                        //check logi or not login
                        if (Session.shared.isLogedin()) {
                          // callAPIBookSlot();
                          //check free or paid event.
                          if (widget.modelEvent.isPaidEvent() && widget.modelEvent.isNotClose()) {
                            //paid và chưa đóng thì cho book
                            //if isAttend
                            if (!controller.modelEvent.value.isAttendee) {
                              Get.to(() => UploadPaymentEvent(modelEvent: widget.modelEvent,));
                            } else {
                              //call APi cancel
                              callAPIBookSlot();
                            }
                          } else {
                            //ngược lại thì ko cho
                            callAPIBookSlot();
                          }
                        } else {
                          Session.shared.changeRootViewToLogin();
                        }

                      },
                      title: controller.modelEvent.value.isAttendee
                          ? controller.modelEvent.value.btnCancelLabel
                          : controller.modelEvent.value.btnBookLabel),
                ),
          );
        }
      case NewsType.News:
        {
          print('News check isAttendee later');
          //for guest users
          //- if news is public then just view content and remove view more button
          //- else show 'view more' and redirect to register
          if (widget.modelNews.isPublic) {
            //is_public = 1 then hide button
            // setState(() {
            //   isShowGradientView = false;
            // });

            return SizedBox();
          } else {
            // setState(() {
            //   isShowGradientView = true;
            // });

            var msgToShow = widget.modelNews.viewMoreMessage ?? "";
            //if msgToShow == "" then hide button damn!
            print("msgToShow $msgToShow");
            if (msgToShow == "" || msgToShow == null) {
              return SizedBox();
            } else {
              return Container(
                // height: 100,
                color: Colors.white,
                padding: EdgeInsets.all(20),
                // color: Colors.red,
                child: PrimaryButton(
                    colorButton: Config.secondColor,
                    callbackOnPress: () {
                      print(' widget.modelNews ${widget.modelNews.toJson()}');
                      print('viewMoreMessage $msgToShow');
                      Session.shared.showAlertPopupOneButtonNoCallBack(
                          title: msgToShow, content: '');
                    },
                    title: 'View More'),
              );
            }
          }
        }
        break;
      default:
        return SizedBox();
        break;
    }
  }

  callAPIBookSlot() async {
    print("start callAPIBookSlot");
    var bodyquery = {'event_id': controller.modelEvent.value.eventId};
    Dioo.FormData formData =
        new Dioo.FormData.fromMap(bodyquery);
    Map<String, dynamic> jsonQuery = {"access-token": await Session.shared.getToken()};
    print(bodyquery);
    var network = NetworkAPI(
        endpoint: url_event_join, formData: formData, jsonQuery: jsonQuery);
    var jsonBody = await network.callAPIPOST();
    if (jsonBody["code"] == 100) {
      setState(() {
        controller.modelEvent.value.isAttendee = !controller.modelEvent.value.isAttendee;
      });

      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: jsonBody['title'] ?? "", content: jsonBody['message']);
      print(
          "success $jsonBody"); //need update modelevent to get change button title
      print("modelEvent ${controller.modelEvent.value.isAttendee}");
    } else {
      Session.shared.showAlertPopupOneButtonNoCallBack(
          title: "Error", content: jsonBody["message"]);
    }
  }

  getSlider() {
    return widget.newsType == NewsType.News
        ? SliderNewsDetails(
            modelNews: widget.modelNews,
          )
        : SliderEventsDetails(
            modelEvent: widget.modelEvent,
          );
  }

  @override
  Widget build(BuildContext context) {
    print("debug details model");
    // print(widget.modelNews.toJson());
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        // appBar: PreferredSize(
        //     preferredSize: AppBarCustomRightIcon().preferredSize,
        //     child: AppBarCustomRightIcon(
        //       leftClicked: () {
        //         print("close clicked");
        //         Get.back();
        //       },
        //       title: widget.title,
        //     )),
        //SliderNewsDetails(modelNews: modelNews,),
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          title: (this.widget.newsType == NewsType.Event) ? Text("") : Text(""),
          elevation: 1,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: isHaveGalleries()
                  ? FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        // side: BorderSide(color: Colors.red)
                      ),
                      color: Colors.white,
                      onPressed: () {
                        if (this.widget.newsType == NewsType.Event) {
                          Get.to(() => ListImageView(
                            galleries: widget.modelEvent.galleries,
                          ));
                        } else {
                          Get.to(() => ListImageView(
                            galleries: widget.modelNews.galleries,
                          ));
                        }
                      },
                      child: Text("See all"))
                  : SizedBox(),
            ),
            GestureDetector(
              onTap: (){
                _onShareWithEmptyOrigin(context);
              },
              child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(
                    Icons.share,
                    color: Colors.white,
                  )),
            ),
          ],
        ),
        body: ListView(padding: EdgeInsets.only(top: 0), //tràn viền
            children: [
              Stack(
                children: [
                  getSlider(),
                  // AppBarTransparent(
                  //   showRightIcon: isHaveGalleries(),
                  //   title: (this.widget.newsType == NewsType.Event)
                  //       ? "Events"
                  //       : "News",
                  //   leftClicked: () {
                  //     print("left clicked");
                  //     Get.back();
                  //   },
                  //   rightClicked: () {
                  //     print("rightClicked");
                  //     //check event or news
                  //     //List<Galleries> galleries
                  //     if (this.widget.newsType == NewsType.Event) {
                  //       Get.to(() => ListImageView(
                  //         galleries: widget.modelEvent.galleries,
                  //       ));
                  //     } else {
                  //       Get.to(() => ListImageView(
                  //         galleries: widget.modelNews.galleries,
                  //       ));
                  //     }
                  //   },
                  // ),
                  Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 160),
                          child: WebViewSection(
                              url: widget.newsType == NewsType.News
                                  ? widget.modelNews.url
                                  : widget.modelEvent.url),
                        ),
                      ]),
                ],
              ),
              getBottomButton()
            ]));
  }

  _onShareWithEmptyOrigin(BuildContext context) async {
    switch (widget.newsType) {
      case NewsType.Event:
        {
          //todo
          print('Event');
          print(widget.modelEvent.url);
          await Share.share(widget.modelEvent.url);
        }
        break;
      case NewsType.News:
        {
          print('News');
          print(widget.modelNews.url);
          await Share.share(widget.modelNews.url);
        }
        break;
      default:
        // return SizedBox();
        break;
    }
  }

  isHaveGalleries() {
    if (widget.newsType == NewsType.News) {
      return (widget.modelNews?.galleries?.length > 0);
    }
    if (widget.newsType == NewsType.Event) {
      return (widget.modelEvent?.galleries?.length > 0);
    }
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.modelEvent.value = widget.modelEvent;

  }
}

enum NewsType { Event, News }


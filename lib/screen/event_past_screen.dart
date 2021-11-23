import 'package:carkee/components/debouncer.dart';
import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/colors.dart';
import 'package:carkee/config/singleton.dart';
import 'package:carkee/config/styles.dart';
import 'package:carkee/controllers/controllers.dart';
import 'package:carkee/models/ModelEventsResult.dart';
import 'package:carkee/networks_app/url_app.dart';
import 'package:carkee/screen/v2/event_controller.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:carkee/components/search_bar_phung.dart';
import 'package:carkee/components/load_image_component.dart';
import 'package:get/get.dart';

import 'event_tab_screen.dart';
import 'news_details_web.dart';

class EventPastScreen extends StatefulWidget {
  final String searchTextString;

  const EventPastScreen({Key key, this.searchTextString}) : super(key: key);
  @override
  _EventPastScreenState createState() => _EventPastScreenState();
}

class _EventPastScreenState extends State<EventPastScreen> {
  final ProfileController profileController = Get.find();
  final EventController logic = Get.find();
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState EventPastScreen");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Container(
            color: Colors.white,
            child: SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  // getSearchbar(),
                  Expanded(
                    child: LazyLoadScrollView(
                      // scrollOffset : 0,
                      isLoading: logic.isLoading,
                      onEndOfPage: () {
                        logic.loadMore_past();
                      },
                      child: RefreshIndicator(
                        onRefresh: logic.reloadData_Past,
                        child: Obx(
                            () => ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: logic.finalArray_Past.length,
                              itemBuilder: (BuildContext context, int itemIndex) {
                                return GestureDetector(
                                  onTap: () {
                                    var itemTapped = logic.finalArray_Past[itemIndex];
                                    // print(
                                    //     'itemTapped newsId ${itemTapped.eventId}');
                                    print(
                                        '✅ itemTapped newsId ${itemTapped.toJson()}');
                                    Get.to(
                                      () => DetailsNewsWeb(
                                          modelEvent: itemTapped,
                                          newsType: NewsType.Event,
                                          title: "Events"),
                                    );
                                  },
                                  child: buildItem_Past(itemIndex),
                                );
                              }),
                        ),
                      ),
                    ),
                  )
                ]))));
  }

  buildItem_Past(int itemIndex) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: LoadImageFromUrl(logic.finalArray_Past[itemIndex].image),
              ),
              Padding(
                padding: const EdgeInsets.all(Config.kDefaultPadding),
                child: Text(logic.finalArray_Past[itemIndex].title,
                    maxLines: 1,
                    style: Styles.mclub_smallTilteBold,
                    overflow: TextOverflow.ellipsis),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: Config.kDefaultPadding,
                    right: Config.kDefaultPadding,
                    bottom: Config.kDefaultPadding * 2),
                child: ExtendedText(
                  logic.finalArray_Past[itemIndex].summary,
                  maxLines: 2,
                  style: Styles.mclub_smallText,
                  // overflow: TextOverflow.ellipsis,
                  overflowWidget: TextOverflowWidget(
                    //maxHeight: double.infinity,
                    //align: TextOverflowAlign.right,
                    //fixedOffset: Offset.zero,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text('\u2026 '),
                        Text(
                          "See more",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Config.secondColor),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}

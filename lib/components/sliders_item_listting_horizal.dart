
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/config/strings.dart';
import 'package:carkee/models/ModelItemListingResult.dart';
import 'package:carkee/models/ModelListingResult.dart';
import 'package:transparent_image/transparent_image.dart';
//phase 2
class SliderItemsList extends StatelessWidget {
  final List<ModelItem> modelItems;

  final Function(ModelItem item) didTap;

  const SliderItemsList({Key key, this.modelItems, this.didTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return modelItems.length > 0 ? Container(
      constraints: BoxConstraints(minHeight: 270, maxHeight: 290),
      // height: 290,
      // color: Colors.yellow,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: modelItems.length,
          itemBuilder: (BuildContext context, int itemIndex) {
            return GestureDetector(
              onTap: () => didTap(modelItems[itemIndex]),
              child: Container(
                width: 170,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInImage(
                          fit: BoxFit.cover,
                          height: 170,
                          width: 170,
                          image: ResizeImage(
                            CachedNetworkImageProvider(
                              modelItems[itemIndex].geImageUrl(),
                            ),
                            width: 170,
                          ),
                          placeholder: AssetImage(Strings.placeHolderImage),
                          // placeholder image until finish loading
                          imageErrorBuilder: (context, error, st) {
                            return Text(error.toString());
                          }),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(modelItems[itemIndex].title,
                          maxLines: 2,
                          style: Styles.mclub_smallTilteBold,
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor: 1,
                        ),

                      ),

                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Text(modelItems[itemIndex].content,
                              maxLines: 3,
                              style: Styles.mclub_smallText,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              textScaleFactor: 1,
                            ),)
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    ) : SizedBox();
  }

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    // currentIndex = index;
    // print('currentIndex $index');
  }
}
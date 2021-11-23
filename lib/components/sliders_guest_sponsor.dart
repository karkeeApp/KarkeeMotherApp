
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/config/strings.dart';
import 'package:carkee/models/ModelListingResult.dart';
import 'package:transparent_image/transparent_image.dart';


class SliderSponsor extends StatelessWidget {
  final List<ModelListing> modelListings;

  final Function(ModelListing item) didTap;

  const SliderSponsor({Key key, this.modelListings, this.didTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return modelListings.length > 0 ? Container(
      constraints: BoxConstraints(minHeight: 250, maxHeight: 250),
      // height: 290,
      // color: Colors.yellow,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: modelListings.length,
          itemBuilder: (BuildContext context, int itemIndex) {
            return GestureDetector(
              onTap: () => didTap(modelListings[itemIndex]),
              child: Container(
                width: 170,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        child: FadeInImage(
                            fit: BoxFit.cover,
                            height: 170,
                            width: 170,
                            image: ResizeImage(
                              CachedNetworkImageProvider(
                                modelListings[itemIndex].primaryPhoto,
                              ),
                              width: 170,
                            ),
                            placeholder: AssetImage(Strings.placeHolderImage),
                            // placeholder image until finish loading
                            imageErrorBuilder: (context, error, st) {
                              return Text(error.toString());
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(modelListings[itemIndex].title,
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
                            child: Text(modelListings[itemIndex].content,
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

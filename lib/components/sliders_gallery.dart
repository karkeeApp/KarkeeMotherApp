import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/config/strings.dart';
import 'package:carkee/models/ModelBannerResult.dart';
import 'package:carkee/models/ModelNewsResult.dart';
import 'package:carkee/screen/photo_view.dart';
import 'package:transparent_image/transparent_image.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class SliderGalleries extends StatelessWidget {
  final List<ModelGallery> modelGalleries;

  final Function(ModelGallery item) didTap;
  const SliderGalleries({Key key, this.modelGalleries, this.didTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
        itemCount: modelGalleries.length,
        // itemCount: 30,
        itemBuilder: (BuildContext context, int itemIndex, int realIndex) => Container(
              child: GestureDetector(
                onTap: () {
                  didTap(modelGalleries[itemIndex]);
                  Get.to(() => FullImagePageRoute(
                    galleryItems: modelGalleries,
                    initialIndex: itemIndex,
                    scrollDirection: Axis.horizontal,
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                  ));
                },
                child: Container(
                  // color: Colors.red,
                    margin: EdgeInsets.all(5.0),
                  child: FadeInImage(
                      fit: BoxFit.cover,
                      height: 230,
                      width: Get.width - 40,
                      image: ResizeImage(
                        CachedNetworkImageProvider(
                          modelGalleries[itemIndex].image,
                        ),
                        width: (Get.width - 40).toInt(),
                        // width: MediaQuery.of(context).size.width.toInt(),
                      ),
                      placeholder: AssetImage(Strings.placeHolderImage),
                      // placeholder image until finish loading
                      imageErrorBuilder: (context, error, st) {
                        return Text(error.toString());
                      }
                      ),
                ),
              ),
            ),
        options: CarouselOptions(
          height: 230,

          // aspectRatio: 16/9,
          viewportFraction: 0.9,
          initialPage: 0,
          onPageChanged: onPageChange,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 5),
          enlargeCenterPage: false, // invisual item lower
          enlargeStrategy: CenterPageEnlargeStrategy.height,
        ));
  }

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    // currentIndex = index;
    print('currentIndex $index');
  }
}

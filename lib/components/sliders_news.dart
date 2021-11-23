import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/config/strings.dart';
import 'package:carkee/models/ModelNewsResult.dart';
import 'package:carkee/screen/photo_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SliderNews extends StatelessWidget {
  final List<ModelNews> modelNews;

  final Function(ModelNews item) didTap;
  const SliderNews({Key key, this.modelNews, this.didTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return modelNews.length > 0 ? LazyLoadScrollView(
      onEndOfPage: () => print('load more'),
      child: CarouselSlider.builder(
          itemCount: modelNews.length,
          itemBuilder: (BuildContext context, int itemIndex, int realIndex) => Container(
                child: GestureDetector(
                  onTap: () {
                    didTap(modelNews[itemIndex]);
                  },
                  child: Container(
                      // color: Colors.red,
                      height: 310,
                      margin: EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeInImage(
                              fit: BoxFit.cover,
                              height: 230,
                              width: (Get.width - 40),
                              image: ResizeImage(
                                CachedNetworkImageProvider(
                                  modelNews[itemIndex].image,
                                ),
                                width: (Get.width - 40).toInt(),
                              ),
                              placeholder: AssetImage(Strings.placeHolderImage),
                              // placeholder image until finish loading
                              imageErrorBuilder: (context, error, st) {
                                // return Text('Something went wrong $error');
                                return Icon(Icons.error_outline, size: 100, color: Colors.red,);
                              }),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(modelNews[itemIndex].title,
                                maxLines: 1,
                                style: Styles.mclub_smallTilteBold,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Text(modelNews[itemIndex].summary,
                              maxLines: 2,
                              style: Styles.mclub_smallText,
                              overflow: TextOverflow.ellipsis),
                        ],
                      )
                  ),
                ),
              ),
          options: CarouselOptions(
            height: 310,

            // aspectRatio: 16/9,
            viewportFraction: 0.9,
            initialPage: 0,
            onPageChanged: onPageChange,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            enlargeCenterPage: false, // invisual item lower
            enlargeStrategy: CenterPageEnlargeStrategy.height,
          )
      ),
    ) : SizedBox();
  }

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    // currentIndex = index;
    // print('currentIndex $index');
  }

}

import 'dart:ui';

import 'package:carkee/components/load_image_component.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/config/strings.dart';
import 'package:carkee/models/ModelBannerResult.dart';
import 'package:carkee/models/ModelNewsResult.dart';
import 'package:carkee/screen/photo_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SliderNewsDetails extends StatefulWidget {
  final ModelNews modelNews;

  SliderNewsDetails({Key key, this.modelNews}) : super(key: key);

  @override
  _SliderNewsDetailsState createState() => _SliderNewsDetailsState();
}

class _SliderNewsDetailsState extends State<SliderNewsDetails> {
  final CarouselController _controller = CarouselController();
  var _current = 0.obs;
  List<Galleries> finalArrayImage;

  getfinalArrayImage() {
    finalArrayImage = [];
    var modelNew = Galleries(id: 0, url: widget.modelNews.image);
    setState(() {
      finalArrayImage.add(modelNew);
    });
    if (widget.modelNews.galleries.length > 0) {
      setState(() {
        finalArrayImage.addAll(widget.modelNews.galleries);
      });
    } else {
      print("empty galleries");
    }

    print('finalArrayImage have item: ${finalArrayImage.length}');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getfinalArrayImage();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: finalArrayImage.length,
          itemBuilder: (BuildContext context, int itemIndex, int realIndex) =>
              Container(
            child: GestureDetector(
              onTap: () {
                goFullScreen(itemIndex);
              },
              child: Container(
                  // color: Colors.red,
                  width: (Get.width),
                  height: 230,
                  margin: EdgeInsets.all(0.0),
                  child: LoadImageFromUrl(
                    finalArrayImage[itemIndex].url,
                    height: 230,
                    boxFit: BoxFit.cover,
                    width: double.infinity,
                  )),
            ),
          ),
          options: CarouselOptions(
              height: 230,
              viewportFraction: 1.0,
              initialPage: 0,
              // autoPlay: true,
              autoPlay: finalArrayImage.length > 1 ? true : false,
              autoPlayInterval: Duration(seconds: 5),
              enlargeCenterPage: false, // invisual item lower
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              onPageChanged: (index, reason) {
                _current.value = index;
              }),
        ),
        //Slide thumnail
        // Obx(() => finalArrayImage.length > 1 ? getIndicatorBotom() : SizedBox())
        // Obx(() => finalArrayImage.length > 1 ? getIndicatorBotom() : SizedBox())
        (finalArrayImage.length > 1) ? buildthumnailGaleries() : SizedBox(),
      ],
    );
  }

  getIndicatorBotom() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: finalArrayImage.map((url) {
          int index = finalArrayImage.indexOf(url);
          return Container(
            width: 10.0,
            height: 10.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                color: _current == index ? Colors.transparent : Colors.white),
          );
        }).toList(),
      ),
    );
  }

  Container buildthumnailGaleries() {
    return Container(
      height: 80,
      // color: Colors.yellow,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 0),
          itemCount: finalArrayImage.length,
          itemBuilder: (BuildContext context, int itemIndex) {
            return GestureDetector(
              onTap: () {
                _controller.animateToPage(itemIndex);
                goFullScreen(itemIndex);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                  left: 5,
                ),
                child: Obx(() => Container(
                      foregroundDecoration: itemIndex == _current.value
                          ? null
                          : BoxDecoration(color: Colors.white.withOpacity(0.5)),
                      width: 80,
                      child: FadeInImage(
                          fit: BoxFit.cover,
                          height: 80,
                          width: 80,
                          image: ResizeImage(
                            CachedNetworkImageProvider(
                              finalArrayImage[itemIndex].url,
                            ),
                            width: 80,
                          ),
                          placeholder: AssetImage(Strings.placeHolderImage),
                          // placeholder image until finish loading
                          imageErrorBuilder: (context, error, st) {
                            return Text(error.toString());
                          }),
                    )),
              ),
            );
          }),
    );
  }

  goFullScreen(int itemIndex) {
    Get.to(() => FullImageDetailsNews(
          galleryItems: finalArrayImage,
          initialIndex: itemIndex,
          scrollDirection: Axis.horizontal,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
        ));
  }
}

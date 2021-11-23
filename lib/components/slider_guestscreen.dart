import 'package:cached_network_image/cached_network_image.dart';
import 'package:carkee/components/load_image_component.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carkee/config/strings.dart';
import 'package:carkee/models/ModelBannerResult.dart';

class SliderGuestScreen extends StatelessWidget {
  final List<ModelGallery> modelGalleries;

  final Function(ModelGallery item) didTap;
  const SliderGuestScreen({Key key, @required this.modelGalleries, this.didTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
        itemCount: modelGalleries.length,
        // itemCount: 30,
        itemBuilder: (BuildContext context, int itemIndex, int realIndex) =>
            Container(
              child: Container(
                // color: Colors.red,
                // margin: EdgeInsets.all(5.0),
                child: LoadImageFromUrl(modelGalleries[itemIndex].image,
                    height: Get.height, width: Get.width, boxFit: BoxFit.cover),
              ),
            ),
        options: CarouselOptions(
          height: Get.height,

          // aspectRatio: 16/9,
          viewportFraction: 1,
          initialPage: 0,
          onPageChanged: onPageChange,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 10),
          enlargeCenterPage: false, // invisual item lower
          enlargeStrategy: CenterPageEnlargeStrategy.height,
        ));
  }

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    // currentIndex = index;
    // print('currentIndex $index');
  }
}

class SliderAppScreen extends StatefulWidget {
  final List<ModelGallery> modelGalleries;
  final bool showArrow;

  final Function(ModelGallery item) didTap;
  const SliderAppScreen(
      {Key key,
      @required this.modelGalleries,
      this.didTap,
      this.showArrow = false})
      : super(key: key);

  @override
  _SliderAppScreenState createState() => _SliderAppScreenState();
}

class _SliderAppScreenState extends State<SliderAppScreen> {
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: CarouselSlider.builder(
              carouselController: _controller,
              itemCount: widget.modelGalleries.length,
              // itemCount: 30,
              itemBuilder:
                  (BuildContext context, int itemIndex, int realIndex) =>
                      Container(
                        child: Container(
                          // color: Colors.red,
                          // margin: EdgeInsets.all(5.0),
                          child: FadeInImage(
                              fit: BoxFit.cover,
                              height: 400, //Get.height,
                              // width: Get.width - 80,
                              image: ResizeImage(
                                CachedNetworkImageProvider(
                                  widget.modelGalleries[itemIndex].image,
                                ),
                                width: (Get.width).toInt(),
                                // width: MediaQuery.of(context).size.width.toInt(),
                              ),
                              placeholder: AssetImage(Strings.placeHolderImage),
                              // placeholder image until finish loading
                              imageErrorBuilder: (context, error, st) {
                                return Text(error.toString());
                              }),
                        ),
                      ),
              options: CarouselOptions(
                height: 400, //Get.height,
                pageSnapping: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                onPageChanged: onPageChange,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 10),
                enlargeCenterPage: true, // invisual item lower
                enlargeStrategy: CenterPageEnlargeStrategy.height,
              )),
        ),
        Positioned(
          child: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 50,
            ),
            onPressed: () {
              print("left clicked");
              _controller.previousPage();
            },
          ),
          left: -20,
        ),
        Positioned(
          child: IconButton(
            icon: Icon(
              Icons.chevron_right,
              size: 50,
            ),
            onPressed: () {
              print("right clicked");
              _controller.nextPage();
            },
          ),
          right: 0,
        ),
      ],
    );
  }

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    // currentIndex = index;
    print('currentIndex $index');
  }
}

import 'dart:ui';

import 'package:carkee/components/load_image_component.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:carkee/config/app_configs.dart';

import 'package:carkee/models/ModelListingResult.dart';


class SliderMemberSponsors extends StatelessWidget {
  final List<ModelListing> modelListings;

  final Function(ModelListing item) didTap;
  const SliderMemberSponsors({Key key, this.modelListings, this.didTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return modelListings.length > 0
        ? LazyLoadScrollView(
            onEndOfPage: () => print('load more'),
            child: CarouselSlider.builder(
                itemCount: modelListings.length,
                itemBuilder: (BuildContext context, int itemIndex, int realIndex) => Container(
                        child: GestureDetector(
                      onTap: () {
                        didTap(modelListings[itemIndex]);
                      },
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          //background image
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                              // child : LoadImageFromUrl(modelListings[itemIndex].primaryPhoto,boxFit: BoxFit.fitWidth),
                                //                   .primaryPhoto)
                            child: Container(
                                // color: Colors.red,
                                height: 310,
                                decoration: BoxDecoration(

                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: Config.kShadowSponsor,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          modelListings[itemIndex]
                                              .primaryPhoto),
                                      fit: BoxFit.cover),
                                )
                            ),
                          ),


                          //Text
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                                    // border: Border.all(color: Colors.red, width: 2),

                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.black,
                                        Colors.black26,
                                        Colors.transparent,
                                      ],
                                      stops: [0,0.5,1],// độ phủ stop của các step 0,0.25,1: mờ phần dưới là chính, 0,0.9,1 mờ phần trên là chính
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter

                                  ),
                                ),
                                // color: Colors.green,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //text 1
                                        Padding(
                                          padding: const EdgeInsets.only(top: 20,left: 20, right: 20),
                                          child: Text(modelListings[itemIndex].title,
                                          textAlign: TextAlign.left,
                                          maxLines: 1,
                                          style: Styles.mclub_smallTilteBold_white,
                                          overflow: TextOverflow.ellipsis),
                                        ),
                                    //text 2
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10,left: 20, right: 20, bottom: 20),
                                      child: Text(modelListings[itemIndex].content,
                                      maxLines: 2,
                                      style: Styles.mclub_smallText_white,
                                      overflow: TextOverflow.ellipsis),
                                    ),
                                      ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                options: CarouselOptions(

                  height: 310,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.85,
                  initialPage: 0,
                  onPageChanged: onPageChange,
                  // autoPlay: false,
                  // aspectRatio: 2.0,
                  // autoPlayInterval: Duration(seconds: 5),
                  enlargeCenterPage: true, // invisual item lower
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                )
            ),
          )
        : SizedBox();
  }

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    // currentIndex = index;
    // print('currentIndex $index');
  }
}

//
//
// class SliderMemberSponsors extends StatelessWidget {
//   final List<ModelListing> modelListings;
//
//   final Function(ModelListing item) didTap;
//   const SliderMemberSponsors({Key key, this.modelListings, this.didTap}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return modelListings.length > 0 ? LazyLoadScrollView(
//       onEndOfPage: () => print('load more'),
//       child: CarouselSlider.builder(
//           itemCount: modelListings.length,
//           itemBuilder: (BuildContext context, int itemIndex) => Container(
//             child: GestureDetector(
//               onTap: () {
//                 didTap(modelListings[itemIndex]);
//               },
//               child: Container(
//                 // color: Colors.red,
//                   height: 310,
//                   margin: EdgeInsets.all(0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//
//                     children: [
//                       FadeInImage(
//                           fit: BoxFit.cover,
//                           height: 230,
//                           width: (Get.width - 40),
//                           image: ResizeImage(
//                             CachedNetworkImageProvider(
//                               modelListings[itemIndex].primaryPhoto,
//                             ),
//                             width: (Get.width - 40).toInt(),
//                           ),
//                           placeholder: AssetImage(Strings.placeHolderImage),
//                           // placeholder image until finish loading
//                           imageErrorBuilder: (context, error, st) {
//                             // return Text('Something went wrong $error');
//                             return Icon(Icons.error_outline, size: 100, color: Colors.red,);
//                           }),
//                       Align(
//                         alignment : Alignment.centerLeft,
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
//                           child: Text(modelListings[itemIndex].title,
//                               textAlign: TextAlign.left,
//                               maxLines: 1,
//                               style: Styles.mclub_smallTilteBold,
//                               overflow: TextOverflow.ellipsis),
//                         ),
//                       ),
//                       Align(
//                         alignment : Alignment.centerLeft,
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
//                           child: Text(modelListings[itemIndex].content,
//                               maxLines: 2,
//                               style: Styles.mclub_smallText,
//                               overflow: TextOverflow.ellipsis),
//                         ),
//                       ),
//                     ],
//                   )
//               ),
//             ),
//           ),
//           options: CarouselOptions(
//             height: 310,
//
//             // aspectRatio: 16/9,
//             enableInfiniteScroll : false,
//             viewportFraction : 0.9,
//             // enableInfiniteScroll : modelListings.length >=2 ? true : false,
//             // viewportFraction: modelListings.length >=2 ? 0.9 : 1.0,
//             initialPage: 0,
//             onPageChanged: onPageChange,
//             autoPlay: false,
//
//             autoPlayInterval: Duration(seconds: 5),
//             enlargeCenterPage: false, // invisual item lower
//             enlargeStrategy: CenterPageEnlargeStrategy.height,
//           )
//       ),
//     ) : SizedBox();
//   }
//
//   void onPageChange(int index, CarouselPageChangedReason changeReason) {
//     // currentIndex = index;
//     // print('currentIndex $index');
//   }
//
// }

import 'package:carkee/components/load_image_component.dart';
import 'package:carkee/config/singleton.dart';
import 'package:carkee/config/strings.dart';
import 'package:carkee/models/ModelBottomAdsResult.dart';
import 'package:carkee/networks_app/url_app.dart';
import 'package:carkee/screen/remove_ads_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'network_api.dart';

class BottomAds extends StatefulWidget {
  final ModelBottomAdsResult modelBottomAdsResult;

  const BottomAds({Key key, this.modelBottomAdsResult}) : super(key: key);
  @override
  _BottomAdsState createState() => _BottomAdsState();
}

class _BottomAdsState extends State<BottomAds> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.modelBottomAdsResult != null) print("modelBottomAdsResult ${widget.modelBottomAdsResult.toJson()}");

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
            onTap: () {
              print("You want remove ads?");
              Get.to(() => RemoveAdsScreen());
            },
            child: Align(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Remove ads"),
                ),
                alignment: Alignment.topRight)),
        widget.modelBottomAdsResult != null
            ? GestureDetector(
          onTap: (){
            Session.shared.openWebView(title: "Ads", url: widget.modelBottomAdsResult.data.url ?? "");
          },
          child: LoadImageFromUrl(widget.modelBottomAdsResult.data?.image, height: 70,),
              // child: FadeInImage.assetNetwork(
              //     placeholder: Strings.placeHolderImage,
              //     // image: 'https://picsum.photos/600/100',
              //     image: widget.modelBottomAdsResult.data?.image,
              //     fit: BoxFit.fitWidth,
              //     height: 70,
              //   ),
            )
            : SizedBox(),
      ],
    );

  }
}

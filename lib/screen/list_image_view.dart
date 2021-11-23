import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/config/strings.dart';
import 'package:carkee/models/ModelNewsResult.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'photo_view.dart';

class ListImageView extends StatefulWidget {
  final List<Galleries> galleries;

  const ListImageView({Key key, this.galleries}) : super(key: key);
  @override
  _ListImageViewState createState() => _ListImageViewState();
}

class _ListImageViewState extends State<ListImageView> {

  var listImage = [Galleries(id: 1, url: "https://picsum.photos/200"),
    Galleries(id: 2, url: "https://cdn.pixabay.com/photo/2018/03/19/15/04/wet-3240211_960_720.jpg"),
    Galleries(id: 3, url: "https://picsum.photos/200/400"),
    Galleries(id: 4, url: "https://picsum.photos/200/500"),
    Galleries(id: 5, url: "https://picsum.photos/200/600"),
    Galleries(id: 6, url: "https://picsum.photos/200/350"),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: AppBarCustom().preferredSize,
            child: AppBarCustom(
              leftClicked: () {
                print("close clicked");
                Get.back();
              },
              title: 'All Images',
            )),
    body: buildBody(),
    );

  }
  buildBody(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text("Click to expand", style: TextStyle(color: Config.secondColor),),
        ),
        buildListImage(),
      ],
    );
  }

  buildListImage() {
    return Expanded(
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 2,
        itemCount: widget.galleries.length,
        itemBuilder: (context, index) {
          // return Image.network(listImage[index]);
          return GestureDetector(
            onTap: (){
              goFullScreen(index);
            },
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: widget.galleries[index].url,
              imageErrorBuilder: (context, error, st) {
                return Icon(Icons.error_outline, size: 100, color: Colors.red,);
              },
            ),
            // child: FadeInImage(
            //     fit: BoxFit.cover,
            //     // height: 230,
            //     // width: (Get.width),
            //     image: CachedNetworkImageProvider(
            //         widget.galleries[index].url,
            //       ),
            //       // width: (Get.width).toInt(),
            //     placeholder: AssetImage(Strings.placeHolderImage),
            //     // placeholder image until finish loading
            //     imageErrorBuilder: (context, error, st) {
            //       // return Text('Something went wrong $error');
            //       return Icon(Icons.error_outline, size: 100, color: Colors.red,);
            //     }
            // ),
          );
        },
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        // staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
        staggeredTileBuilder: (index) => new StaggeredTile.fit(2)
      ),
    );
  }
  goFullScreen(int itemIndex){
    Get.to(() => FullImageDetailsNews(
      galleryItems: widget.galleries,
      initialIndex: itemIndex,
      scrollDirection: Axis.horizontal,
      backgroundDecoration: const BoxDecoration(
        color: Colors.black,
      ),
    ));
  }
}

final Uint8List kTransparentImage = new Uint8List.fromList(<int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
]);

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carkee/models/ModelBannerResult.dart';
import 'package:carkee/models/ModelNewsResult.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
class FullImagePageRoute extends StatefulWidget {
  FullImagePageRoute({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex,
    @required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder loadingBuilder;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<ModelGallery> galleryItems;
  final Axis scrollDirection;

  @override
  _FullImagePageRouteState createState() => _FullImagePageRouteState();
}

class _FullImagePageRouteState extends State<FullImagePageRoute> {
  int currentIndex;
  void initState() {
    // currentIndex = widget.initialIndex;
    super.initState();
    currentIndex = widget.initialIndex;
    print('_FullImagePageRouteState initState $currentIndex');
  }
  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
    print('_FullImagePageRouteState onPageChanged $currentIndex');
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final ModelGallery item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(item.image),//AssetImage(item.resource),
      initialScale: PhotoViewComputedScale.covered,//contained
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              PhotoViewGallery.builder(
                scrollPhysics: BouncingScrollPhysics(),
                builder: _buildItem,
                itemCount: widget.galleryItems.length,
                loadingBuilder: widget.loadingBuilder,
                backgroundDecoration: widget.backgroundDecoration,
                pageController: widget.pageController,
                onPageChanged: onPageChanged,
                scrollDirection: widget.scrollDirection,
              ),

              IconButton(
                padding: EdgeInsets.only(left: 10),
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.close),
                iconSize: 30,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );

  }
}


//For Model type
class FullImageDetailsNews extends StatefulWidget {
  FullImageDetailsNews({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex,
    @required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder loadingBuilder;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<Galleries> galleryItems;
  final Axis scrollDirection;

  @override
  _FullImageDetailsNewsState createState() => _FullImageDetailsNewsState();
}

class _FullImageDetailsNewsState extends State<FullImageDetailsNews> {
  int currentIndex;
  void initState() {
    // currentIndex = widget.initialIndex;
    super.initState();
    currentIndex = widget.initialIndex;
    print('_FullImageDetailsNewsState initState $currentIndex');
  }
  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
    print('_FullImagePageRouteState onPageChanged $currentIndex');
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final Galleries item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(item.url),//AssetImage(item.resource),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              PhotoViewGallery.builder(
                scrollPhysics: BouncingScrollPhysics(),
                builder: _buildItem,
                itemCount: widget.galleryItems.length,
                loadingBuilder: widget.loadingBuilder,
                backgroundDecoration: widget.backgroundDecoration,
                pageController: widget.pageController,
                onPageChanged: onPageChanged,
                scrollDirection: widget.scrollDirection,
              ),

              IconButton(
                padding: EdgeInsets.only(left: 10),
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.close),
                iconSize: 30,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );

  }
}

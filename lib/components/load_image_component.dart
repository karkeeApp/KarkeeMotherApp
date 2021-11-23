import 'package:carkee/config/strings.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadImageFromUrl extends StatelessWidget {
  final String url;
  final BoxFit boxFit;
  final double width;
  final double height;
  const LoadImageFromUrl(this.url,
      {Key key, this.boxFit, this.width,this.height})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return buildImageFull();
  }
  Widget buildImageFull() {

    return ExtendedImage.network(
      url,
      handleLoadingProgress: true,
      clearMemoryCacheIfFailed: true,
      clearMemoryCacheWhenDispose: false,// ko xoá
      retries: 3,
      fit: BoxFit.cover,
      cache: true,
      height: height,
      width: Get.width,
      loadStateChanged: (ExtendedImageState state) {
        if (state.extendedImageLoadState == LoadState.loading) {
          final ImageChunkEvent loadingProgress =
              state.loadingProgress;
          final double progress =
          loadingProgress?.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
              loadingProgress.expectedTotalBytes
              : null;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    width: 30.0,
                    height: 30,
                    child: CircularProgressIndicator(strokeWidth: 0.5,)
                  // width: 150.0,
                  // child: LinearProgressIndicator(
                  //   value: progress,
                  // ),
                ),
                // const SizedBox(
                //   height: 10.0,
                // ),
                // Text('${((progress ?? 0.0) * 100).toInt()}%'),
              ],
            ),
          );
        }
        return null;
      },
    );
  }
}


class LoadImageResizeFullWidthFromUrl extends StatelessWidget {
  final String urlImage;
  const LoadImageResizeFullWidthFromUrl(this.urlImage,{Key key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      urlImage,
      handleLoadingProgress: true,
      clearMemoryCacheIfFailed: true,
      clearMemoryCacheWhenDispose: true,
      retries: 3,
      cache: true,
      width: Get.width,
      loadStateChanged: (ExtendedImageState state) {
        if (state.extendedImageLoadState == LoadState.loading) {
          final ImageChunkEvent loadingProgress =
              state.loadingProgress;
          final double progress =
          loadingProgress?.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
              loadingProgress.expectedTotalBytes
              : null;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    width: 30.0,
                    height: 30,
                    child: CircularProgressIndicator()
                  // child: LinearProgressIndicator(
                  //   value: progress,
                  // ),
                ),
                // const SizedBox(
                //   height: 10.0,
                // ),
                // Text('${((progress ?? 0.0) * 100).toInt()}%'),
              ],
            ),
          );
        }
        return null;
      },
    );
  }
}
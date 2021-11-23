import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carkee/config/app_configs.dart';

class XibItemUpload extends StatelessWidget {
  final String line1;
  final String line2;
  final String line3;
  final String urlImage;
  final String fileType;
  final Function onTap;
  const XibItemUpload({
    Key key,
    this.line1,
    this.line2 = 'Allowed Formats',
    this.line3 = "Jpeg, jpg, png, gif, pdf (Max. 5MB)",
    this.urlImage,
    this.onTap,
    this.fileType = 'application/pdf',
  }) : super(key: key);


  getIcon(){
    if (urlImage != "" && urlImage != null) {
      if (fileType == 'application/pdf') {
        print('load pdf icon');
        return Icon(Icons.picture_as_pdf, color: Config.primaryColor,);
      } else {
        print('load image $urlImage');
        return SizedBox(
          height: 50,width: 50,
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/plusIcon.png',
            image: urlImage,
          ),
        );
      }
      //check type
    } else {
      print('load default image icon');
      return SizedBox(
          height: 50,width: 50,
          child: Image.asset('assets/images/plusIcon.png'));
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        getIcon(),
        SizedBox(width: 20,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // buildFormBuilder(context),

              line1 != null ? Text(line1) : SizedBox(),
              line2 != null
                  ? Text(
                      line2,
                      style: Styles.mclub_smallText,
                    )
                  : SizedBox(),
              line3 != null
                  ? Text(
                      line3,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                          fontSize: 12),
                    )
                  : SizedBox(),
            ],
          ),
        ),
        // getIcon(),

      ]
      ),
    );
  }
}
//
// //use for no upload right now!
class XibItemImageFile extends StatelessWidget {
  final String line1;
  final String line2;
  final String line3;
  final Widget imageWidget;
  final String fileType;
  final Function onTap;
  const XibItemImageFile({
    Key key,
    this.line1,
    this.line2 = 'Allowed Formats',
    this.line3 = "Jpeg, jpg, png, gif, pdf (Max. 5MB)",
    this.imageWidget,
    this.onTap,
    this.fileType = 'application/pdf',
  }) : super(key: key);


  getIcon(){
    if (imageWidget != null) {
      if (fileType == 'application/pdf') {
        print('load pdf icon');
        return Icon(Icons.picture_as_pdf, color: Config.primaryColor,);
      } else {
        // print('load image $urlImage');
        return SizedBox(
          height: 50,width: 50,
          child: imageWidget,
        );
      }
      //check type
    } else {
      print('load default image icon');
      return SizedBox(
          height: 50,width: 50,
          child: Image.asset('assets/images/plusIcon.png'));
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        getIcon(),
        SizedBox(width: 20,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // buildFormBuilder(context),

              line1 != null ? Text(line1) : SizedBox(),
              line2 != null
                  ? Text(
                line2,
                style: Styles.mclub_smallText,
              )
                  : SizedBox(),
              line3 != null
                  ? Text(
                line3,
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                    fontSize: 12),
              )
                  : SizedBox(),
            ],
          ),
        ),
        // getIcon(),

      ]
      ),
    );
  }
}

//rthis class show image from local
class XibItemUploadLater extends StatelessWidget {
  final String line1;
  final String line2;
  final String line3;
  final File file;
  final String fileType;
  final Function onTap;
  const XibItemUploadLater({
    Key key,
    this.line1,
    this.line2 = 'Allowed Formats',
    this.line3 = "Jpeg, jpg, png, gif, pdf (Max. 5MB)",
    this.file,
    this.onTap,
    this.fileType = 'application/pdf',
  }) : super(key: key);


  getIcon(){
    if (file != null) {
      if (fileType == 'application/pdf') {
        print('load pdf icon');
        return Icon(Icons.picture_as_pdf, color: Config.primaryColor,);
      } else {
        return SizedBox(
          height: 50,width: 50,
          child: Image.file(file),
        );
      }
      //check type
    } else {
      print('load default image icon');
      return Image.asset('assets/images/plusIcon.png');
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // buildFormBuilder(context),

              line1 != null ? Text(line1) : SizedBox(),
              line2 != null
                  ? Text(
                line2,
                style: Styles.mclub_smallText,
              )
                  : SizedBox(),
              line3 != null
                  ? Text(
                line3,
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                    fontSize: 12),
              )
                  : SizedBox(),
            ],
          ),
        ),
        getIcon(),

      ]
      ),
    );
  }
}
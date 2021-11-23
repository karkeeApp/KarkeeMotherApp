import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/config/strings.dart';

class infoItemHorizal extends StatelessWidget {
  final String title;
  final String value;

  const infoItemHorizal({Key key, this.title, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Config.kDefaultPadding * 2, vertical: Config.kDefaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              // color: Colors.yellow,
              child: Text(
                title,
                style: Styles.mclub_normalText,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              // color: Colors.blue,
              child: Text(
                value,style: Styles.mclub_normalBoldText,
              ),
            ),
          ),

        ],
      ),
    );
  }
}



class infoItemHorizalForProfileView extends StatelessWidget {
  final String title;
  final String value;

  const infoItemHorizalForProfileView({Key key, this.title, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Config.kDefaultPadding * 2, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Expanded(
                flex: 3,
                child: Container(
                  // color: Colors.yellow,
                  child: Text(
                    title,
                    style: Styles.mclub_normalText,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  // color: Colors.blue,
                  child: Text(
                    value,style: Styles.mclub_normalText,
                  ),
                ),
              ),



            ],
          ),
        ),
        Divider(color: Config.secondColor.withOpacity(0.3),)
      ],
    );
  }
}

class infoItemImageHorizalForProfileView extends StatelessWidget {
  final String title;
  final String urlImage;
  final String typeImage;
  final Function(String, bool) onPress;

  const infoItemImageHorizalForProfileView({Key key, this.title, this.urlImage, this.typeImage, this.onPress}) : super(key: key);

  isPDF() {
    return (typeImage == 'application/pdf');
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress(urlImage,isPDF()),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Config.kDefaultPadding * 2, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Expanded(
                  // flex: 3,
                  child: Container(
                    // color: Colors.yellow,
                    child: Text(
                      title,
                      style: Styles.mclub_normalText,
                    ),
                  ),
                ),
                isPDF() ? Icon(Icons.picture_as_pdf, size: 90, color: Config.secondColor,) : Container(
                  height: 100,width: 100,
                  // color: Colors.blue,
                  child: FadeInImage(
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                      image: ResizeImage(
                        CachedNetworkImageProvider(urlImage,),
                        width: 100,
                      ),
                      placeholder: AssetImage(Strings.placeHolderImage),
                      // placeholder image until finish loading
                      imageErrorBuilder: (context, error, st) {
                        print(error.toString());
                        //return Text('Something went wrong $error');
                        return Icon(Icons.error_outline, size: 100, color: Colors.red,);
                      }
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Config.secondColor.withOpacity(0.3),)
        ],
      ),
    );
  }
}
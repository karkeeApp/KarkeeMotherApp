import 'package:flutter/material.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/util/hexcolor.dart';
import 'dart:io';
class Styles {
  static const buttonTextStyle = TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.white,);
  static const chartlabelsTextStyle = TextStyle(fontSize: 14,fontWeight: FontWeight.w600, color: Colors.grey);
  static const tabTextStyle = TextStyle(fontSize: 14,fontWeight: FontWeight.w600, color: Colors.grey);
  //TextStyle(color: Colors.black, fontSize: 15))
  static const mclub_inputTextStyle = TextStyle(color: Colors.black, fontSize: 15);
  //TextStyle(fontSize: 14, color: Colors.black)
  static const mclub_smallText = TextStyle(color: Colors.black, fontSize: 13);
  static const mclub_smallText_white = TextStyle(color: Colors.white, fontSize: 13);
  static const mclub_normalText = TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.normal);
  static const mclub_normalText_underline = TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.normal, decoration: TextDecoration.underline,);
  static const mclub_normalBoldText = TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold);
  static const mclub_normalBodyText = TextStyle(color: Color(0xff9A9A9A), fontSize: 14,fontWeight: FontWeight.normal);
  static const mclub_bigerText = TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.normal);
  static const bigerHeader30Bold = TextStyle(color: Colors.black, fontSize: 30,fontWeight: FontWeight.bold);
  static const mclub_Tilte = TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);
  static const mclub_Bold16White = TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);
  static const mclub_smallTilteBold = TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold);
  static const mclub_smallTilteBold_white = TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold);
  static const mclub_TilteBlue = TextStyle(color: Config.secondColor, fontSize: 16, fontWeight: FontWeight.bold);
  static const mclub_subTilteBlue = TextStyle(color: Config.secondColor, fontSize: 13, fontWeight: FontWeight.bold);
  static const mclub_subTilteBlackBoldItalic = TextStyle(color: Config.primaryColor, fontSize: 13, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic);

  static const mclub_UPCASETilte = TextStyle(color: Colors.black, fontSize: 18);

}
class BottomLineMclub extends StatelessWidget {
  const BottomLineMclub({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Divider(color: Config.secondColor.withOpacity(0.3));
  }
}
extension FileExtention on FileSystemEntity{
  String get name {
    return this?.path?.split("/")?.last;
  }
}
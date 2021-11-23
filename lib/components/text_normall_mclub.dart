import 'package:flutter/material.dart';
import 'package:carkee/config/app_configs.dart';
//
class TextNormal extends StatelessWidget {
  final String textContent;

  const TextNormal({Key key, this.textContent}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(textContent);
  }
}

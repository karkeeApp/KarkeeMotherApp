import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:carkee/config/app_configs.dart';

class InputTextApp extends StatelessWidget {
  final String title;
  final String placeholder;
  final TextEditingController controller;
  final int maxLines;

  const InputTextApp(
      {Key key,
        this.title,
        this.controller,
        this.placeholder,
        this.maxLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: Styles.mclub_smallTilteBold,
          ),
        ),
        CupertinoTextField(
          maxLines: maxLines,
          style: Styles.mclub_smallText,
          decoration: BoxDecoration(
            border: Border.all(
              color: Config.kTextLightColor,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          controller: controller,
          placeholder: placeholder,
          padding: EdgeInsets.all(10),
          // clearButtonMode: OverlayVisibilityMode.editing,
        )
      ],
    );
  }
}

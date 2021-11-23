import 'package:flutter/material.dart';
import 'package:carkee/config/app_configs.dart';


class LineBottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: Config.kLineHeight,
          width: 20.0,
          color: Config.secondColor,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3), //trái phải
            child: Container(
              height: Config.kLineHeight,
              // width: 20.0,
              color: Config.primaryColor,
            ),
          ),
        ),
        Container(
          height: Config.kLineHeight,
          width: 20.0,
          color: Config.secondColor,
        ),
      ],
    );
  }
}

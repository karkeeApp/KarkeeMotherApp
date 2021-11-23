import 'package:flutter/material.dart';
import 'package:carkee/config/app_configs.dart';
class HeaderTitleClickable extends StatelessWidget {
  final Function onTap;
  final String title;
  const HeaderTitleClickable({
    Key key, this.onTap, this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(top: 10,right: 10,bottom: 10,left: 20),
        // color: Colors.red,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Styles.mclub_smallTilteBold,
              ),
              Spacer(),
              Text(
                'See All',
                style: Styles.mclub_smallText,
              ),
              Icon(Icons.navigate_next)
            ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:carkee/config/app_configs.dart';

class MenuItemSetting extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function onpress;
  final bool showTopDivider;

  const MenuItemSetting({Key key, this.title, this.subTitle = "", this.onpress, this.showTopDivider = true}) : super(key: key);


  Column itemSetting({String title, String subTitle = "", Function onpress}) {
    return subTitle != ""
        ? Column(
      children: [

        showTopDivider ? Divider() : SizedBox(),
        ListTile(
          tileColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          title: Text(title, style: Styles.mclub_Tilte),
          subtitle: Text(subTitle, style: Styles.mclub_normalBodyText),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: onpress,
        ),
      ],
    )
        : Column(
      children: [
        showTopDivider ? Divider() : SizedBox(),
        ListTile(
          tileColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          title: Text(title, style: Styles.mclub_Tilte),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: onpress,
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return itemSetting(title: this.title, subTitle: this.subTitle, onpress: this.onpress);
  }
}

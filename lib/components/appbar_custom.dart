import 'dart:ui';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import 'package:carkee/components/line_bottom_navigation.dart';
import 'package:carkee/config/app_configs.dart';

AppBar getAppBar(String title) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.white,
    title: Text(title, style: Styles.mclub_Tilte),
    elevation: 1,
  );
}

class AppBarCustom extends StatelessWidget {
  final Function leftClicked;
  final String title;
  const AppBarCustom({Key key, this.leftClicked, this.title}) : super(key: key);
  Size get preferredSize => Size.fromHeight(51);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), //trên dưới
      child: SafeArea(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: leftClicked,
                icon: Icon(Icons.arrow_back_ios_sharp),
                iconSize: 25,
                color: Colors.black,
              ),
              Text(title,
                  style: Styles.mclub_Tilte, textAlign: TextAlign.center),
              SizedBox(width: 50)
            ],
          ),
          // LineBottomNavigation()
        ]),
      ),
    );
  }
}


class AppBarCustomRightIcon extends StatelessWidget {
  final Function leftClicked;
  final String title;
  const AppBarCustomRightIcon({Key key, this.leftClicked, this.title})
      : super(key: key);
  Size get preferredSize => Size.fromHeight(51);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), //trên dưới
      child: SafeArea(

        child: Column(
            children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: leftClicked,
                icon: Icon(Icons.arrow_back_ios_sharp),
                iconSize: 25,
                color: Colors.black,
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(title,
                    style: Styles.mclub_Tilte, textAlign: TextAlign.right),
              ),
              Container(
                // height: 50,
                // width: 60,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 1.0, color: Config.primaryColor),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage('assets/images/logo.png'), width: 40,height: 40,)
                    ],
                  ),
                ),

              )
            ],
          ),
          LineBottomNavigation()
        ]),
      ),
    );
  }
}

class AppBarRightX extends StatelessWidget implements PreferredSizeWidget {
  final Function closeClicked;

  final String title;// "Welcome Back!",
  final String subTitle;//"Log in now and check out the latest deals available!",
  const AppBarRightX({Key key,this.closeClicked, this.title, this.subTitle}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(59);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: Config.kDefaultPadding * 2,
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.white,
      // centerTitle: true,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Styles.mclub_bigerText,
            maxLines: 10,
          ),
          FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(subTitle,
                style: Styles.mclub_smallText,
                maxLines: 1,
              )
          ),

        ],
      ),

      actions: [
        IconButton(
          onPressed: () {
            // print("close clicked");
            closeClicked();
          },
          icon: Icon(Icons.close),
          iconSize: 30,
          color: Colors.black,
        ),
      ],
    );
  }
}


class LineStepRegister extends StatelessWidget {
  final int totalStep;
  final int currentStep;
  const LineStepRegister({Key key, @required this.totalStep, @required this.currentStep}) : super(key: key);
  List<Widget> getListStep(){
    List<Expanded> listItem = [];
    for (var i = 0; i < totalStep; i++) {
      var item = Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Container(
              height: Config.kLineHeight,
              color: (currentStep == i) ? Config.secondColor : Config.kTextLightColor
            // decoration: const BoxDecoration(color: Colors.red),
          ),
        ),
        flex: 1,
      );
      listItem.add(item);
    }
    return listItem;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: getListStep(),
      ),
    );
  }
}


class AppBarTabCenterTitleWithLeftHamberger extends StatelessWidget {
  final Function leftClicked;
  final String title;
  final bool showBorderBottomBar;
  const AppBarTabCenterTitleWithLeftHamberger({Key key, this.title, this.leftClicked, this.showBorderBottomBar = true})
      : super(key: key);
  Size get preferredSize => Size.fromHeight(51);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), //trên dưới
      child: SafeArea(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: leftClicked,
                icon: Icon(Icons.menu),
                iconSize: 25,
                color: Colors.black,
              ),
              Text(title,
                  style: Styles.mclub_Tilte, textAlign: TextAlign.center),
              SizedBox(width: 50)
            ],
          ),
          showBorderBottomBar ? LineBottomNavigation() : SizedBox()
        ]),
      ),
    );
  }
}

class AppBarTabCenterTitleWithLeftHambergerRightAvatar extends StatelessWidget {
  final String urlAvatar;
  final Function leftClicked;
  final Function rightClicked;
  final String title;
  // final bool showBorderBottomBar;
  const AppBarTabCenterTitleWithLeftHambergerRightAvatar({Key key, this.title, this.leftClicked, this.rightClicked, this.urlAvatar})
      : super(key: key);
  Size get preferredSize => Size.fromHeight(60);
  @override
  Widget build(BuildContext context) {
    return bodyView();
  }

  Widget bodyView(){
    return Container(
      color: Colors.white,
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), //trên dưới
      child: SafeArea(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: leftClicked,
                icon: Icon(Icons.menu),
                iconSize: 30,
                color: Colors.black,
              ),
              Text(title,
                  style: Styles.mclub_Tilte, textAlign: TextAlign.center),
              // SizedBox(width: 60),
              GestureDetector(
                onTap: () => rightClicked(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 20,
                      backgroundImage: NetworkImage(urlAvatar)
                  ),
                ),
              )
            ],
          ),
          // showBorderBottomBar ? LineBottomNavigation() : SizedBox()
        ]),
      ),
    );
  }
}

class AppBarTabCenterTitleWithLeftHambergerRightIcon extends StatelessWidget {
  final IconData rightIcon;
  final Function leftClicked;
  final Function rightClicked;
  final String title;
  // final bool showBorderBottomBar;
  const AppBarTabCenterTitleWithLeftHambergerRightIcon({Key key, this.title, this.leftClicked, this.rightClicked, this.rightIcon})
      : super(key: key);
  Size get preferredSize => Size.fromHeight(60);
  @override
  Widget build(BuildContext context) {
    return bodyView();
  }
  Widget bodyView(){
    return Container(
      color: Colors.white,
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), //trên dưới
      child: SafeArea(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: leftClicked,
                icon: Icon(Icons.menu),
                iconSize: 30,
                color: Colors.black,
              ),
              Text(title,
                  style: Styles.mclub_Tilte, textAlign: TextAlign.center),
              // SizedBox(width: 60),
              if (rightIcon != null) IconButton(icon: Icon(rightIcon), onPressed: (){
                print("right clickwd");
                rightClicked();
              }) else GestureDetector(
                onTap: (){
                  print("clicked");
                  rightClicked();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Image.asset('assets/images/ic_three_dot.png'),
                ),
              )
            ],
          ),
          // showBorderBottomBar ? LineBottomNavigation() : SizedBox()
        ]),
      ),
    );
  }
}

class AppBarLeftRightIcon extends StatelessWidget {
  final Function leftClicked;
  final Function rightClicked;
  final String title;
  final Icon iconRight;
  final Widget widgetRight;
  const AppBarLeftRightIcon({Key key, this.leftClicked, this.title, this.rightClicked, this.iconRight, this.widgetRight })
      : super(key: key);
  Size get preferredSize => Size.fromHeight(51);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), //trên dưới
      child: SafeArea(

        child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: leftClicked,
                    icon: Icon(Icons.arrow_back_ios),
                    iconSize: 25,
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(title,
                        style: Styles.mclub_Tilte, textAlign: TextAlign.right),
                  ),
                  widgetRight != null ? widgetRight :
                  IconButton(
                    onPressed: rightClicked,
                    icon: iconRight,
                    iconSize: 25,
                    color: Colors.black,
                  ),
                ],
              ),
              LineBottomNavigation()
            ]),
      ),
    );
  }
}


class AppBarLeftBackRightIcon extends StatelessWidget {
  final Function leftClicked;
  final Function rightClicked;
  final String title;
  final Icon iconRight;
  final Widget widgetRight;
  const AppBarLeftBackRightIcon({Key key, this.leftClicked, this.title, this.rightClicked, this.iconRight, this.widgetRight })
      : super(key: key);
  Size get preferredSize => Size.fromHeight(51);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), //trên dưới
      child: SafeArea(

        child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: leftClicked,
                    icon: Icon(Icons.arrow_back_ios),
                    iconSize: 25,
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(title,
                        style: Styles.mclub_Tilte, textAlign: TextAlign.right),
                  ),
                  widgetRight != null ? widgetRight :
                  IconButton(
                    onPressed: rightClicked,
                    icon: iconRight,
                    iconSize: 25,
                    color: Colors.black,
                  ),
                ],
              ),
              // LineBottomNavigation()
            ]),
      ),
    );
  }
}

class AppNavigationV2 extends StatelessWidget {
  final Function closeClicked;
  final String title;
  final String subTitle;
  final int totalStep;
  final double currentStep;
  Size get preferredSize => Size.fromHeight(120);
  const AppNavigationV2({Key key, @required this.closeClicked, @required this.title, @required this.subTitle, this.totalStep = 0, this.currentStep}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              totalStep != 0 ? DotsIndicator(
                  dotsCount: totalStep,
                  position: currentStep,
                  decorator: DotsDecorator(
                  color: Colors.black, // Inactive color
                  activeColor: Config.secondColor,
                ),
              ) : SizedBox(),
              Spacer(),
              IconButton(onPressed: () {
                print("close clicked");
                closeClicked();
              },
                  icon: Icon(Icons.close, size: 30,)
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Config.kDefaultPadding),
            child: Container(
                alignment: Alignment.topLeft,
                child: Text(title, style: Styles.bigerHeader30Bold,)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Config.kDefaultPadding),
            child: Container(
                alignment: Alignment.topLeft,
                child: Text(subTitle, style: Styles.mclub_normalText,)),
          ),
        ],
      ),
    );
  }

}

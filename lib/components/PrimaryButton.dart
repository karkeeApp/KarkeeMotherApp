import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carkee/config/app_configs.dart';

class PrimaryButton extends StatelessWidget {
  //type Function callbackOnPressFromButtonPrimary
  final Color colorButton;
  final Function
      callbackOnPress; //Nếu ko có final sẽ báo lỗi vì đây là class stateless
  final String title;
  final bool isLoading;
  PrimaryButton(
      {@required this.callbackOnPress,
      @required this.title,
      this.isLoading = false,
      this.colorButton = Config.primaryColor});
  @override
  Widget build(BuildContext context) {
    print("build PrimaryButton");
    return InkWell(
        onTap: callbackOnPress,
      child: Container(
        width: double.infinity, // match_parent
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: colorButton,

        ),

        child: Text(title,
            style: TextStyle(

                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)
        ),

          // child: Stack(
          //   alignment: Alignment.center,
          //   children: [
          //     FlatButton(
          //       minWidth: double.infinity,
          //       height: 50,
          //       color: colorButton,
          //       child: Text(title,
          //           style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 18,
          //               fontWeight: FontWeight.bold)),
          //       onPressed: !isLoading
          //           ? callbackOnPress
          //           : () => print('isLoading true not need call again'),
          //     ),
              // isLoading
              //     ? Positioned(
              //         right: 10,
              //         // top: 10,
              //         child: SizedBox(
              //           height: 20,
              //           width: 20,
              //           child: CircularProgressIndicator(),
              //         ),
              //       )
              //     : Session.shared.EmptyBox()
            // ],
          // ),
        ),
    // ),
    );
  }
}

class BlackButton extends StatelessWidget {
  double _sigmaX = 5.0; // from 0-10
  double _sigmaY = 5.0; // from 0-10
  double _opacity = 0.8; // from 0-1.0
  //type Function callbackOnPressFromButtonPrimary
  final Color colorButton;
  final Function
  callbackOnPress; //Nếu ko có final sẽ báo lỗi vì đây là class stateless
  final String title;
  final bool isLoading;
  BlackButton(
      {@required this.callbackOnPress,
        @required this.title,
        this.isLoading = false,
        this.colorButton = Colors.blue});
  @override
  Widget build(BuildContext context) {
    print("build PrimaryButton");
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity, // match_parent
        height: 50,
        child: ClipRect(//only button blur, cắt bỏ hết BackdropFilter chỉ chừa lại
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(_opacity),
                  borderRadius: BorderRadius.all(
                      Radius.circular(25)
                  )
              ),
              child: FlatButton(
                minWidth: double.infinity,
                height: 50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  // side: BorderSide(color: Colors.red)
                ),
                child: Text(title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                onPressed: !isLoading
                    ? callbackOnPress
                    : () => print('isLoading true not need call again'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class BlackButtonNoWidth extends StatelessWidget {
  double _sigmaX = 5.0; // from 0-10
  double _sigmaY = 5.0; // from 0-10
  double _opacity = 0.8; // from 0-1.0
  //type Function callbackOnPressFromButtonPrimary
  final Color colorButton;
  final Function
  callbackOnPress; //Nếu ko có final sẽ báo lỗi vì đây là class stateless
  final String title;
  final bool isLoading;
  BlackButtonNoWidth(
      {@required this.callbackOnPress,
        @required this.title,
        this.isLoading = false,
        this.colorButton = Colors.blue});
  @override
  Widget build(BuildContext context) {
    print("build PrimaryButton");
    return Container(
      // width: double.infinity, // match_parent
      height: 50,
      child: ClipRect(//only button blur
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(_opacity),
                borderRadius: BorderRadius.all(
                    Radius.circular(25)
                )
            ),
            child: FlatButton(
              // minWidth: double.infinity,
              height: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                // side: BorderSide(color: Colors.red)
              ),
              child: Text(title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              onPressed: !isLoading
                  ? callbackOnPress
                  : () => print('isLoading true not need call again'),
            ),
          ),
        ),
      ),
    );
  }
}


class BackBlackButton extends StatelessWidget {
  double _sigmaX = 5.0; // from 0-10
  double _sigmaY = 5.0; // from 0-10
  double _opacity = 0.8; // from 0-1.0
  //type Function callbackOnPressFromButtonPrimary
  final Function callbackOnPress; //Nếu ko có final sẽ báo lỗi vì đây là class stateless
  final String title;
  BackBlackButton(
      { @required this.callbackOnPress,
        @required this.title,
        });
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity, // match_parent
      height: 50,
      child: ClipRect(//only button blur
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(_opacity),
                borderRadius: BorderRadius.all(
                    Radius.circular(25)
                )
            ),
            child: FlatButton(
              // color: Colors.transparent,
              // minWidth: double.infinity,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                // side: BorderSide(color: Colors.red)
              ),


              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    buildCustomPrefixIcon(Icons.chevron_left),
                    Text(title, style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),

                  ],

                ),
              ),

              onPressed: callbackOnPress,
            ),
          ),
        ),
      ),
    );
  }
}

class NextBlackButton extends StatelessWidget {
  double _sigmaX = 5.0; // from 0-10
  double _sigmaY = 5.0; // from 0-10
  double _opacity = 0.8; // from 0-1.0
  //type Function callbackOnPressFromButtonPrimary
  final Function callbackOnPress; //Nếu ko có final sẽ báo lỗi vì đây là class stateless
  final String title;
  NextBlackButton(
      { @required this.callbackOnPress,
        @required this.title,
      });
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity, // match_parent
      height: 50,
      child: ClipRect(//only button blur
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(_opacity),
                borderRadius: BorderRadius.all(
                    Radius.circular(25)
                )
            ),
            child: FlatButton(
              // color: Colors.transparent,
              // minWidth: double.infinity,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                // side: BorderSide(color: Colors.red)
              ),


              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    Text(title, style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                    buildCustomPrefixIcon(Icons.chevron_right),
                  ],
                ),
              ),
              onPressed: callbackOnPress,
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildCustomPrefixIcon(IconData iconData,{ Color color = Colors.white}) {
  return Container(
    width: 24,
    alignment: Alignment(-0.99, 0.0),
    child: Icon(
      iconData,color: color,
    ),
  );
}

class WhiteButton extends StatelessWidget {
  double _sigmaX = 5.0; // from 0-10
  double _sigmaY = 5.0; // from 0-10
  double _opacity = 0.7; // from 0-1.0
  //type Function callbackOnPressFromButtonPrimary
  final Color colorButton;
  final Function
  callbackOnPress; //Nếu ko có final sẽ báo lỗi vì đây là class stateless
  final String title;
  final bool isLoading;
  WhiteButton(
      {@required this.callbackOnPress,
        @required this.title,
        this.isLoading = false,
        this.colorButton = Colors.blue});
  @override
  Widget build(BuildContext context) {
    print("build PrimaryButton");
    return Container(
      width: double.infinity, // match_parent
      height: 50,
      child: ClipRect(//only button blur
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(_opacity),
                borderRadius: BorderRadius.all(
                    Radius.circular(25)
                )
            ),
            child: FlatButton(
              minWidth: double.infinity,
              height: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                // side: BorderSide(color: Colors.red)
              ),
              child: Text(title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              onPressed: !isLoading
                  ? callbackOnPress
                  : () => print('isLoading true not need call again'),
            ),
          ),
        ),
      ),
    );
  }
}






class SeletedButton extends StatefulWidget {

  final String title;
  final Function onpress;
  final isSelectedButton;
  SeletedButton(
      {@required this.title, this.onpress, this.isSelectedButton});

  @override
  _SeletedButtonState createState() => _SeletedButtonState();
}

class _SeletedButtonState extends State<SeletedButton> {
  double _sigmaX = 5.0;
  double _sigmaY = 5.0;
  double _opacity = 0.8;

  @override

  @override
  Widget build(BuildContext context) {
    print("widget.isSelectedButton ${widget.isSelectedButton}");
    return Container(
      width: double.infinity, // match_parent
      height: 50,
      child: ClipRect(//only button blur
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
          child: Container(
            decoration: BoxDecoration(
                color: widget.isSelectedButton ? Colors.white.withOpacity(_opacity)  : Colors.black.withOpacity(_opacity),
                borderRadius: BorderRadius.all(
                    Radius.circular(25)
                )
            ),
            child: FlatButton(
              minWidth: double.infinity,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(color: Colors.white, width: 1)
              ),
              child: Text(widget.title,
                  style: TextStyle(
                      color: widget.isSelectedButton ? Colors.black : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              onPressed: (){
                widget.onpress();
              },

            ),
          ),
        ),
      ),
    );
  }
}


class ProfileButton extends StatelessWidget {
  final Function onClick;
  final String title;
  const ProfileButton({
    Key key, this.onClick, this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
        child: Container(
            alignment: Alignment.center,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0,
                          -3), //(0,-12) Bóng lên,(0,12) bóng xuống,, tuong tự cho trái phải
                      blurRadius: 10,
                      // spreadRadius: -3,//do bóng phủ xa
                      color: Colors.black26)
                ]),
            child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Config.secondColor),)),
      ),
    );
  }
}

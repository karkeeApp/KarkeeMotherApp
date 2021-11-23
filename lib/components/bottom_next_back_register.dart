import 'package:flutter/material.dart';
import 'package:carkee/config/app_configs.dart';


class BottomNextBackRegister extends StatelessWidget {
  final String titleNext;
  final bool isShowBack;
  final Function nextClicked;
  final Function backClicked;
  const BottomNextBackRegister({
    Key key, this.isShowBack = true, this.nextClicked, this.backClicked, this.titleNext = 'Next'
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 60,
      // color: Color(0xFFF0F0F0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Row(
          children: [
            isShowBack ? buildBackButton() : Session.shared.EmptyBox(),
            Spacer(),
            buildNextButton()
          ],
        ),
      ),
    );
  }

  GestureDetector buildBackButtonGestureDetector() {
    return GestureDetector(
      onTap: (){
        print('back button clicked');
        if (backClicked != null) {
          backClicked();
        }
      },
      child: Row(
        children: [
          IconButton(icon: Icon(Icons.navigate_before,color: Colors.black), padding: EdgeInsets.zero,),

          Text('Back', style: TextStyle(color: Colors.black, fontSize: 16),),
        ],
      ),
    );
  }

  Widget buildBackButton() {
    return BackBlackButton(callbackOnPress: () {
      backClicked();
    }, title: "Back");
  }
  GestureDetector buildNextButtonGestureDetector() {
    return GestureDetector(
      onTap: () {
        print('next button clicked');
        if (nextClicked != null) {
          nextClicked();
        }
      },
      child: Row(
        children: [
          Text(titleNext, style: TextStyle(color: Colors.black,fontSize: 16),),
          IconButton(icon: Icon(Icons.navigate_next,color: Colors.black),
              padding: EdgeInsets.zero,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
  Widget buildNextButton() {
    return NextBlackButton(callbackOnPress: () {
      nextClicked();
    }, title: titleNext);
  }
}
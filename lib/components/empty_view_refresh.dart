import 'package:flutter/material.dart';
class EmptyViewCustom extends StatelessWidget {
  final String errorString;
  final Function() refreshData;

  const EmptyViewCustom({Key key, this.errorString, this.refreshData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return getNodyNoRecord();
  }
  getNodyNoRecord() {
    print("here getNodyNoRecord getNodyNoRecord getNodyNoRecord !");
    return RefreshIndicator(
      onRefresh: refreshData,
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          Container(
            height: 100,
            child: Center(child: Text(errorString)),
          ),
        ],
      ),
    );
  }
}

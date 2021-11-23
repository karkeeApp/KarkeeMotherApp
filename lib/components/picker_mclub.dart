import 'package:flutter/material.dart';

class PickerMclub extends StatelessWidget {
  final TextEditingController controller;
  final Function onTap;
  final String titleValue;


  const PickerMclub({Key key, this.controller, this.onTap, this.titleValue}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: TextFormField(
          controller: controller,
          enabled: false,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            labelText: titleValue,
            labelStyle: TextStyle(fontSize: 15, color: Colors.black),
            suffixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),// thay đổi padding của content suffixIcon
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Icon(//setup padding icon
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math' as math;
class PhungBox extends StatelessWidget {
  final double height;

  const PhungBox({Key key, @required this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
        child: null,
    );
  }
}

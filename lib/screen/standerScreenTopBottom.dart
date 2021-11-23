import 'package:flutter/material.dart';
import 'package:carkee/components/testbox.dart';

class TopAndBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('TopAndBottom'),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                //this section can scroll
                child: PhungBox(height: 800,),
              ),
            ),
            //this is stick at bottom
            PhungBox(height: 100)
          ],
        ));
  }
}

import 'package:flutter/material.dart';

class ComingSoonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Coming Soon"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('ComingSoonScreen'),
            RaisedButton(
                onPressed: (){
                  print('RaisedButton');
                },
              child: Text('ComingSoonScreen'),
            )
          ],
        ),
      ),
    );
  }
}
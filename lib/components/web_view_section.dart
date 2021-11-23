import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class WebViewSection extends StatefulWidget {
  final url;
  WebViewSection({@required this.url});
  @override
  _WebViewSectionState createState() => _WebViewSectionState();
}
class _WebViewSectionState extends State<WebViewSection> {
  bool isLoading = true;
  WebViewController _webViewController;
  double _height = 200.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
  @override
  void dispose() {
    _webViewController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0,
                          5), //(0,-12) Bóng lên,(0,12) bóng xuống,, tuong tự cho trái phải
                      blurRadius: 10,
                      color: Colors.black26)
                ]
            ),
            height: _height,

            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              child: WebView(
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _webViewController = webViewController;
                },
                onPageStarted: (String url) {
                  print('Page started loading: $url');
                },
                onPageFinished: (String url) async {
                  print('Page finished loading: $url');
                  double height = double.parse(await _webViewController.evaluateJavascript(
                      "document.documentElement.scrollHeight;"));
                  setState(() {
                    _height = height + 50;
                    isLoading = false;
                    print("🍠 _height $_height");
                  });
                },
                gestureNavigationEnabled: true,
              ),
            ),
          ),
        ),
        isLoading ? Center(child: CircularProgressIndicator()) : SizedBox(),

      ],
    );
  }
}

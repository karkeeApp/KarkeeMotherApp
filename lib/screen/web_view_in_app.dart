import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class WebViewInApp extends StatefulWidget {
  final String title;
  final String selectedUrl;
  WebViewInApp({
    @required this.title,
    @required this.selectedUrl,
  });

  @override
  _WebViewInAppState createState() => _WebViewInAppState();
}

class _WebViewInAppState extends State<WebViewInApp> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();


  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: WebView(
          initialUrl: widget.selectedUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        )
    );
  }
}
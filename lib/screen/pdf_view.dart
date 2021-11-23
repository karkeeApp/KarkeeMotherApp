import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:get/get.dart';
import 'package:carkee/components/appbar_custom.dart';
import 'package:path_provider/path_provider.dart';

class PDFViewScreen extends StatefulWidget {
  final String linkpdf;

  const PDFViewScreen({Key key, this.linkpdf}) : super(key: key);
  @override
  _PDFViewScreenState createState() => _PDFViewScreenState();
}

class _PDFViewScreenState extends State<PDFViewScreen> {
  String pathPDF = "";
  var isDone = false.obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createFileOfPdfUrl().then((f) {
      isDone.value = true;
      setState(() {
        pathPDF = f.path;
        print('dowload pathPDF DONE!');
        print(pathPDF);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isDone.value ? PDFViewerScaffold(
        appBar: PreferredSize(
            preferredSize: AppBarCustomRightIcon().preferredSize,
            child: AppBarCustomRightIcon(
              leftClicked: () {
                print("close clicked");
                Get.back();
              },
              title: 'Document',
            )),
            path: pathPDF)
        : loading();
  }

  Widget loading() {
    return Scaffold(
        appBar: AppBar(
          title: Text("Document"),
        ),
        body: Center(child: CircularProgressIndicator()));
  }

  Future<File> createFileOfPdfUrl() async {
    // final url = "http://africau.edu/images/default/sample.pdf";
    final url = widget.linkpdf;
    // final filename = url.substring(url.lastIndexOf("/") + 1);
    final filename = 'filepdf.pdf';
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }
}
// // ignore: must_be_immutable
// class PDFScreen extends StatelessWidget {
//   String pathPDF = "";
//   PDFScreen(this.pathPDF);
//
//   @override
//   Widget build(BuildContext context) {
//     return PDFViewerScaffold(
//         appBar: AppBar(
//           title: Text("Document"),
//           actions: <Widget>[
//             IconButton(
//               icon: Icon(Icons.share),
//               onPressed: () {},
//             ),
//           ],
//         ),
//         path: pathPDF);
//   }
// }

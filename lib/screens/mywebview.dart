import 'package:ofledn/Widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_translate/flutter_translate.dart';

class MyWebView extends StatefulWidget {
  MyWebView({this.title, this.url});

  final String url;
  final String title;

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, translate(widget.title)),
      body: Container(
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.tryParse(widget.url),
          ),
        ),
      ),
    );
  }
}

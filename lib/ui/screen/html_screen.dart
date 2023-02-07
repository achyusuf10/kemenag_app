import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class HtmlScreen extends StatelessWidget {
  final RssItem? rssItem;
  HtmlScreen({Key? key, this.rssItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sasa"),
      ),
      body: SingleChildScrollView(
          child: Container(child: Html(data: rssItem!.content!.value))),
    );
  }
}

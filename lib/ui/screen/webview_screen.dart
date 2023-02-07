import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';

class WebViewScreen extends StatelessWidget {
  final title;
  final linkUrl;

  const WebViewScreen({key, this.title, this.linkUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0), // here the desired height
          child: AppBarWidget.light(
            title: '',
            elevation: 0,
          )),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Get.back();
                  },
                ),
                Text(
                  title,
                  style: TextUI.subtitleBlack,
                ),
                Spacer(),
              ],
            ),
            Divider(),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(linkUrl)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

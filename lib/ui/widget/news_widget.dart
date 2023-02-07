import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/ui/screen/webview_screen.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsWidget extends StatelessWidget {
  final RssItem? rssItem;
  NewsWidget({Key? key, required this.rssItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        // qoin.Get.to(HtmlScreen(
        //   rssItem: rssItem,
        // ));

        Get.to(WebViewScreen(
          title: Localization.news.tr,
          linkUrl: rssItem?.link,
        ));
      },
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.all(0),
      minWidth: 0,
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: this.rssItem != null && this.rssItem!.enclosure!.url != null
                    ? Image.network(
                        this.rssItem != null && this.rssItem!.enclosure!.url!.isNotEmpty ? this.rssItem!.enclosure!.url! : '',
                        width: 105,
                        height: 85,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 105,
                        height: 85,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                        ),
                      ),
              ),
              // (rssItem!.link!.contains("kupang.antaranews.com"))
              //     ? ClipRRect(
              //         borderRadius: BorderRadius.circular(10),
              //         child: this.rssItem != null && this.rssItem!.enclosure!.url != null
              //             ? Image.network(
              //                 this.rssItem != null && this.rssItem!.enclosure!.url!.isNotEmpty
              //                     ? this.rssItem!.enclosure!.url!
              //                     : '',
              //                 width: 105,
              //                 height: 85,
              //                 fit: BoxFit.cover,
              //               )
              //             : Container(
              //                 width: 105,
              //                 height: 85,
              //                 decoration: BoxDecoration(
              //                   color: Colors.grey,
              //                 ),
              //               ),
              //       )
              //     : ClipRRect(
              //         borderRadius: BorderRadius.circular(10),
              //         child: this.rssItem != null &&
              //                 this.rssItem?.content != null &&
              //                 this.rssItem!.content!.images.isNotEmpty
              //             ? Image.network(
              //                 this.rssItem != null && this.rssItem!.content!.images.isNotEmpty
              //                     ? this.rssItem!.content!.images.first
              //                     : '',
              //                 width: 105,
              //                 height: 85,
              //                 fit: BoxFit.cover,
              //               )
              //             : Container(
              //                 width: 105,
              //                 height: 85,
              //                 decoration: BoxDecoration(
              //                   color: Colors.grey,
              //                 ),
              //               ),
              //       ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      this.rssItem != null ? this.rssItem!.title ?? '' : '',
                      style: TextUI.bodyText2Black,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          rssItem?.dc?.creator ?? rssItem?.author ?? "",
                          style: TextUI.labelBlack.copyWith(fontSize: 12.sp),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(color: const Color(0xffcacccf), borderRadius: BorderRadius.circular(6)),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          this.rssItem != null && this.rssItem?.pubDate != null
                              ? DateFormat('dd MMMM yyyy').format(this.rssItem!.pubDate!)
                              : "",
                          style: TextUI.labelBlack.copyWith(fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

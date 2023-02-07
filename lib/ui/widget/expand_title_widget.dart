import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:inisa_app/ui/widget/dash_item.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/widget/button_main.dart';

class ExpandTitleWidget extends StatelessWidget {
  final bool expanded;
  final String image;
  final String title;
  final String subtitle;
  final String? expandtitle;
  final backgroundColor;
  final lineColor;
  final List<Map<String, dynamic>>? list;
  final VoidCallback? onTap;

  const ExpandTitleWidget(
      {Key? key,
      this.expanded = false,
      required this.image,
      required this.title,
      required this.subtitle,
      this.expandtitle,
      this.backgroundColor = ColorUI.shape,
      this.lineColor = const Color(0xffdedede),
      this.list,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return expanded == true
        ? DottedBorder(
            radius: Radius.circular(4),
            color: ColorUI.border,
            strokeWidth: 2,
            borderType: BorderType.RRect,
            dashPattern: [6, 4],
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: backgroundColor),
              child: Theme(
                  data: ThemeData().copyWith(dividerColor: Colors.transparent),
                  child: ListTileTheme(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    minLeadingWidth: double.infinity,
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      backgroundColor: backgroundColor,
                      collapsedBackgroundColor: backgroundColor,
                      trailing: Container(
                        height: double.infinity,
                        child: Icon(
                          Icons.chevron_right,
                          color: Get.theme.colorScheme.primary,
                        ),
                      ),
                      collapsedIconColor: Get.theme.colorScheme.primary,
                      title: Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              image,
                              height: 64,
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: TextUI.subtitleBlack,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    subtitle,
                                    style: TextUI.bodyTextBlack,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      children: <Widget>[
                        Container(
                          color: backgroundColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: List.generate(
                                  150 ~/ 2,
                                  (index) => Expanded(
                                    child: Container(
                                      color:
                                          index % 2 == 0 ? Colors.transparent : Color(0xffdedede),
                                      height: 1,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: [
                                      if (expandtitle != null)
                                        Text(
                                          "$expandtitle",
                                          style: TextUI.bodyText2Black,
                                        ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Container(
                                        color: backgroundColor,
                                        child: ListView.builder(
                                            itemCount: list?.length,
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                margin: EdgeInsets.only(bottom: 20),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 30.w,
                                                      height: 30.h,
                                                      child: Image.asset(
                                                        list?[index]['image'],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20.w,
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "${list?[index]['title']}",
                                                            style: TextUI.subtitleBlack,
                                                          ),
                                                          Text(
                                                            "${list?[index]['subtitle']}",
                                                            style: TextUI.bodyTextBlack,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      MainButton(
                                        text: DigitalIdLocalization.cardFullscreenVerifyNow.tr,
                                        onPressed: onTap,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          )
        : DashedItem(
            asset: image,
            title: title,
            subTitle: subtitle,
            onTap: onTap,
          );
  }
}

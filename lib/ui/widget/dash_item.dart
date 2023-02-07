import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';

class DashedItem extends StatelessWidget {
  final String asset;
  final String title;
  final String subTitle;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const DashedItem(
      {Key? key,
      this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      required this.asset,
      required this.title,
      required this.subTitle,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
          radius: Radius.circular(4),
          color: ColorUI.border,
          strokeWidth: 2,
          borderType: BorderType.RRect,
          dashPattern: [6, 4],
          child: Container(
            decoration: BoxDecoration(color: ColorUI.shape),
            padding: padding,
            child: Row(
              children: [
                Image.asset(
                  asset,
                  width: 64,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextUI.subtitleBlack,
                      ),
                      Text(
                        subTitle,
                        style: TextUI.bodyTextBlack,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.chevron_right,
                    color: ColorUI.text_1,
                  ),
                )
              ],
            ),
          )),
    );
  }
}

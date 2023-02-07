import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/ui_text.dart';

class PaymentTileWidget extends StatelessWidget {
  final String descText;
  final String valueText;
  final double? width;
  final Color? color;
  final bool boldTitle;

  const PaymentTileWidget(
      {Key? key, required this.descText, required this.valueText, this.width, this.color, this.boldTitle = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      width: width ?? ScreenUtil().screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(descText, style: boldTitle ? TextUI.subtitleBlack : TextUI.bodyTextBlack),
          ),
          Expanded(
            child: Text(
              valueText,
              style: TextUI.subtitleBlack,
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }
}

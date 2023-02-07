import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/ui_text.dart';

class InvoiceTile extends StatelessWidget {
  final String? invoiceTitle;
  final String? invoiceBody;
  final bool isLarge;

  const InvoiceTile(
      {Key? key, this.invoiceTitle, this.invoiceBody, this.isLarge = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              invoiceTitle ?? ' ',
              textAlign: TextAlign.start,
              style: TextUI.bodyTextBlack,
            ),
          ),
          isLarge
              ? Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rp",
                        textAlign: TextAlign.end,
                        style: TextUI.titleYellow,
                      ),
                      Text(
                        invoiceBody != null
                            ? "${invoiceBody!.substring(2)}"
                            : ' ',
                        textAlign: TextAlign.end,
                        style: TextUI.titleYellow,
                      )
                    ],
                  ),
                )
              : Expanded(
                  child: Text(
                    invoiceBody ?? ' ',
                    textAlign: TextAlign.end,
                    style: isLarge ? TextUI.titleYellow : TextUI.subtitleBlack,
                  ),
                )
        ],
      ),
    );
  }
}

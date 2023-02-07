import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:qoin_sdk/helpers/utils/intl_formats.dart';

class MoneyChoiceWidget extends StatelessWidget {
  final Function() onTap;
  final Color bgColor;
  final Color borderColor;
  final String image;
  final int denom;
  const MoneyChoiceWidget(
      {key,
      required this.onTap,
      required this.bgColor,
      required this.borderColor,
      required this.denom,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: borderColor, width: 1),
            color: bgColor,
            boxShadow: [
              BoxShadow(color: const Color(0x29111111), offset: Offset(0, 2), blurRadius: 10, spreadRadius: 0)
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                width: 64.w,
                height: 64.h,
              ),
              // SizedBox(
              //   height: 4.h,
              // ),
              Text(
                denom.formatCurrencyRp,
                style: TextUI.subtitleBlack.copyWith(fontSize: 13.sp),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Money {
  String image;
  int nominal;

  Money({required this.image, required this.nominal});
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_text.dart';

class PoweredByQoin extends StatelessWidget {
  const PoweredByQoin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xffdedede), width: 1)),
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Powered by',
            style: TextUI.labelGrey.copyWith(fontSize: 12.sp),
          ),
          SizedBox(
            width: 5.w,
          ),
          Image.asset(
            Assets.qoin,
            height: 17.h,
          ),
          SizedBox(
            width: 5.w,
          ),
          Text(
            'Qoin',
            style: TextUI.subtitleBlack.copyWith(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}

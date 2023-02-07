import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PoweredBy extends StatelessWidget {
  const PoweredBy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Powered By"),
            SizedBox(
              height: 12.h,
            ),
            Image.asset(
              Assets.logoPeduliLindungi,
              height: 48.h,
            ),
          ],
        ),
        SizedBox(
          width: 16.w,
        ),
        Image.asset(
          Assets.logoKemenkes,
          height: 48.h,
        ),
        SizedBox(
          width: 16.w,
        ),
        Image.asset(
          Assets.qoinBlack,
          height: 48.h,
        ),
      ],
    );
  }
}

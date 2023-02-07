import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QoinMemberCard extends StatelessWidget {
  final VoidCallback? onTap;
  final double width;
  final double height;
  final bool isFullscreen;

  const QoinMemberCard({
    Key? key,
    this.onTap,
    this.width = 379,
    this.height = 233.17,
    this.isFullscreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var temp = HiveData.userData?.fullname ?? null;
    var name;

    if (temp != null) {
      name = temp.split(' ');
      if (name.length > 2) {
        name = '${name.first} ${name.last}';
      } else {
        name = temp;
      }
    } else {
      name = HiveData.userData?.phone;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        width: width.w,
        height: height.w,
        margin: EdgeInsets.only(bottom: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.w),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.bgCardMemberBasic),
              fit: BoxFit.fill,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(11),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 0.75))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    height: 90.h,
                    width: 90.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45.w),
                        color: Color(0xffe06350)),
                    clipBehavior: Clip.hardEdge,
                    child: HiveData.userData?.pict != null
                        ? Image.memory(
                            base64Decode(HiveData.userData!.pict!),
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            Assets.person,
                            fit: BoxFit.cover,
                          )),
                SizedBox(
                  width: 16.w,
                ),
                Flexible(
                  child: Text(
                    name,
                    maxLines: 2,
                    style: TextUI.title2White.copyWith(fontSize: 19.sp),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  HiveData.userData!.qoinTag ?? "-",
                  style: TextUI.subtitleWhite.copyWith(fontSize: 12.sp),
                ),
                SizedBox(
                  height: 8.w,
                ),
                Container(
                  height: 1.w,
                  width: 70.w,
                  color: ColorUI.white,
                ),
                SizedBox(
                  height: 8.w,
                ),
                if (HiveData.userData!.nIK != null)
                  Text(
                    HiveData.userData!.nIK!,
                    style: TextUI.subtitleWhite.copyWith(fontSize: 12.sp),
                  ),
              ],
            )
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(vertical: 20, horizontal: 14),
            //     child: Text(
            //       (HiveData.userData?.fullname ?? '').toUpperCase(),
            //       style: TextUI.labelWhite2.copyWith(
            //           letterSpacing: 1.sp, fontWeight: FontWeight.w700),
            //     ),
            //   ),
            // ),
            // Spacer(),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       SizedBox(height: 5),
            //       Text(
            //         HiveData.userData!.phone!,
            //         style: TextUI.titleWhite,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

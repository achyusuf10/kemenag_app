import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:qoin_sdk/models/qoin_digitalid/document_user_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/intl_formats.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class OtaquMembershipCard extends StatelessWidget {
  final VoidCallback? onTap;
  final DocumentUserData? data;
  final double width;
  final double height;
  final bool isFullscreen;

  const OtaquMembershipCard({
    Key? key,
    this.onTap,
    this.data,
    this.width = 379,
    this.height = 233,
    this.isFullscreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String expiredDate = data?.docExpired != null && data?.docExpired != ''
        ? data!.docExpired!.substring(0, 10)
        : '-';  
    String membershipType = "-";
    if (data!.docNo!.startsWith('MM')) {
      membershipType = 'Master Contributor';
    } else {
      membershipType = 'Sub Contributor';
    }
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width.w,
        height: height.w,
        margin: EdgeInsets.only(bottom: 8.w),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.bgOtaquMembershipCard),
            fit: BoxFit.fill,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black54,
                blurRadius: 3.0,
                offset: Offset(0.0, 0.75))
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 10.w),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Your Current Contributor",
                        style: TextUI.bodyText2White.copyWith(fontSize: 10.sp),
                      ),
                      SizedBox(width: 16.h),
                      Text(
                        'Wildlife Komodo',
                        style: TextUI.title2White,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Contributor Number',
                        style: TextUI.bodyText2White
                            .copyWith(fontSize: 7.sp, letterSpacing: 0.2),
                      ),
                      Text(
                        data?.docNo ?? '-',
                        style: TextUI.bodyText2White
                            .copyWith(fontSize: 8.sp, letterSpacing: 0.2),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Contributor Type',
                        style: TextUI.bodyText2White
                            .copyWith(fontSize: 7.sp, letterSpacing: 0.2),
                      ),
                      Text(
                        membershipType,
                        style: TextUI.bodyText2White
                            .copyWith(fontSize: 8.sp, letterSpacing: 0.2),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Active Periode',
                        style: TextUI.bodyText2White
                            .copyWith(fontSize: 7.sp, letterSpacing: 0.2),
                      ),
                      Text(
                        // expiredDate != '-'
                        //     ? (expiredDate).datetimeFormat
                        //     : '-',
                        'Until ' + (expiredDate).dateFormat,
                        style: TextUI.bodyText2White
                            .copyWith(fontSize: 8.sp, letterSpacing: 0.2),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
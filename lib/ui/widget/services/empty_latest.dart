import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class EmptyLatest extends StatelessWidget {
  const EmptyLatest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          Assets.emptyTransaction,
          height: 180.h,
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.h),
          child: Text(
            QoinServicesLocalization.emptyHistoryCustomerIds.tr,
            style: TextUI.subtitleBlack,
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/qoin_transaction_localization.g.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class NotificationEmptyScreen extends StatelessWidget {
  final int? tabIndex;
  const NotificationEmptyScreen({key, required this.tabIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.h, 80.h, 16.h, 12.h),
          child: Image.asset(
            Assets.emptyNotification,
            height: ScreenUtil().setHeight(183.8),
            width: ScreenUtil().setWidth(180),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setHeight(12),
          ),
          child: Text(
            tabIndex == 0 ? QoinTransactionLocalization.emptyActivities.tr : QoinTransactionLocalization.emptyNotification.tr,
            style: TextUI.subtitleBlack,
            textScaleFactor: 1.0,
          ),
        )
      ],
    );
  }
}

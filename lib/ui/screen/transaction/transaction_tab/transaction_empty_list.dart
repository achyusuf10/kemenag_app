import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/qoin_transaction_localization.g.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class TransactionEmptyWidget extends StatelessWidget {
  final bool isQoin;
  const TransactionEmptyWidget({key, this.isQoin = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20.w, !isQoin ? ScreenUtil().screenHeight / 5 : 20.w, 20.w, 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            isQoin ? Assets.emptyTransactionQoin : Assets.emptyTransaction,
            height: ScreenUtil().setWidth(180),
            width: ScreenUtil().setWidth(180),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(20),
          ),
          Text(
            QoinTransactionLocalization.trxTitleTextEmptyTransaction.tr,
            style: TextUI.subtitleBlack,
            textScaleFactor: 1.0,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

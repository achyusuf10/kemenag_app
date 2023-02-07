import 'package:inisa_app/helper/ui_design.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/qoin_transaction_localization.g.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusWidget extends StatelessWidget {
  final int? status;

  const StatusWidget({key, required this.status}) : super(key: key);

  String getStatus() {
    if (status == 9) {
      return QoinTransactionLocalization.trxStatusTextIWWaiting.tr;
    } else if (status == 2) {
      return QoinTransactionLocalization.trxStatusTextIWCancel.tr;
    } else if ([1, 3].contains(status)) {
      return QoinTransactionLocalization.trxStatusTextIWSuccess.tr;
    } else if (status == 0) {
      return QoinTransactionLocalization
          .trxStatusTextIWOnProcess.tr; //QoinTransactionLocalization.trxStatusTextIWWaiting.tr;
    } else if (status == 7) {
      return QoinTransactionLocalization.trxStatusTextIWPaymentComplete.tr;
    } else if (status == 4) {
      return QoinTransactionLocalization.trxStatusTextIWRefund.tr;
    } else if (status == 6) {
      return QoinTransactionLocalization.trxStatusTextIWOnProcess.tr;
    } else if (status == 10) {
      return QoinTransactionLocalization.trxStatusTextIWExpired.tr;
    } else if (status == 8) {
      return QoinTransactionLocalization.trxStatusTextIWRefundFailed.tr;
    } else {
      return QoinTransactionLocalization.trxTitleText.tr;
    }
  }

  Widget statusWidget(int? status) {
    switch (status) {
      case 2:
      case 8:
        return Padding(
          padding: EdgeInsets.only(
            right: ScreenUtil().setHeight(4),
          ),
          child: Container(
            child: Icon(
              Icons.cancel,
              color: UIDesign.getStatusColor(trxStatus: status),
              size: ScreenUtil().setHeight(16),
            ),
          ),
        );
      case 1:
      case 3:
        return Padding(
          padding: EdgeInsets.only(
            right: ScreenUtil().setHeight(4),
          ),
          child: Icon(
            Icons.check_circle,
            color: UIDesign.getStatusColor(trxStatus: status),
            size: ScreenUtil().setHeight(16),
          ),
        );
      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        statusWidget(status),
        Text(
          getStatus(),
          style: TextUI.subtitleBlack.copyWith(
            fontSize: 14.sp,
            color: UIDesign.getStatusColor(trxStatus: status),
          ),
          textScaleFactor: 1.0,
        ),
      ],
    );
  }
}

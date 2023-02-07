import 'package:inisa_app/localization/qoin_transaction_localization.g.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/background.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/models/qoin_transaction/history_data.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'transaction_detail_ticket/transaction_detail_ticket_widget.dart';

class TransactionDetailScreen extends StatelessWidget {
  final HistoryData? data;
  TransactionDetailScreen({
    key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.setContext(context);
    GlobalKey _shareKey = new GlobalKey();

    return ModalProgress(
      loadingStatus: QoinTransactionController.to.isMainLoading.stream,
      child: Scaffold(
        appBar: AppBarWidget(
          title: QoinTransactionLocalization.trxTitleNewText.tr,
        ),
        body: RepaintBoundary(
          key: _shareKey,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Background(),
                Padding(
                  padding: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight),
                  child: TransactionDetailTicketWidget(
                    data: data,
                    globalKey: _shareKey,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

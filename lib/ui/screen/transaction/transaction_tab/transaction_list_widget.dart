import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/widget/transaction/separator_widget.dart';
import 'package:qoin_sdk/models/qoin_transaction/history_data.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'transaction_empty_list.dart';
import 'transaction_item_list.dart';

class TransactionListWidget extends StatelessWidget {
  final bool isQoin;
  final List<HistoryData>? data;

  TransactionListWidget({key, this.data, this.isQoin = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data!.isEmpty && data!.length == 0) {
      return TransactionEmptyWidget(
        isQoin: isQoin,
      );
    }

    return GroupedListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      elements: data!,
      groupBy: (HistoryData element) => DateFormat('dd MMMM yyyy').format(
        DateTime.parse(element.trxDate!),
      ),
      groupComparator: (String? val1, String? val2) => val2!.compareTo(val1!),
      itemComparator: (HistoryData val1, HistoryData val2) => val2.trxDate!.compareTo(val1.trxDate!),
      useStickyGroupSeparators: true,
      sort: false,
      groupSeparatorBuilder: (value) {
        return Container(
          color: Color(0XFFE5E5E5),
          padding: EdgeInsets.symmetric(
            vertical: 9.h,
            horizontal: 16.h,
          ),
          child: Text(
            '$value',
            style: TextUI.bodyTextBlack,
            textScaleFactor: 1.0,
          ),
        );
      },
      itemBuilder: (context, HistoryData element) => TransactionItemList(data: element),
      separator: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.h,
        ),
        child: SeparatorWidget(
          height: 1,
          color: Color(0XFFE5E5E5),
        ),
      ),
    );
  }
}

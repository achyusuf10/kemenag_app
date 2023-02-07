import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qoin_sdk/models/qoin_transaction/history_data.dart';

import 'transaction_detail_expanded_ticket_item.dart';

class TransactionDetailExpandedTicketWidget extends StatelessWidget {
  final HistoryData? data;

  const TransactionDetailExpandedTicketWidget({key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget>? trxDetailData;

    switch (data!.trxOrderType) {
      case 'PPOB':
        trxDetailData = TransactionDetailExpandedTicketItem(data!).ppob();
        break;
      case 'PPOBOY':
        trxDetailData = TransactionDetailExpandedTicketItem(data!).ppob();
        break;
      case 'TRANSFER':
        if (data?.trxCode != 'MD') {
          trxDetailData = TransactionDetailExpandedTicketItem(data!).transfer();
          break;
        }
        trxDetailData = TransactionDetailExpandedTicketItem(data!).request();
        break;
      case 'TOPUP':
        trxDetailData = TransactionDetailExpandedTicketItem(data!).topup();
        break;
      case 'WITHDRAW':
        trxDetailData = TransactionDetailExpandedTicketItem(data!).withdraw();
        break;
      case 'QOINTAG':
        trxDetailData = TransactionDetailExpandedTicketItem(data!).changeQoinTag();
        break;
      case 'OY':
        if (data?.trxCode == 'PBB') {
          trxDetailData = TransactionDetailExpandedTicketItem(data!).paymentPBB();
          break;
        }
        trxDetailData = TransactionDetailExpandedTicketItem(data!).payment();
        break;
      case 'RB':
        if (data?.trxCode == 'PBB') {
          trxDetailData = TransactionDetailExpandedTicketItem(data!).paymentPBB();
          break;
        }
        trxDetailData = TransactionDetailExpandedTicketItem(data!).payment();
        break;
      case 'PAYMENT':
        if (data?.trxCode == 'PBB') {
          trxDetailData = TransactionDetailExpandedTicketItem(data!).paymentPBB();
          break;
        } else if (data?.trxGroup == 'QRIS') {
          trxDetailData = TransactionDetailExpandedTicketItem(data!).qris();
          break;
        }
        trxDetailData = TransactionDetailExpandedTicketItem(data!).payment();
        break;
      case 'REDEEM':
        trxDetailData = TransactionDetailExpandedTicketItem(data!).redeem();
        break;
      case 'REFUND':
        trxDetailData = TransactionDetailExpandedTicketItem(data).refund();
        break;
      default:
        trxDetailData = [Container()];
    }

    trxDetailData.removeWhere((element) => element is SizedBox);

    return ListView.separated(
      itemCount: trxDetailData.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) => trxDetailData![index],
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: ScreenUtil().setHeight(12),
        );
      },
    );
  }
}

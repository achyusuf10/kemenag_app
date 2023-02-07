import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/helper/intl_formats.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/qoin_transaction_localization.g.dart';
import 'package:intl/intl.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:qoin_sdk/models/qoin_transaction/history_data.dart';

import 'status_widget.dart';
import 'ticket_item_widget.dart';

class RequestItemWidget extends StatelessWidget {
  final HistoryData? data;
  RequestItemWidget({key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: ScreenUtil().setHeight(16),
        bottom: ScreenUtil().setHeight(data!.trxStatus == 4 ? 0 : 16),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xffdedede),
        ),
        borderRadius: BorderRadius.circular(
          ScreenUtil().radius(4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(
                16,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                  child: Text(
                    '${data?.trxTransferToName?.initialWords}',
                    style: TextUI.subtitleWhite,
                    textAlign: TextAlign.center,
                    textScaleFactor: 1,
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setHeight(12),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(158),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data?.trxTransferToName?.capitalizeFirstofEach}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextUI.subtitleBlack,
                        textScaleFactor: 1,
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(4),
                      ),
                      Text(
                        '0817150596',
                        style: TextUI.labelGrey2,
                        textScaleFactor: 1,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Text(
                  '${data?.trxAmount?.formatCurrencyRp}',
                  style: TextUI.subtitleBlack,
                  textScaleFactor: 1,
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(
              12,
            ),
          ),
          Divider(
            height: 1,
            color: Color(0xffdedede),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(
              12,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(
                16,
              ),
            ),
            child: TicketItemWidget(
              title: QoinTransactionLocalization.trxstatus.tr,
              child: StatusWidget(
                status: data!.trxStatus,
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(
              data!.trxStatus == 4 ? 16 : 8,
            ),
          ),
          data!.trxStatus == 10
              ? InkWell(
                  onTap: () {},
                  child: Container(
                    child: Center(
                      child: Text(
                        QoinTransactionLocalization.trxremindMe.tr,
                        style: TextUI.buttonTextRed,
                        textScaleFactor: 1.0,
                      ),
                    ),
                    height: ScreenUtil().setHeight(36),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(
                          ScreenUtil().radius(4),
                        ),
                      ),
                      border: Border.all(
                        width: 1,
                        color: Color(0xfff7b500),
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(
                      16,
                    ),
                  ),
                  child: TicketItemWidget(
                    title: QoinTransactionLocalization.trxdate.tr,
                    desc: data?.trxDate != null && data?.trxDate != ''
                        ? AnyUtils.convertToLocal(data!.trxDate!)
                        : '-',
                  ),
                ),
        ],
      ),
    );
  }
}

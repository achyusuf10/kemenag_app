import 'package:flutter/rendering.dart';
import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/localization/qoin_transaction_localization.g.dart';
import 'package:inisa_app/ui/widget/transaction/request_item_widget.dart';
import 'package:inisa_app/ui/widget/transaction/status_widget.dart';
import 'package:qoin_sdk/models/qoin_transaction/history_data.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/ui/widget/transaction/ticket_item_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/intl_formats.dart';

class TransactionDetailExpandedTicketItem {
  final HistoryData? data;

  const TransactionDetailExpandedTicketItem(this.data);

  List<Widget> ppob() {
    String ppobTitle;
    if (data?.trxCode == 'PULSA') {
      ppobTitle = QoinTransactionLocalization.trxphoneNumber.tr;
    } else {
      ppobTitle = QoinTransactionLocalization.trxcustomerID.tr;
    }
    return [
      TicketItemWidget(
        title: QoinTransactionLocalization.trxstatus.tr,
        child: StatusWidget(
          status: data!.trxStatus,
        ),
      ),
      data?.trxGroup == 'TELKOM'
          ? TicketItemWidget(
              title: ppobTitle,
              desc:
                  "(${data?.trxPel1})${data?.trxPel2 != null ? data?.trxPel2 : ''}",
            )
          : TicketItemWidget(
              title: ppobTitle,
              desc:
                  "${data?.trxPel1}${data?.trxPel2 != null ? ' / ${data?.trxPel2}' : ''}${data?.trxPel3 != null ? ' / ${data?.trxPel3}' : ''}",
            ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxdate.tr,
        desc: data?.trxDate != null && data?.trxDate != ''
            ? AnyUtils.convertToLocal(data!.trxDate!)
            : '-',
      ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxpaymentMethod.tr,
        desc: data?.trxPaymentType == 'QOINCASH'
            ? QoinServicesLocalization.serviceTextQoinCash.tr
            : data?.trxPaymentType,
      ),
    ];
  }

  List<Widget> transfer() {
    return [
      TicketItemWidget(
        title: QoinTransactionLocalization.trxstatus.tr,
        child: StatusWidget(
          status: data!.trxStatus,
        ),
      ),
      if (data?.trxCode == "MDREQ")
        TicketItemWidget(
          title: QoinTransactionLocalization.trxaskFrom.tr,
          desc: data?.trxTransferToName,
        ),
      if (data?.trxFilter == 'TRXOUT' && data?.trxCode == 'M2M')
        TicketItemWidget(
          title: QoinTransactionLocalization.trxto.tr,
          desc: data!.trxTransferToName != null
              ? data!.trxTransferToName!.toLowerCase().contains('qoin user')
                  ? '${data?.trxTransferToName?.toLowerCase().replaceFirst('qoin user ', '').replaceFirst('62', '0')}'
                  : '${data?.trxTransferToName?.capitalizeFirstofEach}'
              : '-',
        ),
      if (data?.trxFilter == 'TRXOUT' && data?.trxCode == 'VA-OUT')
        Column(
          children: [
            TicketItemWidget(
              title: QoinTransactionLocalization.trxto.tr,
              desc: data!.trxRealAccountName != null
                  ? '${data?.trxRealAccountName?.capitalizeFirstofEach}'
                  : '-',
            ),
            SizedBox(
              height: ScreenUtil().setHeight(12),
            ),
            TicketItemWidget(
              title: QoinTransactionLocalization.trxbank.tr,
              desc: data!.trxRealBankName != null
                  ? '${data?.trxRealBankName?.capitalizeFirstofEach}'
                  : '-',
            ),
          ],
        ),
      if (data?.trxFilter == 'TRXIN' && data?.trxCode == 'M2M')
        TicketItemWidget(
          title: QoinTransactionLocalization.trxsender.tr,
          desc: data!.trxTransferFromName != null
              ? data!.trxTransferFromName!.toLowerCase().contains('qoin user')
                  ? '${data?.trxTransferFromName?.toLowerCase().replaceFirst('qoin user ', '').replaceFirst('62', '0')}'
                  : '${data?.trxTransferFromName?.capitalizeFirstofEach}'
              : '-',
        ),
      if (data?.trxFilter == 'TRXIN' && data?.trxCode == 'VA-IN')
        Column(
          children: [
            TicketItemWidget(
              title: QoinTransactionLocalization.trxsender.tr,
              desc: data!.trxRealAccountName != null
                  ? '${data?.trxRealAccountName?.capitalizeFirstofEach}'
                  : '-',
            ),
            SizedBox(
              height: ScreenUtil().setHeight(12),
            ),
            TicketItemWidget(
              title: QoinTransactionLocalization.trxbank.tr,
              desc: data!.trxRealBankName != null
                  ? '${data?.trxRealBankName?.capitalizeFirstofEach}'
                  : '-',
            ),
          ],
        ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxdate.tr,
        desc: data?.trxDate != null && data?.trxDate != ''
            ? AnyUtils.convertToLocal(data!.trxDate!)
            : '-',
      ),
      if (data?.trxCode != "MDREQ")
        TicketItemWidget(
          title: QoinTransactionLocalization.trxpaymentMethod.tr,
          desc: data?.trxPaymentType == 'QOINCASH'
              ? QoinServicesLocalization.serviceTextQoinCash.tr
              : data?.trxPaymentType,
        ),
      if (data?.trxCode == "MDREQ")
        TicketItemWidget(
          title: QoinTransactionLocalization.trxnominalReq.tr,
          desc: (data?.trxAmount ?? 0).toString(),
        ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxnote.tr,
        desc: '${data?.trxNote}',
      ),
    ];
  }

  List<Widget> topup() {
    return [
      TicketItemWidget(
        title: QoinTransactionLocalization.trxstatus.tr,
        child: StatusWidget(
          status: data!.trxStatus,
        ),
      ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxdate.tr,
        desc: data?.trxDate != null && data?.trxDate != ''
            ? AnyUtils.convertToLocal(data!.trxDate!)
            // DateFormat("dd-MM-yyyy - HH:mm").format(
            //     DateTime.parse(
            //         '${data?.trxDate}${Constans.serverTimeStringAddition}'), //DateTime.parse('${data?.trxDate}'),
            //   )
            : '-',
      ),
      data?.trxCode == "VA-IN-NTT"
          ? TicketItemWidget(
              title: QoinTransactionLocalization.trxpaymentMethod.tr,
              desc: 'Bank NTT',
            )
          : TicketItemWidget(
              title: QoinTransactionLocalization.trxaccountName.tr,
              desc: '${data?.trxTopUpVaName ?? "-"}',
            ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxtopUpNominal.tr,
        desc: '${(data?.trxAmount ?? 0).formatCurrencyRp}',
      ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxadminFee.tr,
        desc: '${(data?.trxFee ?? 0).formatCurrencyRp}',
      ),
    ];
  }

  List<Widget> withdraw() {
    return [
      TicketItemWidget(
        title: QoinTransactionLocalization.trxstatus.tr,
        child: StatusWidget(
          status: data!.trxStatus,
        ),
      ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxname.tr,
        desc: '${data?.trxCardAccountName}'.capitalizeFirstofEach,
      ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxcardNumber.tr,
        desc: '${data?.trxCardAccountNumber}',
      ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxdate.tr,
        desc: data?.trxDate != null && data?.trxDate != ''
            ? AnyUtils.convertToLocal(data!.trxDate!)
            : '-',
      ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxpaymentMethod.tr,
        desc: data?.trxPaymentType == 'QOINCASH'
            ? QoinServicesLocalization.serviceTextQoinCash.tr
            : data?.trxPaymentType,
      ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxnote.tr,
        desc: '${data?.trxNote}',
      ),
    ];
  }

  List<Widget> request() {
    return [
      RequestItemWidget(
        data: data,
      ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxnote.tr,
        desc: '${data?.trxNote}',
      ),
    ];
  }

  List<Widget> changeQoinTag() {
    return [
      TicketItemWidget(
        title: QoinTransactionLocalization.trxstatus.tr,
        child: StatusWidget(
          status: data!.trxStatus,
        ),
      ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxdate.tr,
        desc: data?.trxDate != null && data?.trxDate != ''
            ? AnyUtils.convertToLocal(data!.trxDate!)
            : '-',
      ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxchangeQointag.tr,
        desc: 'Q-Tag',
      ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxtotalBill.tr,
        desc: data?.trxAmount != null ? data?.trxAmount!.formatCurrencyRp : '0',
      ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxpaymentMethod.tr,
        desc: data?.trxPaymentType == 'QOINCASH'
            ? QoinServicesLocalization.serviceTextQoinCash.tr
            : data?.trxPaymentType,
      ),
    ];
  }

  List<Widget> payment() {
    return [
      TicketItemWidget(
        title: QoinTransactionLocalization.trxstatus.tr,
        child: StatusWidget(
          status: data!.trxStatus,
        ),
      ),
      // if (data?.trxCode != "VOUCHER")
      //   TicketItemWidget(
      //     title: QoinTransactionLocalization.trxmerchantName.tr,
      //     desc: '-',
      //   ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxdate.tr,
        desc: data?.trxDate != null && data?.trxDate != ''
            ? AnyUtils.convertToLocal(data!.trxDate!)
            : '-',
      ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxpaymentMethod.tr,
        desc: data?.trxPaymentType == 'QOINCASH'
            ? QoinServicesLocalization.serviceTextQoinCash.tr
            : data?.trxPaymentType,
      ),
    ];
  }

  List<Widget> redeem() {
    return [
      TicketItemWidget(
        title: QoinTransactionLocalization.trxpaymentMethod.tr,
        child: StatusWidget(
          status: data!.trxStatus,
        ),
      ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxdate.tr,
        desc: data?.trxDate != null && data?.trxDate != ''
            ? AnyUtils.convertToLocal(data!.trxDate!)
            : '-',
      ),
    ];
  }

  List<Widget> paymentPBB() {
    return [
      TicketItemWidget(
        title: QoinTransactionLocalization.trxstatus.tr,
        child: StatusWidget(
          status: data!.trxStatus,
        ),
      ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxdate.tr,
        desc: data?.trxDate != null && data?.trxDate != ''
            ? AnyUtils.convertToLocal(data!.trxDate!)
            : '-',
      ),
      if (data!.trxStatus == 1)
        TicketItemWidget(
          title: 'Nomor Objek Pajak',
          desc: data!.trxPbbNOP,
        ),
      if (data!.trxStatus == 1)
        TicketItemWidget(
          title: 'Nama',
          desc: data!.trxPbbName,
        ),
      if (data!.trxStatus == 1)
        TicketItemWidget(
          title: 'Tahun Pajak',
          desc: data!.trxPbbYear,
        ),
      if (data!.trxStatus == 1)
        TicketItemWidget(
          title: 'Total Tagihan',
          desc: (data!.trxPbbTagihan ?? 0).formatCurrencyRp,
        ),
      if (data!.trxStatus == 1)
        TicketItemWidget(
          title: 'Biaya Transaksi',
          desc: (data!.trxPbbAdminBank ?? 0).formatCurrencyRp,
        ),
      if (data!.trxStatus == 1)
        TicketItemWidget(
          title: 'Detail Invoice',
          child: GestureDetector(
            onTap: () {},
            child: Text('Lihat Invoice',
                textAlign: TextAlign.right,
                style: TextUI.subtitleBlack.copyWith(
                  letterSpacing: 0.2,
                  color: ColorUI.yellow,
                  fontSize: 14.sp,
                  decoration: TextDecoration.underline,
                )),
          ),
        ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxpaymentMethod.tr,
        desc: data?.trxPaymentType == 'QOINCASH'
            ? QoinServicesLocalization.serviceTextQoinCash.tr
            : data?.trxPaymentType,
      ),
    ];
  }

  List<Widget> qris() {
    return [
      TicketItemWidget(
        title: QoinTransactionLocalization.trxpaymentMethod.tr,
        child: StatusWidget(
          status: data!.trxStatus,
        ),
      ),
      TicketItemWidget(
        title: 'Nama Merchant',
        desc: data!.trxQrMerchant,
      ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxdate.tr,
        desc: data?.trxDate != null && data?.trxDate != ''
            ? AnyUtils.convertToLocal(data!.trxDate!)
            : '-',
      ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxpaymentMethod.tr,
        desc: data?.trxPaymentType == 'QOINCASH'
            ? QoinServicesLocalization.serviceTextQoinCash.tr
            : data?.trxPaymentType,
      ),
    ];
  }

  List<Widget> refund() {
    return [
      TicketItemWidget(
        title: QoinTransactionLocalization.trxpaymentMethod.tr,
        child: StatusWidget(
          status: data!.trxStatus,
        ),
      ),
      TicketItemWidget(
        title: 'Nama Merchant',
        desc: data!.trxQrMerchant,
      ),
      TicketItemWidget(
        title: QoinTransactionLocalization.trxdate.tr,
        desc: data?.trxDate != null && data?.trxDate != ''
            ? AnyUtils.convertToLocal(data!.trxDate!)
            : '-',
      ),
      TicketItemWidget(
        title: 'Nominal',
        desc: '${(data?.trxAmount ?? 0).formatCurrencyRp}',
      ),
    ];
  }
}

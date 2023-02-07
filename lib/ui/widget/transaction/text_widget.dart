import 'package:inisa_app/localization/qoin_transaction_localization.g.dart';
import 'package:qoin_sdk/models/qoin_transaction/history_data.dart';
import 'package:inisa_app/helper/intl_formats.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class TextWidget {
  static String getTitle(HistoryData? data) {
    String value = '';
    if (data?.trxFilter == 'TRXIN' && data?.trxOrderType == 'TRANSFER') {
      if (data?.trxCode == 'M2M') {
        if (data!.trxTransferFromName != null) {
          if (data.trxTransferFromName!.toLowerCase().contains('qoin user')) {
            value =
                '${QoinTransactionLocalization.trxTitleTextIWReceiveFrom.tr} ${data.trxTransferFromName?.replaceFirst('Qoin user ', '').replaceFirst('62', '0')}';
          }
          value =
              '${QoinTransactionLocalization.trxTitleTextIWReceiveFrom.tr} ${data.trxTransferFromName?.capitalizeFirstofEach}';
        }
      } else if (data?.trxCode == 'VA-IN') {
        if (data?.trxRealAccountName != null) {
          value =
              '${QoinTransactionLocalization.trxTitleTextIWReceiveFrom.tr} ${data?.trxRealAccountName?.capitalizeFirstofEach}';
        } else {
          value = 'Transfer IN';
        }
      } else if (data?.trxCode == 'TFAGI') {
        value = 'Transfer AGI Cash';
      } else {
        value = 'Transfer';
      }
    } else if (data?.trxFilter == 'TRXOUT' && data?.trxOrderType == 'TRANSFER') {
      if (data?.trxCode == 'M2M') {
        if (data?.trxTransferToName != null) {
          if (data!.trxTransferToName!.toLowerCase().contains('qoin user')) {
            value =
                '${QoinTransactionLocalization.trxTitleTextIWTransferTo.tr} ${data.trxTransferToName?.toLowerCase().replaceFirst('qoin user ', '').replaceFirst('62', '0')}';
          } else {
            value =
                '${QoinTransactionLocalization.trxTitleTextIWTransferTo.tr} ${data.trxTransferToName /*?.capitalizeFirstofEach */}';
          }
        }
      } else if (data?.trxCode == 'VA-OUT') {
        if (data!.trxRealAccountName != null) {
          value =
              '${QoinTransactionLocalization.trxTitleTextIWTransferTo.tr} ${data.trxRealAccountName?.capitalizeFirstofEach}';
        } else {
          value = 'Transfer Out';
        }
      } else if (data?.trxCode == 'TFAGI') {
        value = 'Transfer AGI Cash';
      } else {
        value = 'Transfer';
      }
    } else if (data?.trxFilter == 'TRXOUT' && data?.trxOrderType == 'WITHDRAW') {
      if (data?.trxCardAccountName != null) {
        value = '${QoinTransactionLocalization.trxTitleTextIWWithdrawTo.tr} ${data?.trxCardAccountName}';
      }
      value = '${QoinTransactionLocalization.trxTitleTextIWWithdrawTo.tr} -';
    } else if (data?.trxFilter == 'TRXOUT' && data?.trxOrderType == 'PAYMENT') {
      if (data?.trxCode == 'VOUCHER')
        value = QoinTransactionLocalization.trxTitleTextIWVoucherTopUp.tr;
      else if (data?.trxCode == 'PBB')
        value = 'Payment PBB${data!.trxPbbNOP != null ? ' - ${data.trxPbbNOP}' : ''}';
      else if (data?.trxGroup == 'QRIS')
        value = 'Pembayaran QRIS - ${data?.trxQrMerchant}';
      else
        value = '${data?.trxProductName}';
    } else if (data?.trxFilter == 'TRXIN' && data?.trxOrderType == 'REDEEM') {
      value = QoinTransactionLocalization.trxTitleTextIWRedeemVoucher.tr;
    } else {
      value = '${data?.trxProductName}';
    }

    if (data?.trxCode != 'PBB') return value.capitalizeFirstofEach;
    return value;
  }

  static String getStatus(int? status) {
    if (status == null) {
      return "-";
    } else if (status == 9) {
      return QoinTransactionLocalization
          .trxStatusTextIWOnProcess.tr; //QoinTransactionLocalization.trxStatusTextIWWaiting.tr;
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
      return QoinTransactionLocalization.trxStatusTextIWCancel.tr;
    } else if (status == 8) {
      return QoinTransactionLocalization.trxStatusTextIWRefundFailed.tr;
    } else {
      return QoinTransactionLocalization.trxTitleText.tr;
    }
  }

  static String tokenPln(String token) {
    String helper = "";
    for (int i = 0; i < token.length; i++) {
      if (i != 0) {
        if (i % 4 == 0) {
          helper += "-${token[i]}";
        } else {
          helper += "${token[i]}";
        }
      } else {
        helper += "${token[i]}";
      }
    }
    return helper;
  }
}

import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/qoin_transaction_localization.g.dart';
import 'package:inisa_app/ui/screen/services/widget_menu/models/services_id_model.dart';
import 'package:qoin_sdk/helpers/services/environment.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

import 'enums.dart';
import 'ui_text.dart';

class UIDesign {
  static String getTransactionImage({
    required String? trxOrderType,
    required String? trxFilter,
    required String? trxCode,
  }) {
    if (trxOrderType == 'PPOB') {
      return Assets.icBuy;
    } else if (trxOrderType == 'TOPUP') {
      return Assets.icTopUp;
    } else if (trxOrderType == 'REFUND') {
      return Assets.icRefund;
    } else if (trxOrderType == 'RECEIPT') {
      return Assets.icReciept;
    } else if (trxOrderType == 'REQUEST') {
      return Assets.icReciept;
    } else if (trxOrderType == 'QOINTAG') {
      return Assets.icBuy;
    } else if (trxOrderType == 'WITHDRAW') {
      return Assets.icTransfer;
    } else if (trxOrderType == 'TRANSFER') {
      if (trxFilter == 'TRXOUT') {
        return Assets.icTransfer;
      } else if (trxFilter == 'TRXIN') {
        return Assets.icReceive;
      } else if (trxFilter == 'REQUEST') {
        return Assets.icReciept;
      } else {
        return Assets.inisa;
      }
    } else if (trxOrderType == 'REWARD') {
      return Assets.icReward;
    } else if (trxOrderType == 'PAYMENT') {
      return Assets.icBuy;
    } else if (trxOrderType == 'REDEEM') {
      return Assets.icRedeem;
    } else if (trxOrderType == 'YUKKQRIS') {
      return Assets.icYukkQris;
    } else {
      return Assets.inisa;
    }
  }

  static Color getStatusColor({required int? trxStatus}) {
    if ([0, 6, 7, 9].contains(trxStatus)) {
      return Color(0xfff48e2d);
    } else if ([2, 8, 10].contains(trxStatus)) {
      return Color(0xffeb5050);
    } else if ([1, 3].contains(trxStatus)) {
      return Color(0xff2c8424);
    } else if ([4].contains(trxStatus)) {
      return Color(0xff3ba7c4);
    } else {
      return ColorUI.text_1;
    }
  }

  static String getMenuImage({required int serviceId}) {
    ServicesIdModel servicesIdModel = ServicesIdModel();
    if (serviceId == servicesIdModel.mobileRecharge)
      return Assets.menuPulsa;
    else if (serviceId == servicesIdModel.telephone)
      return Assets.menuTelepon;
    else if (serviceId == servicesIdModel.pajakPBB)
      return Assets.menuPajak;
    else if (serviceId == servicesIdModel.pdam)
      return Assets.menuPam;
    else if (serviceId == servicesIdModel.postpaid)
      return Assets.menuPascabayar;
    else if (serviceId == servicesIdModel.gas)
      return Assets.menuGas;
    else if (serviceId == servicesIdModel.tvCable || serviceId == servicesIdModel.internet)
      return Assets.menuInternetAndTvCable;
    else if (serviceId == servicesIdModel.electricityPostpaid)
      return Assets.menuListrikPascabayar;
    else if (serviceId == servicesIdModel.electricityTokens)
      return Assets.menuPln;
    else if (serviceId == servicesIdModel.bpjsKesehatan)
      return Assets.menuHealthyBpjs;
    else
      return Assets.inisa;
  }

  static String getProviderAssets({required phoneNumber}) {
    if (RegExp(telkomselRule).hasMatch(phoneNumber)) {
      return Assets.logoTelkomsel;
    } else if (RegExp(indosatRule).hasMatch(phoneNumber)) {
      return Assets.logoIndosat;
    } else if (RegExp(xlRule).hasMatch(phoneNumber)) {
      return Assets.logoXl;
    } else if (RegExp(smartfrenRule).hasMatch(phoneNumber)) {
      return Assets.logoSmartfren;
    } else if (RegExp(threeRule).hasMatch(phoneNumber)) {
      return Assets.logoTri;
    } else {
      return Assets.iconPhoneNumber;
    }
  }

  static String? getDialogImage({
    required DialogType type,
  }) {
    if (type == DialogType.noInternet) {
      return Assets.noInternet;
    } else if (type == DialogType.transactionExist) {
      return Assets.noBill;
    } else if (type == DialogType.problem ||
        type == DialogType.requestCardCanceled ||
        type == DialogType.overLimitSaldo) {
      return Assets.problem;
    } else if (type == DialogType.requestSplitBillSent) {
      return Assets.requestSent;
    } else if (type == DialogType.insufficientBalance) {
      return Assets.warning;
    } else if (type == DialogType.successPaymet) {
      return Assets.paymentSuccess;
    } else if (type == DialogType.warning) {
      return Assets.warning;
    } else {
      return null;
    }
  }

  static String? getDialogAnimation({
    required DialogType type,
  }) {
    if (type == DialogType.problem) {
      return Assets.problemAnimation;
    } else if (type == DialogType.noBill) {
      return Assets.noBillAnimation;
    } else if (type == DialogType.emailUsed) {
      return Assets.emailWarningAnimation;
    } else {
      return null;
    }
  }

  static String getDialogTitle({
    required DialogType type,
  }) {
    if (type == DialogType.noInternet) {
      return Localization.dialogTitleNoInternet.tr;
    } else if (type == DialogType.noBill) {
      return Localization.dialogTitleNoBill.tr;
    } else if (type == DialogType.problem) {
      return Localization.dialogTitleProblem.tr;
    } else if (type == DialogType.emailUsed) {
      return Localization.dialogTitleEmailNotAvailable.tr;
    } else if (type == DialogType.requestCardCanceled) {
      return Localization.dialogTitleRequestRejected.tr;
    } else if (type == DialogType.requestSplitBillSent) {
      return Localization.dialogTitleRequestSent.tr;
    } else if (type == DialogType.insufficientBalance) {
      return Localization.dialogTitleNotEnoughBalance.tr;
    } else if (type == DialogType.successPaymet) {
      return Localization.dialogTitlePaymentSuccess.tr;
    } else if (type == DialogType.transactionExist || type == DialogType.transactionExistDone) {
      return Localization.dialogTitleTrxMade.tr;
    } else if (type == DialogType.overLimitSaldo) {
      return Localization.dialogTitleOverLimitBalance.tr;
    } else {
      return "";
    }
  }

  static String getDialogDesc({
    required DialogType type,
  }) {
    if (type == DialogType.noInternet) {
      return Localization.dialogDescNoInternet.tr;
    } else if (type == DialogType.noBill) {
      return Localization.dialogDescNoBill.tr;
    } else if (type == DialogType.problem) {
      return Localization.dialogDescProblem.tr;
    } else if (type == DialogType.emailUsed) {
      return Localization.dialogDescEmailNotAvailable.tr;
    } else if (type == DialogType.requestCardCanceled) {
      return Localization.dialogDescRequestRejected.tr;
    } else if (type == DialogType.successPaymet) {
      return Localization.dialogDescPaymentSuccess.tr;
    } else if (type == DialogType.transactionExist) {
      return Localization.dialogDescTrxMade.tr;
    } else if (type == DialogType.overLimitSaldo) {
      return Localization.dialogDescOverLimitBalance.tr;
    } else {
      return "";
    }
  }

  static String getDialogMainButtonText({
    required DialogType type,
  }) {
    if (type == DialogType.noInternet) {
      return Localization.close.tr;
    } else if (type == DialogType.emailUsed) {
      return Localization.dialogButtonRecheck.tr;
    } else if (type == DialogType.requestSplitBillSent || type == DialogType.successPaymet) {
      return Localization.dialogButtonShowDetail.tr;
    } else if (type == DialogType.transactionExist) {
      return QoinTransactionLocalization.trxcontinuePayment.tr;
    } else {
      return Localization.back.tr;
    }
  }

  static String getMsgInf({
    @required String? trxFilter,
    @required String? trxOrderType,
    @required String? trxStatus,
  }) {
    if (trxFilter == 'DIGITALID' && trxStatus == '1') {
      return Assets.icDigitalIdSuccess;
    } else if (trxFilter == 'DIGITALID' && trxStatus == '0') {
      return Assets.icDigitalIdOnProcess;
    } else if (trxFilter == 'DIGITALID' && trxStatus == '2') {
      return Assets.icDigitalIdFailed;
    } else {
      return Assets.inisaRed;
    }
  }

  static InputDecoration searchBoxStyle(String hintText, Color focusColor) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextUI.placeHolderBlack,
      suffixIcon: Icon(
        Icons.search_rounded,
        color: ColorUI.border,
        size: 24,
      ),
      filled: true,
      fillColor: ColorUI.shape,
      isDense: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: ColorUI.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: focusColor),
      ),
    );
  }

  static InputDecoration qoinBorderTextFieldStyle(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: TextUI.placeHolderBlack,
        filled: true,
        fillColor: ColorUI.shape,
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: ColorUI.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: ColorUI.qoinSecondary),
        ),
      );

  static Decoration bottomButton = BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: const Color(0x14111111),
        offset: Offset(0, -2),
        blurRadius: 16,
        spreadRadius: 0,
      ),
    ],
    color: const Color(0xffffffff),
  );
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/logic/controller/digitalid/digital_archive_ui_controller.dart';
import 'package:inisa_app/ui/screen/digital_id/detail_digital_doc_screen.dart';
import 'package:inisa_app/ui/screen/digital_id/digital_id_helper.dart';
import 'package:inisa_app/ui/screen/services/top_up/topup_voucher_redeem_detail.dart';
import 'package:inisa_app/ui/widget/digital_id/doc_holder_widget.dart';
import 'package:inisa_app/ui/widget/topup_voucher_redeem_widget.dart';
import 'package:inisa_app/ui/widget/voucher_widget.dart';
import 'package:qoin_sdk/helpers/utils/hive_data.dart';
import 'package:qoin_sdk/models/qoin_digitalid/document_user_data.dart';

import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

class GenerateCard {
  var deleteMode = false.obs;

  generateIdentity(qoin.CardItem cardType, controller) {
    DocumentUserData? data;
    //* [TAKE OUT] RELAWAN JOKOWI
    // if (cardType.docNumber != 'relawan_jokowi') {
    // data = qoin.HiveData.docData?.firstWhere((element) => element?.docNo == cardType.docNumber);
    // }

    if (cardType.docNumber != 'digitalisasi_tni') {
      data = qoin.HiveData.docData
          ?.firstWhere((element) => element?.docNo == cardType.docNumber);
    }

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(24.w),
          margin: EdgeInsets.only(bottom: 16.h),
          child: Stack(
            children: [
              //* [TAKE OUT] RELAWAN JOKOWI
              // (cardType.docNumber == 'relawan_jokowi')
              //     ? InkWell(
              //         onTap: () => RelawanJokowiController.to.checkRelawanJokowiStatus(),
              //         child: RelawanJokowiCard(
              //           relawanData: {
              //             "qoin_tag": HiveData.userData!.qoinTag,
              //             "name": HiveData.userData!.fullname,
              //             "phone_number": HiveData.userData!.phone,
              //             "avatar": HiveData.userData!.pict,
              //           },
              //         ),
              //       )
              //     :
              DocHolderWidget(
                data: data!,
                onTap: () {
                  // qoin.DigitalIdController.instance.getQrImage(data: data);
                  DigitalIdHelper.getQRData(data);
                  qoin.Get.to(
                    () => DetailDigitalDocScreen(data: data),
                  );
                },
              ),
              qoin.Obx(
                () => !deleteMode.value
                    ? Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            controller.saveToFavorite(cardType);
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(34)),
                                color: Colors.white),
                            child: Image.asset(
                              cardType.isFavorite
                                  ? Assets.icFavoriteContactFill
                                  : Assets.icFavoriteContact,
                              height: 24,
                              width: 24,
                              color: cardType.isFavorite
                                  ? Colors.red
                                  : Colors.black,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ),
        qoin.Obx(() => deleteMode.value &&
                data!.docCardType != '${qoin.CardCode.ktpCardType}'
            ? Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    DialogUtils.showMainPopup(
                        title: DigitalIdLocalization.deleteCard.tr,
                        description: DigitalIdLocalization.deleteCardDesc.tr,
                        mainButtonText: Localization.cancel.tr,
                        mainButtonFunction: () => qoin.Get.back(),
                        secondaryButtonText: Localization.yes.tr,
                        secondaryButtonFunction: () async {
                          qoin.Get.back();
                          await Future.delayed(Duration(milliseconds: 300));
                          qoin.DigitalIdController.instance
                              .deleteDocumentByDocId(data!, onSuccess: () {
                            controller.deleteCard(cardType);
                            _snackBarSuccess();
                          }, onError: (error) {
                            _snackBarFailed();
                          });
                        },
                        mainPopupButtonDirection:
                            MainPopupButtonDirection.Horizontal,
                        buttonMainFirst: true);
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.only(top: 16.h, right: 16.w),
                    width: 20.w,
                    height: 20.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.w)),
                        color: Colors.red),
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 12.w,
                    ),
                  ),
                ),
              )
            : SizedBox()),
      ],
    );
  }

  generateTicket(qoin.CardItem cardType, controller) {
    var data;
    var widget;

    if (cardType.typeCard == qoin.TypeCard.eticket) {
      data = qoin.HiveData.ticketManifests
          ?.firstWhere((element) => element.ticketNumber == cardType.docNumber);
      widget = VoucherWidget(voucherData: data!);
    } else {
      if (cardType.typeCard == qoin.TypeCard.voucher &&
          cardType.ket == qoin.TypeCard.idcard.toString()) {
        data = qoin.HiveData.docData
            ?.firstWhere((element) => element?.docNo == cardType.docNumber);
        widget = DocHolderWidget(
          data: data!,
          onTap: () {
            // qoin.DigitalIdController.instance.getQrImage(data: data);
            DigitalIdHelper.getQRData(data);
            qoin.Get.to(
              () => DetailDigitalDocScreen(data: data),
            );
          },
        );
      } else {
        data = qoin.HiveData.vouchers?.firstWhere(
            (element) => element.voucherNumber == cardType.docNumber);
        widget = VoucherWidget(voucherData: data!);
      }
    }

    return Container(
      padding: EdgeInsets.all(24.w),
      margin: EdgeInsets.only(bottom: 16.h),
      child: Stack(
        children: [
          widget,
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                controller.saveToFavorite(cardType);
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(34)),
                    color: Colors.white),
                child: Image.asset(
                  cardType.isFavorite
                      ? Assets.icFavoriteContactFill
                      : Assets.icFavoriteContact,
                  height: 24,
                  width: 24,
                  color: cardType.isFavorite ? Colors.red : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  generateVoucherTopUp(qoin.CardItem cardType, controller) {
    var data = qoin.HiveData.vouchersTopupPurchased?.firstWhere((element) =>
        element.voucherNo == cardType.docNumber && cardType.ket == null);
    return Container(
      padding: EdgeInsets.all(24.w),
      margin: EdgeInsets.only(bottom: 16.h),
      child: Stack(
        children: [
          TopUpVoucherRedeemWidget(
            data: data!,
            onTapButton: () {
              qoin.Get.to(() => TopUpVoucherRedeemDetail(
                    data: data,
                  ));
            },
          ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                controller.saveToFavorite(cardType);
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(34)),
                    color: Colors.white),
                child: Image.asset(
                  cardType.isFavorite
                      ? Assets.icFavoriteContactFill
                      : Assets.icFavoriteContact,
                  height: 24,
                  width: 24,

                  /// * Take Out Data Tiket Otaqu
                  color: cardType.isFavorite ? Colors.red : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  generateEDocument(qoin.CardItem cardType, controller) {
    return Container(
      padding: EdgeInsets.all(24.w),
      margin: EdgeInsets.only(bottom: 16.h),
      child: Stack(
        children: [
          SizedBox(),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                controller.saveToFavorite(cardType);
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(34)),
                    color: Colors.white),
                child: Image.asset(
                  cardType.isFavorite
                      ? Assets.icFavoriteContactFill
                      : Assets.icFavoriteContact,
                  height: 24,
                  width: 24,
                  color: cardType.isFavorite ? Colors.red : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  generateVoucherBansos(qoin.CardItem cardType, controller) {
    return Container(
      padding: EdgeInsets.all(24.w),
      margin: EdgeInsets.only(bottom: 16.h),
      child: Stack(
        children: [],
      ),
    );
  }

  _snackBarSuccess() {
    return qoin.Get.showSnackbar(qoin.GetSnackBar(
      icon: Icon(
        Icons.check_circle,
        color: Colors.green,
      ),
      backgroundColor: Color(0xffd9ffe0),
      snackPosition: qoin.SnackPosition.TOP,
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(DigitalIdLocalization.deleteCardSuccess.tr,
              style: TextUI.bodyText2Black.copyWith(
                color: Colors.green,
              )),
          GestureDetector(
              onTap: () {
                qoin.Get.closeCurrentSnackbar();
              },
              child: Icon(Icons.close, color: ColorUI.text_4))
        ],
      ),
      margin: EdgeInsets.only(top: kBottomNavigationBarHeight),
      duration: Duration(seconds: 3),
      shouldIconPulse: true,
    ));
  }

  _snackBarFailed() {
    return qoin.Get.showSnackbar(qoin.GetSnackBar(
      icon: Image(
        image: AssetImage(Assets.attention),
        color: Colors.red,
        height: 21,
      ),
      backgroundColor: Color(0xffffe4e4),
      snackPosition: qoin.SnackPosition.TOP,
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(DigitalIdLocalization.deleteCardFailed.tr,
              style: TextUI.bodyText2Black.copyWith(
                color: Colors.red,
              )),
          GestureDetector(
              onTap: () {
                qoin.Get.closeCurrentSnackbar();
              },
              child: Icon(Icons.close, color: ColorUI.text_4))
        ],
      ),
      margin: EdgeInsets.only(top: kBottomNavigationBarHeight),
      duration: Duration(seconds: 3),
      shouldIconPulse: true,
    ));
  }
}

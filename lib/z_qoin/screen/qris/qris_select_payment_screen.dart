import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/ui_design.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/screen/account/pin/pin_screen_old.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/dashed_separator.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:inisa_app/z_qoin/widget/merchant_item.dart';
import 'package:inisa_app/z_qoin/widget/source_fund_widget.dart';
import 'package:qoin_sdk/models/qoin_wallets/qris_inquiry_data.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

import '../topup/topup_screen.dart';

class QRISSelectPaymentScreen extends StatefulWidget {
  String? tipAmount;
  final QRISInquiryData? inquiryData;
  final Map? qrisDescription;

  QRISSelectPaymentScreen({
    this.tipAmount = '0',
    this.inquiryData,
    this.qrisDescription,
  });

  @override
  _QRISSelectPaymentScreenState createState() => _QRISSelectPaymentScreenState();
}

class _QRISSelectPaymentScreenState extends State<QRISSelectPaymentScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.inquiryData?.tipIndicator == '03' && widget.inquiryData?.tipPercentage != null) {
      widget.tipAmount = "${((int.tryParse(QoinWalletController.to.amountToTransfer ?? "0") ?? 0) * double.parse(widget.tipAmount!.replaceAll('%', '')) / 100).round()}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: QoinWalletController.to.isMainLoading.stream,
      child: Scaffold(
        appBar: AppBarWidget.qoin(
          title: WalletLocalization.payment.tr,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                WalletLocalization.merchant.tr,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 16,
              ),
              MerchantItem(
                merchant: "${widget.qrisDescription!["Merchant"]}",
                location: "${widget.qrisDescription!["Lokasi"]}",
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                child: DashedSeparator(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              SourceFundWidget(
                contentPadding: EdgeInsets.zero,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: DashedSeparator(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              Text(
                WalletLocalization.detailPayment.tr,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    WalletLocalization.payment.tr,
                    style: TextUI.bodyTextBlack3,
                  ),
                  Text(
                    "Rp${NumberFormat.currency(locale: "id", symbol: "", decimalDigits: 0).format(int.parse(QoinWalletController.to.amountToTransfer ?? '0'))}",
                    style: TextUI.bodyTextBlack,
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (widget.inquiryData?.tipIndicator == '01') ? WalletLocalization.tipToMerchant.tr : WalletLocalization.transactionPayment.tr,
                    style: TextUI.bodyTextBlack3,
                  ),
                  Text(
                    "Rp${NumberFormat.currency(locale: "id", symbol: "", decimalDigits: 0).format(int.parse(widget.tipAmount!.replaceAll('.', '')))}",
                    style: TextUI.bodyTextBlack,
                  )
                ],
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: UIDesign.bottomButton,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    WalletLocalization.totalPayment.tr,
                    style: TextUI.subtitleBlack,
                  ),
                  Text(
                    "Rp${NumberFormat.currency(locale: "id", symbol: "", decimalDigits: 0).format(int.parse(QoinWalletController.to.amountToTransfer ?? '0') + int.parse(widget.tipAmount!.replaceAll('.', '')))}",
                    style: TextUI.subtitleBlack,
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              MainButton.qoin(
                text: QoinServicesLocalization.servicePaymentPayNow.tr,
                onPressed: (int.parse(QoinWalletController.to.amountToTransfer ?? "0") <=
                        int.parse(
                          QoinWalletController.to.balance.replaceAll(".", ""),
                        ))
                    ? () async {
                        final result = await Get.to(() => PinScreenOld(
                              pinType: PinTypeEnum.confirmationTransaction,
                            ));
                        if (result != null) {
                          var totalAmount = int.parse(QoinWalletController.to.amountToTransfer ?? '0') +
                              int.parse(
                                (widget.tipAmount ?? "0").replaceAll('.', ''),
                              );
                          // set amount and tip before post to api
                          setQRISAmount(widget.inquiryData!.merchantCode ?? "");
                          setTipAmount(widget.inquiryData!.tipIndicator ?? "");
                          var referenceNumber = DateTime.now().millisecondsSinceEpoch.toString().substring(0, 12);
                          QoinWalletController.to.qrisPayment(
                              referenceNumber: referenceNumber,
                              paymentId: widget.inquiryData?.paymentId ?? "0",
                              tipAmount: widget.tipAmount!.replaceAll('.', ''),
                              onSuccess: (paymentData) {
                                QoinWalletController.to.isMainLoading.value = false;
                                if (paymentData?.responseCode == "00") {
                                  DialogUtils.showMainPopup(
                                    image: Assets.icSuccessPay,
                                    title: 'Pembayaran Berhasil',
                                    description: 'Pembayaran Rp${NumberFormat.currency(locale: "id", symbol: "", decimalDigits: 0).format(totalAmount)} ke merchant ${widget.qrisDescription!['Merchant']}',
                                    mainButtonText: 'Tutup',
                                    mainButtonFunction: () {
                                      Get.offAll(() => HomeScreen(), binding: OnloginBindings());
                                    },
                                  );
                                } else {
                                  DialogUtils.showPopUp(
                                      type: DialogType.problem,
                                      title: 'Pembayaran Gagal',
                                      description: '${paymentData?.responseDescription}',
                                      buttonText: 'Kembali',
                                      buttonFunction: () {
                                        Get.back();
                                        Get.back();
                                        Get.back();
                                        Get.back();
                                      });
                                }
                              },
                              onError: (e, paymentData) {
                                debugPrint("debugPrint error in UI ${paymentData?.responseCode}");
                                if (e.toLowerCase() == 'you are offline') {
                                  DialogUtils.showPopUp(type: DialogType.noInternet);
                                  return;
                                }
                                if (paymentData != null) {
                                  if (paymentData.responseCode == "68") {
                                    QoinWalletController.to.isMainLoading.value = false;
                                    log('QRIS REFERENCE NUMBER $referenceNumber');
                                    hitCheckStatus(
                                      referenceNumber: referenceNumber,
                                      totalAmount: totalAmount,
                                      responseDesc: paymentData.responseDescription,
                                    );
                                  } else {
                                    QoinWalletController.to.isMainLoading.value = false;
                                    DialogUtils.showPopUp(
                                        type: DialogType.problem,
                                        title: 'Pembayaran Gagal',
                                        description: '${paymentData.responseDescription}',
                                        buttonText: 'Kembali',
                                        buttonFunction: () {
                                          Get.back();
                                          Get.back();
                                          Get.back();
                                          Get.back();
                                        });
                                  }
                                } else {
                                  print("data null ${QoinWalletController.to.paymentQrisTimeout.value}");
                                  if (QoinWalletController.to.paymentQrisTimeout.value < 5) {
                                    QoinWalletController.to.isMainLoading.value = false;
                                    DialogUtils.showPopUp(
                                        type: DialogType.problem,
                                        title: 'Pembayaran Gagal',
                                        description: 'Maaf sepertinya ada masalah ketika memproses permintaan kamu, silahkan coba beberapa\nsaat lagi.',
                                        buttonText: 'Kembali',
                                        buttonFunction: () {
                                          Get.back();
                                          Get.back();
                                          Get.back();
                                          Get.back();
                                        });
                                  }
                                }
                              });
                        }
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setQRISAmount(String merchantCode) {
    switch (merchantCode) {
      //tidak perlu input amount dan tip
      case "QRIS1":
        QoinWalletController.to.amountToTransfer = '';
        break;
      //input amount saja
      case "QRIS2":
        break;
      //input tip saja
      case "QRIS3":
        QoinWalletController.to.amountToTransfer = '';
        break;
      //input amount dan tip
      case "QRIS4":
        break;
    }
  }

  void setTipAmount(String tipIndicator) {
    switch (tipIndicator) {
      //clear tip karena sudah ada di inquiry
      case "00":
        widget.tipAmount = '';
        break;
      //pakai tip yang dipilih user
      case "01":
        print("tip diinput user");
        break;
      //clear tip karena sudah ada di inquiry
      case "02":
        widget.tipAmount = '';
        break;
      //clear tip karena sudah ada di inquiry
      case "03":
        widget.tipAmount = '';
        break;
    }
  }

  void hitCheckStatus({
    String? referenceNumber,
    int? totalAmount,
    String? responseDesc,
    bool isFromSuccess = false,
  }) {
    Future.delayed(Duration(milliseconds: 300), () {
      log('referenceNumber: $referenceNumber');
      QoinWalletController.to.qrisCheckStatus(
          paymentId: referenceNumber,
          onSuccess: (data) {
            DialogUtils.showMainPopup(
              image: Assets.icSuccessPay,
              title: 'Pembayaran Berhasil',
              description: 'Pembayaran Rp${NumberFormat.currency(locale: "id", symbol: "", decimalDigits: 0).format(totalAmount)} ke merchant ${widget.qrisDescription!['Merchant']}',
              mainButtonText: 'Tutup',
              mainButtonFunction: () {
                Get.offAll(() => HomeScreen(), binding: OnloginBindings());
              },
            );
          },
          onError: (e) {
            if (isFromSuccess) {
              DialogUtils.showMainPopup(
                image: Assets.icSuccessPay,
                title: 'Pembayaran Berhasil',
                description: 'Pembayaran Rp${NumberFormat.currency(locale: "id", symbol: "", decimalDigits: 0).format(totalAmount)} ke merchant ${widget.qrisDescription!['Merchant']}',
                mainButtonText: 'Tutup',
                mainButtonFunction: () {
                  Get.offAll(() => HomeScreen(), binding: OnloginBindings());
                },
              );
            } else {
              DialogUtils.showMainPopup(
                  image: Assets.icClose,
                  title: 'Pembayaran Gagal',
                  description: '',
                  mainButtonText: 'Tutup',
                  mainButtonFunction: () {
                    Get.offAll(() => HomeScreen(), binding: OnloginBindings());
                  });
            }
          });
    });
  }
}

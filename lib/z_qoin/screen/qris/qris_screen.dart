import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_bottom.dart';
import 'package:inisa_app/ui/widget/dashed_separator.dart';
import 'package:inisa_app/z_qoin/widget/merchant_item.dart';
import 'package:inisa_app/z_qoin/widget/nominal_textfield.dart';
import 'package:qoin_sdk/models/qoin_wallets/qris_inquiry_data.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

import 'qris_select_payment_screen.dart';

class TipOptions {
  String? amount;
  bool? isActive;

  TipOptions({this.amount, this.isActive});
}

class QRISScreen extends StatefulWidget {
  final QRISInquiryData inquiryData;

  QRISScreen({required this.inquiryData});

  @override
  _QRISScreenScreenState createState() => _QRISScreenScreenState();
}

class _QRISScreenScreenState extends State<QRISScreen> {
  var enableButton = false.obs;
  TextEditingController amountController = TextEditingController();
  String amount = "0";
  FocusNode amountFocusNode = FocusNode();
  Map? qrisDescription;

  List<TipOptions> _tipOptions = [
    TipOptions(amount: '1.000', isActive: false),
    TipOptions(amount: '2.500', isActive: false),
    TipOptions(amount: '5.000', isActive: false),
    TipOptions(amount: '10.000', isActive: false),
    TipOptions(amount: '15.000', isActive: false),
    TipOptions(amount: '20.000', isActive: false)
  ];

  TipOptions _selectedTip = TipOptions(amount: '0', isActive: false);

  @override
  void initState() {
    super.initState();

    var description = widget.inquiryData.qrisDescription;
    if (description!.endsWith(",}")) {
      description = description.substring(0, description.length - 2);
      print("remove last comma $description");
      description = description + "}";
      qrisDescription = jsonDecode(description);
    }

    //set amount
    if (widget.inquiryData.amount != null) {
      print("amount ${widget.inquiryData.amount}");
      if (widget.inquiryData.amount!.contains('.')) {
        amount =
            "${NumberFormat.currency(locale: "id", symbol: "", decimalDigits: 0).format(int.tryParse(widget.inquiryData.amount!.substring(0, widget.inquiryData.amount!.indexOf('.'))))}";
      } else {
        amount =
            "${NumberFormat.currency(locale: "id", symbol: "", decimalDigits: 0).format(int.tryParse(widget.inquiryData.amount!))}";
      }
      QoinWalletController.to.amountToTransfer = amount.replaceAll('.', '');
      amountController.text = amount;
      enableButton.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBarWidget.qoin(
          title: WalletLocalization.payment.tr,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    WalletLocalization.merchant.tr,
                    style: TextUI.subtitleBlack,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  MerchantItem(
                    merchant: "${qrisDescription!["Merchant"]}",
                    location: "${qrisDescription!["Lokasi"]}",
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                    child: DashedSeparator(
                      height: 1,
                      color: Colors.grey,
                    ),
                  ),
                  NominalTextField.qris(
                      controller: amountController,
                      onDataChanged: (value, amount) {
                        enableButton.value = value;
                        if (amount != null) {
                          QoinWalletController.to.amountToTransfer = amount;
                          amount = amount;
                        }
                      }),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
            tipWidget(widget.inquiryData.tipIndicator ?? "")
          ],
        ),
        bottomSheet: Obx(
          () => ButtonBottom.qoin(
            text: WalletLocalization.selectMethodPayment.tr,
            onPressed: enableButton.value
                ? () {
                    Get.to(QRISSelectPaymentScreen(
                      tipAmount: _selectedTip.amount,
                      inquiryData: widget.inquiryData,
                      qrisDescription: qrisDescription,
                    ));
                  }
                : null,
          ),
        ),
      ),
    );
  }

  Widget tipWidget(String tipIndicator) {
    switch (tipIndicator) {
      case "00":
        _selectedTip = TipOptions(amount: '0', isActive: true);
        return SizedBox();
      case "01":
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                WalletLocalization.wannaGiveTip.tr,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                height: 200,
                child: GridView.count(
                    primary: false,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    crossAxisCount: 3,
                    childAspectRatio: 2,
                    children: _tipOptions.map((e) {
                      return InkResponse(
                        onTap: () {
                          for (var i = 0; i < _tipOptions.length; i++) {
                            _tipOptions[i].isActive = false;
                          }
                          e.isActive = !e.isActive!;
                          _selectedTip = e;
                          setState(() {});
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0x28000000),
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                    spreadRadius: 0)
                              ],
                              border: Border.all(
                                  color: e.isActive! ? ColorUI.qoinSecondary : Colors.transparent),
                              color: Colors.white),
                          child: Center(
                              child: Text("Rp${e.amount}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                        ),
                      );
                    }).toList()),
              )
            ],
          ),
        );
      case "02":
        _selectedTip =
            TipOptions(amount: widget.inquiryData.tipAmount!.split('.')[0], isActive: true);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                WalletLocalization.transactionPayment.tr,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                "Rp${NumberFormat.currency(locale: "id", symbol: "", decimalDigits: 0).format(int.tryParse(_selectedTip.amount!))}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              )
            ],
          ),
        );
      case "03":
        _selectedTip = TipOptions(
            amount: "${double.tryParse((widget.inquiryData.tipPercentage ?? 0).toString())}%",
            isActive: true);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                WalletLocalization.transactionPayment.tr,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                "${_selectedTip.amount}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              )
            ],
          ),
        );
      default:
        return SizedBox();
    }
  }
}

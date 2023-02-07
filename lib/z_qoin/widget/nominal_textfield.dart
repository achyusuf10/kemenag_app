import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/z_qoin/screen/topup/topup_screen.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum NominalFieldType { pay, transfer, request, qris }

class NominalTextField extends StatelessWidget {
  var notEnoughBalance;
  var amountErrorText;
  final Function(bool, String? amount) onDataChanged;
  final int minimalAmount;
  final int maximalAmount;
  final withTopUp;
  final type;
  final EdgeInsetsGeometry? padding;
  final TextEditingController? controller;

  NominalTextField(
      {Key? key,
      this.maximalAmount = 10000000,
      this.minimalAmount = 10000,
      this.controller,
      this.padding,
      required this.onDataChanged,
      this.withTopUp = false})
      : notEnoughBalance = false.obs,
        amountErrorText = ''.obs,
        type = NominalFieldType.pay,
        super(key: key);

  NominalTextField.transfer(
      {Key? key,
      this.maximalAmount = 10000000,
      this.minimalAmount = 10000,
      this.padding,
      required this.onDataChanged,
      this.withTopUp = false,
      this.controller})
      : notEnoughBalance = false.obs,
        amountErrorText = ''.obs,
        type = NominalFieldType.transfer,
        super(key: key);

  NominalTextField.request(
      {Key? key,
      this.maximalAmount = 10000000,
      this.minimalAmount = 10000,
      this.padding,
      required this.onDataChanged,
      this.controller,
      this.withTopUp = false})
      : notEnoughBalance = false.obs,
        amountErrorText = ''.obs,
        type = NominalFieldType.request,
        super(key: key);

  NominalTextField.qris({
    Key? key,
    required this.onDataChanged,
    this.padding,
    this.controller,
  })  : notEnoughBalance = false.obs,
        amountErrorText = ''.obs,
        type = NominalFieldType.qris,
        maximalAmount = 10000000,
        minimalAmount = 1,
        this.withTopUp = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var title;
    var hint;
    switch (type) {
      case NominalFieldType.transfer:
        title = WalletLocalization.transferNominal.tr;
        break;
      case NominalFieldType.request:
        title = WalletLocalization.requestNominal.tr;
        break;
      case NominalFieldType.qris:
        title = WalletLocalization.totalPayment.tr;
        hint = WalletLocalization.inputNominalPayment.tr;
        break;
      default:
        title = WalletLocalization.paymentNominal.tr;
    }

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: TextUI.subtitleBlack,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            // decoration: UIDesign.qoinBorderTextFieldStyle(''),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(color: ColorUI.border, width: 1),
                color: ColorUI.shape),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        inputFormatters: <TextInputFormatter>[
                          CurrencyTextInputFormatter(
                            locale: 'id',
                            decimalDigits: 0,
                            symbol: 'Rp',
                          ),
                        ],
                        controller: controller ?? TextEditingController(),
                        keyboardType: TextInputType.number,
                        maxLength: 12,
                        decoration: InputDecoration(
                            hintText: hint ?? 'Rp0',
                            hintStyle: TextUI.titleGrey,
                            filled: true,
                            fillColor: ColorUI.shape,
                            isDense: true,
                            counterText: "",
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            border: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorStyle: TextUI.labelRed),
                        style: TextUI.titleBlack,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            var amount = value.replaceAll('Rp', '').replaceAll('.', '');
                            if (int.parse(amount) < minimalAmount && value.length > 0) {
                              notEnoughBalance.value = false;
                              if (type == NominalFieldType.transfer)
                                amountErrorText.value = WalletLocalization.transferMinimumInfo.tr;
                              else if (type == NominalFieldType.request)
                                amountErrorText.value = WalletLocalization.requestMinimumInfo.tr;
                              else
                                amountErrorText.value = WalletLocalization.minimalPayment.tr;
                              onDataChanged(false, null);
                              return;
                            } else if (int.parse(amount) >
                                    int.parse(
                                        QoinWalletController.to.balance.replaceAll(".", "")) &&
                                type != NominalFieldType.request) {
                              notEnoughBalance.value = true;
                              amountErrorText.value = WalletLocalization.notEnoughBalance.tr;
                              onDataChanged(false, null);
                              return;
                            } else {
                              notEnoughBalance.value = false;
                              amountErrorText.value = '';
                              onDataChanged(true, amount);
                            }
                          } else {
                            notEnoughBalance.value = false;
                            amountErrorText.value =
                                QoinServicesLocalization.servicePamErrorEmptyForm.tr;
                            onDataChanged(false, null);
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Obx(
                          () => Text(
                            amountErrorText.value,
                            style: TextUI.labelRed,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                if (withTopUp)
                  Obx(() => notEnoughBalance.value
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: MainButton.qoin(
                            text: WalletLocalization.menuTopup.tr,
                            width: 80.w,
                            height: 36.h,
                            onPressed: () => Get.to(TopUpScreen()),
                          ),
                        )
                      : SizedBox())
              ],
            ),
          ),
        ],
      ),
    );
  }
}

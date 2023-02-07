import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_design.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_bottom.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

import 'tf_bank_drawer.dart';

class TransferAddDestinationScreen extends StatelessWidget {
  TransferAddDestinationScreen({key}) : super(key: key);

  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  var accountFocus = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget.qoin(
          title: WalletLocalization.transferSubTitle.tr,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: ListView(
            children: [
              Text(
                WalletLocalization.transferAddAccount.tr,
                style: TextUI.title2Black,
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                WalletLocalization.bank.tr,
                style: TextUI.labelBlack,
              ),
              SizedBox(
                height: 4,
              ),
              InkWell(
                onTap: () {
                  DialogUtils.showGeneralDrawer(
                      radius: 16.r,
                      withStrip: true,
                      padding: EdgeInsets.only(top: 16.0),
                      content: Container(
                          height:
                              ScreenUtil().screenHeight - (kToolbarHeight * 3),
                          child: TransferBankDrawer(
                            onItemTap: (val) {
                              _bankNameController.text = val!.name!;
                            },
                          )));
                },
                child: TextField(
                  style: TextUI.bodyTextBlack,
                  controller: _bankNameController,
                  decoration: InputDecoration(
                      hintText: WalletLocalization.transferSelectBank.tr,
                      hintStyle: TextUI.placeHolderBlack,
                      filled: true,
                      fillColor: ColorUI.shape,
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: ColorUI.border),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: ColorUI.border),
                      ),
                      suffixIcon: Icon(Icons.arrow_drop_down)),
                  enabled: false,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                WalletLocalization.transferAccountNumber.tr,
                style: TextUI.labelBlack,
              ),
              SizedBox(
                height: 4,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: accountFocus,
                          style: TextUI.bodyTextBlack,
                          keyboardType: TextInputType.number,
                          controller: _bankAccountController,
                          decoration: UIDesign.qoinBorderTextFieldStyle(
                              WalletLocalization.transferInputAccountNumber.tr),
                        ),
                      ),
                      Container(
                          width: 72,
                          margin: EdgeInsets.only(left: 16.0),
                          child: GetBuilder<QoinWalletTransferBankController>(
                              builder: (controller) {
                            if (controller.isLoadingInquiry) {
                              return Container(
                                height: 48,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            return MainButton.qoin(
                              text: WalletLocalization.transferCheck.tr,
                              onPressed: () {
                                if (controller.selectedBank != null &&
                                    _bankAccountController.text != '') {
                                  controller.inquiryTransferOut(
                                    bankAccount: _bankAccountController.text,
                                    bankCode:
                                        controller.selectedBank?.code ?? "",
                                    amount: 0,
                                    isPrototype: controller.isPrototype,
                                    onSuccess: (data) {},
                                    onError: (error) {
                                      DialogUtils.showPopUp(
                                          type: DialogType.problem,
                                          description: WalletLocalization
                                              .transferCheckError.tr);
                                    },
                                  );
                                }
                              },
                            );
                          }))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GetBuilder<QoinWalletTransferBankController>(
                      builder: (controller) {
                    return (controller.inquryBankData == null)
                        ? SizedBox()
                        : Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "${controller.inquryBankData?.bankAccountName}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          );
                  })
                ],
              ),
            ],
          ),
        ),
        bottomSheet:
            GetBuilder<QoinWalletTransferBankController>(builder: (controller) {
          return ButtonBottom.qoin(
            text: WalletLocalization.confirmation.tr,
            onPressed: (controller.inquryBankData == null)
                ? null
                : () {
                    accountFocus.unfocus();
                    if (controller.inquryBankData == null) {
                      return;
                    }
                    controller.saveAccount(controller.inquryBankData);
                    Get.back();
                  },
          );
        }));
  }
}

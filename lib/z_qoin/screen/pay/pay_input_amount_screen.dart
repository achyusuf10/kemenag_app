import 'package:flutter/material.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/qoin_transaction_localization.g.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/screen/account/pin/pin_screen.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/widget/button_bottom.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:inisa_app/z_qoin/widget/account_item.dart';
import 'package:inisa_app/z_qoin/widget/message_texfield.dart';
import 'package:inisa_app/z_qoin/widget/nominal_textfield.dart';
import 'package:inisa_app/z_qoin/widget/separator_widget.dart';
import 'package:inisa_app/z_qoin/widget/source_fund_widget.dart';
import 'package:inisa_app/z_qoin/widget/title_section_text.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';

class PayInputAmountScreen extends StatefulWidget {
  const PayInputAmountScreen({key}) : super(key: key);

  @override
  _PayInputAmountScreenState createState() => _PayInputAmountScreenState();
}

class _PayInputAmountScreenState extends State<PayInputAmountScreen> {
  var buttonEnable = false.obs;
  FocusNode amountFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: qoin.QoinWalletController.to.isMainLoading.stream,
      child: Scaffold(
        appBar: AppBarWidget.qoin(
          title: WalletLocalization.payment.tr,
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                TitleSectionText(title: WalletLocalization.paymentPurpose.tr),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 16.0),
                  child: AccountItem(
                    fullname:
                        qoin.QoinWalletController.to.vaData?.mFullname ?? "-",
                    phone: qoin.QoinWalletController.to.vaData?.mPhoneNumber ??
                        "-",
                  ),
                ),
                SeparatorShapeWidget(),
                SourceFundWidget(),
                SeparatorShapeWidget(),
                NominalTextField(
                  padding: EdgeInsets.all(16.0),
                  withTopUp: true,
                  onDataChanged: (value, amount) {
                    buttonEnable.value = value;
                    if (amount != null) {
                      qoin.QoinWalletController.to.amountToTransfer = amount;
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                  child: MessageTextField(
                    onChanged: (val) {
                      qoin.QoinWalletController.to.noteToTransfer = val;
                    },
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ],
        ),
        bottomSheet: qoin.Obx(
          () => ButtonBottom.qoin(
            text: WalletLocalization.sendNow.tr,
            onPressed: !buttonEnable.value
                ? null
                : () async {
                    // final result = await
                    await qoin.Get.to(() => PinScreen(
                          pinType: qoin.PinTypeEnum.confirmationTransaction,
                          functionSubmit: (result) async {
                            print("check pin result : $result");
                            await qoin.QoinWalletController.to.transferAssets(
                              onSuccess: () {
                                DialogUtils.showMainPopup(
                                  image: Assets.icSuccessTopUp,
                                  title: QoinTransactionLocalization
                                      .trxTitleText.tr,
                                  description:
                                      '${WalletLocalization.paymentTo.tr} ${qoin.QoinWalletController.to.vaData?.mFullname ?? qoin.QoinWalletController.to.vaData?.mPhoneNumber} Berhasil',
                                  mainButtonText: Localization.close.tr,
                                  mainButtonFunction: () {
                                    qoin.Get.offAll(() => HomeScreen());
                                  },
                                );
                              },
                              onError: (error) {
                                DialogUtils.showMainPopup(
                                  image: Assets.icClose,
                                  title: WalletLocalization.paymentFailed.tr,
                                  description: error,
                                  mainButtonText: Localization.tryAgain.tr,
                                  mainButtonFunction: () {
                                    qoin.Get.back();
                                  },
                                );
                              },
                            );
                          },
                        ));
                  },
          ),
        ),
      ),
    );
  }
}

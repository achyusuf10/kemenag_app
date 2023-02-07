import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_image.dart';
import 'package:inisa_app/ui/widget/search_textfield.dart';
import 'package:inisa_app/z_qoin/widget/separator_widget.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

import '../transfer_qoin/tf_account_detail_screen.dart';
import 'tf_add_destiantion_screen.dart';

class TransferAccountScreen extends StatelessWidget {
  const TransferAccountScreen({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.qoin(
        title: WalletLocalization.menuTransfer.tr,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  WalletLocalization.transferAccountDestination.tr,
                  style: TextUI.subtitleBlack,
                ),
                SizedBox(
                  height: 16,
                ),
                ButtonImage(
                  icon: Icon(
                    Icons.add,
                    color: ColorUI.qoinSecondary,
                  ),
                  text: WalletLocalization.transferAddAccount.tr,
                  textColor: ColorUI.qoinSecondary,
                  borderColor: ColorUI.qoinSecondary,
                  borderWidth: 2.0,
                  backgroundColor: qoin.Get.theme.backgroundColor,
                  onPressed: () async {
                    qoin.QoinWalletTransferBankController.to.selectedBank = null;
                    qoin.QoinWalletTransferBankController.to.inquryBankData = null;
                    await qoin.Get.to(TransferAddDestinationScreen());
                  },
                ),
              ],
            ),
          ),
          SeparatorShapeWidget(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchTextField.qoin(
                    hint: WalletLocalization.transferSearchNameAcc.tr,
                    onChanged: (val) {
                      qoin.QoinWalletTransferBankController.to.searchSavedBankAccount(val);
                    },
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: qoin.GetBuilder<qoin.QoinWalletTransferBankController>(
                        builder: (controller) {
                      return ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => Divider(
                                color: Colors.grey,
                                height: 30,
                              ),
                          itemCount: controller.savedBankAccountShow.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => qoin.Get.to(TransferBankAccountDetailScreen(
                                transferOutData: controller.savedBankAccountShow[index],
                              )),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image(
                                  //   image: EmoneyAssets.lgArthaGraha,
                                  //   // color: Colors.grey,
                                  //   height: 29.h,
                                  //   width: 48.w,
                                  // ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${controller.savedBankAccountShow[index].bankAccountName}",
                                        style: TextUI.subtitleBlack,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "${controller.savedBankAccountShow[index].bankName} - ${controller.savedBankAccountShow[index].bankAccountNo}",
                                        style: TextUI.bodyTextGrey,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          });
                    }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

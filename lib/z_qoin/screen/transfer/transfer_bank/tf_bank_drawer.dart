import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/widget/search_textfield.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class TransferBankDrawer extends StatelessWidget {
  final Function(BankData? data)? onItemTap;

  const TransferBankDrawer({key, this.onItemTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Center(
                        child: Text(WalletLocalization.transferAddAccount.tr,
                            style: TextUI.title2Black)),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SearchTextField.qoin(
                        hint: WalletLocalization.transferSearchBankName.tr,
                        onChanged: (val) {
                          QoinWalletTransferBankController.to.searchBank(val);
                        },
                      )),
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: GetBuilder<QoinWalletTransferBankController>(builder: (controller) {
                      return ListView.separated(
                        itemCount: controller.bankListShow.length,
                        shrinkWrap: true,
                        itemBuilder: (_, i) {
                          return InkWell(
                            child: ListTile(
                              title: Text("${controller.bankListShow[i].name}",
                                  style: TextUI.bodyTextBlack),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ),
                            onTap: () {
                              controller.selectedBank = controller.bankListShow[i];
                              controller.bankListShow = controller.bankList;
                              Get.back();
                              if (onItemTap != null) {
                                onItemTap!(controller.selectedBank);
                              }
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => Divider(
                          color: ColorUI.border,
                        ),
                      );
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

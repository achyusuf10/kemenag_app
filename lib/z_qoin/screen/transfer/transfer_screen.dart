import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/logic/controller/qoin_wallet_tf_bank_bindings.dart';
import 'package:inisa_app/ui/widget/dash_item.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';

import 'transfer_bank/tf_account_screen.dart';
import 'transfer_qoin/tf_qoin_screen.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({key}) : super(key: key);

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  List<Map<String, dynamic>> topUpMethod = [
    {
      "name": WalletLocalization.transferMenuUser.tr,
      "description": WalletLocalization.transferMenuUserDesc.tr,
      "icon": Assets.icQoinTransfer,
      "page": QoinRemoteConfigController.instance.isTransferToFellow == true ? TransferQoinScreen() : null,
      "binding": null,
    },
    {
      "name": WalletLocalization.transferMenuBank.tr,
      "description": WalletLocalization.transferMenuBankDesc.tr,
      "icon": Assets.icBankTransfer,
      "page": QoinRemoteConfigController.instance.isTransferToBanks == true ? TransferAccountScreen() : null,
      "binding": QoinRemoteConfigController.instance.isTransferToBanks == true ? QoinWalletTfBankBindings() : null,
    },
    {
      "name": WalletLocalization.transferMenuChat.tr,
      "description": WalletLocalization.transferMenuChatDesc.tr,
      "icon": Assets.icChatTransfer,
      "page": null,
      "binding": null,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.qoin(
        title: WalletLocalization.menuTransfer.tr,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(
              height: 8,
            ),
            Text(
              WalletLocalization.transferSubTitle.tr,
              style: TextUI.subtitleBlack,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              WalletLocalization.transferSubDesc.tr,
              style: TextUI.bodyText2Black,
            ),
            SizedBox(
              height: 24,
            ),
            ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                      height: 16,
                    ),
                shrinkWrap: true,
                itemCount: topUpMethod.length,
                itemBuilder: (context, index) {
                  return DashedItem(
                    asset: topUpMethod[index]["icon"],
                    title: topUpMethod[index]["name"],
                    subTitle: topUpMethod[index]["description"],
                    onTap: () => (topUpMethod[index]["page"] == null)
                        ? DialogUtils.showComingSoonDrawer()
                        : Get.to(topUpMethod[index]["page"],
                            binding: topUpMethod[index]["binding"]),
                  );
                })
          ],
        ),
      ),
    );
  }
}

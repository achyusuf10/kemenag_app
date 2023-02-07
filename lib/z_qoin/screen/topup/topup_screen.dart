import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/widget/dash_item.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';

import 'bank_transfer/select_bank_screen.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({key}) : super(key: key);

  @override
  _TopUpScreenState createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  List<Map<String, dynamic>> topUpMethod = [
    {
      "name": WalletLocalization.topUpMenuTranfer.tr,
      "description": WalletLocalization.topUpMenuTranferDesc.tr,
      "icon": Assets.icBankTransfer,
      "page": QoinRemoteConfigController.instance.isTopupBank == true ? SelectBankScreen() : null,
    },
    {
      "name": WalletLocalization.topUpMenuCredit.tr,
      "description": WalletLocalization.topUpMenuCreditDesc.tr,
      "icon": Assets.icCreditCard,
      // "page": QoinRemoteConfigController.instance.isTopupCreditCard == true ? AddCardScreen() : null,
    },
    {
      "name": WalletLocalization.topUpMenuMitra.tr,
      "description": WalletLocalization.topUpMenuMitraDesc.tr,
      "icon": Assets.icMerchantQoin,
      // "page": QoinRemoteConfigController.instance.isTopupMitra == true ? TopupMitraPage() : null
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.qoin(
        title: WalletLocalization.menuTopup.tr,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(
              height: 8,
            ),
            Text(
              WalletLocalization.topUpMethod.tr,
              style: TextUI.subtitleBlack,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              WalletLocalization.topUpMethodDesc.tr,
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
                        : Get.to(topUpMethod[index]["page"]),
                  );
                })
          ],
        ),
      ),
    );
  }
}

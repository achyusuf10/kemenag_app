import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'title_section_text.dart';

class SourceFundWidget extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  const SourceFundWidget({Key? key, this.contentPadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleSectionText(
            title: WalletLocalization.sourceFund.tr,
            padding: contentPadding,
          ),
          ListTile(
            contentPadding: contentPadding,
            leading: Image.asset(
              Assets.qoinBlack,
              width: 40.w,
              fit: BoxFit.fitWidth,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleSectionText(
                  title: QoinServicesLocalization.serviceTextQoinCash.tr,
                  padding: EdgeInsets.only(bottom: 8),
                ),
                Text(
                  "Rp${QoinWalletController.to.balance}",
                  style: TextUI.bodyText2Grey2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

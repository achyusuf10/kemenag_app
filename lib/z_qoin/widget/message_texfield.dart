import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_design.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

import 'title_section_text.dart';

class MessageTextField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final int? maxLength;

  const MessageTextField({Key? key, this.onChanged, this.maxLength, this.maxLines = 3})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSectionText(
          title: WalletLocalization.messageOptional.tr,
          padding: EdgeInsets.only(bottom: 8),
        ),
        TextField(
          maxLines: maxLines,
          maxLength: maxLength,
          style: TextUI.bodyTextBlack,
          decoration: UIDesign.qoinBorderTextFieldStyle(WalletLocalization.writeToReceiver.tr),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

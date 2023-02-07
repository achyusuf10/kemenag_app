import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class CustomerIdsWidget extends StatelessWidget {
  final Widget child;
  const CustomerIdsWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Localization.trxLatest.tr,
          style: TextUI.subtitleBlack,
        ),
        SizedBox(
          height: 16,
        ),
        child
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/localization/localization.dart';

class NoInternetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Assets.noInternet,
            height: 180,
          ),
          SizedBox(
            height: 22.0,
          ),
          Text(
            Localization.noInternetTitle.tr,
            style: TextUI.subtitleBlack,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              Localization.noInternetDesc.tr,
              style: TextUI.bodyTextBlack,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

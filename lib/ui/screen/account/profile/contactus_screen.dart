import 'package:flutter/material.dart';
import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/constans.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.light(
        title: Localization.labelContactUs.tr,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 70),
        child: Column(
          children: [
            Image.asset(
              Assets.ilustrationChat,
              height: 180.0,
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Localization.contactUsSent.tr + " ",
                  style: TextUI.subtitleBlack,
                ),
                Text(
                  Constans.csPhoneNumber,
                  style: TextUI.subtitleRed,
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              Localization.contactUsIfYouHaveQuestion.tr,
              style: Get.textTheme.bodyText1!.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16.0,
            ),
            MainButton(
              text: Localization.contactUsVia.tr,
              onPressed: () async {
                IntentTo.customerServices();
              },
            )
          ],
        ),
      ),
    );
  }
}

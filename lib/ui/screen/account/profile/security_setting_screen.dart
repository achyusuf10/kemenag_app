import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/ui/screen/account/pin/pin_edit_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/screen/account/profile/profile_screen.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
// import 'package:venturo_mobile/change_phone_number/ui/screens/security_question_insert_form_screen.dart';
// import 'package:venturo_mobile/change_phone_number/ui/screens/security_question_menu_screen.dart';
// import 'package:venturo_mobile/shared_inisa/controllers/security_setting_status_controller.dart';
// import 'package:venturo_mobile/localization/localization_change_email.dart';

class SecuritySettingScreen extends StatelessWidget {
  SecuritySettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // qoin.Get.put(SecuritySettingStatusController());

    List<Widget> listSecuritySettingMenuWidget = [
      SecuritySettingMenuWidget(
        text: Localization.buttonChangePin.tr,
        onTap: () => qoin.Get.to(() => PinEditScreen()),
        icon: Assets.icPin,
      ),
      SecuritySettingMenuWidget(
        text: Localization.loginPhoneNumber.tr,
        onTap: () {},
        icon: Assets.icPhoneSmallPurple,
      ),
      SecuritySettingMenuWidget(
        customWidget: customWidgetChangeEmail(),
        text: '',
        onTap: () {
          // SecuritySettingStatusController.to.changeEmail();
        },
        icon: Assets.icMailSmallOutline,
      ),
      SecuritySettingMenuWidget(
        customWidget: customWidgetSecurityQuestion(),
        text: Localization.securityQuestionSettings.tr,
        onTap: () {},
        icon: Assets.icSecurityQuestionSetting,
      ),
    ];
    return Scaffold(
      appBar: AppBarWidget.light(
        title: Localization.securitySettings.tr,
        elevation: 0.5,
      ),
      backgroundColor: ColorUI.shape,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(16),
              child: Text(
                Localization.labelAccountSettings.tr,
                style: TextUI.bodyText2Grey,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffe8e8e8)),
                color: ColorUI.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) =>
                    listSecuritySettingMenuWidget[index],
                separatorBuilder: (context, index) {
                  if (index == listSecuritySettingMenuWidget.length - 1) {
                    return SizedBox();
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(left: 36.0),
                      child: Divider(
                        thickness: 1,
                        height: 1,
                        color: Color(0xffdedede),
                      ),
                    );
                  }
                },
                itemCount: listSecuritySettingMenuWidget.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customWidgetChangeEmail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: [
            Image.asset(
              Assets.icMailSmallOutline,
              width: 24.0,
            ),
            SizedBox(
              width: 16.0,
            ),
            Text(
              'Alamat Email',
              style: TextUI.subtitleBlack,
            )
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.chevron_right,
            ),
          ],
        ),
      ],
    );
  }

  Widget customWidgetSecurityQuestion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: [
            Image.asset(
              Assets.icSecurityQuestionSetting,
              width: 24.0,
            ),
            SizedBox(
              width: 16.0,
            ),
            Text(
              Localization.securityQuestionSettings.tr,
              style: TextUI.subtitleBlack,
            )
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.chevron_right,
            ),
          ],
        ),
      ],
    );
  }
}

/// Jika menggunakan custom widget, icon, dan text nya tidak diisi juga gpp
class SecuritySettingMenuWidget extends StatelessWidget {
  final String icon;
  final String text;
  final Function() onTap;
  final Widget? customWidget;
  const SecuritySettingMenuWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.customWidget,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: customWidget ??
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Image.asset(
                      icon,
                      width: 24.0,
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      text,
                      style: TextUI.subtitleBlack,
                    )
                  ],
                ),
                Icon(
                  Icons.chevron_right,
                ),
              ],
            ),
      ),
    );
  }
}

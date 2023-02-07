import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:inisa_app/config/inter_module.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/constans.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/ui/screen/account/pin/pin_edit_screen.dart';
import 'package:inisa_app/ui/screen/account/profile/delete_account_screen.dart';
import 'package:inisa_app/ui/screen/account/profile/security_setting_screen.dart';
import 'package:inisa_app/ui/screen/services/widget_menu/controller/menu_services_controller.dart';
import 'package:inisa_app/ui/screen/onboarding/onboarding_screen.dart';
import 'package:inisa_app/ui/screen/webview_screen.dart';
import 'package:inisa_app/ui/widget/profile/pp_widget.dart';
import 'package:qoin_sdk/controllers/controllers_export.dart';
import 'package:qoin_sdk/helpers/services/environment.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:qoin_sdk/models/qoin_accounts/file_upload_result.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:venturo_mobile/shared_inisa/inisa_venturo_methods.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
// import 'package:venturo_mobile/shared_inisa/controllers/subsidi_status_controller.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

import 'contactus_screen.dart';
import 'profile_edit_screen.dart';
import 'qr_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FileUploadResult? pic;

  @override
  void initState() {
    pic = FileUploadResult(
      fileName: "",
      base64Value: AccountsController.instance.userData!.pict,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<MenuData> _accountSettings = [
      MenuData(
        text: Localization.securitySettings.tr,
        onTap: () {
          Get.to(() => SecuritySettingScreen());
        },
        icon: Assets.iconKey,
      ),
      // MenuData(
      //   text: Localization.buttonChangePin.tr,
      //   onTap: () {
      //     Get.to(() => PinEditScreen());
      //   },
      //   icon: Assets.iconKey,
      // ),
      // MenuData(text: "Kartu Saya", onTap: () {}, icon: Assets.iconCard),
      // MenuData(text: "Kode Referal", onTap: () {}, icon: Assets.iconReferal),
      MenuData(
        text: Localization.buttonLanguage.tr,
        onTap: () {},
        icon: Assets.iconLanguage,
      ),
      MenuData(
        text: Localization.buttonDeleteAcc.tr,
        onTap: () async {
          Get.to(() => DeleteAccountScreen());
        },
        icon: Assets.iconDelete,
      ),
      // if (HiveData.userData!.nIKConfirmed == true)
      //   MenuData(
      //     text: Localization.buttonSubsidy.tr,
      //     onTap: () async {
      //       SubsidiStatusController.to.isGoingToSubsidi.value = true;
      //       SubsidiStatusController.to.checkSubsidiStatus();
      //     },
      //     icon: Assets.iconSubsidy,
      //   )
      // MenuData(text: "Voucher", onTap: () {}, icon: Assets.iconSell),
    ];
    List<MenuData> _about = [
      MenuData(
          text: Localization.buttonFaq.tr,
          onTap: () {
            Get.to(() => WebViewScreen(
                  title: Localization.buttonFaq.tr,
                  linkUrl: 'https://www.inisa.id/faq/',
                ));
          },
          icon: Assets.iconFAQ),
      MenuData(
          text: Localization.buttonTermAndCondition.tr,
          onTap: () {
            Get.to(() => WebViewScreen(
                  title: Localization.buttonTermAndCondition.tr,
                  linkUrl: 'https://www.inisa.id/ketentuan-layanan/',
                ));
          },
          icon: Assets.iconDoc),
      MenuData(
          text: Localization.buttonPrivacyPolicy.tr,
          onTap: () {
            Get.to(() => WebViewScreen(
                  title: Localization.buttonPrivacyPolicy.tr,
                  linkUrl: 'https://www.inisa.id/kebijakan-privasi/',
                ));
          },
          icon: Assets.iconPrivacy),
    ];

    Widget profileSection() => Container(
          color: Get.theme.backgroundColor,
          padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(() => ProfileEditScreen());
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: PPWidget(
                          value: pic,
                          onChanged: (val) {},
                          clickable: false,
                        ),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GetBuilder<AccountsController>(
                              builder: (controller) {
                                return Text(
                                  controller.userData?.fullname ??
                                      controller.userData?.phone ??
                                      '-',
                                  style: TextUI.title2Black,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                );
                              },
                            ),
                            Row(
                              children: [
                                Text(
                                  Localization.editProfile.tr,
                                  style: TextUI.bodyTextGrey
                                      .copyWith(color: ColorUI.text_3),
                                ),
                                Icon(
                                  Icons.navigate_next,
                                  color: ColorUI.text_3,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 56,
                child: InkWell(
                    onTap: () {
                      Get.to(() => QRScreen());
                    },
                    child: Image.asset(
                      Assets.qrMini,
                      height: 40,
                    )),
              )
            ],
          ),
        );

    return Scaffold(
      backgroundColor: ColorUI.shape,
      appBar: AppBarWidget.light(
        title: Localization.labelProfile.tr,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              profileSection(),
              titleSection(Localization.labelAccountSettings.tr),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffe8e8e8)),
                  color: Get.theme.backgroundColor,
                ),
                child: Column(
                    children: _accountSettings
                        .map(
                          (menu) => ListTileProfileMenu(
                            text: menu.text ?? "",
                            onTap: menu.onTap,
                            trailing: Icon(Icons.chevron_right),
                            icon: menu.icon!,
                            // withLine: menu.text == Localization.buttonLanguage.tr ? false : true,
                            withLine: menu.text == Localization.buttonSubsidy.tr
                                ? false
                                : true,
                          ),
                        )
                        .toList()),
              ),
              titleSection(Localization.labelAbout.tr),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffe8e8e8)),
                  color: Get.theme.backgroundColor,
                ),
                child: Column(
                    children: _about
                        .map(
                          (menu) => ListTileProfileMenu(
                            text: menu.text ?? "",
                            onTap: menu.onTap,
                            trailing: Icon(Icons.chevron_right),
                            icon: menu.icon!,
                            withLine:
                                menu.text == Localization.buttonPrivacyPolicy.tr
                                    ? false
                                    : true,
                          ),
                        )
                        .toList()),
              ),
              titleSection(Localization.labelContactUs.tr),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffe8e8e8)),
                  color: Get.theme.backgroundColor,
                ),
                child: ListTileProfileMenu(
                  text: Localization.whatsApp.tr,
                  onTap: () {
                    Get.to(() => ContactUsScreen());
                  },
                  trailing: Icon(Icons.chevron_right),
                  icon: Assets.whatsApp,
                  withLine: false,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                child: MainButton(
                  text: Localization.logout.tr,
                  color: Colors.white,
                  textColor: Colors.red,
                  onPressed: () {
                    DialogUtils.showMainPopup(
                        title: Localization.labelLogoutApps.tr,
                        buttonMainFirst: true,
                        description: Localization.areYouSure.tr,
                        secondaryButtonText: Localization.yes.tr,
                        secondaryButtonFunction: () {
                          AccountsController.instance.logout(
                              additionalDataDelete: () {},
                              onboardingScreen: OnboardingScreen());
                        },
                        mainButtonText: Localization.no.tr,
                        mainButtonFunction: () {
                          Navigator.pop(context);
                        },
                        mainPopupButtonDirection:
                            MainPopupButtonDirection.Horizontal);
                  },
                ),
              ),
              Center(
                child: Text(
                  Constans.appVersion,
                  style: TextUI.labelGrey.copyWith(letterSpacing: 0.5),
                ),
              ),
              SizedBox(
                height: 12.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget titleSection(String title) => Container(
        color: ColorUI.shape,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
        child: Text(
          title,
          style: TextUI.bodyTextGrey,
        ),
      );
}

class ListTileProfileMenu extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final Widget? trailing;
  final String icon;
  final bool withLine;

  const ListTileProfileMenu({
    required this.text,
    this.onTap,
    this.trailing,
    required this.icon,
    this.withLine = true,
  });

  @override
  _ListTileProfileMenuState createState() => _ListTileProfileMenuState();
}

class _ListTileProfileMenuState extends State<ListTileProfileMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Stack(
            children: [
              ListTile(
                onTap: (widget.text != Localization.buttonLanguage.tr)
                    ? widget.onTap
                    : null,
                contentPadding: EdgeInsets.zero,
                title: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            widget.icon,
                            width: 24.0,
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          Text(
                            widget.text,
                            style: TextUI.subtitleBlack,
                          )
                        ],
                      ),
                      widget.text != Localization.buttonLanguage.tr
                          ? widget.trailing!
                          : SizedBox()
                    ],
                  ),
                ),
              ),
              if (widget.text == Localization.buttonLanguage.tr)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Container(
                      width: 94.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: Color(0xfff6f6f6),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Get.locale ==
                                        InterModule.translations!.locales[0]
                                    ? ColorUI.secondary
                                    : null,
                                borderRadius: Get.locale ==
                                        InterModule.translations!.locales[0]
                                    ? BorderRadius.all(
                                        Radius.circular(4),
                                      )
                                    : BorderRadius.horizontal(
                                        left: Radius.circular(4),
                                        right: Radius.circular(0),
                                      ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  InterModule.translations!.changeLocale(
                                    InterModule.translations!.langs[0],
                                  );
                                  MenuServicesController.to.updateServices();
                                },
                                child: Center(
                                  child: Text(
                                    InterModule
                                        .translations!.locales[0].languageCode
                                        .toUpperCase(),
                                    style: TextUI.subtitleBlack.copyWith(
                                      color: Get.locale ==
                                              InterModule
                                                  .translations!.locales[0]
                                          ? ColorUI.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Get.locale ==
                                        InterModule.translations!.locales[1]
                                    ? ColorUI.secondary
                                    : null,
                                borderRadius: Get.locale ==
                                        InterModule.translations!.locales[1]
                                    ? BorderRadius.all(Radius.circular(4))
                                    : BorderRadius.horizontal(
                                        left: Radius.circular(0),
                                        right: Radius.circular(4)),
                              ),
                              child: InkWell(
                                onTap: () {
                                  InterModule.translations!.changeLocale(
                                      InterModule.translations!.langs[1]);
                                  MenuServicesController.to.updateServices();
                                },
                                child: Center(
                                  child: Text(
                                      InterModule
                                          .translations!.locales[1].languageCode
                                          .toUpperCase(),
                                      style: TextUI.subtitleBlack.copyWith(
                                        color: Get.locale ==
                                                InterModule
                                                    .translations!.locales[1]
                                            ? Colors.white
                                            : Color(0xff3f4144),
                                      )),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (widget.withLine)
            Padding(
              padding: const EdgeInsets.only(left: 36.0),
              child: Divider(thickness: 1, height: 1, color: Color(0xffdedede)),
            )
        ],
      ),
    );
  }
}

class MenuData {
  final String? text;
  VoidCallback? onTap;
  final String? icon;

  MenuData({required this.text, this.onTap, this.icon});
}

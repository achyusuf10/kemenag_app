import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_design.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/ui/screen/account/pin/pin_screen.dart';
import 'package:inisa_app/ui/screen/account/profile/profile_edit_screen.dart';
import 'package:inisa_app/ui/screen/digital_id/select_id_type_screen.dart';
import 'package:inisa_app/ui/screen/verificationemail_screen.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/button_secondary.dart';
import 'package:lottie/lottie.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:open_mail_app/open_mail_app.dart';

import 'assets.dart';

enum MainPopupButtonDirection { Vertical, Horizontal }

class DialogUtils {
  static Future<dynamic> showGeneralDrawer({
    bool isDismissable = true,
    double radius = 0,
    bool withStrip = false,
    Color? color,
    Widget? content,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  }) async {
    await Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: color != null ? color : Get.theme.backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
            ),
          ),
          padding: padding,
          child: Column(
            children: [
              withStrip
                  ? Column(
                      children: [
                        Container(
                          width: 65.h,
                          height: 5.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(2.5)),
                              color: withStrip ? Color(0xffe8e8e8) : Colors.transparent),
                        ),
                        SizedBox(
                          height: 24.h,
                        )
                      ],
                    )
                  : Container(),
              content != null
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: content,
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
      isDismissible: isDismissable,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  static Future<dynamic> showMainDrawer({
    bool isDismissable = true,
    double radius = 24,
    bool withStrip = false,
    Color? color,
    String? image,
    String? title,
    String? description,
    Widget? content,
    double? imageHeight = 150.0,
  }) async {
    await showGeneralDrawer(
      isDismissable: isDismissable,
      radius: radius,
      withStrip: withStrip,
      color: color,
      content: Column(
        children: [
          image != null
              ? Container(
                  margin: EdgeInsets.only(bottom: 20.h),
                  child: Image.asset(
                    image,
                    height: imageHeight,
                  ))
              : SizedBox(),
          title != null
              ? Text(
                  title,
                  style: TextUI.title2Black,
                  textAlign: TextAlign.center,
                )
              : SizedBox(),
          SizedBox(
            height: 12.h,
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Text(
                description,
                style: TextUI.bodyTextBlack,
                textAlign: TextAlign.center,
              ),
            ),
          content != null ? content : SizedBox(),
        ],
      ),
    );
  }

  static Future<dynamic> showGeneralPopup(
      {double radius = 0,
      Color? color,
      Widget? content,
      bool barrierDismissible = true,
      EdgeInsetsGeometry padding = const EdgeInsets.all(16)}) async {
    await Get.dialog(
        WillPopScope(
          onWillPop: () => Future.value(barrierDismissible),
          child: Center(
            child: SingleChildScrollView(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.all(40),
                  padding: padding,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: color != null ? color : Get.theme.backgroundColor,
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  child: content != null ? content : SizedBox(),
                ),
              ),
            ),
          ),
        ),
        barrierDismissible: barrierDismissible);
  }

  static Future<dynamic> showMainPopup({
    double radius = 8,
    Color? color,
    String? image,
    double? imageSize = 128,
    Widget? imageWidget,
    String? package,
    String? animation,
    String? title,
    String? description,
    String? mainButtonText,
    VoidCallback? mainButtonFunction,
    String? secondaryButtonText,
    VoidCallback? secondaryButtonFunction,
    EdgeInsetsGeometry padding = const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 24),
    MainPopupButtonDirection mainPopupButtonDirection = MainPopupButtonDirection.Vertical,
    bool barrierDismissible = true,
    bool buttonMainFirst = false,
  }) async {
    await showGeneralPopup(
      barrierDismissible: barrierDismissible,
      radius: radius,
      color: color,
      padding: padding,
      content: Column(
        children: [
          image == null && animation == null && imageWidget == null
              ? SizedBox()
              : imageWidget != null
                  ? imageWidget
                  : animation != null
                      ? Lottie.asset(package != null ? 'packages/$package/$animation' : animation,
                          width: 160, repeat: false)
                      : Image.asset(
                          package != null ? 'packages/$package/$image' : image!,
                          height: imageSize,
                        ),
          image == null && animation == null && imageWidget == null
              ? SizedBox()
              : SizedBox(
                  height: 16,
                ),
          title == null
              ? SizedBox()
              : Text(
                  title,
                  style: TextUI.title2Black,
                  textAlign: TextAlign.center,
                ),
          description == null
              ? SizedBox()
              : Padding(
                  padding: EdgeInsets.only(top: 7.h),
                  child: Text(
                    description,
                    style: TextUI.bodyTextBlack,
                    textAlign: TextAlign.center,
                  ),
                ),
          SizedBox(height: 32.0),
          mainPopupButtonDirection == MainPopupButtonDirection.Vertical
              ? Column(
                  children: [
                    mainButtonText == null
                        ? SizedBox()
                        : MainButton(text: (mainButtonText), onPressed: mainButtonFunction),
                    secondaryButtonText == null
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: SecondaryButton(
                                text: (secondaryButtonText), onPressed: secondaryButtonFunction),
                          ),
                  ],
                )
              : buttonMainFirst
                  ? Row(
                      children: [
                        mainButtonText == null
                            ? SizedBox()
                            : Expanded(
                                child: MainButton(
                                  text: (mainButtonText),
                                  onPressed: mainButtonFunction,
                                ),
                              ),
                        if (secondaryButtonText != null && mainButtonText != null)
                          SizedBox(
                            width: 8.0,
                          ),
                        secondaryButtonText == null
                            ? SizedBox()
                            : Expanded(
                                child: SecondaryButton(
                                  text: (secondaryButtonText),
                                  onPressed: secondaryButtonFunction,
                                ),
                              ),
                      ],
                    )
                  : Row(
                      children: [
                        secondaryButtonText == null
                            ? SizedBox()
                            : Expanded(
                                child: SecondaryButton(
                                  text: (secondaryButtonText),
                                  onPressed: secondaryButtonFunction,
                                ),
                              ),
                        if (secondaryButtonText != null && mainButtonText != null)
                          SizedBox(
                            width: 8.0,
                          ),
                        mainButtonText == null
                            ? SizedBox()
                            : Expanded(
                                child: MainButton(
                                  text: (mainButtonText),
                                  onPressed: mainButtonFunction,
                                ),
                              ),
                      ],
                    )
        ],
      ),
    );
  }

  static showVerificationDrawer({
    String? image,
    String? title,
    String? description,
    String? positiveText,
    VoidCallback? onTapPositive,
    String? negativeText,
    double? imageHeight,
    VoidCallback? onTapNegative,
    MainPopupButtonDirection mainPopupButtonDirection = MainPopupButtonDirection.Vertical,
  }) {
    showMainDrawer(
        withStrip: true,
        image: image,
        title: title,
        radius: 24,
        description: description,
        imageHeight: imageHeight,
        content: Column(
          children: [
            //SizedBox(height: 25.0),
            mainPopupButtonDirection == MainPopupButtonDirection.Vertical
                ? Column(
                    children: [
                      positiveText == null
                          ? SizedBox()
                          : MainButton(text: (positiveText), onPressed: onTapPositive),
                      if (negativeText != null && positiveText != null)
                        SizedBox(
                          height: 8.0,
                        ),
                      negativeText == null
                          ? SizedBox()
                          : SecondaryButton(text: (negativeText), onPressed: onTapNegative),
                    ],
                  )
                : Row(
                    children: [
                      negativeText == null
                          ? SizedBox()
                          : Expanded(
                              child: SecondaryButton(
                                text: (negativeText),
                                onPressed: onTapNegative,
                              ),
                            ),
                      if (negativeText != null && positiveText != null)
                        SizedBox(
                          width: 8.0,
                        ),
                      positiveText == null
                          ? SizedBox()
                          : Expanded(
                              child: MainButton(
                                text: (positiveText),
                                onPressed: onTapPositive,
                              ),
                            ),
                    ],
                  )
          ],
        ));
  }

  static showComingSoonDrawer() {
    showMainDrawer(
        withStrip: true,
        image: Assets.icErrorOccured,
        imageHeight: 188.0,
        radius: 24.0,
        title: Localization.underContructionTitle.tr,
        description: Localization.underContructionDesc.tr,
        content: MainButton(
          text: Localization.ok.tr,
          onPressed: () => Get.back(),
        ));
  }

  static showCompleteEmailDrawer() {
    showVerificationDrawer(
        image: Assets.completeProfile,
        imageHeight: 230.0,
        title: Localization.completeEmailTitle.tr,
        description: Localization.completeEmailDesc.tr,
        positiveText: Localization.completeProfileNow.tr,
        onTapPositive: () {
          Get.back();
          Get.to(() => ProfileEditScreen());
        },
        negativeText: Localization.completeProfileLater.tr,
        onTapNegative: () => Get.back(),
        mainPopupButtonDirection: MainPopupButtonDirection.Horizontal);
  }

  static showCompleteProfileDrawer() {
    showVerificationDrawer(
        image: Assets.completeProfile,
        imageHeight: 230.0,
        title: Localization.dialogCompleteProfile.tr,
        description: Localization.dialogCompleteProfileDesc.tr,
        positiveText: Localization.completeProfileNow.tr,
        onTapPositive: () {
          Get.back();
          Get.to(() => ProfileEditScreen());
        },
        negativeText: Localization.completeProfileLater.tr,
        onTapNegative: () => Get.back(),
        mainPopupButtonDirection: MainPopupButtonDirection.Horizontal);
  }

  static showEmailVerificationDrawer() {
    showMainDrawer(
        image: Assets.sendingEmail,
        title: Localization.emailVerificationTitle.tr,
        imageHeight: 192.0,
        content: /* Container() */ VerificationEmailScreen());
  }

  static showUpgradeAccountDrawer() {
    showVerificationDrawer(
        image: Assets.upgradeAccount,
        imageHeight: 210.0,
        title: Localization.letsUpgrade.tr,
        description: Localization.letsUpgradeDesc.tr,
        positiveText: Localization.upgradeNow.tr,
        onTapPositive: () async {
          Get.back();
          // Get.to(() => DetailDigitalDocScreen(data: null));
          Get.to(() => SelectIdTypeScreen());
        },
        negativeText: Localization.completeProfileLater.tr,
        onTapNegative: () => Get.back(),
        mainPopupButtonDirection: MainPopupButtonDirection.Horizontal);
  }

  static showEmailVerificationPopUp({String? title}) {
    return showMainPopup(
      animation: Assets.successAnimation,
      title: title ?? Localization.changeProfileSuccessTitle.tr,
      description: Localization.changeProfileSuccessDesc.tr,
      mainButtonText: Localization.openEmailNow.tr,
      mainButtonFunction: () async {
        Get.back();
        // Android: Will open mail app or show native picker.
        // iOS: Will open mail app if single mail app found.
        var result = await OpenMailApp.openMailApp();

        // If no mail apps found, show error
        if (!result.didOpen && !result.canOpen) {
          Get.rawSnackbar(message: 'no mail apps', backgroundColor: ColorUI.qoinPrimary);

          // iOS: if multiple mail apps found, show dialog to select.
          // There is no native intent/default app system in iOS so
          // you have to do it yourself.
        } else if (!result.didOpen && result.canOpen) {
          Get.dialog(MailAppPickerDialog(
            mailApps: result.options,
          ));
        }
      },
    );
  }

  static showPopUp(
      {required DialogType type,
      String? buttonText,
      VoidCallback? buttonFunction,
      String? description,
      String? title,
      bool barrierDismissible = true}) {
    return showMainPopup(
      image: UIDesign.getDialogImage(type: type),
      animation: UIDesign.getDialogAnimation(type: type),
      title: title ?? UIDesign.getDialogTitle(type: type),
      description: description ?? UIDesign.getDialogDesc(type: type),
      barrierDismissible: barrierDismissible,
      mainButtonText: buttonText ?? UIDesign.getDialogMainButtonText(type: type),
      mainButtonFunction: buttonFunction ??
          () async {
            Get.back();
          },
    );
  }

  static showPopUpSuccess(
      {VoidCallback? buttonOnTap,
      String? desc,
      String? title,
      String? textButton,
      bool barrierDismissible = true}) {
    return showMainPopup(
      animation: Assets.successAnimation,
      title: title ?? Localization.success.tr,
      padding: EdgeInsets.only(left: 32, right: 32, bottom: 24, top: 40),
      description: desc,
      barrierDismissible: barrierDismissible,
      mainButtonText: textButton ?? Localization.ok.tr,
      mainButtonFunction: buttonOnTap ??
          () async {
            Get.back();
          },
    );
  }

  static Future<void> showGuidelinesDialog(
      String? title, String? subtitle, List<String> list, BuildContext? context) async {
    await showGeneralDrawer(
        withStrip: true,
        radius: 24,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "$title",
                      style: TextUI.subtitleBlack,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Center(
                    child: Text(
                      "$subtitle",
                      textAlign: TextAlign.center,
                      style: TextUI.bodyTextBlack,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: list.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            margin: EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xff3f4144)),
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          Flexible(
                            child: Text(
                              list[index],
                              style: TextUI.bodyTextBlack,
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (_, __) => SizedBox(
                      height: 10,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: MainButton(
                          text: Localization.ok.tr,
                          onPressed: () => Get.back(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }

  static showPopUpProblem(
      {VoidCallback? buttonOnTap,
      String? desc,
      String? title,
      String? textButton,
      bool barrierDismissible = true}) {
    return showMainPopup(
      animation: Assets.problemAnimation,
      title: title ?? Localization.success.tr,
      padding: EdgeInsets.only(left: 32, right: 32, bottom: 24),
      description: desc,
      barrierDismissible: barrierDismissible,
      mainButtonText: textButton ?? Localization.ok.tr,
      mainButtonFunction: buttonOnTap ??
          () async {
            Get.back();
          },
    );
  }

  static showPlainDrawer(
      {required String title, required String description, VoidCallback? onTap, String? buttonText}) {
    showMainDrawer(
        title: title,
        description: description,
        content: onTap != null
            ? MainButton(
                text: buttonText ?? Localization.ok.tr,
                onPressed: onTap,
              )
            : null);
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/button_secondary.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

import 'account/profile/profile_edit_screen.dart';

class VerificationEmailScreen extends StatefulWidget {
  @override
  _VerificationEmailScreenState createState() =>
      _VerificationEmailScreenState();
}

class _VerificationEmailScreenState extends State<VerificationEmailScreen> {
  var controller = Get.put(AccountsController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      checkRemaining();
    });
  }

  checkRemaining() {
    if (mounted) {
      if (HiveData.userData!.emailConfirmed!) {
        controller.resumeTimerEmail(isStop: true);
      } else {
        controller.resumeTimerEmail();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  style: TextUI.bodyTextBlack,
                  text: "${Localization.emailVerificationDesc.tr} "),
              TextSpan(
                  style: TextUI.subtitleBlack,
                  text: "${HiveData.userData!.email!}")
            ])),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Divider(
            height: 1,
          ),
        ),
        GetBuilder<AccountsController>(builder: (controller) {
          return Obx(
            () => controller.otpCountdown.value != 0 &&
                    !controller.isMainLoading.value
                ? RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(style: TextUI.bodyTextBlack, text: "${Localization.emailDrawerAskResend.tr} "),
                      TextSpan(
                        style: TextUI.subtitleBlack,
                        text: formatHHMMSS(controller.otpCountdown.value),
                      )
                    ]))
                : RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(style: TextUI.bodyTextBlack, text: "${Localization.emailDrawerAskResend2.tr} "),
                      TextSpan(
                          style: TextUI.subtitleRed
                              .copyWith(decoration: TextDecoration.underline),
                          text: Localization.editProfileVerifEmail.tr,
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () async {
                              // controller.editProfile(
                              //     email: HiveData.userData?.email,
                              //     isResend: true,
                              //     onFinishEdit: (message) {
                              //       var editEmailStatus = message
                              //           .split(", ")
                              //           .last
                              //           .split(": ")
                              //           .last;
                              //       if (editEmailStatus == 'success') {
                              //         DialogUtils.showEmailVerificationPopUp(
                              //             title: Localization
                              //                 .emailDrawerHasBeenSent.tr);
                              //         setState(() {});
                              //       } else {}
                              //     });
                              //
                              //
                              //
                              // await controller.editEmail(onSuccess: () {
                              //   var controllerCounter =
                              //       Get.put(TimerController());
                              //   controllerCounter.init(
                              //       second: OtpUtil.secondDefault);
                              //   HiveData.lastDateResendMail = DateTime.now();
                              //   DialogUtils.showEmailVerificationPopUp(
                              //       title: "Email Sudah Dikirimkan");
                              //   setState(() {});
                              // }, onError: (err) {
                              //   if (err == "You are offline") {
                              //     DialogUtils.showPopUp(
                              //         type: DialogType.noInternet);
                              //     return;
                              //   }
                              //   DialogUtils.showMainPopup(
                              //     image: Assets.failed,
                              //     title: Localization.pinResetFail.tr,
                              //     description:
                              //         "Gagal Mengirim Email Verifikasi",
                              //     secondaryButtonText: 'Tutup',
                              //     secondaryButtonFunction: () {
                              //       Get.back();
                              //     },
                              //   );
                              // });
                            }),
                      TextSpan(
                          style: TextUI.bodyTextBlack,
                          text: " ${Localization.or.tr} "),
                      TextSpan(
                          style: TextUI.subtitleRed
                              .copyWith(decoration: TextDecoration.underline),
                          text: Localization.emailDrawerChangeEmail.tr,
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () async {
                              Get.back();
                              Get.to(() => ProfileEditScreen());
                            }),
                    ])),
          );
        }),
        SizedBox(
          height: 24,
        ),
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                text: Localization.completeProfileLater.tr,
                onPressed: () => Get.back(),
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: MainButton(
                text: Localization.emailVerificationNow.tr,
                onPressed: () async {
                  Get.back();
                  // QoinWidgets.reqResendMail();
                  // Android: Will open mail app or show native picker.
                  // iOS: Will open mail app if single mail app found.
                  var result = await OpenMailApp.openMailApp();

                  // If no mail apps found, show error
                  if (!result.didOpen && !result.canOpen) {
                    Get.rawSnackbar(
                        message: 'no mail apps',
                        backgroundColor: ColorUI.qoinPrimary);

                    // iOS: if multiple mail apps found, show dialog to select.
                    // There is no native intent/default app system in iOS so
                    // you have to do it yourself.
                  } else if (!result.didOpen && result.canOpen) {
                    Get.dialog(MailAppPickerDialog(
                      mailApps: result.options,
                    ));
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}

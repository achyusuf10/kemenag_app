import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_design.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/logic/controller/ocr_bindings.dart';
import 'package:inisa_app/ui/screen/webview_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/digital_id/step_wizard_widget.dart';
import 'package:get/get.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

import 'digitalid_component.dart';
import 'ocr_screen.dart';

class OCRGuideScreen extends StatelessWidget {
  final checked = false.obs;
  var cardType;

  @override
  Widget build(BuildContext context) {
    cardType = DigitalIdComponent.getCardType(
        qoin.DigitalIdController.instance.data.cardType ?? 0);
    List<String> _noteInstruction = [
      "${DigitalIdLocalization.ocrGuide1Part1.tr} $cardType ${DigitalIdLocalization.ocrGuide1Part2.tr}",
      "${DigitalIdLocalization.ocrGuide2Part1.tr} $cardType ${DigitalIdLocalization.ocrGuide2Part2.tr}",
      "${DigitalIdLocalization.ocrGuide3Part1.tr} $cardType ${DigitalIdLocalization.ocrGuide3Part2.tr}",
    ];

    return Scaffold(
      appBar: AppBarWidget.light(
        title: DigitalIdLocalization.titleIdConfirmation.tr,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: StepWizardWidget(
                    active: true,
                    title: qoin.DigitalIdController.instance.data.cardType ==
                            qoin.CardCode.ktpCardType
                        ? DigitalIdLocalization.headerWizardKTPPhoto.tr
                        : qoin.DigitalIdController.instance.data.cardType ==
                                qoin.CardCode.simCardType
                            ? DigitalIdLocalization.headerWizardSIMPhoto.tr
                            : qoin.DigitalIdController.instance.data.cardType ==
                                    qoin.CardCode.passportCardType
                                ? DigitalIdLocalization
                                    .headerWizardPassportPhoto.tr
                                : DigitalIdLocalization.headerWizardG20Photo.tr,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: StepWizardWidget(
                    active: false,
                    title:
                        DigitalIdLocalization.headerWizardDataConfirmation.tr,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  flex: 1,
                  child: StepWizardWidget(
                    active: false,
                    title:
                        DigitalIdLocalization.headerWizardDataVerification.tr,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40.w),
            Image.asset(
              qoin.DigitalIdController.instance.data.cardType ==
                      qoin.CardCode.ktpCardType
                  ? Assets.sampleCaptureKTP
                  : qoin.DigitalIdController.instance.data.cardType ==
                          qoin.CardCode.simCardType
                      ? Assets.sampleCaptureSIM
                      : qoin.DigitalIdController.instance.data.cardType ==
                              qoin.CardCode.passportCardType
                          ? Assets.sampleCapturePassport
                          : Assets.sampleCaptureG20,
              width: 196.w,
            ),
            SizedBox(height: 24.w),
            Text(
              '${DigitalIdLocalization.verificationGuideButtonTakePhoto.tr} $cardType',
              style: TextUI.subtitleBlack,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.w),
            Text(
              "${DigitalIdLocalization.ocrDesclaimer1.tr} $cardType ${DigitalIdLocalization.ocrDesclaimer2.tr}",
              style: TextUI.bodyTextBlack,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.w),
            GestureDetector(
              onTap: () {
                DialogUtils.showGuidelinesDialog(
                  qoin.DigitalIdController.instance.data.cardType ==
                          qoin.CardCode.ktpCardType
                      ? DigitalIdLocalization.verificationGuideETKPGuide.tr
                      : qoin.DigitalIdController.instance.data.cardType ==
                              qoin.CardCode.simCardType
                          ? DigitalIdLocalization.verificationGuideSIMGuide.tr
                          : qoin.DigitalIdController.instance.data.cardType ==
                                  qoin.CardCode.passportCardType
                              ? DigitalIdLocalization
                                  .verificationGuidePassportGuide.tr
                              : DigitalIdLocalization
                                  .verificationGuideG20Guide.tr,
                  DigitalIdLocalization.ocrTip.tr,
                  _noteInstruction,
                  context,
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DigitalIdLocalization.showGuide.tr,
                    style: TextUI.subtitleRed,
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: ColorUI.secondary,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.w),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: UIDesign.bottomButton,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(Get.width * 0.05),
              child: Row(
                children: [
                  Obx(
                    () => Checkbox(
                        value: checked.value,
                        checkColor: Colors.white,
                        activeColor: ColorUI.secondary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity(
                          vertical: -4,
                          horizontal: -4,
                        ),
                        onChanged: (value) async {
                          if (checked.value == false) {
                            checked.value = true;
                          } else {
                            checked.value = false;
                          }
                        }),
                  ),
                  SizedBox(width: Get.width * 0.05),
                  Flexible(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: DigitalIdLocalization
                                .verificationGuideDetailText.tr,
                          ),
                          TextSpan(
                            text: " ${Localization.buttonTermAndCondition.tr} ",
                            style: TextUI.bodyText2Yellow
                                .copyWith(fontWeight: FontWeight.bold),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                qoin.Get.to(() => WebViewScreen(
                                      linkUrl:
                                          'https://www.inisa.id/ketentuan-layanan/',
                                      title: Localization
                                          .buttonTermAndCondition.tr,
                                    ));
                              },
                          ),
                          TextSpan(
                            text: "${Localization.and.tr} ",
                          ),
                          TextSpan(
                            text: Localization.buttonPrivacyPolicy.tr,
                            style: TextUI.bodyText2Yellow
                                .copyWith(fontWeight: FontWeight.bold),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                qoin.Get.to(() => WebViewScreen(
                                      linkUrl:
                                          'https://www.inisa.id/kebijakan-privasi/',
                                      title:
                                          Localization.buttonPrivacyPolicy.tr,
                                    ));
                              },
                          ),
                          TextSpan(
                            text: " INISA.",
                          ),
                        ],
                      ),
                      style: TextUI.bodyText2Black,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Obx(
                () => MainButton(
                  text: DigitalIdLocalization.verificationGuideTitle.tr,
                  onPressed: checked.value
                      ? () {
                          Get.to(() => OCRScreen(), binding: OcrBindings());
                        }
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:face_sdk/face_sdk.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/digital_id/step_wizard_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

import 'qoin_liveness_screen.dart';

class VerificationGuideScreen extends StatelessWidget {
  final LivenessType livenessType;

  const VerificationGuideScreen({Key? key, this.livenessType = LivenessType.KTP}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> _noteInstruction = [
      DigitalIdLocalization.verificationGuideInstructionList1.tr,
      DigitalIdLocalization.verificationGuideInstructionList2.tr,
      DigitalIdLocalization.verificationGuideInstructionList3.tr,
      DigitalIdLocalization.verificationGuideInstructionList4.tr
    ];

    return Scaffold(
      appBar: AppBarWidget.light(
        title: DigitalIdLocalization.titleFaceVerification.tr,
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
                SizedBox(width: 10.w),
                Expanded(
                  flex: 1,
                  child: StepWizardWidget(
                    active: true,
                    title: DigitalIdLocalization.headerWizardDataConfirmation.tr,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  flex: 1,
                  child: StepWizardWidget(
                    active: true,
                    title: DigitalIdLocalization.headerWizardDataVerification.tr,
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
              Assets.sampleLiveness,
              width: 196.w,
            ),
            SizedBox(height: 24.w),
            Text(
              DigitalIdLocalization.headerWizardDataVerification.tr,
              style: TextUI.subtitleBlack,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.w),
            Text(
              DigitalIdLocalization.verificationGuideDesc.tr,
              style: TextUI.bodyTextBlack,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.w),
            GestureDetector(
              onTap: () => DialogUtils.showGuidelinesDialog(
                  DigitalIdLocalization.verificationFaceGuideTitle.tr,
                  DigitalIdLocalization.verificationFaceGuideDesc.tr,
                  _noteInstruction,
                  context),
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x80cacccf),
              offset: Offset(0, -1),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
          color: Colors.white,
        ),
        child: MainButton(
          text: DigitalIdLocalization.verificationGuideButtonTakePhoto.tr,
          onPressed: () async {
            ///
            FaceSDK.showLiveness(
              motionCount: 1,
              onSuccess: (res) {
                debugPrint("liveness success: $res");
                qoin.Get.to(() => QoinLivenessScreen(
                      livenessImage: res,
                      livenessType: livenessType,
                    ));
              },
              onFailed: (error) {
                debugPrint("liveness error: $error");
                var message;
                if (error == 'Face Lost') {
                  message = DigitalIdLocalization.faceLost.tr;
                } else if (error == 'Wrong movement') {
                  message = DigitalIdLocalization.faceWrongMovement.tr;
                } else {
                  message = error;
                }
                DialogUtils.showPopUp(
                    type: DialogType.problem, description: message);
              },
            );
          },
        ),
      ),
    );
  }
}

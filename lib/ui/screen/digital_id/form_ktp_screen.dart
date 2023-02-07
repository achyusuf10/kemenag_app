import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/regex_rule.dart';
import 'package:inisa_app/helper/ui_design.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/logic/controller/liveness_bindings.dart';
import 'package:inisa_app/ui/screen/digital_id/camera_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/digital_id/date_picker_field.dart';
import 'package:inisa_app/ui/widget/digital_id/labeled_radio_widget.dart';
import 'package:inisa_app/ui/widget/digital_id/step_wizard_widget.dart';
import 'package:inisa_app/ui/widget/main_textfield.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

import 'verification_guide_screen.dart';

class FormKTPScreen extends StatelessWidget {
  FormKTPScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBarWidget.light(
          title: DigitalIdLocalization.idTypeTitle.tr,
          onBack: () {
            Get.back();
          },
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: StepWizardWidget(
                      active: true,
                      title: DigitalIdLocalization.headerWizardKTPPhoto.tr,
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
                      active: false,
                      title: DigitalIdLocalization.headerWizardDataVerification.tr,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.05,
            vertical: 10,
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  DigitalIdLocalization.fKTPFillData.tr,
                  style: TextUI.subtitleBlack,
                ),
                SizedBox(height: 4.h),
                Text(
                  DigitalIdLocalization.fKTPFillDataDesc.tr,
                  style: TextUI.bodyTextBlack,
                ),
                SizedBox(height: 24.h),
                MainTextField(
                  initialValue: qoin.DigitalIdController.instance.data.nIK ?? "",
                  onChange: (val) async {
                    qoin.DigitalIdController.instance.docNo = val;
                    qoin.DigitalIdController.instance.editNik(val);
                  },
                  labelText: DigitalIdLocalization.fSIMNIK.tr,
                  hintText: DigitalIdLocalization.fSIMNIKHint.tr,
                  textInputType: TextInputType.number,
                  maxLength: 16,
                  validation: [
                    RegexRule.emptyValidationRule,
                    RegexRule.nikValidationRule,
                    RegexRule.numberValidationRule,
                  ],
                  onAction: TextInputAction.next,
                ),
                SizedBox(height: 20.h),
                MainTextField(
                  initialValue: qoin.DigitalIdController.instance.data.name ?? "",
                  onChange: (val) {
                    qoin.DigitalIdController.instance.name = val;
                  },
                  labelText: DigitalIdLocalization.fKTPNameLabel.tr,
                  hintText: DigitalIdLocalization.fKTPNameHint.tr,
                  textInputType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  validation: [RegexRule.emptyValidationRule],
                  onAction: TextInputAction.next,
                ),
                SizedBox(height: 20.h),
                qoin.GetBuilder<qoin.DigitalIdController>(builder: (controller) {
                  return DatePickerField(
                    dateFormat: 'dd-MM-yyyy',
                    labelText: DigitalIdLocalization.formKTPDateOfBirth.tr,
                    minTime: DateTime.tryParse("1940-01-01"),
                    maxTime: DateTime.now(),
                    errorText: controller.validateBirthDate.value == false
                        ? null
                        : controller.data.doB == null
                            ? DigitalIdLocalization.messageRequired.tr
                            : controller.difference.value < 6209
                                ? DigitalIdLocalization.messageAgeValidation.tr
                                : DigitalIdLocalization.messageRequired.tr,
                    hintText: DigitalIdLocalization.fSIMDoBHint.tr,
                    onPicked: (date) async {
                      print("date: $date");
                      if (date != null) {
                        debugPrint("date: $date");
                        controller.dob = date.toFormatsString(format: 'yyyy-MM-dd');
                      }
                      //  else {
                      //   controller.dob = null;
                      // }
                      controller.dobValidate();
                      controller.update();
                      _formKey.currentState!.validate();
                    },
                    initialValue: controller.data.doB != null ? DateTime.tryParse(controller.data.doB!) : null,
                  );
                }),
                SizedBox(height: 20.h),
                Text(DigitalIdLocalization.detailDigitalDocGender.tr),
                qoin.GetBuilder<qoin.DigitalIdController>(builder: (controller) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: LabeledRadio<String>(
                          value: describeEnum(GenderType.male),
                          groupValue: (controller.data.gender ?? "male").toLowerCase(),
                          title:
                              Text(DigitalIdLocalization.fKTPMale.tr, style: TextUI.bodyTextBlack),
                          onChanged: (String? val) {
                            controller.gender = val;
                          },
                          activeColor: Color(0xff111111),
                          contentPadding: EdgeInsets.zero,
                          toggleable: true,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: LabeledRadio<String>(
                          value: describeEnum(GenderType.female),
                          groupValue: (controller.data.gender ?? "male").toLowerCase(),
                          title: Text(DigitalIdLocalization.fKTPFemale.tr,
                              style: TextUI.bodyTextBlack),
                          onChanged: (String? val) {
                            controller.gender = val;
                          },
                          activeColor: Color(0xff111111),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  );
                }),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.all(16),
          decoration: UIDesign.bottomButton,
          child: MainButton(
              height: 50,
              text: Localization.buttonContinue.tr,
              onPressed: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                qoin.DigitalIdController.instance.dobValidate();
                var isValid = _formKey.currentState!.validate();
                if (isValid == false ||
                    qoin.DigitalIdController.instance.validateBirthDate.value == true) {
                  DialogUtils.showPopUp(
                      type: DialogType.problem,
                      title: DigitalIdLocalization.fKTPCompleteAll.tr,
                      description: DigitalIdLocalization.fKTPCompleteAllDesc.tr,
                      buttonText: Localization.recheck.tr);
                  return;
                }

                if (qoin.AccountsController.instance.userData?.nIK != null && qoin.AccountsController.instance.userData?.nIK != '') {
                  if (qoin.AccountsController.instance.userData!.nIK != qoin.DigitalIdController.instance.data.nIK) {
                    DialogUtils.showMainPopup(
                      animation: Assets.problemAnimation,
                      title: DigitalIdLocalization.fKTPNIKNotMatch.tr,
                      description: DigitalIdLocalization.fKTPNIKNotMatchDesc.tr,
                      mainButtonText: Localization.recheck.tr,
                      color: Colors.white,
                      mainButtonFunction: () {
                        Get.back();
                      },
                    );
                  } else {
                    if (qoin.DigitalIdController.instance.data.cardType == qoin.CardCode.ktpCardType) {
                      Get.to(() => VerificationGuideScreen(), binding: LivenessBindings());
                    } else {
                      Get.to(() => CameraScreen(
                            frameType: FrameType.PasPhoto,
                          ));
                    }
                  }
                } else {
                  if (qoin.DigitalIdController.instance.data.cardType == qoin.CardCode.ktpCardType) {
                    Get.to(() => VerificationGuideScreen(), binding: LivenessBindings());
                  } else {
                    Get.to(() => CameraScreen(
                          frameType: FrameType.PasPhoto,
                        ));
                  }
                }
              }),
        ),
      ),
    );
  }
}

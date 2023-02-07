import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inisa_app/helper/constans.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/regex_rule.dart';
import 'package:inisa_app/helper/ui_design.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/logic/controller/liveness_bindings.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/digital_id/step_wizard_widget.dart';
import 'package:inisa_app/ui/widget/main_textfield.dart';
import 'package:inisa_app/ui/widget/more_field.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

import 'verification_guide_screen.dart';

class FormG20Screen extends StatelessWidget {
  FormG20Screen({Key? key}) : super(key: key);

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
                      title: DigitalIdLocalization.headerWizardG20Photo.tr,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    flex: 1,
                    child: StepWizardWidget(
                      active: true,
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
                  DigitalIdLocalization.fG20FillDataDesc.tr,
                  style: TextUI.bodyTextBlack,
                ),
                SizedBox(height: 24.h),
                MainTextField(
                  onChange: (val) async {
                    qoin.DigitalIdController.instance.docNo = val;
                  },
                  labelText: 'Nomor Kartu G20',
                  hintText: 'Nomor Kartu G20',
                  textInputType: TextInputType.text,
                  maxLength: 20,
                  validation: [
                    RegexRule.emptyValidationRule,
                  ],
                  onAction: TextInputAction.next,
                ),
                SizedBox(height: 20.h),
                MainTextField(
                  initialValue:
                      qoin.DigitalIdController.instance.data.name ?? '',
                  onChange: (val) {
                    qoin.DigitalIdController.instance.data.name = val!;
                  },
                  labelText: DigitalIdLocalization.fSIMFullname.tr,
                  hintText: DigitalIdLocalization.fSIMFullname.tr,
                  textInputType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  validation: [RegexRule.emptyValidationRule],
                  onAction: TextInputAction.next,
                ),
                SizedBox(height: 20.h),
                qoin.DigitalIdController.instance.data.nationality != null
                    ? MoreField(
                        labelText: 'Negara',
                        hint: Text(
                          'Negara',
                          style: TextUI.placeHolderBlack,
                        ),
                        value:
                            qoin.DigitalIdController.instance.data.nationality,
                        validator: (val) {
                          if (val == null) {
                            return DigitalIdLocalization.messageRequired.tr;
                          }
                          return null;
                        },
                        items: qoin.DigitalIdController.g20countries
                            .map((e) => DropdownMenuItem(
                                  child: Text(
                                    e,
                                    style: TextUI.bodyTextBlack,
                                  ),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          print('NEGARA val: $val');
                          if (val != null) {
                            qoin.DigitalIdController.instance.nationality =
                                val.toString();
                          }
                        },
                      )
                    : MoreField(
                        labelText: 'Negara',
                        hint: Text(
                          'Negara',
                          style: TextUI.placeHolderBlack,
                        ),
                        validator: (val) {
                          if (val == null) {
                            return DigitalIdLocalization.messageRequired.tr;
                          }
                          return null;
                        },
                        items: qoin.DigitalIdController.g20countries
                            .map((e) => DropdownMenuItem(
                                  child: Text(
                                    e,
                                    style: TextUI.bodyTextBlack,
                                  ),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          print('NEGARA val: $val');
                          if (val != null) {
                            qoin.DigitalIdController.instance.nationality =
                                val.toString();
                          }
                        },
                      ),
                // MoreField(
                //   labelText: 'Negara',
                //   hint: Text(
                //     'Negara',
                //     style: TextUI.placeHolderBlack,
                //   ),
                //   validator: (val) {
                //     if (val == null) {
                //       return DigitalIdLocalization.messageRequired.tr;
                //     }
                //     return null;
                //   },
                //   items: qoin.DigitalIdController.g20countries
                //       .map((e) => DropdownMenuItem(
                //             child: Text(
                //               e,
                //               style: TextUI.bodyTextBlack,
                //             ),
                //             value: e,
                //           ))
                //       .toList(),
                //   onChanged: (val) {
                //     print('NEGARA val: $val');
                //     if (val != null) {
                //       qoin.DigitalIdController.instance.nationality =
                //           val.toString();
                //     }
                //   },
                // ),
                SizedBox(height: 20.h),
                MainTextField(
                  initialValue:
                      qoin.DigitalIdController.instance.data.position ?? "",
                  onChange: (val) {
                    qoin.DigitalIdController.instance.position = val;
                  },
                  labelText: "Posisi",
                  hintText: "Posisi",
                  textInputType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  validation: [RegexRule.emptyValidationRule],
                  onAction: TextInputAction.next,
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
            padding: EdgeInsets.all(16),
            decoration: UIDesign.bottomButton,
            child: GetBuilder<qoin.DigitalIdController>(builder: (controller) {
              return MainButton(
                  height: 50,
                  text: Localization.buttonContinue.tr,
                  onPressed: qoin.DigitalIdController.instance.data.name !=
                              null &&
                          qoin.DigitalIdController.instance.data.nationality !=
                              null &&
                          qoin.DigitalIdController.instance.data.position !=
                              null &&
                          qoin.DigitalIdController.instance.data.docNo != null
                      ? () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          var isValid = _formKey.currentState!.validate();
                          if (isValid == false) {
                            DialogUtils.showPopUp(
                                type: DialogType.problem,
                                title: DigitalIdLocalization.fKTPCompleteAll.tr,
                                description: DigitalIdLocalization
                                    .fKTPCompleteAllDesc.tr,
                                buttonText: Localization.recheck.tr);
                            return;
                          }
                          Get.to(() => VerificationGuideScreen(),
                              binding: LivenessBindings());
                        }
                      : null);
            })),
      ),
    );
  }
}

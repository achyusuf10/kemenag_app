import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/regex_rule.dart';
import 'package:inisa_app/helper/ui_design.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/button_secondary.dart';
import 'package:inisa_app/ui/widget/digital_id/date_picker_field.dart';
import 'package:inisa_app/ui/widget/digital_id/step_wizard_widget.dart';
import 'package:inisa_app/ui/widget/main_textfield.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:inisa_app/ui/widget/more_field.dart';
import 'package:qoin_sdk/bindings/liveness_bidings.dart';
import 'package:qoin_sdk/controllers/qoin_digitalid/digitalid_controller.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

import 'qoin_liveness_screen.dart';
import 'verification_guide_screen.dart';

class FormPassportScreen extends StatefulWidget {
  const FormPassportScreen({Key? key}) : super(key: key);

  @override
  _FormPassportScreenState createState() => _FormPassportScreenState();
}

class _FormPassportScreenState extends State<FormPassportScreen> {
  var _formKey = GlobalKey<FormState>();
  qoin.RxBool loadingStatus = false.obs;

  @override
  void initState() {
    super.initState();
    qoin.DigitalIdController.instance.nik =
        (qoin.DigitalIdController.instance.data.nationalityCode == "IDN") ? qoin.HiveData.userData?.nIK : "";
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: loadingStatus.stream,
      child: Scaffold(
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
                      title: DigitalIdLocalization.headerWizardPassportPhoto.tr,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    flex: 1,
                    child: StepWizardWidget(
                      active: true,
                      title: "${DigitalIdLocalization.headerWizardDataConfirmation.tr}",
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    flex: 1,
                    child: StepWizardWidget(
                      active: false,
                      title: "${DigitalIdLocalization.headerWizardDataVerification.tr}",
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    DigitalIdLocalization.fPasProfileConfirmationTitle.tr,
                    style: TextUI.subtitleBlack,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    DigitalIdLocalization.fPasProfileConfirmationDesc.tr,
                    style: TextUI.bodyTextBlack,
                  ),
                  SizedBox(height: 20.h),
                  MoreField(
                    labelText: DigitalIdLocalization.detailDigitalDocNationality.tr,
                    hint: Text(
                      DigitalIdLocalization.fPasNationalityHint.tr,
                      style: TextUI.bodyText2Grey,
                    ),
                    value: qoin.DigitalIdController.instance.data.nationality,
                    validator: (val) {
                      if (val == null) {
                        return DigitalIdLocalization.messageRequired.tr;
                      }
                      return null;
                    },
                    items: ['WNI', 'WNA']
                        .map((e) => DropdownMenuItem(
                              child: Text(
                                e,
                                style: TextUI.bodyTextBlack,
                              ),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (val) {
                      DigitalIdController.instance.nationality = val.toString();
                    },
                  ),
                  SizedBox(height: 20.h),
                  qoin.GetBuilder<qoin.DigitalIdController>(builder: (controller) {
                    return (controller.data.nationality == "WNI")
                        ? MainTextField(
                            labelText: DigitalIdLocalization.fSIMNIK.tr,
                            initialValue: controller.data.nIK,
                            onChange: (val) {
                              controller.nik = val;
                            },
                            hintText: DigitalIdLocalization.fSIMNIKHint.tr,
                            validation: [
                              RegexRule.emptyValidationRule,
                              RegexRule.nikValidationRule,
                              RegexRule.numberValidationRule
                            ],
                            onAction: TextInputAction.next,
                            enabled: true,
                            maxLines: 1,
                            maxLength: 16,
                          )
                        : SizedBox();
                  }),
                  SizedBox(height: 20.h),
                  MainTextField(
                    initialValue: DigitalIdController.instance.data.docNo,
                    onChange: (val) {
                      DigitalIdController.instance.docNo = val;
                    },
                    labelText: DigitalIdLocalization.fPasNumber.tr,
                    hintText: DigitalIdLocalization.fPasNumberHint.tr,
                    validation: [
                      RegexRule.emptyValidationRule,
                    ],
                    onAction: TextInputAction.next,
                    maxLines: 1,
                    textInputType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                  ),
                  SizedBox(height: 20.h),
                  MoreField(
                    labelText: DigitalIdLocalization.fPasType.tr,
                    hint: Text(
                      DigitalIdLocalization.fPasTypeHint.tr,
                      style: TextUI.labelBlack,
                    ),
                    value: DigitalIdController.instance.data.passportType,
                    validator: (val) {
                      if (val == null) {
                        return DigitalIdLocalization.messageRequired.tr;
                      }
                      return null;
                    },
                    items: DigitalIdController.instance.passportTypes
                        .map((e) => DropdownMenuItem(
                              child: Text(
                                e['label']!,
                                style: TextUI.bodyTextBlack,
                              ),
                              value: e['value']!,
                            ))
                        .toList(),
                    onChanged: (val) {
                      DigitalIdController.instance.passportTypeCode = val.toString();
                    },
                  ),
                  SizedBox(height: 20),
                  qoin.GetBuilder<qoin.DigitalIdController>(builder: (controller) {
                    return MainTextField(
                      initialValue: controller.data.nationalityCode,
                      onChange: (val) {
                        controller.nationalityCode = val;
                      },
                      labelText: DigitalIdLocalization.fPasCountryCode.tr,
                      hintText: DigitalIdLocalization.fPasCountryCodeHint.tr,
                      validation: [
                        RegexRule.emptyValidationRule,
                      ],
                      onAction: TextInputAction.next,
                      maxLines: 1,
                      textInputType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                    );
                  }),
                  SizedBox(height: 20.h),
                  MainTextField(
                    initialValue: DigitalIdController.instance.data.name,
                    onChange: (val) {
                      DigitalIdController.instance.name = val;
                    },
                    labelText: DigitalIdLocalization.fSIMFullname.tr,
                    hintText: DigitalIdLocalization.fSIMFullnameHint.tr,
                    validation: [
                      RegexRule.emptyValidationRule,
                    ],
                    onAction: TextInputAction.next,
                    maxLines: 1,
                    textInputType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                  ),
                  SizedBox(height: 20.h),
                  MainTextField(
                    initialValue: DigitalIdController.instance.data.poB,
                    onChange: (val) {
                      DigitalIdController.instance.pob = val;
                    },
                    labelText: DigitalIdLocalization.formKTPBirthPlace.tr,
                    hintText: DigitalIdLocalization.fSIMPoBHint.tr,
                    validation: [
                      RegexRule.emptyValidationRule,
                    ],
                    onAction: TextInputAction.next,
                    maxLines: 1,
                    textInputType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                  ),
                  SizedBox(height: 20.h),
                  DatePickerField(
                    dateFormat: 'yyyy-MM-dd',
                    labelText: DigitalIdLocalization.formKTPDateOfBirth.tr,
                    minTime: DateTime.tryParse("1940-01-01"),
                    maxTime: DateTime.now(),
                    hintText: DigitalIdLocalization.fSIMDoBHint.tr,
                    onPicked: (date) async {
                      DigitalIdController.instance.dob = date.toString();
                    },
                    initialValue: DigitalIdController.instance.data.doB != null
                        ? DateTime.tryParse(DigitalIdController.instance.data.doB!)
                        : null,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    DigitalIdLocalization.formKTPGender.tr,
                    style: TextUI.labelBlack,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        qoin.GetBuilder<qoin.DigitalIdController>(builder: (controller) {
                          return Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Radio(
                                      value: describeEnum(GenderType.male),
                                      groupValue: controller.data.gender,
                                      onChanged: (String? val) {
                                        controller.gender = val!;
                                      },
                                      activeColor: Color(0xff111111),
                                    ),
                                    Text(DigitalIdLocalization.male.tr, style: TextUI.bodyTextBlack)
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Radio(
                                      value: describeEnum(GenderType.female),
                                      groupValue: controller.data.gender,
                                      onChanged: (String? val) {
                                        controller.gender = val!;
                                      },
                                      activeColor: Color(0xff111111),
                                    ),
                                    Text(DigitalIdLocalization.female.tr, style: TextUI.bodyTextBlack)
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                        SizedBox(height: 20.h),
                        DatePickerField(
                          dateFormat: 'yyyy-MM-dd',
                          labelText: DigitalIdLocalization.fPasDateIssuer.tr,
                          hintText: DigitalIdLocalization.fPasDateIssuerHint.tr,
                          onPicked: (date) async {
                            DigitalIdController.instance.issuerDate = date.toString();
                          },
                          initialValue: DigitalIdController.instance.data.issuerDate != null
                              ? DateTime.tryParse(DigitalIdController.instance.data.issuerDate!)
                              : null,
                        ),
                        SizedBox(height: 20.h),
                        DatePickerField(
                          dateFormat: 'yyyy-MM-dd',
                          labelText: DigitalIdLocalization.fPasDateValidityEnd.tr,
                          hintText: DigitalIdLocalization.fPasDateValidityEndHint.tr,
                          onPicked: (date) async {
                            DigitalIdController.instance.expired = date.toString();
                          },
                          initialValue: DigitalIdController.instance.data.expired != null
                              ? DateTime.tryParse(DigitalIdController.instance.data.expired!)
                              : null,
                        ),
                        SizedBox(height: 20.h),
                        if (qoin.DigitalIdController.instance.data.nationalityCode == "IDN")
                          MainTextField(
                            initialValue: DigitalIdController.instance.data.registerNo,
                            onChange: (val) {
                              DigitalIdController.instance.registerNo = val;
                            },
                            labelText: DigitalIdLocalization.fPasRegisterNumber.tr,
                            hintText: DigitalIdLocalization.fPasRegisterNumberHint.tr,
                            validation: [
                              RegexRule.emptyValidationRule,
                            ],
                            onAction: TextInputAction.next,
                            maxLines: 1,
                            textInputType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
                          ),
                        SizedBox(height: 20),
                        MainTextField(
                          initialValue: DigitalIdController.instance.data.issuer,
                          onChange: (val) {
                            DigitalIdController.instance.issuer = val;
                          },
                          labelText: DigitalIdLocalization.fSIMIssuer.tr,
                          hintText: DigitalIdLocalization.fSIMIssuerHint.tr,
                          validation: [
                            RegexRule.emptyValidationRule,
                          ],
                          onAction: TextInputAction.next,
                          maxLines: 1,
                          textInputType: TextInputType.text,
                          textCapitalization: TextCapitalization.characters,
                        ),
                        SizedBox(height: 100.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.all(16),
          decoration: UIDesign.bottomButton,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: SecondaryButton(
                  text: DigitalIdLocalization.faceVerificationReshot.tr,
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DialogUtils.showVerificationDrawer(
                        title: DigitalIdLocalization.fSIMRetakeWarningTitle.tr,
                        description: DigitalIdLocalization.fSIMRetakeWarningDesc.tr,
                        positiveText: Localization.no.tr,
                        onTapPositive: () {
                          qoin.Get.back();
                        },
                        negativeText: Localization.yes.tr,
                        onTapNegative: () {
                          qoin.Get.back();
                          qoin.Get.back();
                        },
                        mainPopupButtonDirection: MainPopupButtonDirection.Horizontal);
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: MainButton(
                  text: Localization.buttonContinue.tr,
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    var issuerDate = DigitalIdController.instance.data.issuerDate != null
                        ? DateTime.tryParse(DigitalIdController.instance.data.issuerDate!)
                        : null;
                    var expiredDate = DigitalIdController.instance.data.expired != null
                        ? DateTime.tryParse(DigitalIdController.instance.data.expired!)
                        : null;
                    var dob = DigitalIdController.instance.data.doB != null
                        ? DateTime.tryParse(DigitalIdController.instance.data.doB!)
                        : null;

                    debugPrint("validate: ${_formKey.currentState!.validate()}");

                    var isValidate = _formKey.currentState!.validate();
                    if (isValidate &&
                        dob != null &&
                        DigitalIdController.instance.data.gender != null &&
                        expiredDate != null &&
                        issuerDate != null) {
                      DialogUtils.showPlainDrawer(
                          title: DigitalIdLocalization.fPasDataReminderTitle.tr,
                          description: DigitalIdLocalization.fPasDataReminderDesc.tr,
                          onTap: () {
                            if (qoin.HiveData.userDataLiveness?.base64image != null) {
                              qoin.Get.back();
                              loadingStatus.value = true;
                              FocusScope.of(context).requestFocus(FocusNode());
                              qoin.Get.put<qoin.LivenessController>(qoin.LivenessController());
                              qoin.DigitalIdController.instance.image = qoin.HiveData.userDataLiveness?.base64image;
                              qoin.LivenessController.instance.verify(onSuccess: (data) {
                                loadingStatus.value = false;
                                DialogUtils.showMainPopup(
                                    image: Assets.icAddSIM,
                                    title:
                                        "${DigitalIdLocalization.idTypePassport.tr} ${DigitalIdLocalization.messageDocSuccessVerification.tr}",
                                    mainButtonText: DigitalIdLocalization.buttonSuccessVerification.tr,
                                    mainButtonFunction: () {
                                      qoin.Get.offAll(() => HomeScreen(), binding: qoin.OnloginBindings());
                                    });
                              }, onFailed: (error) {
                                loadingStatus.value = false;
                                if (error == '500') {
                                  DialogUtils.showPopUp(
                                    type: DialogType.problem,
                                    description: DigitalIdLocalization.messageWeStillFixingIt.tr,
                                    buttonText: Localization.close.tr,
                                  );
                                  return;
                                } else if (error == 'The Doc Number has been registered') {
                                  DialogUtils.showPopUp(
                                    type: DialogType.problem,
                                    title: Localization.somethingWrong.tr,
                                    description:
                                        "${DigitalIdLocalization.idTypePassport.tr} ${DigitalIdLocalization.messageDocIsRegistered1.tr} ${DigitalIdLocalization.idTypePassport.tr} ${DigitalIdLocalization.messageDocIsRegistered2.tr}",
                                    buttonText: Localization.close.tr,
                                  );
                                  return;
                                } else if (error == 'Compare face failed') {
                                  DialogUtils.showPopUp(
                                    type: DialogType.problem,
                                    description: DigitalIdLocalization.messageErrorCompareFace.tr,
                                    buttonText: Localization.close.tr,
                                  );
                                  return;
                                } else if (error == "relogin") {
                                  IntentTo.sessionExpired();
                                } else {
                                  DialogUtils.showPopUp(
                                    type: DialogType.problem,
                                    description: DigitalIdLocalization.messageWeStillFixingIt.tr,
                                    buttonText: Localization.close.tr,
                                  );
                                  return;
                                }
                              });
                            } else {
                              qoin.Get.back();
                              qoin.Get.to(() => VerificationGuideScreen(livenessType: LivenessType.Passport),
                                  binding: LivenessBindings());
                            }
                          });
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

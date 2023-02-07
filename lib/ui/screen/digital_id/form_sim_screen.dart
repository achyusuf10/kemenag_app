import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/regex_rule.dart';
import 'package:inisa_app/helper/ui_design.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/logic/controller/liveness_bindings.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/button_secondary.dart';
import 'package:inisa_app/ui/widget/digital_id/date_picker_field.dart';
import 'package:inisa_app/ui/widget/digital_id/step_wizard_widget.dart';
import 'package:inisa_app/ui/widget/main_textfield.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:inisa_app/ui/widget/more_field.dart';
import 'package:qoin_sdk/controllers/qoin_digitalid/doc_controller.dart';
import 'package:qoin_sdk/controllers/qoin_digitalid/liveness_controller.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'qoin_liveness_screen.dart';
import 'verification_guide_screen.dart';

class FormSIMScreen extends StatefulWidget {
  const FormSIMScreen({Key? key}) : super(key: key);

  @override
  _FormSIMScreenState createState() => _FormSIMScreenState();
}

class _FormSIMScreenState extends State<FormSIMScreen> {
  var formKey = GlobalKey<FormState>();
  bool _submitted = false;
  final qoin.RxBool loadingStatus = false.obs;

  @override
  void initState() {
    qoin.DigitalIdController.instance.validateBirthDate.value = false;
    qoin.DigitalIdController.instance.validateExpire.value = false;
    qoin.DigitalIdController.instance.validateGender.value = false;
    qoin.DigitalIdController.instance.data.nIK = qoin.HiveData.userData?.nIK;
    _submitted = false;
    super.initState();
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
                      title: "${DigitalIdLocalization.headerWizardSIMPhoto.tr}",
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
            child: qoin.GetBuilder<qoin.DigitalIdController>(builder: (controller) {
              return Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    Text(
                      DigitalIdLocalization.fSIMProfileConfirmationTitle.tr,
                      style: TextUI.subtitleBlack,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      DigitalIdLocalization.fSIMProfileConfirmationDesc.tr,
                      style: TextUI.bodyTextBlack,
                    ),
                    SizedBox(height: 20.h),
                    MainTextField(
                      labelText: DigitalIdLocalization.fSIMNIK.tr,
                      initialValue: qoin.HiveData.userData?.nIK ?? '',
                      onChange: (val) => controller.data.nIK = val,
                      hintText: DigitalIdLocalization.fSIMNIKHint.tr,
                      validation: [
                        RegexRule.emptyValidationRule,
                        RegexRule.nikValidationRule,
                        RegexRule.numberValidationRule
                      ],
                      onAction: TextInputAction.next,
                      enabled: qoin.HiveData.userData?.nIK == null ? true : false,
                      maxLines: 1,
                      maxLength: 16,
                    ),
                    SizedBox(height: 20.h),
                    controller.data.typeCode != null
                        ? MoreField(
                            labelText: DigitalIdLocalization.fSIMType.tr,
                            hint: Text(
                              DigitalIdLocalization.fSIMTypeHint.tr,
                              style: TextUI.placeHolderBlack,
                            ),
                            value: controller.data.typeCode,
                            validator: (val) {
                              if (val == null) {
                                return DigitalIdLocalization.messageRequired.tr;
                              }
                              return null;
                            },
                            items: controller.simType
                                .map((e) => DropdownMenuItem(
                                      child: Text(
                                        e['label']!,
                                        style: TextUI.bodyTextBlack,
                                      ),
                                      value: e['value'],
                                    ))
                                .toList(),
                            onChanged: (val) {
                              controller.data.typeCode = val as String;
                              if (_submitted == true) {
                                formKey.currentState!.validate();
                              }
                            },
                          )
                        : MoreField(
                            labelText: DigitalIdLocalization.fSIMType.tr,
                            hint: Text(
                              DigitalIdLocalization.fSIMTypeHint.tr,
                              style: TextUI.placeHolderBlack,
                            ),
                            validator: (val) {
                              if (val == null) {
                                return DigitalIdLocalization.messageRequired.tr;
                              }
                              return null;
                            },
                            items: controller.simType
                                .map((e) => DropdownMenuItem(
                                      child: Text(
                                        e['label']!,
                                        style: TextUI.bodyTextBlack,
                                      ),
                                      value: e['value'],
                                    ))
                                .toList(),
                            onChanged: (val) {
                              controller.data.typeCode = val as String;
                              if (_submitted == true) {
                                formKey.currentState!.validate();
                              }
                            },
                          ),
                    SizedBox(height: 20.h),
                    MainTextField(
                      initialValue: controller.data.docNo ?? '',
                      onChange: (val) {
                        controller.data.docNo = val;
                      },
                      labelText: DigitalIdLocalization.fSIMNumber.tr,
                      hintText: DigitalIdLocalization.fSIMNumberHint.tr,
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
                      initialValue: controller.data.name ?? '',
                      onChange: (val) {
                        controller.data.name = val!;
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
                      initialValue: controller.data.poB ?? '',
                      onChange: (val) {
                        controller.data.poB = val!;
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
                      errorText: controller.validateBirthDate.value == false
                          ? null
                          : controller.data.doB == null
                              ? DigitalIdLocalization.messageRequired.tr
                              : controller.difference.value < 6209
                                  ? DigitalIdLocalization.messageAgeValidation.tr
                                  : DigitalIdLocalization.messageRequired.tr,
                      hintText: DigitalIdLocalization.fSIMDoBHint.tr,
                      onPicked: (date) async {
                        controller.data.doB = date?.toFormatsString(format: 'yyyy-MM-dd');
                        controller.dobValidate();
                        controller.update();
                        if (_submitted == true) {
                          formKey.currentState!.validate();
                        }
                      },
                      initialValue: controller.data.doB != null ? DateTime.tryParse(controller.data.doB!) : null,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      DigitalIdLocalization.detailDigitalDocGender.tr,
                      style: TextUI.labelBlack,
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Radio(
                                      value: describeEnum(GenderType.male),
                                      groupValue: controller.data.gender,
                                      onChanged: (String? val) {
                                        controller.data.gender = val!;
                                        controller.validateGender.value = false;
                                        setState(() {});
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
                                        controller.data.gender = val!;
                                        controller.validateGender.value = false;
                                        setState(() {});
                                      },
                                      activeColor: Color(0xff111111),
                                    ),
                                    Text(DigitalIdLocalization.female.tr,
                                        style: TextUI.bodyTextBlack)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          qoin.Obx(() => controller.validateGender.value == true
                              ? Text(
                                  "${DigitalIdLocalization.messageRequired.tr}",
                                  style: TextStyle(color: Colors.red),
                                )
                              : SizedBox()),
                          controller.data.blood != null
                              ? MoreField(
                                  labelText: DigitalIdLocalization.detailDigitalDocBloodType.tr,
                                  hint: Text(DigitalIdLocalization.fSIMBloodTypeHint.tr,
                                      style: TextUI.placeHolderBlack),
                                  value: controller.data.blood,
                                  validator: (val) {
                                    if (val == null) {
                                      return DigitalIdLocalization.messageRequired.tr;
                                    }
                                  },
                                  items: ['A', 'B', 'O', 'AB']
                                      .map((e) => DropdownMenuItem(
                                            child: Text(
                                              e,
                                              style: TextUI.bodyTextBlack,
                                            ),
                                            value: e,
                                          ))
                                      .toList(),
                                  onChanged: (val) {
                                    controller.data.blood = val.toString();
                                    if (_submitted == true) {
                                      formKey.currentState!.validate();
                                    }
                                  },
                                )
                              : MoreField(
                                  labelText: DigitalIdLocalization.detailDigitalDocBloodType.tr,
                                  hint: Text(
                                    DigitalIdLocalization.fSIMBloodTypeHint.tr,
                                    style: TextUI.placeHolderBlack,
                                  ),
                                  validator: (val) {
                                    if (val == null) {
                                      return DigitalIdLocalization.messageRequired.tr;
                                    }
                                  },
                                  items: ['A', 'B', 'O', 'AB']
                                      .map((e) => DropdownMenuItem(
                                            child: Text(
                                              e,
                                              style: TextUI.bodyTextBlack,
                                            ),
                                            value: e,
                                          ))
                                      .toList(),
                                  onChanged: (val) {
                                    controller.data.blood = val.toString();
                                    if (_submitted == true) {
                                      formKey.currentState!.validate();
                                    }
                                  },
                                ),
                          SizedBox(height: 20.h),
                          MainTextField(
                            initialValue: controller.data.address ?? '',
                            onChange: (val) {
                              controller.data.address = val!;
                            },
                            labelText: DigitalIdLocalization.detailDigitalDocAddress.tr,
                            hintText: DigitalIdLocalization.fSIMAddressHint.tr,
                            maxLines: 3,
                            validation: [
                              RegexRule.emptyValidationRule,
                            ],
                            textInputType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.characters,
                            onAction: TextInputAction.newline,
                          ),
                          SizedBox(height: 20.h),
                          MainTextField(
                            initialValue: controller.data.kota,
                            onChange: (val) {
                              controller.data.kota = val;
                            },
                            labelText: DigitalIdLocalization.detailDigitalDocCity.tr,
                            hintText: DigitalIdLocalization.fSIMCityHint.tr,
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
                            labelText: DigitalIdLocalization.detailDigitalDocProfession.tr,
                            hint: Text(
                              DigitalIdLocalization.fSIMProfessionHint.tr,
                              style: TextUI.placeHolderBlack,
                            ),
                            validator: (val) {
                              if (val == null) {
                                return DigitalIdLocalization.messageRequired.tr;
                              }
                            },
                            items: ChoicesList.workList
                                .map((e) => DropdownMenuItem(
                                      child: Text(
                                        e['label']!,
                                        style: TextUI.bodyTextBlack,
                                      ),
                                      value: e['value'],
                                    ))
                                .toList(),
                            onChanged: (val) {
                              controller.data.profession = val.toString();
                              if (_submitted == true) {
                                formKey.currentState!.validate();
                              }
                            },
                          ),
                          SizedBox(height: 20.h),
                          MainTextField(
                            initialValue: controller.data.issuer ?? '',
                            onChange: (val) {
                              controller.data.issuer = val;
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
                          SizedBox(height: 20.h),
                          DatePickerField(
                            dateFormat: 'yyyy-MM-dd',
                            labelText: DigitalIdLocalization.fSIMValidityPeriod.tr,
                            errorText: controller.validateExpire.value == false
                                ? null
                                : DigitalIdLocalization.messageRequired.tr,
                            hintText: DigitalIdLocalization.fSIMValidityPeriodHint.tr,
                            onPicked: (date) async {
                              controller.data.expired = date?.toFormatsString(format: 'yyyy-MM-dd');
                              print('controller.data.expired => ${controller.data.expired}');
                              controller.docExpireType?.value = describeEnum(ExpireType.validuntil);
                              controller.expireValidate();
                              controller.update();
                              if (_submitted == true) {
                                formKey.currentState!.validate();
                              }
                            },
                            initialValue:
                                controller.data.expired != null ? DateTime.tryParse(controller.data.expired!) : null,
                          ),
                          SizedBox(height: 100.h),
                          // MainFileUpload(
                          //   title: DigitalIdLocalization.formKTPUploadPhoto.tr,
                          //   onChanged: (file) {},
                          //   hint: DigitalIdLocalization.formKTPUploadPhotoHint.tr,
                          // ),
                          // SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
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
                    height: 50,
                    text: DigitalIdLocalization.faceVerificationReshot.tr,
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());

                      DialogUtils.showMainPopup(
                          mainPopupButtonDirection: MainPopupButtonDirection.Horizontal,
                          title: DigitalIdLocalization.fSIMRetakeWarningTitle.tr,
                          description: DigitalIdLocalization.fSIMRetakeWarningDesc.tr,
                          secondaryButtonText: Localization.yes.tr,
                          secondaryButtonFunction: () {
                            qoin.Get.back();
                            qoin.Get.back();
                            qoin.Get.back();
                            qoin.DigitalIdController.instance.data.cardType = qoin.CardCode.simCardType;
                          },
                          mainButtonText: Localization.no.tr,
                          mainButtonFunction: () {
                            qoin.Get.back();
                          });
                    }),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: MainButton(
                    height: 50,
                    text: Localization.buttonContinue.tr,
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());

                      if (qoin.DigitalIdController.instance.data.typeCode == qoin.CardCode.simATypeCode) {
                        if (DocController.to.isSIMACardAlreadyDigitized) {
                          DialogUtils.showMainPopup(
                              image: Assets.warning,
                              title: DigitalIdLocalization.fSIMRetakeWarningSIMA.tr,
                              description: DigitalIdLocalization.fSIMRetakeWarningSIMADesc.tr,
                              mainButtonText: Localization.back.tr,
                              mainButtonFunction: () {
                                qoin.Get.back();
                              });
                          return;
                        }
                      }

                      if (qoin.DigitalIdController.instance.data.typeCode == qoin.CardCode.simCTypeCode) {
                        if (DocController.to.isSIMCCardAlreadyDigitized) {
                          DialogUtils.showMainPopup(
                              image: Assets.warning,
                              title: DigitalIdLocalization.fSIMRetakeWarningSIMC.tr,
                              description: DigitalIdLocalization.fSIMRetakeWarningSIMCDesc.tr,
                              mainButtonText: Localization.back.tr,
                              mainButtonFunction: () {
                                qoin.Get.back();
                              });
                          return;
                        }
                      }

                      qoin.DigitalIdController.instance.dobValidate();
                      qoin.DigitalIdController.instance.genderValidate();
                      qoin.DigitalIdController.instance.expireValidate();
                      qoin.DigitalIdController.instance.update();
                      setState(() {
                        _submitted = true;
                      });
                      if (!formKey.currentState!.validate() ||
                          qoin.DigitalIdController.instance.validateBirthDate.value == true ||
                          qoin.DigitalIdController.instance.validateGender.value == true ||
                          qoin.DigitalIdController.instance.validateExpire.value == true) {
                        setState(() {});
                        return;
                      }
                      DialogUtils.showMainPopup(
                          title: DigitalIdLocalization.fSIMNIKReCheckTitle.tr,
                          mainPopupButtonDirection: MainPopupButtonDirection.Horizontal,
                          description: DigitalIdLocalization.fSIMNIKReCheckDesc.tr,
                          secondaryButtonText: Localization.recheck.tr,
                          secondaryButtonFunction: () {
                            qoin.Get.back();
                          },
                          mainButtonText: Localization.buttonContinue.tr,
                          mainButtonFunction: () {
                            qoin.Get.back();
                            if (qoin.HiveData.userData?.nIK != null && qoin.HiveData.userData?.nIK != '') {
                              if (qoin.HiveData.userData!.nIK != qoin.DigitalIdController.instance.data.nIK) {
                                DialogUtils.showMainPopup(
                                  radius: 10,
                                  animation: Assets.problemAnimation,
                                  title: DigitalIdLocalization.fSIMNIKNotMatchedTitle.tr,
                                  description: DigitalIdLocalization.fSIMNIKNotMatchedDesc.tr,
                                  mainButtonText: Localization.recheck.tr,
                                  color: Colors.white,
                                  mainButtonFunction: () {
                                    qoin.Get.back();
                                  },
                                );
                              } else {
                                process();
                              }
                            } else {
                              process();
                            }
                          });
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  process() async {
    if (qoin.HiveData.userDataLiveness != null) {
      loadingStatus.value = true;
      qoin.DigitalIdController.instance.image = qoin.HiveData.userDataLiveness!.base64image;
      var controller = qoin.Get.put(LivenessController());
      await LivenessController.instance.verify(
        onSuccess: (data) {
          loadingStatus.value = false;
          DialogUtils.showMainPopup(
              image: Assets.icAddSIM,
              title:
                  "${DigitalIdLocalization.idTypeSimCard.tr} ${DigitalIdLocalization.messageDocSuccessVerification.tr}",
              mainButtonText: DigitalIdLocalization.buttonSuccessVerification.tr,
              mainButtonFunction: () {
                qoin.Get.offAll(() => HomeScreen(), binding: qoin.OnloginBindings());
              });
        },
        onFailed: (error) {
          loadingStatus.value = false;
          if (error == '500') {
            DialogUtils.showPopUp(
              type: DialogType.problem,
              description: DigitalIdLocalization.messageWeStillFixingIt.tr,
              buttonText: Localization.close.tr,
            );
            return;
          } else if (error == 'The Doc Number has been registered' ||
              error == 'The document number has been registered') {
            DialogUtils.showPopUp(
              type: DialogType.problem,
              title: Localization.somethingWrong.tr,
              description:
                  "${DigitalIdLocalization.idTypeSimCard.tr} ${DigitalIdLocalization.messageDocIsRegistered1.tr} ${DigitalIdLocalization.idTypeSimCard.tr} ${DigitalIdLocalization.messageDocIsRegistered2.tr}",
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
        },
      );
    } else {
      qoin.Get.to(() => VerificationGuideScreen(livenessType: LivenessType.SIM),
          binding: LivenessBindings());
    }
  }
}

class ChoicesList {
  static List<Map<String, String>> workList = [
    {
      'label': DigitalIdLocalization.workTypeAbri.tr,
      'value': 'ABRI',
    },
    {
      'label': DigitalIdLocalization.workTypeLaborer.tr,
      'value': 'Buruh',
    },
    {
      'label': DigitalIdLocalization.workTypeDoctor.tr,
      'value': 'Dokter',
    },
    {
      'label': DigitalIdLocalization.workTypeLecturer.tr,
      'value': 'Dosen',
    },
    {
      'label': DigitalIdLocalization.workTypeAmbassador.tr,
      'value': 'Duta Besar',
    },
    {
      'label': DigitalIdLocalization.workTypeTeacher.tr,
      'value': 'Guru',
    },
    {
      'label': DigitalIdLocalization.workTypeJudge.tr,
      'value': 'Hakim',
    },
    {
      'label': DigitalIdLocalization.workTypeHouseWife.tr,
      'value': 'Ibu Rumah Tangga',
    },
    {
      'label': DigitalIdLocalization.workTypeProsecutor.tr,
      'value': 'Jaksa',
    },
    {
      'label': DigitalIdLocalization.workTypeSeller.tr,
      'value': 'Pedagang',
    },
    {
      'label': DigitalIdLocalization.workTypeBumd.tr,
      'value': 'Pegawai BUMD',
    },
    {
      'label': DigitalIdLocalization.workTypeBumn.tr,
      'value': 'Pegawai BUMN',
    },
    {
      'label': DigitalIdLocalization.workTypeGovEmployee.tr,
      'value': 'Pegawai Negeri',
    },
    {
      'label': DigitalIdLocalization.workTypeEmployee.tr,
      'value': 'Pegawai Swasta',
    },
    {
      'label': DigitalIdLocalization.workTypeStudent.tr,
      'value': 'Pelajar',
    },
    {
      'label': DigitalIdLocalization.workTypeLawyer.tr,
      'value': 'Pengacara',
    },
    {
      'label': DigitalIdLocalization.workTypeDriver.tr,
      'value': 'Pengemudi',
    },
    {
      'label': DigitalIdLocalization.workTypePolri.tr,
      'value': 'POLRI',
    },
    {
      'label': DigitalIdLocalization.workTypePensioner.tr,
      'value': 'Purnawirawan',
    },
    {
      'label': DigitalIdLocalization.workTypeAD.tr,
      'value': 'TNI AD',
    },
    {
      'label': DigitalIdLocalization.workTypeAL.tr,
      'value': 'TNI AL',
    },
    {
      'label': DigitalIdLocalization.workTypeAU.tr,
      'value': 'TNI AU',
    },
    {
      'label': DigitalIdLocalization.workTypeTNI.tr,
      'value': 'TNI/POLRI',
    },
    {
      'label': DigitalIdLocalization.workTypeJournalist.tr,
      'value': 'Wartawan',
    },
    {
      'label': DigitalIdLocalization.workTypeWiraswasta.tr,
      'value': 'Wiraswasta',
    },
    {
      'label': DigitalIdLocalization.workTypeArtist.tr,
      'value': 'Artis',
    },
    {
      'label': DigitalIdLocalization.workTypeOther.tr,
      'value': 'Lainnya',
    },
  ];
}

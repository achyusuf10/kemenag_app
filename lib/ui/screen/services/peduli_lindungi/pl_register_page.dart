import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/regex_rule.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/main_textfield.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/controllers/qoin_services/pl_controllers.dart';
import 'package:qoin_sdk/models/qoin_services/peduli_lindungi/submit_identity_req.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'pl_scanner_page.dart';
import 'powerby_widget.dart';

class PLRegisterPage extends StatefulWidget {
  const PLRegisterPage();

  @override
  _PLRegisterPageState createState() => _PLRegisterPageState();
}

class _PLRegisterPageState extends State<PLRegisterPage> {
  bool isChecked = false;
  bool disableButton = true;

  var _fullname = ''.obs;
  var _nik = ''.obs;
  TextEditingController _nikController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (HiveData.userData?.nIK != null) {
      _nik.value = HiveData.userData!.nIK!.toUpperCase();
      _nikController.text = HiveData.userData!.nIK!.toUpperCase();
    }
    if (HiveData.userData?.fullname != null) {
      _fullname.value = HiveData.userData!.fullname!.toUpperCase();
      _fullNameController.text = HiveData.userData!.fullname!.toUpperCase();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PLController());
    return ModalProgress(
      loadingStatus: PLController.to.isLoading.stream,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBarWidget.light(
          title: 'Scan & Check-In',
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Image.asset(
                    Assets.peduliLindungiBlue,
                    height: 80.h,
                    width: 80.w,
                  ),
                ),
              ),
              MainTextField(
                initialValue: _nik.value,
                onChange: (val) {
                  _nik.value = val;
                  if (_nik.value.length >= 16 && _fullname.value != "" && isChecked == true) {
                    disableButton = false;
                  } else {
                    disableButton = true;
                  }
                },
                textInputType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16)
                ],
                hintText: DigitalIdLocalization.fSIMNIKHint.tr,
                labelText: DigitalIdLocalization.fSIMNIK.tr,
                validator: (value) {
                  String? error;
                  var validation = [RegexRule.emptyValidationRule, RegexRule.nikValidationRule];
                  validation.forEach((element) {
                    RegExp regExp = new RegExp(element.regex);
                    if (!regExp.hasMatch(value!)) {
                      error = element.errorMesssage;
                    }
                  });
                  return error;
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              MainTextField(
                onChange: (val) {
                  _fullname.value = val;
                  if (_nik.value.length >= 16 && _fullname.value != "" && isChecked == true) {
                    disableButton = false;
                  } else {
                    disableButton = true;
                  }
                },
                initialValue: _fullname.value,
                textCapitalization: TextCapitalization.characters,
                hintText: DigitalIdLocalization.fSIMFullnameHint.tr,
                labelText: QoinServicesLocalization.plFullnameLabel.tr,
              ),
              SizedBox(
                height: 24,
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: RichText(
                    text: TextSpan(style: TextUI.labelBlack, children: [
                  TextSpan(text: "${QoinServicesLocalization.plAgreement1.tr} "),
                  TextSpan(style: TextUI.labelYellow, text: Localization.buttonTermAndCondition.tr),
                  TextSpan(
                    text: " ${QoinServicesLocalization.plAgreement2.tr} ",
                    style: TextUI.labelBlack,
                  ),
                  TextSpan(
                      style: TextUI.labelYellow, text: "${Localization.buttonPrivacyPolicy.tr} "),
                  TextSpan(
                    text: "PeduliLindungi",
                    style: TextUI.labelBlack,
                  )
                ])),
                checkColor: Colors.white,
                activeColor: ColorUI.secondary,
                value: isChecked,
                onChanged: (newValue) {
                  setState(() {
                    isChecked = newValue!;
                    if (_nik.value.length >= 16 &&
                        _fullname.value.isNotEmpty &&
                        isChecked == true) {
                      disableButton = false;
                    } else {
                      disableButton = true;
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
              SizedBox(
                height: 24,
              ),
              Obx(
                () => MainButton(
                  onPressed: _nik.value.length < 16 || _fullname.value.isEmpty || !isChecked
                      ? null
                      : () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (PLController.to.submitIdentityData != null) {
                            Get.to(() => PLScannerPage(), binding: PLBindings());
                          } else {
                            SubmitIdentityReq request = SubmitIdentityReq(
                                nik: _nik.value,
                                fullName: _fullname.value.toUpperCase(),
                                countryCode: "IDN");
                            PLController.to.submitIdentity(request, onSuccess: () {
                              Get.back();
                              Get.back();
                              Get.to(() => PLScannerPage(), binding: PLBindings());
                            }, onFailed: (error) {
                              if (error == "relogin") {
                                IntentTo.sessionExpired();
                              } else {
                                DialogUtils.showPopUp(
                                    type: DialogType.problem,
                                    description: error == ''
                                        ? QoinServicesLocalization.plSomethingWrong.tr
                                        : error.toLowerCase() ==
                                                'sesuaikan nama dan nik anda dengan ktp'
                                            ? QoinServicesLocalization.plNikNameNotMatched.tr
                                            : error);
                              }
                            });
                          }
                        },
                  text: Localization.buttonContinue.tr,
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: PoweredBy(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

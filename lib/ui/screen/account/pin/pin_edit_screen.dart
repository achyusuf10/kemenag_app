import 'package:flutter/material.dart';
import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/screen/account/otp/otp_method_screen.dart';
import 'package:inisa_app/ui/screen/account/otp/otp_screen.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_bottom.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/helpers/services/api_status.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:inisa_app/ui/widget/main_textfield.dart';

import 'pin_screen.dart';

class PinEditScreen extends StatelessWidget {
  PinEditScreen({Key? key}) : super(key: key);

  final RxBool _obsecureCurrent = true.obs;
  final RxBool _obsecureNew = true.obs;
  final RxBool _obsecureNewConfirm = true.obs;

  var _pinCurrent = "".obs;
  var _pinNew = "".obs;
  var _pinNewConfirm = "".obs;

  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: AccountsController.instance.isMainLoading.stream,
      child: Scaffold(
        appBar: AppBarWidget.light(
          title: Localization.buttonChangePin.tr,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Localization.pinVerifOldPin.tr,
                      style: TextUI.subtitleBlack,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Obx(
                      () => MainTextField(
                        labelText: Localization.pinPreviousPin.tr,
                        hintText: Localization.pinInputYourPin.tr,
                        obscureText: _obsecureCurrent.value,
                        maxLength: 6,
                        textInputType: TextInputType.number,
                        suffixIcon: _obsecureCurrent.value
                            ? InkWell(
                                child: Icon(Icons.visibility),
                                onTap: () {
                                  _obsecureCurrent.value = false;
                                },
                              )
                            : InkWell(
                                child: Icon(Icons.visibility_off),
                                onTap: () {
                                  _obsecureCurrent.value = true;
                                },
                              ),
                        onChange: (value) => _pinCurrent.value = value,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: InkResponse(
                          onTap: () async {
                            _resetPin();
                          },
                          child: Text(
                            '${Localization.pinForgot.tr}?',
                            style: TextUI.buttonTextUnderline,
                          ),
                        ))
                  ],
                ),
              ),
              Divider(
                color: ColorUI.shape,
                thickness: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      Localization.pinConfirm.tr,
                      style: TextUI.subtitleBlack,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Obx(
                      () => MainTextField(
                        labelText: Localization.pinNewPin.tr,
                        hintText: Localization.pinNewPin.tr,
                        obscureText: _obsecureNew.value,
                        maxLength: 6,
                        textInputType: TextInputType.number,
                        onChange: (value) => _pinNew.value = value,
                        suffixIcon: _obsecureNew.value
                            ? InkWell(
                                child: Icon(Icons.visibility),
                                onTap: () {
                                  _obsecureNew.value = false;
                                },
                              )
                            : InkWell(
                                child: Icon(Icons.visibility_off),
                                onTap: () {
                                  _obsecureNew.value = true;
                                },
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Obx(
                      () => MainTextField(
                          labelText: Localization.pinConfirm.tr,
                          hintText: Localization.pinInputNewPinAgain.tr,
                          obscureText: _obsecureNewConfirm.value,
                          maxLength: 6,
                          textInputType: TextInputType.number,
                          onChange: (value) => _pinNewConfirm.value = value,
                          suffixIcon: _obsecureNewConfirm.value
                              ? InkWell(
                                  child: Icon(Icons.visibility),
                                  onTap: () {
                                    _obsecureNewConfirm.value = false;
                                  },
                                )
                              : InkWell(
                                  child: Icon(Icons.visibility_off),
                                  onTap: () {
                                    _obsecureNewConfirm.value = true;
                                  },
                                ),
                          validator: (data) {
                            if (_pinNew.value.length > 0 &&
                                _pinNewConfirm.value.length > 0 &&
                                _pinNew.value != _pinNewConfirm.value) {
                              return Localization.pinNotMatched.tr;
                            }
                            return null;
                          }),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 96,
              ),
            ],
          ),
        ),
        bottomSheet: Obx(
          () => ButtonBottom(
              text: Localization.save.tr,
              onPressed: _pinCurrent.value != "" &&
                      _pinNew.value != "" &&
                      _pinNewConfirm.value != "" &&
                      (_pinNew.value == _pinNewConfirm.value)
                  ? () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      AccountsController.instance.changePin(
                        _pinCurrent.value,
                        _pinNew.value,
                        _pinNewConfirm.value,
                        onSuccess: () {
                          Get.back();
                          DialogUtils.showMainPopup(
                            animation: Assets.successAnimation,
                            title: Localization.pinChangeSuccess.tr,
                            secondaryButtonText: Localization.close.tr,
                            secondaryButtonFunction: () {
                              Get.back();
                            },
                          );
                        },
                        onError: (error) {
                          if (error == "You are offline") {
                            DialogUtils.showPopUp(type: DialogType.noInternet);
                            return;
                          }
                          if (error == "relogin") {
                            IntentTo.sessionExpired();
                            return;
                          }
                          String errorMessage = '';
                          switch (error) {
                            case "old pin don't match":
                              errorMessage = Localization.pinWrongOldPin.tr;
                              break;
                            case "invalid validation":
                              errorMessage = Localization.pinPairNotMatched.tr;
                              break;
                            case "error":
                              errorMessage = Localization.somethingWrong.tr;
                              break;
                            default:
                              errorMessage = error;
                              break;
                          }
                          DialogUtils.showPopUp(
                            type: DialogType.problem,
                            title: errorMessage,
                            buttonText: Localization.close.tr,
                          );
                        },
                      );
                    }
                  : null),
        ),
      ),
    );
  }

  _resetPin() async {
    AccountsFlowController.instance.forgotPinFlow(
      // isPrototype: true,
      otpMethodScreen: (phone, otpTypes) => OtpMethodScreen(
        phone: HiveData.userData!.phone!,
        otpTypes: otpTypes,
      ),
      otpInputScreen: (fSubmit, fResend, fTryOtherMethod, otpType) => OtpScreen(
        otpType: otpType,
        resendOtp: fResend,
        submitOtp: fSubmit,
      ),
      inputPinScreen: (pinType, functionSubmit) => PinScreen(
        pinType: pinType,
        functionSubmit: functionSubmit,
      ),
      onSuccess: () {
        DialogUtils.showMainPopup(
          animation: Assets.successAnimation,
          title: Localization.pinChangeSuccess.tr,
          secondaryButtonText: Localization.close.tr,
          secondaryButtonFunction: () {
            Get.back();
          },
        );
      },
      onFailedValidateJatis: (fOtherMethod, fTryAgain) {},
      onFailedOffline: () => DialogUtils.showPopUp(type: DialogType.noInternet),
      onFailedOtpExpired: () {
        // no set, will be set on otp screen or create a var in controller later
        AccountsController.instance.otpError = Localization.otpExpired.tr;
        debugPrint("error onFailedOtpExpired");
      },
      onFailedOtpNotMatch: () {
        // no set, will be set on otp screen or create a var in controller later
        AccountsController.instance.otpError = Localization.otpNotMatch.tr;
        debugPrint("error onFailedOtpNotMatch");
      },
      onFailedRequestForgotPin: (error) {
        DialogUtils.showPopUp(type: DialogType.problem, title: error);
        debugPrint("error onFailedRequestForgotPin: $error");
      },
      onFailedProblem: (error) {
        DialogUtils.showPopUp(
          type: DialogType.problem,
          title: Localization.pinResetFail.tr,
          description: error,
        );
      },
    );
  }
}

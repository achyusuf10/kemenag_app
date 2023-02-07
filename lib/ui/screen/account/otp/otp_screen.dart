import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/controllers/controllers_export.dart';
import 'package:qoin_sdk/helpers/constants/otp_type_contants.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/shaking_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpScreen extends StatefulWidget {
  final String otpType;
  final Function(String) submitOtp;
  final Function() resendOtp;
  // final bool isForgot;
  // final String otpType;
  // final int? continueSecond;
  // final String? methodType;

  OtpScreen({
    key,
    required this.submitOtp,
    required this.resendOtp,
    required this.otpType,
    // this.isForgot = false,
    // this.continueSecond,
    // this.methodType = 'text',
  }) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpTextController = TextEditingController();
  FocusNode _otpFocus = FocusNode();
  var _otp = ''.obs;

  final _shakeKey = GlobalKey<ShakeWidgetState>();
  var _textUnder = ''.obs;
  var _textUnderStyle = TextUI.bodyTextBlack2.obs;
  late String _phone;

  @override
  void initState() {
    _textUnder.value = Localization.otpResend.tr;
    _phone = AccountsController.instance.loginRecord?.phone ?? HiveData.userData?.phone ?? '';
    checkPhonenumber(_phone);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkPhonenumber(String phoneValue) {
    if (phoneValue.startsWith('62')) {
      _phone = '+62' + AnyUtils.phoneNumberConvert(phoneValue);
    } else {
      _phone = '+' + phoneValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    _otpFocus.requestFocus();

    return ModalProgress(
      loadingStatus: AccountsController.instance.isMainLoading.stream,
      child: Scaffold(
        appBar: AppBarWidget.light(
          title: Localization.otpVerification.tr,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Text(Localization.otpTitle.tr, style: TextUI.subtitleBlack),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "${Localization.otpDescription1.tr} ${widget.otpType == 'voice' ? Localization.otpCall.tr : widget.otpType == 'wa' ? 'WhatsApp' : "SMS"} ${Localization.otpDescription2.tr} $_phone",
                          style: TextUI.bodyTextBlack,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _otpFocus.requestFocus();
                  },
                  child: Container(
                    color: Get.theme.backgroundColor,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Stack(
                          children: [
                            SizedBox(
                              height: 44,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.h),
                                    child: Obx(() {
                                      if (_otp.value.length > 0) {
                                        return Text(
                                          _otp.value.substring(0, 1),
                                          style: TextUI.headerBlack,
                                        );
                                      } else {
                                        return dottedWidget;
                                      }
                                    }),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.h),
                                    child: Obx(() {
                                      if (_otp.value.length > 1) {
                                        return Text(
                                          _otp.value.substring(1, 2),
                                          style: TextUI.headerBlack,
                                        );
                                      } else {
                                        return dottedWidget;
                                      }
                                    }),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.h),
                                    child: Obx(() {
                                      if (_otp.value.length > 2) {
                                        return Text(
                                          _otp.value.substring(2, 3),
                                          style: TextUI.headerBlack,
                                        );
                                      } else {
                                        return dottedWidget;
                                      }
                                    }),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.h),
                                    child: Obx(() {
                                      if (_otp.value.length > 3) {
                                        return Text(
                                          _otp.value.substring(3, 4),
                                          style: TextUI.headerBlack,
                                        );
                                      } else {
                                        return dottedWidget;
                                      }
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            TextField(
                              focusNode: _otpFocus,
                              keyboardType: TextInputType.number,
                              controller: otpTextController,
                              onChanged: (value) {
                                _otp.value = value;
                              },
                              toolbarOptions: ToolbarOptions(
                                copy: false,
                                cut: false,
                                paste: false,
                                selectAll: false,
                              ),
                              enableInteractiveSelection: false,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                  counterText: ''),
                              cursorColor: Colors.transparent,
                              maxLength: 4,
                            ),
                            Container(
                              width: 50.w,
                              height: 50.w,
                              color: Colors.white,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 19,
                        ),
                        GetBuilder<AccountsController>(builder: (controller) {
                          if ([Localization.otpNotMatch.tr, Localization.otpExpired.tr]
                              .contains(AccountsController.instance.otpError)) {
                            _shakeKey.currentState?.shake();
                          }
                          return Obx(
                            () => Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ShakeWidget(
                                key: _shakeKey,
                                shakeCount: 3,
                                shakeOffset: 10,
                                shakeDuration: Duration(milliseconds: 500),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text: AccountsController.instance.otpCounterFromLocal.value == 3 &&
                                                  AccountsController.instance.otpCountdown.value == 0
                                              ? Localization.otpMaxWarning.tr
                                              : (AccountsController.instance.otpError ??
                                                      Localization.otpResend.tr) +
                                                  " "
                                          /* (AccountsController.to
                                                                .otpCountdown.value ==
                                                            0
                                                        ? " atau "
                                                        : " ") */
                                          ,
                                          style: TextUI.bodyTextBlack2.copyWith(
                                              color: AccountsController.instance.otpCounterFromLocal.value ==
                                                          3 &&
                                                      AccountsController.instance.otpCountdown.value == 0
                                                  ? Colors.red
                                                  : ColorUI.text_2)),
                                      TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            widget.resendOtp();
                                            // resend otp
                                            // if (!widget.isForgot) {
                                            //   widget.resendOtp();
                                            // } else {
                                            //   // AccountsController.instance.forgotPin(phoneNumber, otpType: otpType, onSuccessJatis: onSuccessJatis, onSuccessNotJatis: onSuccessNotJatis, onError: onError)
                                            // }
                                          },
                                        text: AccountsController.instance.otpCountdown.value > 0
                                            ? Utils.formatHHMMSS(
                                                AccountsController.instance.otpCountdown.value)
                                            : AccountsController.instance.otpCounterFromLocal.value == 3
                                                ? ''
                                                : "${Localization.otpSend.tr} ${AccountsFlowController.instance.otpValidationType != OtpValidationTypeConst.forgot ? '(${AccountsController.instance.otpCounterFromApi.value}/3)' : ''}",
                                        style: TextUI.bodyTextBlack.copyWith(
                                          color: AccountsController.instance.otpCountdown.value == 0
                                              ? Get.theme.colorScheme.secondary
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                          decoration: AccountsController.instance.otpCountdown.value == 0
                                              ? TextDecoration.underline
                                              : TextDecoration.none,
                                        ),
                                      )
                                    ],
                                  ),
                                  style: TextUI.bodyTextBlack2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          color: Colors.white,
          child: Obx(
            () => MainButton(
                text: Localization.buttonContinue.tr,
                onPressed: _otp.value.length == 4
                    ? () {
                        // marked TODO
                        widget.submitOtp(_otp.value);
                      }
                    : null),
          ),
        ),
      ),
    );
  }

  get dottedWidget => SizedBox(
        width: 12,
        height: 12,
        child: Container(
          decoration: BoxDecoration(
            color: ColorUI.shape_2,
            borderRadius: BorderRadius.circular(5.h),
          ),
        ),
      );
}

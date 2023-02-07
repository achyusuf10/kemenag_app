import 'package:flutter/material.dart';
import 'package:inisa_app/ui/screen/account/otp/otp_method_screen.dart';
import 'package:inisa_app/ui/screen/account/otp/otp_screen.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:inisa_app/ui/widget/responsive_widget.dart';
import 'package:qoin_sdk/helpers/services/api_status.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/oval_background.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/ui/widget/pin/pad_number.dart';

import 'controller/pin_binding.dart';
import 'controller/pin_controller.dart';

class PinScreenOld extends StatefulWidget {
  final qoin.PinTypeEnum? pinType;

  PinScreenOld({Key? key, this.pinType}) : super(key: key);

  @override
  _PinScreenOldState createState() => _PinScreenOldState();
}

class _PinScreenOldState extends State<PinScreenOld> {
  var pin = "".obs;
  var title = Localization.pinAppBarLogin.tr.obs;
  late Function onComplete;
  var modalProgress = false.obs;
  var errorPin = false.obs;
  var errorPinMessage = '';

  @override
  void initState() {
    setAction();
    super.initState();
  }

  setAction() {
    switch (widget.pinType) {
      case qoin.PinTypeEnum.createPin:
        title.value = Localization.pinAppBarCreate.tr;
        onComplete = () {
          qoin.AccountsController.instance.pin.value = pin.value;
          qoin.Get.back();
          qoin.Get.to(() => PinScreenOld(pinType: qoin.PinTypeEnum.createPinConfirmation));
        };
        break;
      case qoin.PinTypeEnum.createPinConfirmation:
        title.value = Localization.pinAppBarConfirmation.tr;
        onComplete = () {
          if (qoin.AccountsController.instance.pin.value != pin.value) {
            errorPin.value = true;
            errorPinMessage = Localization.pinConfirmationNotMatched.tr;
            return;
          }
          qoin.AccountsController.instance.register(
              pin: qoin.AccountsController.instance.pin.value,
              pinConfirmation: pin.value,
              onSuccess: () {
                qoin.AccountsController.instance.pin.value = "";
                qoin.AccountsController.instance.cancelTimer();
                qoin.Get.offAll(() => HomeScreen(
                      isRegister: true,
                    ));
                return;
              },
              onError: (error) {
                if (error == "You are offline") {
                  DialogUtils.showPopUp(type: DialogType.noInternet);
                } else if (error == "Terjadi kesalahan, coba lagi beberapa saat") {
                  DialogUtils.showPopUp(type: DialogType.problem);
                } else {
                  DialogUtils.showPopUp(
                    type: DialogType.problem,
                    title: error,
                  );
                }
              });
        };
        break;
      case qoin.PinTypeEnum.reCreatePin:
        title.value = Localization.pinAppBarReCreate.tr;
        onComplete = () {
          PinController.to.pin.value = pin.value;
          qoin.Get.back();
          qoin.Get.to(PinScreenOld(pinType: qoin.PinTypeEnum.reCreatePinConfirmation),
              binding: PinBinding(), arguments: pin.value);
        };
        break;
      case qoin.PinTypeEnum.reCreatePinConfirmation:
        title.value = Localization.pinAppBarReConfirmation.tr;
        onComplete = () async {
          var pinController = qoin.Get.put(PinController());
          PinController.to.pin.value = qoin.Get.arguments;
          pinController.pinConfirmation.value = pin.value;
          if (PinController.to.pin.value != PinController.to.pinConfirmation.value) {
            errorPin.value = true;
            errorPinMessage = Localization.pinConfirmationNotMatched.tr;
            pin.value = '';
          } else {
            qoin.AccountsController.instance.validateForgotPin(
                newPin: PinController.to.pin.value,
                newPinConfirmation: PinController.to.pinConfirmation.value,
                onSuccess: () {
                  qoin.Get.offAll(() => HomeScreen());
                },
                onError: (error) {
                  qoin.Get.back();
                  qoin.Get.back();
                  qoin.Get.back();
                  DialogUtils.showPopUp(
                    type: DialogType.problem,
                    title: error,
                  );
                },
                onSuccessAlreadyLogin: () {
                  qoin.Get.back();
                  qoin.Get.back();
                  qoin.Get.back();
                  DialogUtils.showMainPopup(
                    animation: Assets.successAnimation,
                    title: Localization.pinChangeSuccess.tr,
                    mainButtonText: Localization.close.tr,
                    mainButtonFunction: () {
                      qoin.Get.back();
                    },
                  );
                });
          }
        };
        break;
      case qoin.PinTypeEnum.login:
        title.value = Localization.pinAppBarLogin.tr;
        onComplete = () {
          qoin.AccountsController.instance.login(
            pin: pin.value,
            onSuccess: () {
              qoin.AccountsController.instance.cancelTimer();
              qoin.Get.offAll(() => HomeScreen());
            },
            onError: (error) {
              pin.value = '';
              if (error == "Phone & PIN don't match") {
                errorPin.value = true;
                errorPinMessage = Localization.pinIncorrect.tr;
              } else if (error == "You are offline") {
                DialogUtils.showPopUp(type: DialogType.noInternet);
              } /* else if (error == "no user") {
                // qoin.Get.back();
                qoin.Get.to(PinScreen(pinType: qoin.PinType.createPin));
              }  */
              else if (error == "Terjadi kesalahan, coba lagi beberapa saat") {
                DialogUtils.showPopUp(type: DialogType.problem);
              } else {
                DialogUtils.showPopUp(
                  type: DialogType.problem,
                  title: error,
                );
              }
            },
          );
        };
        break;
      case qoin.PinTypeEnum.confirmationTransaction:
        title.value = Localization.pinAppBarLogin.tr;
        onComplete = () {
          qoin.AccountsController.instance.pinValidation(
              pin: pin.value,
              onSuccess: (token) async {
                qoin.Get.back(result: token);
              },
              onError: (error) {
                pin.value = '';
                if (error == "pin don't match") {
                  errorPin.value = true;
                  errorPinMessage = Localization.pinIncorrect.tr;
                } else if (error == "You are offline") {
                  // DialogUtils.showNoInternetPopUp();
                } else if (error == "relogin") {
                  qoin.Get.back();
                  DialogUtils.showPopUp(
                      type: DialogType.problem,
                      title: Localization.titleSessionEnd.tr,
                      barrierDismissible: false,
                      buttonText: Localization.buttonRelogin.tr,
                      buttonFunction: () =>
                          qoin.Get.offAll(() => PinScreenOld(pinType: qoin.PinTypeEnum.login)));
                } else {
                  DialogUtils.showPopUp(type: DialogType.problem, title: error);
                }
              });
        };
        break;
      default:
        title.value = Localization.pinAppBarLogin.tr;
        onComplete = () {
          Navigator.pop(context, pin.value);
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: qoin.AccountsController.instance.isMainLoading.stream,
      child: Scaffold(
        appBar: AppBarWidget.red(
          title: title.value,
        ),
        body: Stack(
          children: [
            OvalBackground(
              heightBackground: 287.h,
              heightPrimary: 320.h,
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(24.h),
                  child: label,
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    qoin.Obx(() => pinInput(pin: pin.value)),
                    SizedBox(
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    qoin.Obx(
                      () => errorPin.value
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.h),
                              child: Text(
                                errorPinMessage,
                                style: TextUI.labelWhite.copyWith(fontSize: 13.sp),
                              ),
                            )
                          : SizedBox(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                // if (widget.pinType == qoin.PinTypeEnum.login)
                //   InkWell(
                //       onTap: () async {
                //         String? type = await qoin.Get.to(() => OtpMethodScreen());
                //         if (type != null) {
                //           _resetPin(type);
                //         }
                //       },
                //       child: Text(
                //         Localization.pinForgot.tr + '?',
                //         style: TextUI.bodyText2White,
                //       )),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0x14111111),
                            offset: Offset(0, 2),
                            blurRadius: 16,
                            spreadRadius: 0)
                      ],
                      color: Colors.white),
                  margin: EdgeInsets.fromLTRB(16.w, 50.h, 16.w, 0),
                  padding: EdgeInsets.all(30.h),
                  child: ResponsiveWidget(
                    width: 379,
                    height: 460,
                    enableScale: true,
                    child: PadNumber(
                      onNumberPressed: (number) {
                        pin.value += number.toString();
                        if (pin.value.length == 6) {
                          errorPin.value = false;
                          onComplete();
                        }
                      },
                      onDeletedPressed: () {
                        if (pin.value.length > 0) {
                          pin.value = pin.value.substring(0, pin.value.length - 1);
                        }
                      },
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget pinInput({String pin = ''}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.h),
          child: Column(
            children: [
              SizedBox(
                width: 15.h,
                height: 15.h,
                child: Container(
                  decoration: BoxDecoration(
                    color: pin.length > 0 ? qoin.Get.theme.backgroundColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              SizedBox(
                width: 35.w,
                height: 4.h,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    color: qoin.Get.theme.backgroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.h),
          child: Column(
            children: [
              SizedBox(
                width: 15.h,
                height: 15.h,
                child: Container(
                  decoration: BoxDecoration(
                    color: pin.length > 1 ? qoin.Get.theme.backgroundColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              SizedBox(
                width: 35.w,
                height: 4.h,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    color: qoin.Get.theme.backgroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.h),
          child: Column(
            children: [
              SizedBox(
                width: 15.h,
                height: 15.h,
                child: Container(
                  decoration: BoxDecoration(
                    color: pin.length > 2 ? qoin.Get.theme.backgroundColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              SizedBox(
                width: 35.w,
                height: 4.h,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    color: qoin.Get.theme.backgroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.h),
          child: Column(
            children: [
              SizedBox(
                width: 15.h,
                height: 15.h,
                child: Container(
                  decoration: BoxDecoration(
                    color: pin.length > 3 ? qoin.Get.theme.backgroundColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              SizedBox(
                width: 35.w,
                height: 4.h,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    color: qoin.Get.theme.backgroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.h),
          child: Column(
            children: [
              SizedBox(
                width: 15.h,
                height: 15.h,
                child: Container(
                  decoration: BoxDecoration(
                    color: pin.length > 4 ? qoin.Get.theme.backgroundColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              SizedBox(
                width: 35.w,
                height: 4.h,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    color: qoin.Get.theme.backgroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.h),
          child: Column(
            children: [
              SizedBox(
                width: 15.h,
                height: 15.h,
                child: Container(
                  decoration: BoxDecoration(
                    color: pin.length > 5 ? qoin.Get.theme.backgroundColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              SizedBox(
                width: 35.w,
                height: 4.h,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    color: qoin.Get.theme.backgroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget get label {
    if (widget.pinType == qoin.PinTypeEnum.createPin || widget.pinType == qoin.PinTypeEnum.reCreatePin) {
      return _PinLabel(
          startSentence: Localization.pinCreate.tr, endSentence: Localization.pinToSafe.tr);
    } else if (widget.pinType == qoin.PinTypeEnum.createPinConfirmation ||
        widget.pinType == qoin.PinTypeEnum.reCreatePinConfirmation) {
      return _PinLabel(startSentence: Localization.pinVerify.tr);
    } else if (widget.pinType == qoin.PinTypeEnum.login ||
        widget.pinType == qoin.PinTypeEnum.confirmationTransaction) {
      return SizedBox();
    } else {
      return _PinLabel(
          startSentence: Localization.pinEnter.tr, endSentence: Localization.pinConfirmation.tr);
    }
  }

  // _resetPin(type) async {
  //   pin.value = '';
  //   setState(() {});
  //   qoin.AccountsController.to
  //       .forgotPin(qoin.AccountsController.to.loginRecord!.phone ?? qoin.HiveData.lastAccountLogin!,
  //           onError: (error) {
  //     DialogUtils.showPopUp(
  //         type: DialogType.problem, title: Localization.pinResetFail.tr, description: error);
  //   }, onSuccess: () {
  //     qoin.Get.to(() => OtpScreen(otpType: OTPType.forgot, methodType: type));
  //   });
  // }
}

class _PinLabel extends StatelessWidget {
  final String startSentence;
  final String? endSentence;
  final bool withPin;

  _PinLabel({required this.startSentence, this.endSentence, this.withPin = true});

  @override
  Widget build(BuildContext context) {
    return RichText(
        textScaleFactor: 1.0,
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(style: TextUI.subtitleWhite.copyWith(fontSize: 16.sp), text: "$startSentence "),
          if (withPin) TextSpan(style: TextUI.subtitleWhite.copyWith(fontSize: 16.sp), text: "PIN"),
          if (endSentence != null)
            TextSpan(style: TextUI.subtitleWhite.copyWith(fontSize: 16.sp), text: " $endSentence")
        ]));
  }
}

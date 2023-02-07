import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:qoin_sdk/helpers/services/environment.dart';
import 'package:qoin_sdk/models/qoin_accounts/otp_types_mdl.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:inisa_app/ui/widget/button_image.dart';

class OtpMethodScreen extends StatelessWidget {
  final String? phone;
  final List<OtpTypesMdl> otpTypes;

  OtpMethodScreen({required this.phone, required this.otpTypes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.light(
        title: Localization.otpVerificationMethod.tr,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 64.h,
              ),
              SvgPicture.asset(
                Assets.illustrationMethodOTP,
              ),
              SizedBox(
                height: 36.h,
              ),
              Text(Localization.otpVerificationMethodTitle.tr,
                  style: TextUI.subtitleBlack),
              SizedBox(
                height: 16,
              ),
              Text(
                "${Localization.otpVerificationMethodDesc.tr} +${phone ?? AccountsController.instance.loginRecord?.phone ?? HiveData.userData?.phone ?? ''}",
                style: TextUI.bodyTextBlack,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 40,
              ),
              Column(
                children: otpTypes.map((e) {
                  Widget? icon;
                  String? text;
                  Color? bgColor;
                  Color? textColor;
                  Function()? onPressed;

                  if (e.otpType == OtpTypeEnum.IVR) {
                    icon = Image.asset(
                      Assets.iconCall,
                      color: Colors.white,
                      width: 24,
                    );
                    text = Localization.otpViaCall.tr;
                    onPressed = () {
                      // Get.back(result: e.value);
                      DialogUtils.showMainPopup(
                          imageWidget: Image.asset(
                            Assets.iconCall,
                            color: ColorUI.yellow,
                            height: 107.h,
                          ),
                          title: 'Panggilan Telepon',
                          description:
                              'Lakukan panggilan telepon untuk mendapatkan OTP, biaya panggilan akan dibebankan kepada kamu, pastikan kamu memiliki pulsa ',
                          mainButtonText: 'Telepon Sekarang',
                          mainButtonFunction: () {
                            Get.back();
                            Get.back(result: e.value);
                          });
                    };
                  } else if (e.otpType == OtpTypeEnum.CALL) {
                    icon = Image.asset(
                      Assets.iconCall,
                      color: Colors.white,
                      width: 24,
                    );
                    text = Localization.otpViaCall.tr;
                    onPressed = () {
                      Get.back(result: e.value);
                    };
                  } else if (e.otpType == OtpTypeEnum.WA) {
                    icon = Image.asset(
                      Assets.iconWhatsApp,
                      color: Colors.white,
                      width: 24,
                    );
                    text = Localization.otpViaWA.tr;
                    bgColor = Colors.green;
                    textColor = Colors.white;
                    onPressed = () {
                      Get.back(result: e.value);
                    };
                  } else if (e.otpType == OtpTypeEnum.SMS) {
                    icon = Image.asset(
                      Assets.iconMessage,
                      color: Colors.white,
                      width: 24,
                    );
                    text = Localization.otpViaSMS.tr;
                    onPressed = () {
                      Get.back(result: e.value);
                    };

                    if (EnvironmentConfig.flavor == Flavor.Production) {
                      return SizedBox();
                    }
                  } else if (e.otpType == OtpTypeEnum.JATIS) {
                    return SizedBox();
                  } else {
                    icon = Image.asset(
                      Assets.iconMessage,
                      color: Colors.white,
                      width: 24,
                    );
                    text = "-";
                    onPressed = () {
                      // Get.back(result: e.value);
                    };
                  }

                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: ButtonImage(
                      icon: icon,
                      text: text,
                      backgroundColor: bgColor,
                      textColor: textColor,
                      onPressed: onPressed,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

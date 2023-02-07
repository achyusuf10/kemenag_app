import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:inisa_app/config/inter_module.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/constans.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/screen/account/otp/otp_method_screen.dart';
import 'package:inisa_app/ui/screen/account/otp/otp_screen.dart';
import 'package:inisa_app/ui/screen/account/pin/pin_screen.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/screen/webview_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:lottie/lottie.dart';
import 'package:qoin_sdk/controllers/controllers_export.dart';
import 'package:qoin_sdk/helpers/services/environment.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'countries_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final FocusNode phoneFocus = FocusNode();
  final TextEditingController phoneController = new TextEditingController();
  final phone = ''.obs;
  var selectedCountry = Constans.dataFlags[32].obs;
  var checked = false.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bottom = MediaQuery.of(context).viewInsets.bottom;
    return ModalProgress(
      loadingStatus: AccountsController.instance.isMainLoading.stream,
      child: Scaffold(
        backgroundColor: Get.theme.primaryColor,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(0.0), // here the desired height
            child: AppBarWidget.light(
              title: '',
              elevation: 0,
            )),
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Container(
                  color: Get.theme.backgroundColor,
                  // height: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40.h,
                      ),
                      Row(
                        children: [
                          Spacer(),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              child: Image.asset(
                                Assets.inisa,
                                height: 72.h,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(vertical: 24.h),
                              margin: EdgeInsets.all(16),
                              child: Container(
                                width: 94.w,
                                height: 32.w,
                                decoration: BoxDecoration(
                                  color: Color(0xfff6f6f6),
                                  border: Border.all(
                                    color: ColorUI.border,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Get.locale ==
                                                  InterModule
                                                      .translations!.locales[0]
                                              ? ColorUI.secondary
                                              : null,
                                          borderRadius: Get.locale ==
                                                  InterModule
                                                      .translations!.locales[0]
                                              ? BorderRadius.all(
                                                  Radius.circular(4),
                                                )
                                              : BorderRadius.horizontal(
                                                  left: Radius.circular(4),
                                                  right: Radius.circular(0),
                                                ),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            InterModule.translations!
                                                .changeLocale(
                                              InterModule
                                                  .translations!.langs[0],
                                            );
                                          },
                                          child: Center(
                                            child: Text(
                                              InterModule.translations!
                                                  .locales[0].languageCode
                                                  .toUpperCase(),
                                              style:
                                                  TextUI.subtitleBlack.copyWith(
                                                color: Get.locale ==
                                                        InterModule
                                                            .translations!
                                                            .locales[0]
                                                    ? ColorUI.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Get.locale ==
                                                  InterModule
                                                      .translations!.locales[1]
                                              ? ColorUI.secondary
                                              : null,
                                          borderRadius: Get.locale ==
                                                  InterModule
                                                      .translations!.locales[1]
                                              ? BorderRadius.all(
                                                  Radius.circular(4))
                                              : BorderRadius.horizontal(
                                                  left: Radius.circular(0),
                                                  right: Radius.circular(4)),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            InterModule.translations!
                                                .changeLocale(InterModule
                                                    .translations!.langs[1]);
                                          },
                                          child: Center(
                                            child: Text(
                                              InterModule.translations!
                                                  .locales[1].languageCode
                                                  .toUpperCase(),
                                              style:
                                                  TextUI.subtitleBlack.copyWith(
                                                color: Get.locale ==
                                                        InterModule
                                                            .translations!
                                                            .locales[1]
                                                    ? Colors.white
                                                    : ColorUI.text_4,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.end,
                            //   children: [
                            //     InkWell(
                            //       onTap: () {
                            //         if (Get.locale ==
                            //             InterModule.translations!.locales[0]) {
                            //           InterModule.translations!.changeLocale(
                            //               InterModule.translations!.langs[1]);
                            //           // MenuServicesController.to.updateServices();
                            //           // engEnable.value = false;
                            //           Get.back();
                            //         } else {
                            //           InterModule.translations!.changeLocale(
                            //               InterModule.translations!.langs[0]);
                            //           // MenuServicesController.to.updateServices();
                            //           // engEnable.value = true;
                            //           Get.back();
                            //         }
                            //       },
                            //       child: Container(
                            //         width: 85.w,
                            //         padding: EdgeInsets.symmetric(
                            //             vertical: 3, horizontal: 7),
                            //         margin: EdgeInsets.all(16),
                            //         decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.all(
                            //                 Radius.circular(4)),
                            //             border: Border.all(
                            //                 color: const Color(0xffdedede),
                            //                 width: 1)),
                            //         child: Row(
                            //           mainAxisSize: MainAxisSize.min,
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.center,
                            //           children: [
                            //             Padding(
                            //               padding: Get.locale ==
                            //                       InterModule
                            //                           .translations!.locales[0]
                            //                   ? EdgeInsets.zero
                            //                   : const EdgeInsets.symmetric(
                            //                       vertical: 4),
                            //               child: Image.asset(
                            //                 Get.locale ==
                            //                         InterModule.translations!
                            //                             .locales[0]
                            //                     ? Assets.icUnitedkingdom
                            //                     : Assets.icIndonesia,
                            //                 width: 28.w,
                            //               ),
                            //             ),
                            //             SizedBox(
                            //               width: 4,
                            //             ),
                            //             Text(
                            //               Get.locale ==
                            //                       InterModule
                            //                           .translations!.locales[0]
                            //                   ? 'ENG'
                            //                   : 'IDN',
                            //               style: TextUI.subtitleBlack,
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ),
                        ],
                      ),
                      Container(
                        height: 508.h,
                        child: qoin.GetBuilder<OnboardingController>(
                            builder: (controller) {
                          return Swiper(
                            itemCount: controller.onboarding.length,
                            autoplay: true,
                            autoplayDelay: 3000,
                            physics: BouncingScrollPhysics(),
                            onIndexChanged: (index) {
                              controller.onboardingIndex = index;
                            },
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Center(
                                    child: Lottie.asset(
                                      controller.onboarding[index][0],
                                      height: 379.h,
                                      fit: BoxFit.fitHeight,
                                      repeat: false,
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Text(
                                      controller.onboarding[index][1].tr,
                                      style: TextUI.titleBlack,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Text(
                                      controller.onboarding[index][2].tr,
                                      style: TextUI.bodyTextBlack,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: OnboardingController.instance.onboarding
                            .map((item) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: GetBuilder<OnboardingController>(
                                  builder: (controller) {
                                return Container(
                                  padding: EdgeInsets.all(1.h),
                                  height: 12,
                                  width: 12,
                                  color: OnboardingController
                                              .instance.onboarding
                                              .indexOf(item) ==
                                          controller.onboardingIndex
                                      ? Colors.black
                                      : Get.theme.unselectedWidgetColor,
                                  child: OnboardingController
                                              .instance.onboarding
                                              .indexOf(item) ==
                                          controller.onboardingIndex
                                      ? Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                              color: Get.theme.backgroundColor,
                                              width: 1,
                                            ),
                                          ),
                                        )
                                      : null,
                                );
                              }),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 500,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 24.h,
                          ),
                          Text(
                            "${Localization.loginEnter.tr} ${Localization.loginPhoneNumber.tr} ${Localization.loginToContinue.tr}",
                            textAlign: TextAlign.center,
                            style: TextUI.subtitleWhite,
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          InkWell(
                            onTap: () {
                              phoneFocus.requestFocus();
                            },
                            child: Container(
                              height: 56.h,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                color: Get.theme.backgroundColor,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 12.h),
                              child: Row(
                                children: [
                                  InkResponse(
                                    onTap: () {
                                      // if (EnvironmentConfig.flavor != qoin.Flavor.Production) {
                                      DialogUtils.showGeneralDrawer(
                                          withStrip: true,
                                          radius: 24,
                                          padding: EdgeInsets.only(top: 16.h),
                                          content: Container(
                                              height:
                                                  ScreenUtil().screenHeight -
                                                      kToolbarHeight * 3,
                                              child: CountriesPage(
                                                onChange: (data) {
                                                  Get.back();
                                                  selectedCountry.value = data;
                                                },
                                              )));
                                      // }
                                    },
                                    child: Obx(
                                      () => Row(
                                        children: [
                                          Image.asset(
                                            selectedCountry.value.image!,
                                            fit: BoxFit.fill,
                                            height: 24.h,
                                          ),
                                          // if (EnvironmentConfig.flavor != qoin.Flavor.Production)
                                          Icon(
                                            Icons.arrow_drop_down,
                                            color: ColorUI.primary,
                                          ),
                                          SizedBox(
                                            width: 4.w,
                                          ),
                                          Text(
                                            "+" +
                                                selectedCountry
                                                    .value.countryCode!,
                                            style: TextUI.subtitleBlack,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.h,
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: TextField(
                                        focusNode: phoneFocus,
                                        controller: phoneController,
                                        onChanged: (value) {
                                          phone.value = value;
                                        },
                                        onSubmitted: (value) async {
                                          onSubmit();
                                        },
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: InputDecoration(
                                          hintText: "8XXXXXXXXX",
                                          hintStyle: TextUI.placeHolderBlack,
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(0),
                                        ),
                                        style: TextUI.subtitleBlack,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                          bottom > 0 // && !waitForOTP
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Obx(
                                          () => Checkbox(
                                              value: checked.value,
                                              checkColor: Colors.white,
                                              activeColor: Colors.amber,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              visualDensity: VisualDensity(
                                                vertical: -4,
                                                horizontal: -4,
                                              ),
                                              onChanged: (value) async {
                                                if (checked.value == false) {
                                                  checked.value = true;
                                                } else {
                                                  checked.value = false;
                                                }
                                              }),
                                        ),
                                        SizedBox(
                                          width: 16.w,
                                        ),
                                        Expanded(
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: Localization
                                                      .loginAgree.tr,
                                                ),
                                                TextSpan(
                                                  text:
                                                      " ${Localization.buttonTermAndCondition.tr} ",
                                                  style: TextUI.bodyText2Yellow
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                  recognizer:
                                                      new TapGestureRecognizer()
                                                        ..onTap = () {
                                                          qoin.Get.to(() =>
                                                              WebViewScreen(
                                                                linkUrl:
                                                                    'https://www.inisa.id/ketentuan-layanan/',
                                                                title: Localization
                                                                    .buttonTermAndCondition
                                                                    .tr,
                                                              ));
                                                        },
                                                ),
                                                TextSpan(
                                                  text:
                                                      "${Localization.and.tr} ",
                                                ),
                                                TextSpan(
                                                  text: Localization
                                                      .buttonPrivacyPolicy.tr,
                                                  style: TextUI.bodyText2Yellow
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                  recognizer:
                                                      new TapGestureRecognizer()
                                                        ..onTap = () {
                                                          qoin.Get.to(() =>
                                                              WebViewScreen(
                                                                linkUrl:
                                                                    'https://www.inisa.id/kebijakan-privasi/',
                                                                title: Localization
                                                                    .buttonPrivacyPolicy
                                                                    .tr,
                                                              ));
                                                        },
                                                ),
                                              ],
                                            ),
                                            style: TextUI.bodyText2White,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 24.h,
                                    ),
                                    Obx(
                                      () => MainButton(
                                          text: Localization.buttonContinue.tr,
                                          onPressed: phone.value.length >= 9 &&
                                                  phone.value.length <= 18 &&
                                                  checked.value
                                              ? () async {
                                                  onSubmit();
                                                }
                                              : null),
                                    ),
                                    SizedBox(
                                      height: 32.h,
                                    )
                                  ],
                                )
                              : SizedBox(),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onSubmit() async {
    phoneFocus.unfocus();

    String _phone = qoin.Utils.phoneNumberConvertDev(
        phoneController.text, selectedCountry.value.countryCode!);
    debugPrint("phone: $_phone");

    qoin.AccountsFlowController.instance.loginFlow(
      isBypassOtp: Constans.demoPhoneNumbers.contains(_phone) ? true : false,
      // isBypassOtp: true,
      maxOtpReq:
          3, // ini masih belum jalan kalo satu alur tadi, marked untuk dipastikan lagi
      phoneNumber: _phone,
      otpMethodScreen: (phone, otpTypes) => OtpMethodScreen(
        phone: phone,
        otpTypes: otpTypes,
      ),
      otpInputScreen: (fSubmit, fResend, fTryOtherMethod, otpType) {
        return OtpScreen(
          otpType: otpType,
          resendOtp: fResend,
          submitOtp: fSubmit,
        );
      },
      inputPinScreen: (pinType, functionSubmit) => PinScreen(
        pinType: pinType,
        functionSubmit: functionSubmit,
      ),
      homeScreen: HomeScreen(),
      isDeletedUser: () {
        DialogUtils.showMainPopup(
          image: Assets.warning,
          title: 'Akun Terhapus',
          description:
              'Anda telah menghapus akun anda sebelumnya. Harap hubungi CS untuk mengaktifkan akun kembali.',
          mainButtonText: Localization.close.tr,
          mainButtonFunction: () {
            Get.back();
          },
        );
      },
      onOtpMaxReq: () {
        DialogUtils.showMainPopup(
            description: Localization.otpMaxWarning.tr,
            mainButtonText: Localization.ok.tr,
            mainButtonFunction: () {
              Get.back();
            });
      },
      onFailedCheckPhone: (errorMessage) {
        DialogUtils.showPopUp(type: DialogType.problem, title: errorMessage);
        debugPrint("error onFailedCheckPhone: $errorMessage");
      },
      onFailedOtpExpired: () {
        // no set, will be set on otp screen or create a var in controller later
        qoin.AccountsController.instance.otpError = Localization.otpExpired.tr;
        debugPrint("error onFailedOtpExpired");
      },
      onFailedOtpNotMatch: () {
        // no set, will be set on otp screen or create a var in controller later
        qoin.AccountsController.instance.otpError = Localization.otpNotMatch.tr;
        debugPrint("error onFailedOtpNotMatch");
      },
      onErrorPinNotMatch: (errorMessage) {
        qoin.PinController.instance.pinError = Localization.pinNotMatched.tr;
        // or you can trigger popup here
        debugPrint("error onErrorPinNotMatch: $errorMessage");
      },
      onErrorWrongPin: (errorMessage) {
        // marked
        qoin.PinController.instance.pinError = Localization.pinNotMatched.tr;
        // or you can trigger popup here
        debugPrint("error onErrorWrongPin: $errorMessage");
      },
      onErrorOffline: () {
        DialogUtils.showPopUp(type: DialogType.noInternet);
        debugPrint("error onErrorOffline");
      },
      onErrorProblem: (errorMessage) {
        DialogUtils.showPopUp(type: DialogType.problem);
        debugPrint("error onErrorProblem: $errorMessage");
      },
      onErrorOther: (errorMessage) {
        DialogUtils.showPopUp(type: DialogType.problem, title: errorMessage);
        debugPrint("error onErrorOther: $errorMessage");
      },
      onFailedValidateJatis: (fOtherMethod, fTryAgain) {},
    );
  }
}

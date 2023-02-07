import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/screen/account/pin/pin_screen.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/widget/button_bottom.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:inisa_app/helper/regex_rule.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/profile/pp_widget.dart';
import 'package:inisa_app/ui/widget/profile/profile_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qoin_sdk/models/qoin_accounts/file_upload_result.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  Rx<FileUploadResult> pic = FileUploadResult(
          fileName: "",
          base64Value: qoin.AccountsController.instance.userData?.pict)
      .obs;

  qoin.RxBool emailFieldActive = false.obs;
  FocusNode emailFocus = FocusNode();
  ScrollController _scrollController = new ScrollController();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  var emailTextController = TextEditingController();
  var fullnameTextController = TextEditingController();
  var email = ''.obs;
  var fullName = ''.obs;
  bool _onReq = false;
  bool _isEditEmailSuccess = false;
  var _modalProgress = false.obs;

  @override
  void initState() {
    super.initState();
    // pic.value = FileUploadResult(fileName: "", base64Value: qoin.AccountsController.instance.userData?.pict);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _onInit();
    });
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  _onInit() {
    emailTextController.text =
        qoin.AccountsController.instance.userData?.email ?? '';
    email.value = qoin.AccountsController.instance.userData?.email ?? '';
    fullnameTextController.text =
        qoin.AccountsController.instance.userData?.fullname ?? '';
    fullName.value = qoin.AccountsController.instance.userData?.fullname ?? '';
    emailFieldActive.value = false;
    emailFocus.unfocus();
    _checkRemaining();
  }

  void _onRefresh() async {
    await qoin.AccountsController.instance.getProfile(onSuccess: () {
      _onReq = false;
    }, onError: (error) {
      _onReq = false;
    });
    _onInit();
    _refreshController.refreshCompleted();
  }

  _checkRemaining() {
    if (qoin.AccountsController.instance.userData?.emailConfirmed ??
        qoin.HiveData.userData!.emailConfirmed!) {
      qoin.AccountsController.instance.resumeTimerEmail(isStop: true);
    } else {
      qoin.AccountsController.instance.resumeTimerEmail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: qoin.AccountsController.instance.isMainLoading.stream,
      child: Scaffold(
        backgroundColor: ColorUI.shape,
        appBar: AppBarWidget.light(
          title: Localization.editProfile.tr,
        ),
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          scrollController: _scrollController,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Column(
                    children: [
                      Center(
                        child: Obx(
                          () => PPWidget(
                            value: pic.value,
                            onChanged: (val) {
                              if (val != null) {
                                qoin.AccountsController.instance
                                    .uploadPhotoProfile(val, onError: (error) {
                                  DialogUtils.showMainPopup(
                                    image: Assets.warning,
                                    title:
                                        Localization.uploadPhotoFailedTitle.tr,
                                    secondaryButtonText: Localization.close.tr,
                                    secondaryButtonFunction: () {
                                      qoin.Get.back();
                                    },
                                  );
                                }, onSuccess: () {
                                  pic.value = val;
                                  DialogUtils.showMainPopup(
                                    animation: Assets.successAnimation,
                                    title:
                                        Localization.uploadPhotoSuccessTitle.tr,
                                    mainButtonText: Localization.close.tr,
                                    mainButtonFunction: () {
                                      qoin.Get.back();
                                    },
                                  );
                                  qoin.Get.forceAppUpdate();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    color: ColorUI.shape,
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 16.0, bottom: 8.0),
                    child: Text(
                      Localization.labelAccount.tr.toUpperCase(),
                      style: TextUI.bodyText2Grey,
                    )),
                Form(
                  key: _formKey,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffdedede)),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        qoin.GetBuilder<qoin.AccountsController>(
                            builder: (controller) {
                          return ProfileItem(
                            assetImage: Assets.qoin,
                            initialValue: controller.userData?.qoinTag ??
                                qoin.HiveData.userData?.qoinTag ??
                                "-",
                            labelText: 'Qointag',
                            profileStatus: true,
                            hintText: Localization.editProfileNameOnId.tr,
                            readOnly: true,
                            onTap: () {},
                          );
                        }),
                        qoin.GetBuilder<qoin.AccountsController>(
                            builder: (controller) {
                          return ProfileItem(
                            assetImage: Assets.iconAkun,
                            controller: fullnameTextController,
                            initialValue: controller.userData?.fullname ??
                                qoin.HiveData.userData?.fullname ??
                                fullnameTextController.text,
                            labelText: Localization.editProfileNameOnId.tr,
                            hintText: Localization.editProfileNameOnId.tr,
                            onTap: () {
                              emailFieldActive.value = false;
                              emailFocus.unfocus();
                            },
                            readOnly: controller.userData?.nameConfirmed ??
                                qoin.HiveData.userData?.nameConfirmed ??
                                false,
                            profileStatus: controller.userData?.nameConfirmed ??
                                qoin.HiveData.userData?.nameConfirmed ??
                                false,
                            onChange: (value) => fullName.value = value,
                          );
                        }),
                        qoin.GetBuilder<qoin.AccountsController>(
                            builder: (controller) {
                          return ProfileItem(
                            assetImage: Assets.iconPhoneNumber,
                            initialValue: controller.userData?.phone ??
                                qoin.HiveData.userData?.phone ??
                                "-",
                            labelText: Localization.handphoneNumber.tr,
                            hintText: Localization.enterYourPhoneNumber.tr,
                            validation: [
                              RegexRule.emptyValidationRule,
                              RegexRule.numberValidationRule
                            ],
                            readOnly: true,
                            profileStatus: true,
                          );
                        }),
                        qoin.MixinBuilder<qoin.AccountsController>(
                            builder: (controller) {
                          return !emailFieldActive.value
                              ? ProfileItem(
                                  assetImage: Assets.iconMail,
                                  onTap: () async {
                                    // emailFieldActive.value = true;
                                    // emailFocus.requestFocus();
                                    // await Future.delayed(
                                    //     Duration(milliseconds: 600),
                                    //     () => _scrollController.jumpTo(
                                    //           _scrollController
                                    //               .position.maxScrollExtent,
                                    //         ));
                                  },
                                  initialValue: controller.userData?.email ??
                                      qoin.HiveData.userData?.email ??
                                      emailTextController.text,
                                  controller: emailTextController,
                                  labelText: 'Email',
                                  hintText: Localization.enterYourEmail.tr,
                                  validator: (String? value) {
                                    String? error;
                                    if (value!.length == 0) {
                                      return null;
                                    } else {
                                      qoin.RegexValidation validation =
                                          RegexRule.emailValidationRule;
                                      RegExp regExp =
                                          new RegExp(validation.regex);
                                      if (!regExp.hasMatch(value)) {
                                        error = validation.errorMesssage;
                                      }
                                    }
                                    return error;
                                  },
                                  profileStatus: controller
                                          .userData?.emailConfirmed ??
                                      qoin.HiveData.userData?.emailConfirmed ??
                                      false,
                                  onChange: (value) => email.value = value,
                                  // readOnly: controller.otpCountdown.value == 0
                                  //     ? false
                                  //     : true,

                                  readOnly: true,
                                  // statusWidget: Row(
                                  //   children: [
                                  //     if ((controller.userData
                                  //                     ?.emailConfirmed ??
                                  //                 qoin.HiveData.userData
                                  //                     ?.emailConfirmed ??
                                  //                 false) ==
                                  //             false &&
                                  //         controller.userData?.email != null)
                                  //       InkWell(
                                  //         onTap:
                                  //             controller.otpCountdown.value ==
                                  //                         0 &&
                                  //                     controller.userData
                                  //                             ?.email !=
                                  //                         null
                                  //                 ? () {
                                  //                     DialogUtils
                                  //                         .showVerificationDrawer(
                                  //                             image: Assets
                                  //                                 .sendingEmail,
                                  //                             imageHeight:
                                  //                                 192.0,
                                  //                             title: Localization
                                  //                                 .titleDidNotGetEmail
                                  //                                 .tr,
                                  //                             description:
                                  //                                 '${Localization.descDidNotGetEmail.tr} ${controller.userData?.email ?? qoin.HiveData.userData?.email ?? "-"}',
                                  //                             positiveText:
                                  //                                 Localization
                                  //                                     .otpSend
                                  //                                     .tr,
                                  //                             onTapPositive:
                                  //                                 () async {
                                  //                               qoin.Get.back();
                                  //                               controller
                                  //                                   .editProfile(
                                  //                                 email: controller
                                  //                                         .userData
                                  //                                         ?.email ??
                                  //                                     qoin
                                  //                                         .HiveData
                                  //                                         .userData
                                  //                                         ?.email,
                                  //                                 isResend:
                                  //                                     true,
                                  //                                 onSuccess:
                                  //                                     (isNikChanged,
                                  //                                         isEmailSuccess) {
                                  //                                   _isEditEmailSuccess =
                                  //                                       isEmailSuccess;
                                  //                                   if (isEmailSuccess) {
                                  //                                     DialogUtils.showEmailVerificationPopUp(
                                  //                                         title: Localization
                                  //                                             .titleEmailHasBeenSent
                                  //                                             .tr);
                                  //                                   } else {}
                                  //                                 },
                                  //                                 onFailedEditEmail:
                                  //                                     (error) {
                                  //                                   debugPrint(
                                  //                                       "onFailedEditEmail: $error");
                                  //                                   if (error ==
                                  //                                           "not available" ||
                                  //                                       error.toLowerCase() ==
                                  //                                           "The Email has already been taken".toLowerCase()) {
                                  //                                     DialogUtils.showPopUp(
                                  //                                         type: DialogType.emailUsed,
                                  //                                         buttonFunction: () {
                                  //                                           qoin.Get.back();
                                  //                                           emailFieldActive.value =
                                  //                                               true;
                                  //                                           emailFocus.requestFocus();
                                  //                                         });
                                  //                                   } else {
                                  //                                     DialogUtils.showPopUp(
                                  //                                         type:
                                  //                                             DialogType.problem);
                                  //                                   }
                                  //                                 },
                                  //                                 onFailedEditNikAndName:
                                  //                                     (error) {
                                  //                                   debugPrint(
                                  //                                       "onFailedEditNikAndName: $error");
                                  //                                   DialogUtils.showPopUp(
                                  //                                       type: DialogType
                                  //                                           .problem);
                                  //                                 },
                                  //                               );
                                  //                             },
                                  //                             negativeText:
                                  //                                 Localization
                                  //                                     .maybeLater
                                  //                                     .tr,
                                  //                             onTapNegative:
                                  //                                 () => qoin.Get
                                  //                                     .back(),
                                  //                             mainPopupButtonDirection:
                                  //                                 MainPopupButtonDirection
                                  //                                     .Horizontal);
                                  //                   }
                                  //                 : null,
                                  //         child: Text(Localization.editProfileVerifEmail.tr,
                                  //             style: qoin
                                  //                 .Get.theme.textTheme.bodyText1!
                                  //                 .copyWith(
                                  //                     color: controller
                                  //                                 .otpCountdown
                                  //                                 .value ==
                                  //                             0
                                  //                         ? qoin
                                  //                             .Get
                                  //                             .theme
                                  //                             .colorScheme
                                  //                             .secondary
                                  //                         : qoin.Get.theme
                                  //                             .disabledColor,
                                  //                     fontWeight: controller
                                  //                                 .otpCountdown
                                  //                                 .value ==
                                  //                             0
                                  //                         ? FontWeight.bold
                                  //                         : FontWeight.normal,
                                  //                     decoration: TextDecoration
                                  //                         .underline)),
                                  //       ),
                                  //     controller.otpCountdown.value != 0
                                  //         ? qoin.Obx(() => Text(
                                  //             ' ' +
                                  //                 formatHHMMSS(controller
                                  //                     .otpCountdown.value),
                                  //             style: TextUI.bodyText2Black
                                  //                 .copyWith(
                                  //                     fontWeight:
                                  //                         FontWeight.w600)))
                                  //         : SizedBox()
                                  //   ],
                                  // ),
                                )
                              : qoin.GetBuilder<qoin.AccountsController>(
                                  builder: (controller) {
                                  return ProfileItem(
                                    assetImage: Assets.iconMail,
                                    focusNode: emailFocus,
                                    onTap: () async {
                                      // await Future.delayed(
                                      //     Duration(milliseconds: 600),
                                      //     () => _scrollController.jumpTo(
                                      //           _scrollController
                                      //               .position.maxScrollExtent,
                                      //         ));
                                    },
                                    initialValue: controller.userData?.email ??
                                        qoin.HiveData.userData?.email ??
                                        emailTextController.text,
                                    controller: emailTextController,
                                    labelText: 'Email',
                                    hintText: Localization.enterYourEmail.tr,
                                    validator: (String? value) {
                                      String? error;
                                      if (value!.length == 0) {
                                        return null;
                                      } else {
                                        qoin.RegexValidation validation =
                                            RegexRule.emailValidationRule;
                                        RegExp regExp =
                                            new RegExp(validation.regex);
                                        if (!regExp.hasMatch(value)) {
                                          error = validation.errorMesssage;
                                        }
                                      }
                                      return error;
                                    },
                                    onChange: (value) => email.value = value,
                                    // readOnly: controller.otpCountdown.value == 0
                                    //     ? false
                                    //     : true,
                                    readOnly: true,

                                    // statusWidget: Row(
                                    //   children: [
                                    //     if ((controller.userData
                                    //                     ?.emailConfirmed ??
                                    //                 qoin.HiveData.userData
                                    //                     ?.emailConfirmed ??
                                    //                 false) ==
                                    //             false &&
                                    //         controller.userData?.email != null)
                                    //       InkWell(
                                    //         onTap: controller.otpCountdown
                                    //                         .value ==
                                    //                     0 &&
                                    //                 (controller.userData!
                                    //                             .email ??
                                    //                         qoin
                                    //                             .HiveData
                                    //                             .userData
                                    //                             ?.email) !=
                                    //                     null
                                    //             ? () {
                                    //                 DialogUtils
                                    //                     .showVerificationDrawer(
                                    //                         image: Assets
                                    //                             .sendingEmail,
                                    //                         imageHeight: 192.0,
                                    //                         title: Localization
                                    //                             .titleDidNotGetEmail
                                    //                             .tr,
                                    //                         description:
                                    //                             '${Localization.descDidNotGetEmail.tr} ${controller.userData?.email ?? qoin.HiveData.userData?.email}',
                                    //                         positiveText:
                                    //                             Localization
                                    //                                 .resendEmailVerification
                                    //                                 .tr,
                                    //                         onTapPositive:
                                    //                             () async {
                                    //                           qoin.Get.back();
                                    //                           controller
                                    //                               .editProfile(
                                    //                             email: controller
                                    //                                     .userData
                                    //                                     ?.email ??
                                    //                                 qoin
                                    //                                     .HiveData
                                    //                                     .userData
                                    //                                     ?.email,
                                    //                             isResend: true,
                                    //                             onSuccess:
                                    //                                 (isNikChanged,
                                    //                                     isEmailSuccess) {
                                    //                               _isEditEmailSuccess =
                                    //                                   isEmailSuccess;
                                    //                               if (isEmailSuccess) {
                                    //                                 DialogUtils.showEmailVerificationPopUp(
                                    //                                     title: Localization
                                    //                                         .titleEmailHasBeenSent
                                    //                                         .tr);
                                    //                               } else {}
                                    //                             },
                                    //                             onFailedEditEmail:
                                    //                                 (error) {
                                    //                               debugPrint(
                                    //                                   "onFailedEditEmail: $error");
                                    //                               if (error ==
                                    //                                       "not available" ||
                                    //                                   error.toLowerCase() ==
                                    //                                       "The Email has already been taken"
                                    //                                           .toLowerCase()) {
                                    //                                 DialogUtils.showPopUp(
                                    //                                     type: DialogType.emailUsed,
                                    //                                     buttonFunction: () {
                                    //                                       qoin.Get
                                    //                                           .back();
                                    //                                       emailFieldActive.value =
                                    //                                           true;
                                    //                                       emailFocus
                                    //                                           .requestFocus();
                                    //                                     });
                                    //                               } else {
                                    //                                 DialogUtils.showPopUp(
                                    //                                     type: DialogType
                                    //                                         .problem);
                                    //                               }
                                    //                             },
                                    //                             onFailedEditNikAndName:
                                    //                                 (error) {
                                    //                               debugPrint(
                                    //                                   "onFailedEditNikAndName: $error");
                                    //                               DialogUtils.showPopUp(
                                    //                                   type: DialogType
                                    //                                       .problem);
                                    //                             },
                                    //                           );
                                    //                         },
                                    //                         negativeText:
                                    //                             Localization
                                    //                                 .maybeLater
                                    //                                 .tr,
                                    //                         onTapNegative: () =>
                                    //                             qoin.Get.back(),
                                    //                         mainPopupButtonDirection:
                                    //                             MainPopupButtonDirection
                                    //                                 .Horizontal);
                                    //               }
                                    //             : null,
                                    //         child: Text(
                                    //           Localization
                                    //               .editProfileVerifEmail.tr,
                                    //           style:
                                    //               TextUI.bodyText2Black.copyWith(
                                    //                   color: controller
                                    //                               .otpCountdown
                                    //                               .value ==
                                    //                           0
                                    //                       ? qoin
                                    //                           .Get
                                    //                           .theme
                                    //                           .colorScheme
                                    //                           .secondary
                                    //                       : qoin.Get.theme
                                    //                           .disabledColor,
                                    //                   fontWeight: controller
                                    //                               .otpCountdown
                                    //                               .value ==
                                    //                           0
                                    //                       ? FontWeight.bold
                                    //                       : FontWeight.normal,
                                    //                   decoration: TextDecoration
                                    //                       .underline),
                                    //         ),
                                    //       ),
                                    //     controller.otpCountdown.value != 0
                                    //         ? qoin.Obx(() => Text(
                                    //             ' ' +
                                    //                 formatHHMMSS(controller
                                    //                     .otpCountdown.value),
                                    //             style: TextUI.bodyText2Black
                                    //                 .copyWith(
                                    //                     fontWeight:
                                    //                         FontWeight.w600)))
                                    //         : SizedBox()
                                    //   ],
                                    // ),
                                  );
                                });
                        })
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 100.h,
                )
              ],
            ),
          ),
        ),
        bottomSheet:
            qoin.GetBuilder<qoin.AccountsController>(builder: (controller) {
          return qoin.Obx(() {
            if ((fullName.value !=
                        (controller.userData?.fullname ??
                            qoin.HiveData.userData?.fullname) &&
                    fullName.value != "") ||
                (email.value !=
                        (controller.userData?.email ??
                            qoin.HiveData.userData?.email) &&
                    email.value != "")) {
              return ButtonBottom(
                text: Localization.save.tr,
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  bool? validation = _formKey.currentState?.validate();
                  if (validation == true) {
                    qoin.AccountsFlowController.instance.editProfileFlow(
                      // isPrototype: true,
                      fullName: fullName.value,
                      email: email.value,
                      inputPinScreen: (pinType, functionSubmit) => PinScreen(
                        pinType: pinType,
                        functionSubmit: functionSubmit,
                      ),
                      homeScreen: HomeScreen(),
                      onSuccess: (isNikChange, isEmailSuccess) {
                        _isEditEmailSuccess = isEmailSuccess;
                        isEmailSuccess
                            ? DialogUtils.showEmailVerificationPopUp()
                            : DialogUtils.showMainPopup(
                                animation: Assets.successAnimation,
                                title:
                                    Localization.changeProfileSuccessTitle.tr,
                                mainButtonText: Localization.close.tr,
                                mainButtonFunction: () {
                                  qoin.Get.back();
                                });
                      },
                      onErrorEditNikOrName: (error) =>
                          DialogUtils.showPopUp(type: DialogType.problem),
                      onErrorEditEmail: (error) {
                        if (error == "not available" ||
                            error.toLowerCase() ==
                                "The Email has already been taken"
                                    .toLowerCase()) {
                          DialogUtils.showPopUp(
                              type: DialogType.emailUsed,
                              buttonFunction: () {
                                qoin.Get.back();
                                emailFieldActive.value = true;
                                emailFocus.requestFocus();
                              });
                        } else {
                          DialogUtils.showPopUp(type: DialogType.problem);
                        }
                      },
                      onErrorPinNotMatch: (errorMessage) {
                        qoin.PinController.instance.pinError =
                            Localization.pinNotMatched.tr;
                        debugPrint("eeror onErrorPinNotMatch: $errorMessage");
                      },
                      onErrorWrongPin: (errorMessage) {
                        DialogUtils.showPopUp(
                            type: DialogType.problem, title: errorMessage);
                        debugPrint("eeror onErrorWrongPin: $errorMessage");
                      },
                      onErrorOffline: () {
                        DialogUtils.showPopUp(type: DialogType.noInternet);
                        debugPrint("eeror onErrorOffline");
                      },
                      onErrorProblem: (errorMessage) {
                        DialogUtils.showPopUp(
                            type: DialogType.problem, title: errorMessage);
                        debugPrint("eeror onErrorProblem: $errorMessage");
                      },
                      onErrorOther: (errorMessage) {
                        DialogUtils.showPopUp(
                            type: DialogType.problem, title: errorMessage);
                        debugPrint("eeror onErrorOther: $errorMessage");
                      },
                    );
                  }
                },
              );
            } else
              return SizedBox();
          });
        }),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if ((_isEditEmailSuccess && !_onReq) ||
          (qoin.AccountsController.instance.otpCountdown.value != 0 &&
              !_onReq &&
              !qoin.AccountsController.instance.userData!.emailConfirmed!)) {
        _onReq = true;
        _onRefresh();
      }
    }
  }
}

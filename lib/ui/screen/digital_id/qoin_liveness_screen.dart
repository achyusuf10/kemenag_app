import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/button_secondary.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/models/qoin_digitalid/liveness_data.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum LivenessType { KTP, SIM, Passport }

class QoinLivenessScreen extends StatelessWidget {
  final String livenessImage;
  final LivenessType livenessType;
  QoinLivenessScreen({
    Key? key,
    required this.livenessImage,
    this.livenessType = LivenessType.KTP,
  }) : super(key: key);

  final RxBool loadingStatus = false.obs;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (loadingStatus.value) {
          return false;
        } else {
          return true;
        }
      },
      child: ModalProgress(
        loadingStatus: loadingStatus.stream,
        text: DigitalIdLocalization.messageLoading.tr,
        child: Scaffold(
          appBar: AppBarWidget(
            title: DigitalIdLocalization.headerWizardDataVerification.tr,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 40, 24, 32),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.memory(
                      base64Decode(livenessImage),
                      width: 363.w,
                      height: 400.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
                  child: Column(
                    children: [
                      Text(
                        DigitalIdLocalization.faceVerificationResult.tr,
                        style: TextUI.subtitleBlack,
                      ),
                      SizedBox(height: 16.w),
                      Text(
                        DigitalIdLocalization.faceVerificationAsk.tr,
                        style: TextUI.bodyTextBlack,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.w),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: SecondaryButton(
                            text:
                                DigitalIdLocalization.faceVerificationReshot.tr,
                            onPressed: () {
                              Get.back();
                            },
                          )),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: MainButton(
                              onPressed: () async {
                                loadingStatus.value = true;
                                HiveData.userDataLiveness = LivenessData(
                                  base64image: livenessImage,
                                  createdDate: DateTime.now().toString(),
                                );
                                DigitalIdController.instance.image =
                                    livenessImage;
                                // if (DigitalIdController
                                //             .instance.data.cardType !=
                                //         CardCode.ktpCardType &&
                                //     DigitalIdController
                                //             .instance.data.cardType !=
                                //         CardCode.simCardType &&
                                //     DigitalIdController
                                //             .instance.data.cardType !=
                                //         CardCode.passportCardType) {
                                //   loadingStatus.value = false;
                                //   DialogUtils.showMainPopup(
                                //       image: Assets.icAddG20,
                                //       title:
                                //           "${DigitalIdLocalization.idTypeG20Card.tr} ${DigitalIdLocalization.messageDocSuccessVerification.tr}",
                                //       mainButtonText: DigitalIdLocalization
                                //           .buttonSuccessVerification.tr,
                                //       mainButtonFunction: () {
                                //         Get.offAll(() => HomeScreen(),
                                //             binding: OnloginBindings());
                                //       });
                                //   return;
                                // }
                                await LivenessController.instance.verify(
                                  onSuccess: (data) {
                                    loadingStatus.value = false;
                                    if (data?.docCardType ==
                                        CardCode.ktpCardType.toString()) {
                                      DialogUtils.showMainPopup(
                                          image: Assets.icAddKTP,
                                          title:
                                              "${DigitalIdLocalization.idTypeKTP.tr} ${DigitalIdLocalization.messageDocSuccessVerification.tr}",
                                          mainButtonText: DigitalIdLocalization
                                              .buttonSuccessVerification.tr,
                                          mainButtonFunction: () {
                                            Get.offAll(() => HomeScreen(),
                                                binding: OnloginBindings());
                                          });
                                    } else if (data?.docCardType ==
                                        CardCode.simCardType.toString()) {
                                      DialogUtils.showMainPopup(
                                          image: Assets.icAddSIM,
                                          title:
                                              "${DigitalIdLocalization.idTypeSimCard.tr} ${DigitalIdLocalization.messageDocSuccessVerification.tr}",
                                          mainButtonText: DigitalIdLocalization
                                              .buttonSuccessVerification.tr,
                                          mainButtonFunction: () {
                                            Get.offAll(() => HomeScreen(),
                                                binding: OnloginBindings());
                                          });
                                    } else if (data?.docCardType ==
                                        CardCode.passportCardType.toString()) {
                                      DialogUtils.showMainPopup(
                                          image: Assets.icAddPassport,
                                          title:
                                              "${DigitalIdLocalization.idTypePassport.tr} ${DigitalIdLocalization.messageDocSuccessVerification.tr}",
                                          mainButtonText: DigitalIdLocalization
                                              .buttonSuccessVerification.tr,
                                          mainButtonFunction: () {
                                            Get.offAll(() => HomeScreen(),
                                                binding: OnloginBindings());
                                          });
                                    } else if (data?.docCardType ==
                                        CardCode.g20CardType.toString()) {
                                      DialogUtils.showMainPopup(
                                          image: Assets.icAddG20,
                                          title:
                                              "${DigitalIdLocalization.idTypeG20Card.tr} ${DigitalIdLocalization.messageDocSuccessVerification.tr}",
                                          mainButtonText: DigitalIdLocalization
                                              .buttonSuccessVerification.tr,
                                          mainButtonFunction: () {
                                            Get.offAll(() => HomeScreen(),
                                                binding: OnloginBindings());
                                          });
                                    } else {
                                      DialogUtils.showMainPopup(
                                          image: Assets.icAddSIM,
                                          title:
                                              "${DigitalIdLocalization.document.tr} ${DigitalIdLocalization.messageDocSuccessVerification.tr}",
                                          mainButtonText: DigitalIdLocalization
                                              .buttonSuccessVerification.tr,
                                          mainButtonFunction: () {
                                            Get.offAll(() => HomeScreen(),
                                                binding: OnloginBindings());
                                          });
                                    }
                                  },
                                  onFailed: (error) {
                                    loadingStatus.value = false;
                                    if (error == '500') {
                                      DialogUtils.showPopUp(
                                        type: DialogType.problem,
                                        description: DigitalIdLocalization
                                            .messageWeStillFixingIt.tr,
                                        buttonText: Localization.close.tr,
                                      );
                                      return;
                                    } else if (error ==
                                            'The Doc Number has been registered' ||
                                        error ==
                                            'The document number has been registered') {
                                      DialogUtils.showPopUp(
                                        type: DialogType.problem,
                                        title: Localization.somethingWrong.tr,
                                        description:
                                            "${livenessType == LivenessType.KTP ? DigitalIdLocalization.idTypeKTP.tr : livenessType == LivenessType.SIM ? DigitalIdLocalization.idTypeSimCard.tr : DigitalIdLocalization.idTypePassport.tr} ${DigitalIdLocalization.messageDocIsRegistered1.tr} ${livenessType == LivenessType.KTP ? DigitalIdLocalization.idTypeKTP.tr : livenessType == LivenessType.SIM ? DigitalIdLocalization.idTypeSimCard.tr : DigitalIdLocalization.idTypePassport.tr} ${DigitalIdLocalization.messageDocIsRegistered2.tr}",
                                        buttonText: Localization.close.tr,
                                      );
                                      return;
                                    } else if (error == 'Compare face failed') {
                                      DialogUtils.showPopUp(
                                        type: DialogType.problem,
                                        description: DigitalIdLocalization
                                            .messageErrorCompareFace.tr,
                                        buttonText: Localization.close.tr,
                                      );
                                      return;
                                    } else if (error == 'relogin') {
                                      IntentTo.sessionExpired();
                                      return;
                                    } else {
                                      DialogUtils.showPopUp(
                                        type: DialogType.problem,
                                        description: DigitalIdLocalization
                                            .messageWeStillFixingIt.tr,
                                        buttonText: Localization.close.tr,
                                      );
                                      return;
                                    }
                                  },
                                );
                              },
                              text: DigitalIdLocalization.livenessButtonUse.tr,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

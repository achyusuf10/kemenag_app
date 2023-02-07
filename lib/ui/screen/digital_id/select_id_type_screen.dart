import 'package:flutter/gestures.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/logic/controller/digitalid/digital_archive_ui_controller.dart';
import 'package:inisa_app/ui/screen/account/profile/profile_screen.dart';
import 'package:inisa_app/ui/screen/webview_screen.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/controllers/qoin_digitalid/digitalid_controller.dart';
import 'package:qoin_sdk/controllers/qoin_digitalid/doc_controller.dart';
import 'package:qoin_sdk/helpers/services/environment.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/expand_title_widget.dart';
// import 'package:venturo_mobile/digitalisasi_tni/logic/controllers/digitalisasi_tni_controller.dart';
// import 'package:venturo_mobile/digitalisasi_tni/screens/digitalisasi_tni_detail_screen.dart';
// import 'package:venturo_mobile/digitalisasi_tni/screens/digitalisasi_tni_form_screen.dart';
// import 'package:venturo_mobile/relawan_jokowi/logic/controllers/relawan_jokowi_controller.dart';
// import 'package:venturo_mobile/relawan_jokowi/ui/screens/relawan_jokowi_screen.dart';
import 'package:qoin_sdk/helpers/utils/hive_data.dart';
// import 'package:venturo_mobile/shared_inisa/inisa_venturo_methods.dart';
import 'detail_digital_doc_screen.dart';
import 'form_namecard_screen.dart';
import 'list_card/list_cards_screen.dart';
import 'ocr_guide_screen.dart';

class SelectIdTypeScreen extends StatelessWidget {
  const SelectIdTypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    qoin.Get.put(DocController());
    // qoin.Get.put(DigitalisasiTniController());
    List<Map<String, dynamic>> ktpExpandItem = [
      {
        "image": Assets.icUnlock,
        "title": DigitalIdLocalization.ktpBenefitNote1Title.tr,
        "subtitle": DigitalIdLocalization.ktpBenefitNote1Desc.tr
      },
      {
        "image": Assets.icBalanceLimit,
        "title": DigitalIdLocalization.ktpBenefitNote2Title.tr,
        "subtitle": DigitalIdLocalization.ktpBenefitNote2Desc.tr
      },
      {
        "image": Assets.icEasyAndSecure,
        "title": DigitalIdLocalization.ktpBenefitNote3Title.tr,
        "subtitle": DigitalIdLocalization.ktpBenefitNote3Desc.tr
      },
      {
        "image": Assets.icMoreBenefit,
        "title": DigitalIdLocalization.ktpBenefitNote4Title.tr,
        "subtitle": DigitalIdLocalization.ktpBenefitNote4Desc.tr
      },
    ];
    return ModalProgress(
      loadingStatus: qoin.DigitalIdController.instance.isMainLoading.stream,
      child: Scaffold(
        appBar: AppBarWidget.light(
          title: DigitalIdLocalization.idAddTitle.tr,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DigitalIdLocalization.idTypeTitle.tr,
                    style: TextUI.subtitleBlack),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  DigitalIdLocalization.idTypeDesc.tr,
                  style: TextUI.bodyTextBlack,
                ),
                SizedBox(
                  height: 24.h,
                ),
                ExpandTitleWidget(
                  expanded: true,
                  image: Assets.icAddKTP,
                  title: DigitalIdLocalization.idTypeKTP.tr,
                  subtitle: DigitalIdLocalization.idTypeKTPDesc.tr,
                  list: ktpExpandItem,
                  onTap: () async {
                    if (qoin.QoinRemoteConfigController.instance
                        .isDigitalIdKtoActive) {
                      _processKTP();
                    } else {
                      DialogUtils.showComingSoonDrawer();
                    }
                  },
                ),
                SizedBox(height: 20.h),
                ExpandTitleWidget(
                  expanded: false,
                  image: Assets.icAddSIM,
                  title: DigitalIdLocalization.idTypeSimCard.tr,
                  subtitle: DigitalIdLocalization.idTypeSIMDesc.tr,
                  onTap: () async {
                    if (qoin.QoinRemoteConfigController.instance
                        .isDigitalIdSimActive) {
                      if (DocController.to.isKTPAlreadyVerified) {
                        if (!DocController.to.isSIMACardAlreadyDigitized ||
                            !DocController.to.isSIMCCardAlreadyDigitized) {
                          qoin.DigitalIdController.instance.data =
                              new RegisterDocDataFromUser();
                          qoin.DigitalIdController.instance.data.cardType =
                              qoin.CardCode.simCardType;
                          qoin.Get.to(() => OCRGuideScreen());
                        } else {
                          _showDialog(qoin.CardCode.simCardType);
                          return;
                        }
                      } else {
                        _showDialog(0);
                      }
                    } else {
                      DialogUtils.showComingSoonDrawer();
                    }
                  },
                ),
                SizedBox(height: 20.h),
                ExpandTitleWidget(
                  expanded: false,
                  image: Assets.icAddPassport,
                  title: DigitalIdLocalization.idTypePassport.tr,
                  subtitle: DigitalIdLocalization.idTypePassportDesc.tr,
                  onTap: () async {
                    if (qoin.QoinRemoteConfigController.instance
                        .isDigitalIdPassportActive) {
                      if (qoin.AccountsController.instance.userData?.fullname ==
                              null ||
                          qoin.AccountsController.instance.userData?.email ==
                              null) {
                        DialogUtils.showCompleteProfileDrawer();
                        return;
                      } else if (qoin.AccountsController.instance.userData
                                  ?.fullname !=
                              null &&
                          qoin.AccountsController.instance.userData?.email ==
                              null) {
                        DialogUtils.showCompleteEmailDrawer();
                        return;
                      } else if (qoin.AccountsController.instance.userData
                                  ?.emailConfirmed ==
                              null ||
                          !qoin.AccountsController.instance.userData!
                              .emailConfirmed!) {
                        DialogUtils.showEmailVerificationDrawer();
                        return;
                      } else if (!DocController
                          .to.isPassportCardAlreadyDigitized) {
                        qoin.DigitalIdController.instance.data =
                            qoin.RegisterDocDataFromUser();
                        qoin.DigitalIdController.instance.data.cardType =
                            qoin.CardCode.passportCardType;
                        bool? isAlreadyHave = await qoin
                            .DigitalIdController.instance
                            .onlyCheckSingleDigitalId(
                                qoin.CardCode.passportCardType);
                        DigitalArchiveUIController.to.joinAllCard();
                        if (isAlreadyHave != null) {
                          if (isAlreadyHave) {
                            _showDialog(qoin.CardCode.passportCardType);
                          } else {
                            qoin.Get.to(() => OCRGuideScreen());
                          }
                        } else {
                          DialogUtils.showPopUp(type: DialogType.problem);
                        }
                      } else {
                        _showDialog(qoin.CardCode.passportCardType);
                      }
                    } else {
                      DialogUtils.showComingSoonDrawer();
                    }
                  },
                ),
                SizedBox(height: 20.h),
                ExpandTitleWidget(
                  expanded: false,
                  image: Assets.icAddBusinessCard,
                  title: 'Kartu Nama',
                  subtitle: DigitalIdLocalization.idTypeSIMDesc.tr,
                  onTap: () async {
                    if (qoin.QoinRemoteConfigController.instance
                        .isDigitalIdBusinessCardActive) {
                      if (qoin.HiveData.userData?.fullname == null ||
                          qoin.HiveData.userData?.email == null) {
                        DialogUtils.showCompleteProfileDrawer();
                        return;
                      } else if (qoin.HiveData.userData?.fullname != null &&
                          qoin.HiveData.userData?.email == null) {
                        DialogUtils.showCompleteEmailDrawer();
                        return;
                      } else if (qoin.HiveData.userData?.emailConfirmed ==
                              null ||
                          !qoin.HiveData.userData!.emailConfirmed!) {
                        DialogUtils.showEmailVerificationDrawer();
                        return;
                      } else {
                        qoin.DigitalIdController.instance.data =
                            qoin.RegisterDocDataFromUser();
                        qoin.DigitalIdController.instance.data.cardType =
                            qoin.CardCode.businessCardType;
                        qoin.Get.to(() => FormNamecardScreen());
                      }
                    } else {
                      DialogUtils.showComingSoonDrawer();
                    }
                  },
                ),
                SizedBox(height: 20.h),
                if (EnvironmentConfig.flavor != qoin.Flavor.Production)
                  Column(
                    children: [
                      ExpandTitleWidget(
                        expanded: false,
                        image: Assets.icAddG20,
                        title: DigitalIdLocalization.idTypeG20Card.tr,
                        subtitle: DigitalIdLocalization.idTypeSIMDesc.tr,
                        onTap: () async {
                          if (qoin.QoinRemoteConfigController.instance
                              .isDigitalIdG20CardActive) {
                            if (qoin.AccountsController.instance.userData
                                        ?.fullname ==
                                    null ||
                                qoin.AccountsController.instance.userData
                                        ?.email ==
                                    null) {
                              DialogUtils.showCompleteProfileDrawer();
                              return;
                            } else if (qoin.AccountsController.instance.userData
                                        ?.fullname !=
                                    null &&
                                qoin.AccountsController.instance.userData
                                        ?.email ==
                                    null) {
                              DialogUtils.showCompleteEmailDrawer();
                              return;
                            } else if (qoin.AccountsController.instance.userData
                                        ?.emailConfirmed ==
                                    null ||
                                !qoin.AccountsController.instance.userData!
                                    .emailConfirmed!) {
                              DialogUtils.showEmailVerificationDrawer();
                              return;
                            } else if (!DocController
                                .to.isG20CardAlreadyDigitized) {
                              qoin.DigitalIdController.instance.data =
                                  qoin.RegisterDocDataFromUser();
                              qoin.DigitalIdController.instance.data.cardType =
                                  qoin.CardCode.g20CardType;
                              bool? isAlreadyHave = await qoin
                                  .DigitalIdController.instance
                                  .onlyCheckSingleDigitalId(
                                      qoin.CardCode.g20CardType);
                              DigitalArchiveUIController.to.joinAllCard();
                              if (isAlreadyHave != null) {
                                if (isAlreadyHave) {
                                  _showDialog(qoin.CardCode.g20CardType);
                                } else {
                                  qoin.Get.to(() => OCRGuideScreen());
                                }
                              } else {
                                DialogUtils.showPopUp(type: DialogType.problem);
                              }
                            } else {
                              _showDialog(qoin.CardCode.g20CardType);
                            }
                          } else {
                            DialogUtils.showComingSoonDrawer();
                          }
                        },
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                //* [TAKE OUT] RELAWAN JOKOWI
                // ExpandTitleWidget(
                //   expanded: false,
                //   image: Assets.icAddRelawanJokowi,
                //   title: DigitalIdLocalization.idTypeRelawanJokowi.tr,
                //   subtitle: DigitalIdLocalization.idTypeSIMDesc.tr,
                //   onTap: () async => _showAgreementRelawanJokowiDrawer(),
                // ),
                ExpandTitleWidget(
                  expanded: false,
                  image: Assets.icAddTni,
                  title: DigitalIdLocalization.idTypeTni.tr,
                  subtitle: DigitalIdLocalization.idTypeSIMDesc.tr,
                  onTap: () async {
                    // if (InisaVenturoMethods.checkDigitalisasiTniData == null) {
                    //   await DigitalisasiTniController.to.getDigitalisasiTniForm();
                    //   qoin.Get.to(() => DigitalisasiTniFormScreen());
                    // } else {
                    //   DialogUtils.showMainPopup(
                    //     image: Assets.icAddTni,
                    //     title: Localization.dialogCardRegistered.tr,
                    //     mainButtonText: Localization.dialogButtonCardRegistered.tr,
                    //     mainButtonFunction: () {
                    //       qoin.Get.back();
                    //       qoin.Get.to(
                    //         () => DigitalisasiTniDetailScreen(
                    //           tniCardData: InisaVenturoMethods.checkDigitalisasiTniData!,
                    //         ),
                    //       );
                    //     },
                    //   );
                    // }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAgreementRelawanJokowiDrawer() {
    final checkBoxAgreement = false.obs;

    if (HiveData.userData!.pict == null || HiveData.userData!.pict!.isEmpty) {
      DialogUtils.showMainPopup(
        barrierDismissible: false,
        image: 'assets/voucher_bansos/images/no_succes_request.png',
        package: 'venturo_mobile',
        title: 'Profilmu Belum Lengkap',
        description:
            'Mohon maaf, kamu tidak bisa melanjutkan digitalisasi sebelum melengkapi data profil.',
        mainButtonText: 'Lengkapi Profil',
        mainButtonFunction: () {
          qoin.Get.close(1);
          qoin.Get.off(() => ProfileScreen());
        },
        mainPopupButtonDirection: MainPopupButtonDirection.Horizontal,
      );
    } else if (HiveData.userData!.fullname == null ||
        HiveData.userData!.fullname!.isEmpty) {
      DialogUtils.showMainPopup(
        barrierDismissible: false,
        image: 'assets/voucher_bansos/images/no_succes_request.png',
        package: 'venturo_mobile',
        title: 'Profilmu Belum Lengkap',
        description:
            'Mohon maaf, kamu tidak bisa melanjutkan digitalisasi sebelum melengkapi data profil.',
        mainButtonText: 'Lengkapi Profil',
        mainButtonFunction: () {
          qoin.Get.close(1);
          qoin.Get.off(() => ProfileScreen());
        },
        mainPopupButtonDirection: MainPopupButtonDirection.Horizontal,
      );
    } else {}
  }

  Future<void> _processKTP() async {
    if (qoin.AccountsController.instance.userData?.fullname == null ||
        qoin.AccountsController.instance.userData?.email == null) {
      DialogUtils.showCompleteProfileDrawer();
      return;
    } else if (qoin.AccountsController.instance.userData?.fullname != null &&
        qoin.AccountsController.instance.userData?.email == null) {
      DialogUtils.showCompleteEmailDrawer();
      return;
    } else if (qoin.AccountsController.instance.userData?.emailConfirmed ==
            null ||
        !qoin.AccountsController.instance.userData!.emailConfirmed!) {
      DialogUtils.showEmailVerificationDrawer();
      return;
    } else if (DocController.to.isKTPAlreadyDigitized) {
      _showDialog(qoin.CardCode.ktpCardType);
      return;
    } else {
      qoin.DigitalIdController.instance.data = qoin.RegisterDocDataFromUser();
      qoin.DigitalIdController.instance.cardType = qoin.CardCode.ktpCardType;
      bool? isAlreadyHave =
          await qoin.DigitalIdController.instance.onlyCheckSingleDigitalId(
        qoin.CardCode.ktpCardType,
      );
      DigitalArchiveUIController.to.joinAllCard();
      if (isAlreadyHave != null) {
        if (isAlreadyHave) {
          _showDialog(qoin.CardCode.ktpCardType);
        } else {
          qoin.Get.to(() => OCRGuideScreen());
        }
      } else {
        DialogUtils.showPopUp(type: DialogType.problem);
      }
    }
  }

  _showDialog(int cardType) {
    if (cardType == qoin.CardCode.passportCardType)
      return DialogUtils.showMainPopup(
          image: Assets.icAddPassport,
          title: Localization.dialogCardRegistered.tr,
          mainButtonText: Localization.dialogButtonCardRegistered.tr,
          mainButtonFunction: () {
            qoin.Get.back();
            qoin.Get.to(() => DetailDigitalDocScreen(
                data: DocController.to.digitizedPassport!));
          });
    else if (cardType == qoin.CardCode.ktpCardType)
      return DialogUtils.showMainPopup(
          image: Assets.icAddKTP,
          title: Localization.dialogCardRegistered.tr,
          mainButtonText: Localization.dialogButtonCardRegistered.tr,
          mainButtonFunction: () {
            qoin.DigitalIdController.instance.data =
                qoin.RegisterDocDataFromUser();
            qoin.Get.back();
            qoin.Get.to(() =>
                DetailDigitalDocScreen(data: DocController.to.digitizedKTP!));
          });
    else if (cardType == qoin.CardCode.simCardType)
      return DialogUtils.showMainPopup(
          image: Assets.icAddSIM,
          title: Localization.dialogCardRegistered.tr,
          mainButtonText: Localization.dialogButtonCardRegistered.tr,
          mainButtonFunction: () {
            qoin.Get.back();
            qoin.Get.to(() => ListCardScreen());
          });
    else if (cardType == qoin.CardCode.g20CardType)
      return DialogUtils.showMainPopup(
          image: Assets.icAddG20,
          title: Localization.dialogCardRegistered.tr,
          mainButtonText: Localization.dialogButtonCardRegistered.tr,
          mainButtonFunction: () {
            qoin.DigitalIdController.instance.data =
                qoin.RegisterDocDataFromUser();
            qoin.Get.back();
            qoin.Get.to(() =>
                DetailDigitalDocScreen(data: DocController.to.digitizedG20!));
            // qoin.Get.back();
            // qoin.Get.to(() => ListCardScreen());
          });
    else
      return DialogUtils.showMainPopup(
          title: DigitalIdLocalization.unverifiedKTPTitle.tr,
          mainPopupButtonDirection: MainPopupButtonDirection.Horizontal,
          description: DigitalIdLocalization.unverifiedKTPDesc.tr,
          secondaryButtonText: Localization.maybeLater.tr,
          secondaryButtonFunction: () {
            qoin.Get.back();
          },
          mainButtonText: DigitalIdLocalization.unverifiedKTPButton.tr,
          mainButtonFunction: () async {
            qoin.Get.back();
            _processKTP();
          });
  }
}

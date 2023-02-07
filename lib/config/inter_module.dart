import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/constans.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/localization/qoin_transaction_localization.g.dart';
import 'package:inisa_app/localization/sdk_lang.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/logic/controller/digitalid/digital_archive_ui_controller.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/screen/notification/helper/notification_bindings.dart';
import 'package:inisa_app/ui/screen/notification/notification_screen.dart';
import 'package:inisa_app/ui/screen/onboarding/onboarding_screen.dart';
import 'package:package_info/package_info.dart';
import 'package:qoin_sdk/helpers/services/environment.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
// import 'package:venturo_mobile/localization/localization_agi.dart';
// import 'package:venturo_mobile/localization/localization_edit_phone_number.dart';
// import 'package:venturo_mobile/localization/localization_sentra_kependudukan.dart';
// import 'package:venturo_mobile/localization/localization_sentra_lokasi.dart';
// import 'package:venturo_mobile/localization/localization_venturo.dart';
// import 'package:venturo_mobile/localization/localization_voucher_bansos.dart';
// import 'package:venturo_mobile/localization/localization_yukk.dart';
// import 'package:venturo_mobile/shared_inisa/inisa_venturo_methods.dart';
// import 'package:venturo_mobile/localization/localization_subsidi.dart';
// import 'package:venturo_mobile/localization/localization_change_email.dart';

import '../firebase_options.dart';
// import 'package:venturo_mobile/venturo_mobile.dart' as venturo;

class InterModule {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static ThemeData theme = ThemeData();
  static qoin.LocalizationService? translations;

  static String? lastPhoneNumber;
  static String? phoneNumber;

  static bool isEmailEditSuccess = false;
  static bool onReqGetProfileAfterUpdateEmail = false;

  static final supportedLang = [
    qoin.Language(
      language: "Indonesia",
      locale: Locale("id", "ID"),
      key: {
        ...(Localization.ID),
        ...(QoinServicesLocalization.indoLanguageMap),
        ...(QoinTransactionLocalization.indoLanguageMap),
        ...(DigitalIdLocalization.ID),
        ...(WalletLocalization.ID),
        ...(SdkLang.ID),
        // ...(LocalizationSentraLokasi.ID),
        // ...(LocalizationSentraKependudukan.ID),
        // ...(LocalizationEditPhoneNumber.ID),
        // ...(LocalizationVoucherBansos.ID),
        // ...(LocalizationYukk.ID),
        // ...(LocalizationVenturo.ID),
        // ...(LocalizationAGI.ID),
        // ...(LocalizationSubsidi.ID),
        // ...(LocalizationChangeEmail.ID),
      },
    ),
    qoin.Language(
      language: "English",
      locale: Locale("en", "US"),
      key: {
        ...(Localization.EN),
        ...(QoinServicesLocalization.engLanguageMap),
        ...(QoinTransactionLocalization.engLanguageMap),
        ...(DigitalIdLocalization.EN),
        ...(WalletLocalization.EN),
        ...(SdkLang.EN),
        // ...(LocalizationSentraLokasi.EN),
        // ...(LocalizationSentraKependudukan.EN),
        // ...(LocalizationEditPhoneNumber.EN),
        // ...(LocalizationVoucherBansos.EN),
        // ...(LocalizationYukk.EN),
        // ...(LocalizationVenturo.EN),
        // ...(LocalizationAGI.EN),
        // ...(LocalizationSubsidi.EN),
        // ...(LocalizationChangeEmail.EN),
      },
    ),
  ];

  static Future<void> init(qoin.Flavor flavor) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    await qoin.QoinSdk.init(
      app: qoin.APPS.INISA,
      otpMethod: [
        qoin.OtpTypeEnum.IVR,
        qoin.OtpTypeEnum.WA,
      ],
      androidPackageName: packageInfo.packageName,
      androidMinimumVersion: 0,
      iosBundleId: packageInfo.packageName,
      iosMinimumVersion: '0',
      firebaseOptions: DefaultFirebaseOptions.currentPlatform,
      notifIcon: 'ic_inisa_notification',
      onboardings: Constans.onboarding,
      onboardingScreen: OnboardingScreen(),
      checkOtpLimit: true,
      environment: flavor,
    );
    qoin.Get.put<DigitalArchiveUIController>(DigitalArchiveUIController());

    // just for debug
    // var token = qoin.AccountsController.instance.userData?.token;
    // var userData = qoin.AccountsController.instance.userData;
    // var docData = qoin.HiveData.docData;
    // debugPrint("test");
    // log("Token $token");
    // log("Client Id ${userData?.clientId ?? 'Null'}");
    // log("User Id ${userData?.userId ?? 'Null'}");
    // log("Member Id ${userData?.memberId ?? 'Null'}");

    theme = theme.copyWith(
      primaryColor: ColorUI.primary,
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      unselectedWidgetColor: Color(0xffb5b5b5),
      textTheme: TextTheme(
        headline1: GoogleFonts.manrope(
          fontSize: 36,
          color: Colors.black,
          fontStyle: FontStyle.normal,
        ),
        headline2: GoogleFonts.manrope(
          fontSize: 25,
          color: Colors.black,
          fontStyle: FontStyle.normal,
        ),
        headline3: GoogleFonts.manrope(
          fontSize: 21,
          color: Colors.black,
          fontStyle: FontStyle.normal,
        ),
        headline4: GoogleFonts.manrope(
          fontSize: 18,
          color: Colors.black,
          fontStyle: FontStyle.normal,
        ),
        headline5: GoogleFonts.manrope(
            fontSize: 16, color: Colors.black, fontStyle: FontStyle.normal),
        headline6: GoogleFonts.manrope(
          fontSize: 14,
          color: Colors.black,
          fontStyle: FontStyle.normal,
        ),
        bodyText1: GoogleFonts.manrope(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
        ),
        bodyText2: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontStyle: FontStyle.normal,
        ),
        caption: GoogleFonts.manrope(
          fontSize: 13,
          color: Colors.black,
          fontStyle: FontStyle.normal,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: ColorUI.primary,
        secondary: ColorUI.secondary,
        // secondaryVariant: ColorUI.secondaryVariant,
      ),
    );

    translations = qoin.LocalizationService(
      // defaultlocale: qoin.Get.deviceLocale ?? Locale('en', 'US'),
      defaultlocale: Locale("id", "ID"),
      fallbacklocale: supportedLang.first.locale,
      supportedlang: supportedLang,
      onlocalechanged: (val) {
        qoin.HiveData.language = val;
      },
    );

    qoin.QoinSdk.onLoginDo = () async {
      DigitalArchiveUIController.to.joinAllCard();
      //* [TAKE OUT] RELAWAN JOKOWI
      // try {
      //   await InisaVenturoMethods.checkRelawanJokowiStatus();
      // } catch (e) {
      //   debugPrint("[QoinLogin][Venturo] Relawan Jokowi : $e");
      // }

      // try {
      //   await InisaVenturoMethods.getDigitalisasiTni();
      // } catch (e) {
      //   debugPrint("[QoinLogin][Venturo] Digitalisasi TNI : $e");
      // }

      // try {
      //   await InisaVenturoMethods.getAllRiwayat(type: 'kk');
      // } catch (e) {
      //   debugPrint("[QoinLogin][Venturo] Kependudukan KK: $e");
      // }
      // try {
      //   await InisaVenturoMethods.getAllRiwayat(type: 'akta_kelahiran');
      // } catch (e) {
      //   debugPrint("[QoinLogin][Venturo] Kependudukan Akta Lahir: $e");
      // }
      // try {
      //   await InisaVenturoMethods.getVouchersBansos();
      // } catch (e) {
      //   debugPrint("[QoinLogin][Venturo] Voucher Bansos : $e");
      // }
      // DigitalArchiveUIController.to.joinAllCard();
    };

    qoin.QoinSdk.onDigitalIdNotification = (notifData) {
      if (notifData.docNote == 'REJECT') {
        qoin.DigitalIdController.instance
            .checkAndRestoreDigitalId()
            .then((value) {
          DigitalArchiveUIController.to.joinAllCard();
        });
      } else if (notifData.docId != null && notifData.docNote == 'APPROVE') {
        qoin.DigitalIdController.instance.getRegisteredAdjudicator(
            id: notifData.docId!,
            onSuccess: () {
              DigitalArchiveUIController.to.joinAllCard();
              if (notifData.cardType == qoin.CardCode.g20CardType.toString()) {
                DialogUtils.showMainPopup(
                    image: Assets.icAddG20,
                    title: 'Kartu G20 telah berhasil di verifikasi',
                    mainButtonText: 'Kembali',
                    mainButtonFunction: () {
                      qoin.Get.back();
                    });
              } else {
                DialogUtils.showMainPopup(
                    image: Assets.icAddKTP,
                    title: 'E-KTP telah berhasil di verifikasi',
                    mainButtonText: 'Kembali',
                    mainButtonFunction: () {
                      qoin.Get.back();
                    });
              }
            },
            onReview: () {
              DialogUtils.showMainPopup(
                  image: Assets.icAddKTP,
                  title: 'Verifikasi E-KTP Masih Berlangsung',
                  description:
                      "Mohon menunggu, verifikasi E-KTP kamu masih dalam proses review",
                  mainButtonText: 'Kembali',
                  mainButtonFunction: () {
                    qoin.Get.back();
                  });
            },
            onError: (error) {});
      }
    };

    qoin.QoinSdk.onOtherNotification = (notifData) {
      if (notifData['trxFilter'] == "VENTURO_BANSOS") {
        // venturo.VenturoMobile.succesRedeemVoucherBansos(
        //     onSuccedRedeemVoucherDialog: () {
        //   qoin.Get.to(() => HomeScreen(), binding: qoin.OnloginBindings());
        // });
      }
    };

    Constans.appVersion =
        '${Constans.getStringENV()}${packageInfo.version}+${packageInfo.buildNumber}';

    IntentTo.checkUpdate();

    qoin.FireStoreController.to.checkMaintenanceStream(
      buildNumber: int.parse(packageInfo.buildNumber),
      onMaintenance: (title, message) {
        DialogUtils.showPopUp(
            type: DialogType.problem,
            barrierDismissible: false,
            title: title,
            description: message,
            buttonFunction: () {
              exit(0);
            });
      },
      onForceLogout: (isUsePopup) {
        if (isUsePopup) {
          DialogUtils.showMainPopup(
            radius: 10,
            barrierDismissible: false,
            image: Assets.warning,
            title: Localization.updateNotice.tr,
            description: Localization.updateNoticeDesc.tr,
            mainButtonText: Localization.logout.tr,
            mainButtonFunction: () async {
              qoin.HiveData.logout();
              qoin.Get.offAll(OnboardingScreen());
            },
          );
        } else {
          qoin.HiveData.logout();
          qoin.Get.offAll(OnboardingScreen());
        }
      },
    );

    qoin.QoinSdk.onNotificationClick = () {
      qoin.Get.to(NotificationScreen(), binding: NotificationBindings());
    };

    EnvironmentConfig.customIvrPhoneNumber = "+6285592013090";
    EnvironmentConfig.customBaseUrl = EnvironmentConfig.baseUrlVenturo();
    EnvironmentConfig.customDigitalIdBaseUrl =
        EnvironmentConfig.baseUrlVenturo();
    EnvironmentConfig.customLoyaltyBaseUrl = EnvironmentConfig.baseUrlVenturo();

    // venturo.VenturoMobile.init(baseUrl: EnvironmentConfig.baseUrlVenturo());

    // if (qoin.HiveData.userData?.token != null) {
    //   try {
    //     await InisaVenturoMethods.getAllRiwayat(type: 'kk');
    //   } catch (e) {
    //     debugPrint("[InisaVenturoMethods][getAllRiwayat] restore kk error: $e");
    //   }
    //   try {
    //     await InisaVenturoMethods.getAllRiwayat(type: 'akta_kelahiran');
    //   } catch (e) {
    //     debugPrint(
    //         "[InisaVenturoMethods][getAllRiwayat] restore akta error: $e");
    //   }
    //   try {
    //     await InisaVenturoMethods.getVouchersBansos();
    //   } catch (e) {
    //     debugPrint(
    //         "[InisaVenturoMethods][getVouchersBansos] restore bansos error: $e");
    //   }
    // }

    if (qoin.HiveData.userData?.token != null) {
      await qoin.QoinRemoteConfigController.instance.fetchAndActivate();
    }
  }
}

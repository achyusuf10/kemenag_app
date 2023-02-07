import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/ui/screen/account/pin/pin_screen.dart';
import 'package:inisa_app/ui/screen/onboarding/onboarding_screen.dart';
import 'package:inisa_app/ui/screen/webview_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/controllers/qoin_account/accounts_controller.dart';
import 'package:qoin_sdk/controllers/qoin_account/delete_account_controller.dart';
import 'package:qoin_sdk/helpers/constants/enums.dart';
import 'package:qoin_sdk/helpers/services/environment.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
// import 'package:venturo_mobile/shared_inisa/inisa_venturo_methods.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> description = [
      'Menghapus akun tidak akan menghilangkan aset digital kamu selama kamu masih menyimpan frasa pemulihan.',
      'Semua transaksi yang sedang diproses akan dibatalkan.',
      'Dompet yang terhubung dengan akun kamu akan diputus.',
      'Akun akan dihapus permanen dari sistem setelah 30 hari.',
      'Untuk mengaktifkan akun kembali, hubungi CS Inisa sebelum akun kamu dihapus permanen dari sistem.',
    ];

    return ModalProgress(
      loadingStatus: DeleteAccountController.instance.isLoading.stream,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarWidget.light(
          title: Localization.buttonDeleteAcc.tr,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Berikut hal yang perlu kamu perhatikan sebelum menghapus akun.',
                  style: TextUI.bodyTextBlack,
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border:
                          Border.all(color: const Color(0xffeb5050), width: 1),
                      color: const Color(0x1aeb5050)),
                  child: Column(
                    children: description
                        .map(
                          (data) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.h,
                                margin: EdgeInsets.only(
                                    left: 4.w, top: 4.h, right: 12.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xffeb5050),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Text(
                                    data,
                                    style: TextUI.bodyText2Black,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: 14.h,
                ),
                Text(
                  'Kenapa kamu ingin menghapus akun?',
                  style: TextUI.bodyTextBlack.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                TextField(
                  maxLines: 3,
                  onChanged: (val) {
                    DeleteAccountController.instance.reason.value = val;
                  },
                  style: TextUI.bodyTextBlack,
                  // style: Get.textTheme.bodyText1,
                  decoration: InputDecoration(
                    hintText: 'Tuliskan alasanmu di sini (opsional)',
                    // hintStyle: TextStyle(color: Colors.grey),
                    hintStyle: TextUI.bodyTextGrey,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(
                        color: Color(0xffdedede),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(
                        color: Color(0xfff7b500),
                        // color: ColorUI.secondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 200.h,
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: const Color(0x14111111),
                offset: Offset(0, -2),
                blurRadius: 16,
                spreadRadius: 0)
          ], color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  qoin.Obx(
                    () => Checkbox(
                        value: DeleteAccountController
                            .instance.consentChecked.value,
                        checkColor: Colors.white,
                        activeColor: Colors.amber,
                        // activeColor: ColorUI.secondary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity:
                            VisualDensity(vertical: -4, horizontal: -4),
                        onChanged: (value) async {
                          if (DeleteAccountController
                              .instance.consentChecked.value) {
                            DeleteAccountController
                                .instance.consentChecked.value = false;
                          } else {
                            DeleteAccountController
                                .instance.consentChecked.value = true;
                          }
                        }),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Dengan melanjutkan, saya menyetujui\n",
                            style: TextUI.bodyText2Black,
                          ),
                          TextSpan(
                              text: 'Ketentuan Layanan',
                              // style: TextUI.buttonTextRed.copyWith(fontSize: 14.sp),
                              style: TextUI.buttonTextYellow
                                  .copyWith(fontSize: 14.sp),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  qoin.Get.to(() => WebViewScreen(
                                        title: Localization
                                            .buttonTermAndCondition.tr,
                                        linkUrl:
                                            'https://www.inisa.id/ketentuan-layanan/',
                                      ));
                                }),
                          TextSpan(
                            text: " dan",
                            style: TextUI.bodyText2Black,
                          ),
                          TextSpan(
                              text: ' Kebijakan Privasi',
                              // style: TextUI.buttonTextRed.copyWith(fontSize: 14.sp),
                              style: TextUI.buttonTextYellow
                                  .copyWith(fontSize: 14.sp),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  qoin.Get.to(() => WebViewScreen(
                                        title:
                                            Localization.buttonPrivacyPolicy.tr,
                                        linkUrl:
                                            'https://www.inisa.id/kebijakan-privasi/',
                                      ));
                                }),
                          TextSpan(
                            text: " INISA",
                            style: TextUI.bodyText2Black,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              qoin.Obx(
                () => MainButton(
                  text: Localization.buttonDeleteAcc.tr,
                  // color: Color(0xffeb5050),
                  // textColor: Colors.white,
                  onPressed: DeleteAccountController.instance.reason.value ==
                              '' ||
                          !DeleteAccountController.instance.consentChecked.value
                      ? null
                      : () async {
                          DialogUtils.showMainPopup(
                              title: "Yakin Menghapus Akun?",
                              // buttonMainFirst: true,
                              image: Assets.icDialogDelete,
                              imageSize: 96.h,
                              description:
                                  'kamu masih bisa aktivasi kembali akun sampai 30 hari ke depan',
                              secondaryButtonText: 'Batalkan',
                              secondaryButtonFunction: () {
                                qoin.Get.back();
                              },
                              mainButtonText: "Ya, Hapus",
                              mainButtonFunction: () async {
                                qoin.Get.back();
                                var result = await qoin.Get.to(
                                  () => PinScreen(
                                    pinType:
                                        PinTypeEnum.confirmationTransaction,
                                    functionSubmit: (string) async {
                                      debugPrint("CALL DELETE ACCOUNT");
                                      DeleteAccountController.instance
                                          .deleteAccount(
                                        // isPrototype: true,
                                        onSuccess: () {
                                          AccountsController.instance.logout(
                                              additionalDataDelete: () {
                                                // if (EnvironmentConfig.apps ==
                                                //     APPS.INISA) {
                                                //   InisaVenturoMethods
                                                //       .clearAllRiwayatKk = null;
                                                //   InisaVenturoMethods
                                                //           .clearAllRiwayatAktaKelahiran =
                                                //       null;
                                                //   InisaVenturoMethods
                                                //           .clearAllVoucherBansos =
                                                //       null;
                                                //   InisaVenturoMethods
                                                //           .clearValidVouchersBansos =
                                                //       null;
                                                //   InisaVenturoMethods
                                                //           .clearYukkWalletData =
                                                //       null;
                                                //   InisaVenturoMethods
                                                //       .clearAccesWalletData();
                                                //   InisaVenturoMethods
                                                //       .clearDigitalisasiTniData();
                                                //   InisaVenturoMethods
                                                //       .clearOtaquTicket();
                                                //   InisaVenturoMethods
                                                //       .clearSubsidiData();

                                                //   //* [TAKE OUT] RELAWAN JOKOWI
                                                //   // InisaVenturoMethods.clearRelawanJokowiData = null;
                                                // }
                                              },
                                              onboardingScreen:
                                                  OnboardingScreen());
                                          DialogUtils.showMainPopup(
                                            barrierDismissible: true,
                                            image: Assets.success,
                                            title: 'Akun Berhasil Dihapus',
                                            description:
                                                'Akun Berhasil Dihapus, anda akan dialihkan ke beranda.',
                                          );
                                        },
                                        onError: (e) {
                                          DialogUtils.showPopUp(
                                            type: DialogType.problem,
                                            description: e,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                );
                                // if (result == null)
                                return;
                              },
                              mainPopupButtonDirection:
                                  MainPopupButtonDirection.Horizontal);
                          // debugPrint("Delete Account Function");
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

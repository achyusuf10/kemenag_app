import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/logic/controller/digitalid/digital_archive_ui_controller.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/background.dart';
import 'package:inisa_app/ui/widget/button_bottom.dart';
import 'package:inisa_app/ui/widget/button_secondary.dart';
import 'package:inisa_app/ui/widget/digital_id/doc_holder_widget.dart';
import 'package:inisa_app/ui/widget/main_textfield.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/helpers/constants/digital_doc_status.dart';
import 'package:qoin_sdk/helpers/services/connectivity_status.dart';
import 'package:qoin_sdk/models/qoin_digitalid/document_user_data.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:url_launcher/url_launcher.dart';

import 'card_fullscreen.dart';
import 'digital_id_helper.dart';

class DetailDigitalDocScreen extends StatelessWidget {
  final DocumentUserData? data;

  const DetailDigitalDocScreen({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? _content() {
      switch (data?.docCardType) {
        case null:
          return SizedBox();
        case "${qoin.CardCode.ktpCardType}":
          return Column(
            children: [
              if (data?.status != DigitalDocStatus.active)
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage(Assets.attention),
                        color: ColorUI.yellow,
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                          DigitalIdLocalization.detailDigitalDocStillProcess.tr,
                          style: TextUI.bodyText2Black
                              .copyWith(color: Color(0xfff7b500)))
                    ],
                  ),
                ),
              DocHolderWidget(
                data: data!,
                width: 379.w,
                height: 233.17.w,
              ),
              SizedBox(height: 20),
              if (data?.status != DigitalDocStatus.unverified &&
                  data!.status != DigitalDocStatus.onRequest)
                Text(
                  "${DigitalIdLocalization.detailDigitalDocScanQR.tr}",
                  style: TextUI.subtitleBlack,
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 20),
              if (data!.status != DigitalDocStatus.unverified &&
                  data!.status != DigitalDocStatus.onRequest)
                qoin.GetBuilder<qoin.DigitalIdController>(
                  builder: (controller) {
                    if (controller.isLoadingGenrateQr.value) {
                      return Container(
                        padding: EdgeInsets.all(24.w),
                        margin: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0x28000000),
                                  offset: Offset(0, 2),
                                  blurRadius: 10,
                                  spreadRadius: 0)
                            ],
                            color: const Color(0xffffffff)),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return Container(
                      padding: EdgeInsets.all(24.w),
                      margin: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0x28000000),
                                offset: Offset(0, 2),
                                blurRadius: 10,
                                spreadRadius: 0)
                          ],
                          color: const Color(0xffffffff)),
                      child: controller.qrFromBruno.isNotEmpty
                          ? QrImage(
                              data: controller.qrFromBruno,
                              gapless: false,
                              // embeddedImage: AssetImage(Assets.icEmbedQr),
                              // embeddedImageStyle: QrEmbeddedImageStyle(
                              //   size: Size(74, 74),
                              // ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DigitalIdLocalization
                                      .detailDigitalDocQrFail.tr,
                                  style: TextUI.subtitleBlack,
                                  textAlign: TextAlign.center,
                                ),
                                SecondaryButton(
                                  text: Localization.tryAgain.tr,
                                  onPressed: () {
                                    DigitalIdHelper.getQRData(data);
                                  },
                                ),
                              ],
                            ),
                    );
                  },
                ),

              // FutureBuilder<String>(
              //     future: qoin.DigitalIdController.to.getQrImage(data: data!),
              //     builder: (context, snapshot) {
              //       if (snapshot.hasData && snapshot.data!.length != 0) {
              //         return Container(
              //           padding: EdgeInsets.all(24.w),
              //           margin: EdgeInsets.all(10.w),
              //           decoration: BoxDecoration(
              //               borderRadius: BorderRadius.all(Radius.circular(16)),
              //               boxShadow: [
              //                 BoxShadow(
              //                     color: const Color(0x28000000),
              //                     offset: Offset(0, 2),
              //                     blurRadius: 10,
              //                     spreadRadius: 0)
              //               ],
              //               color: const Color(0xffffffff)),
              //           child: QrImage(
              //             data: snapshot.data ?? qoin.DigitalIdController.to.qrFromBruno,
              //             gapless: false,
              //             // embeddedImage: AssetImage(Assets.icEmbedQr),
              //             // embeddedImageStyle: QrEmbeddedImageStyle(
              //             //   size: Size(74, 74),
              //             // ),
              //           ),
              //         );
              //       }
              //       return SizedBox(child: CircularProgressIndicator());
              //     }),
            ],
          );
        case "${qoin.CardCode.simCardType}":
          return Column(
            children: [
              DocHolderWidget(
                data: data!,
                width: 379.w,
                height: 233.17.w,
              ),
              if (data!.status == DigitalDocStatus.unverified) ...[
                SizedBox(height: 20),
                Text(
                  DigitalIdLocalization.detailDigitalDocSIMNotVerified.tr,
                  style: TextUI.bodyTextGrey,
                  textAlign: TextAlign.center,
                )
              ],
              if (data?.status == DigitalDocStatus.active) ...[
                SizedBox(height: 20),
                if (data?.status != DigitalDocStatus.unverified &&
                    data!.status != DigitalDocStatus.onRequest)
                  Text(
                    "${DigitalIdLocalization.detailDigitalDocScanQR.tr}",
                    style: TextUI.subtitleBlack,
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: 20),
                if (data!.status != DigitalDocStatus.unverified &&
                    data!.status != DigitalDocStatus.onRequest)
                  qoin.GetBuilder<qoin.DigitalIdController>(
                    builder: (controller) {
                      if (controller.isLoadingGenrateQr.value) {
                        return Container(
                          padding: EdgeInsets.all(24.w),
                          margin: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0x28000000),
                                    offset: Offset(0, 2),
                                    blurRadius: 10,
                                    spreadRadius: 0)
                              ],
                              color: const Color(0xffffffff)),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return Container(
                        padding: EdgeInsets.all(24.w),
                        margin: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0x28000000),
                                  offset: Offset(0, 2),
                                  blurRadius: 10,
                                  spreadRadius: 0)
                            ],
                            color: const Color(0xffffffff)),
                        child: controller.qrFromBruno.isNotEmpty
                            ? QrImage(
                                data: controller.qrFromBruno,
                                gapless: false,
                                // embeddedImage: AssetImage(Assets.icEmbedQr),
                                // embeddedImageStyle: QrEmbeddedImageStyle(
                                //   size: Size(74, 74),
                                // ),
                              )
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DigitalIdLocalization
                                        .detailDigitalDocQrFail.tr,
                                    style: TextUI.subtitleBlack,
                                    textAlign: TextAlign.center,
                                  ),
                                  SecondaryButton(
                                    text: Localization.tryAgain.tr,
                                    onPressed: () {
                                      DigitalIdHelper.getQRData(data);
                                    },
                                  ),
                                ],
                              ),
                      );
                    },
                  ),
              ]
            ],
          );
        case "${qoin.CardCode.passportCardType}":
          return Container(
            height: 233.17.w,
            child: DocHolderWidget(
              data: data!,
              width: 379.w,
              height: 233.17.w,
            ),
          );
        case "${qoin.CardCode.businessCardType}":
          return Column(
            children: [
              Container(
                height: 233.w,
                child: DocHolderWidget(
                  data: data!,
                  width: 379.w,
                  height: 233.w,
                ),
              ),
              SizedBox(height: 20),
              if (data?.status != DigitalDocStatus.unverified &&
                  data!.status != DigitalDocStatus.onRequest)
                Text(
                  "${DigitalIdLocalization.detailDigitalDocScanQR.tr}",
                  style: TextUI.subtitleBlack,
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 20),
              if (data!.status != DigitalDocStatus.unverified &&
                  data!.status != DigitalDocStatus.onRequest)
                qoin.GetBuilder<qoin.DigitalIdController>(
                  builder: (controller) {
                    if (controller.isLoadingGenrateQr.value) {
                      return Container(
                        padding: EdgeInsets.all(24.w),
                        margin: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0x28000000),
                                  offset: Offset(0, 2),
                                  blurRadius: 10,
                                  spreadRadius: 0)
                            ],
                            color: const Color(0xffffffff)),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return Container(
                      padding: EdgeInsets.all(24.w),
                      margin: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0x28000000),
                                offset: Offset(0, 2),
                                blurRadius: 10,
                                spreadRadius: 0)
                          ],
                          color: const Color(0xffffffff)),
                      child: controller.qrNameCard.isNotEmpty
                          ? QrImage(
                              data: controller.qrNameCard,
                              gapless: false,
                              size: 256.h
                              )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DigitalIdLocalization
                                      .detailDigitalDocQrFail.tr,
                                  style: TextUI.subtitleBlack,
                                  textAlign: TextAlign.center,
                                ),
                                SecondaryButton(
                                  text: Localization.tryAgain.tr,
                                  onPressed: () {
                                    DigitalIdHelper.getQRData(data);
                                  },
                                ),
                              ],
                            ),
                    );
                  },
                ),
            ],
          );
        case "${qoin.CardCode.g20CardType}":
          return Column(
            children: [
              if (data?.status != DigitalDocStatus.active)
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage(Assets.attention),
                        color: ColorUI.yellow,
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                          DigitalIdLocalization.detailDigitalDocStillProcess.tr,
                          style: TextUI.bodyText2Black
                              .copyWith(color: Color(0xfff7b500)))
                    ],
                  ),
                ),
              DocHolderWidget(
                data: data!,
                width: 379.w,
                height: 233.17.w,
              ),
              SizedBox(height: 20),
              if (data?.status != DigitalDocStatus.unverified &&
                  data!.status != DigitalDocStatus.onRequest)
                Text(
                  "${DigitalIdLocalization.detailDigitalDocScanQR.tr}",
                  style: TextUI.subtitleBlack,
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 20),
              if (data!.status != DigitalDocStatus.unverified &&
                  data!.status != DigitalDocStatus.onRequest)
                qoin.GetBuilder<qoin.DigitalIdController>(
                  builder: (controller) {
                    if (controller.isLoadingGenrateQr.value) {
                      return Container(
                        padding: EdgeInsets.all(24.w),
                        margin: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0x28000000),
                                  offset: Offset(0, 2),
                                  blurRadius: 10,
                                  spreadRadius: 0)
                            ],
                            color: const Color(0xffffffff)),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return Container(
                      padding: EdgeInsets.all(24.w),
                      margin: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0x28000000),
                                offset: Offset(0, 2),
                                blurRadius: 10,
                                spreadRadius: 0)
                          ],
                          color: const Color(0xffffffff)),
                      child: controller.qrFromBruno.isNotEmpty
                          ? QrImage(
                              data: controller.qrFromBruno,
                              gapless: false,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DigitalIdLocalization
                                      .detailDigitalDocQrFail.tr,
                                  style: TextUI.subtitleBlack,
                                  textAlign: TextAlign.center,
                                ),
                                SecondaryButton(
                                  text: Localization.tryAgain.tr,
                                  onPressed: () {
                                    DigitalIdHelper.getQRData(data);
                                  },
                                ),
                              ],
                            ),
                    );
                  },
                ),
            ],
          );
        case "${qoin.CardCode.otaquMembership}":
          return Column(
            children: [
              DocHolderWidget(
                data: data!,
                width: 379.w,
                height: 233.17.w,
              ),
              SizedBox(height: 20),
              if (data!.status != DigitalDocStatus.unverified &&
                  data!.status != DigitalDocStatus.onRequest)
              Text(
                "${DigitalIdLocalization.detailDigitalDocScanQR.tr}",
                style: TextUI.subtitleBlack,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              if (data!.status != DigitalDocStatus.unverified &&
                  data!.status != DigitalDocStatus.onRequest)
                qoin.GetBuilder<qoin.DigitalIdController>(
                  builder: (controller) {
                    if (controller.isLoadingGenrateQr.value) {
                      return Container(
                        padding: EdgeInsets.all(24.w),
                        margin: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0x28000000),
                                  offset: Offset(0, 2),
                                  blurRadius: 10,
                                  spreadRadius: 0)
                            ],
                            color: const Color(0xffffffff)),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return Container(
                      padding: EdgeInsets.all(24.w),
                      margin: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0x28000000),
                                offset: Offset(0, 2),
                                blurRadius: 10,
                                spreadRadius: 0)
                          ],
                          color: const Color(0xffffffff)),
                      child: controller.qrFromBruno.isNotEmpty
                          ? QrImage(
                              data: controller.qrFromBruno,
                              gapless: false,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DigitalIdLocalization
                                      .detailDigitalDocQrFail.tr,
                                  style: TextUI.subtitleBlack,
                                  textAlign: TextAlign.center,
                                ),
                                SecondaryButton(
                                  text: Localization.tryAgain.tr,
                                  onPressed: () {
                                    DigitalIdHelper.getQRData(data);
                                  },
                                ),
                              ],
                            ),
                    );
                  },
                ),
            ],
          );  
        default:
          return SizedBox();
      }
    }

    Widget? _bottomButton() {
      switch (data?.status) {
        case DigitalDocStatus.unverified:
          return data?.docCardType == qoin.CardCode.simCardType.toString()
              ? ButtonBottom(
                  text: '${DigitalIdLocalization.cardFullscreenVerifyNow.tr}',
                  onPressed: () async {
                    if (data!.docIssuerConfirm == 0) {
                      DigitalIdController.instance.verifySIMDocument(
                          data: data,
                          onSuccess: () {
                            DialogUtils.showMainPopup(
                                title: 'SIM Kamu Berhasil Diverifikasi',
                                description:
                                    'Digitalisasi SIM kamu di aplikasi Korlantas telah berhasil',
                                mainButtonText: 'Lanjutkan',
                                mainButtonFunction: () {
                                  qoin.Get.back();
                                  DigitalIdController.instance
                                      .approveSIMDocument(
                                          data: data,
                                          onSuccess: () {
                                            DialogUtils.showMainPopup(
                                                image: Assets.icAddSIM,
                                                title:
                                                    'SIM Kamu Berhasil Diverifikasi',
                                                mainButtonText:
                                                    'Mulai Explore INISA',
                                                mainButtonFunction: () async {
                                                  qoin.Get.offAll(
                                                      () => HomeScreen(),
                                                      binding: qoin
                                                          .OnloginBindings());
                                                });
                                          },
                                          onError: (error) {
                                            DialogUtils.showPopUpProblem(
                                                title: error);
                                          });
                                },
                                secondaryButtonText: 'Batalkan Verifikasi',
                                secondaryButtonFunction: () => Get.back());
                          },
                          onError: (error) {
                            if (error.toLowerCase() == 'sim no not found') {
                              showKorlantas();
                            } else if (error.toLowerCase() ==
                                'sim has been verified') {
                              DialogUtils.showPopUpProblem(
                                  title: "SIM sudah diverifikasi");
                            } else {
                              DialogUtils.showPopUpProblem(title: error);
                            }
                          });
                    } else {
                      DialogUtils.showMainPopup(
                          image: Assets.icAddSIM,
                          title: 'SIM Kamu Berhasil Diverifikasi',
                          description:
                              'Digitalisasi SIM kamu di aplikasi Korlantas telah berhasil',
                          mainButtonText: 'Lanjutkan',
                          mainButtonFunction: () {
                            qoin.Get.back();
                            DigitalIdController.instance.approveSIMDocument(
                                data: data,
                                onSuccess: () {
                                  DialogUtils.showMainPopup(
                                      image: Assets.icAddSIM,
                                      title: 'SIM Kamu Berhasil Diverifikasi',
                                      mainButtonText: 'Mulai Explore INISA',
                                      mainButtonFunction: () {
                                        DigitalIdController.instance
                                            .checkAndRestoreDigitalId()
                                            .then((value) {
                                          DigitalArchiveUIController.to
                                              .joinAllCard();
                                        });
                                        qoin.Get.offAll(() => HomeScreen(),
                                            binding: qoin.OnloginBindings());
                                      });
                                },
                                onError: (error) {
                                  DialogUtils.showPopUpProblem(title: error);
                                });
                          },
                          secondaryButtonText: 'Batalkan Verifikasi',
                          secondaryButtonFunction: () => Get.back());
                    }
                  },
                )
              : SizedBox();
        // case DigitalDocStatus.onRequest:
        //   return data?.docCardType == qoin.CardCode.ktpCardCode.toString()
        //       ? Container(
        //           padding: EdgeInsets.all(16.0),
        //           decoration: BoxDecoration(
        //             boxShadow: [
        //               BoxShadow(
        //                 color: Color(0x80cacccf),
        //                 offset: Offset(0, -1),
        //                 blurRadius: 4,
        //               ),
        //             ],
        //             color: Colors.white,
        //           ),
        //           child: MainButton(
        //             // text: '${DigitalIdLocalization.cardFullscreenVerifyNow.tr}',
        //             text: 'Cek Status',
        //             onPressed: () async {
        //               await qoin.DigitalIdController.to.getRegisteredAdjudicator(
        //                 id: data!.docId!,
        //                 onSuccess: () {
        //                   DialogUtils.showPopupFaceVerification(onSuccess: () {
        //                     qoin.Get.offAll(HomeScreen());
        //                   });
        //                 },
        //                 onReview: () {
        //                   DialogUtils.showMainPopup(
        //                     radius: 10,
        //                     barrierDismissible: false,
        //                     image: Assets.icAddKTP,
        //                     title: 'Verifikasi E-KTP Masih Berlangsung',
        //                     description: "Mohon menunggu, verifikasi E-KTP kamu masih dalam proses review",
        //                     mainButtonText: "Kembali",
        //                     color: Colors.white,
        //                     mainButtonFunction: () {
        //                       qoin.Get.back();
        //                     },
        //                   );
        //                 },
        //                 onError: (error) {
        //                   DialogUtils.showMainPopup(
        //                     radius: 10,
        //                     image: Assets.icErrorOccured,
        //                     title: 'Terjadi Masalah',
        //                     description: "Kami sedang memperbaiki masalah yang terjadi, mohon coba beberapa saat lagi.",
        //                     mainButtonText: "Tutup",
        //                     color: Colors.white,
        //                     mainButtonFunction: () {
        //                       qoin.Get.back();
        //                     },
        //                   );
        //                 },
        //               );
        //             },
        //           ),
        //         )
        //       : SizedBox();
        default:
          SizedBox();
      }
    }

    return WillPopScope(
      onWillPop: () {
        qoin.DigitalIdController.instance.isStopGenerateQr = true;
        return Future.value(true);
      },
      child: ModalProgress(
        loadingStatus: qoin.DigitalIdController.instance.isMainLoading.stream,
        child: Scaffold(
          backgroundColor: ColorUI.shape,
          appBar: AppBarWidget(
            title: DigitalIdLocalization.detailDigitalDocTitle.tr,
            onBack: () {
              qoin.DigitalIdController.instance.isStopGenerateQr = true;
              qoin.Get.back();
            },
            actions: [
              data == null
                  ? SizedBox()
                  : IconButton(
                      icon: Image.asset(
                        Assets.icFullscreen,
                        fit: BoxFit.fill,
                        width: 32.w,
                        height: 32.w,
                      ),
                      onPressed: () => Get.to(() => CardFullscreen(data: data)),
                    ),
              // IconButton(
              //   icon: Image.asset(
              //     Assets.icFullscreen,
              //     fit: BoxFit.fill,
              //     width: 32.w,
              //     height: 32.w,
              //   ),
              //   onPressed: () {
              //     Get.to(() => CardFullscreen(data: data));
              //   },
              // ),
            ],
          ),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Background(height: 118.w),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      _content()!,
                      if (data!.docCardType ==
                              qoin.CardCode.ktpCardType.toString() &&
                          data!.status != DigitalDocStatus.active)
                        _form()
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _bottomButton(),
        ),
      ),
    );
  }

  showKorlantas() {
    DialogUtils.showMainPopup(
      animation: Assets.problemAnimation,
      title: 'Gagal Verifikasi Data',
      description:
          "Silahkan lakukan digitalisasi SIM di aplikasi Digital Korlantas",
      color: Colors.white,
      mainButtonText: "Buka Aplikasi Korlantas",
      mainButtonFunction: () async {
        if (Platform.isIOS) {
          const url =
              "https://apps.apple.com/id/app/digital-korlantas-polri/id1565558949";
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            DialogUtils.showMainPopup(
              image: Assets.problemAnimation,
              title: 'Terjadi Masalah',
              description: "Gagal membuka Aplikasi Digital Korlantas",
              mainButtonText: "Tutup",
              color: Colors.white,
              mainButtonFunction: () {
                Get.back();
              },
            );
          }
        } else {
          const url =
              "https://play.google.com/store/apps/details?id=id.qoin.korlantas.user&hl=en&gl=US";
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            DialogUtils.showMainPopup(
              image: Assets.problemAnimation,
              title: 'Terjadi Masalah',
              description: "Gagal membuka Aplikasi Digital Korlantas",
              mainButtonText: "Tutup",
              color: Colors.white,
              mainButtonFunction: () {
                Get.back();
              },
            );
          }
        }
      },
      secondaryButtonText: "Tutup",
      secondaryButtonFunction: () async {
        Get.back();
      },
    );
  }

  Widget _form() {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var tempDob = data?.docDoB != ''
        ? inputFormat.parse(data!.docDoB!.substring(0, 10))
        : null;
    var outputFormat = DateFormat('dd-MM-yyyy');
    return Column(
      children: [
        MainTextField(
          labelText: DigitalIdLocalization.fSIMNIK.tr,
          initialValue: data!.nIK,
          enabled: false,
        ),
        SizedBox(
          height: 20.w,
        ),
        MainTextField(
          labelText: DigitalIdLocalization.formKTPName.tr,
          initialValue: data!.docName ?? '-',
          enabled: false,
        ),
        SizedBox(
          height: 20.w,
        ),
        MainTextField(
          labelText: DigitalIdLocalization.formKTPBirthPlace.tr,
          initialValue:
              data!.docPoB == '' || data!.docPoB == null ? '-' : data!.docPoB,
          enabled: false,
        ),
        SizedBox(
          height: 20.w,
        ),
        MainTextField(
          labelText: DigitalIdLocalization.formKTPDateOfBirth.tr,
          initialValue:
              '${outputFormat.format(tempDob!) != '01-01-0001' ? outputFormat.format(tempDob) : '-'}',
          enabled: false,
        ),
        SizedBox(
          height: 20.w,
        ),
        MainTextField(
          labelText: DigitalIdLocalization.formKTPGender.tr,
          initialValue: data!.docGender!.toLowerCase() == 'female'
              ? DigitalIdLocalization.registerGenderTypeFemale.tr
              : DigitalIdLocalization.registerGenderTypeMale.tr,
          enabled: false,
        ),
        SizedBox(
          height: 20.w,
        ),
        MainTextField(
          labelText: DigitalIdLocalization.formKTPReligion.tr,
          initialValue: data!.docReligion == null
              ? '-'
              : data!.docReligion!.toLowerCase() == 'other' ||
                      data!.docReligion == ''
                  ? '-'
                  : data!.docReligion,
          enabled: false,
        ),
        SizedBox(
          height: 20.w,
        ),
        MainTextField(
          labelText: DigitalIdLocalization.formKTPMaritalStatus.tr,
          initialValue: data!.docMarital ?? '-',
          enabled: false,
        ),
        SizedBox(
          height: 20.w,
        ),
        MainTextField(
          labelText: DigitalIdLocalization.formKTPProfession.tr,
          initialValue: data!.docProfession == null || data!.docProfession == ""
              ? '-'
              : data!.docProfession,
          enabled: false,
        ),
        SizedBox(
          height: 20.w,
        ),
        MainTextField(
          labelText: DigitalIdLocalization.detailDigitalDocNationality.tr,
          initialValue: data!.docNationality ?? '-',
          enabled: false,
        ),
        SizedBox(
          height: 20.w,
        ),
        MainTextField(
          labelText: DigitalIdLocalization.fSIMValidityPeriod.tr,
          initialValue: DigitalIdLocalization.formKTPLifetime.tr,
          enabled: false,
        )
      ],
    );
  }
}

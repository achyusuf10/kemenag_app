// JUST A MODIFICATION A BIT FROM ORC SCREEN
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/logic/controller/liveness_bindings.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/button_secondary.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/controllers/qoin_digitalid/liveness_controller.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

import 'verification_guide_screen.dart';

enum FrameType { Card, PasPhoto }

class CameraScreen extends StatefulWidget {
  final FrameType? frameType;

  CameraScreen({key, this.frameType = FrameType.Card});

  double get xRation {
    switch (frameType) {
      case FrameType.Card:
        return 5;
      case FrameType.PasPhoto:
        return 21.6;
      default:
        return 5;
    }
  }

  double get yRation {
    switch (frameType) {
      case FrameType.Card:
        return 4;
      case FrameType.PasPhoto:
        return 27.9;
      default:
        return 5;
    }
  }

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  GlobalKey headerKey = new GlobalKey();
  bool resultSent = false;
  RxBool loadingStatus = false.obs;

  @override
  void initState() {
    super.initState();

    qoin.QoinCameraController.to.initCamera(
      isOcr: false,
      onFinish: () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    debugPrint('dispose called');
    qoin.QoinCameraController.to.selfieCameraController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (qoin.QoinCameraController.to.selfieCameraController == null) {
      return Container();
    }
    if (qoin.QoinCameraController.to.selfieCameraController?.value.isInitialized == false) {
      return Container();
    }
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
        text: "Mohon menunggu\nData sedang dalam proses",
        child: Scaffold(
          appBar: AppBarWidget(
            title: "Foto Selfie",
          ),
          body: qoin.GetBuilder<qoin.QoinCameraController>(builder: (controller) {
            return controller.selfieCroppedFile != null
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 40, 24, 32),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              File(controller.selfieCroppedFile!.path),
                              width: Get.width,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
                          child: Column(
                            children: [
                              Text(
                                "Hasil Foto Selfie",
                                style: TextUI.subtitleBlack,
                              ),
                              SizedBox(height: 16.w),
                              Text(
                                "Jika foto ini menurut kamu kurang jelas, kamu dapat mengulangi proses foto selfie",
                                style: TextUI.bodyTextBlack,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 32.w),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SecondaryButton(
                                      text: 'Foto Ulang',
                                      onPressed: () async {
                                        controller.resetData();
                                        await controller.initCamera(
                                          isOcr: false,
                                          onFinish: () {
                                            setState(() {});
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 15.w),
                                  Expanded(
                                    child: MainButton(
                                      onPressed: () async {
                                        loadingStatus.value = true;
                                        if (qoin.HiveData.userDataLiveness?.base64image != null) {
                                          qoin.Get.put<LivenessController>(LivenessController());
                                          qoin.DigitalIdController.instance.compareImage =
                                              qoin.HiveData.userDataLiveness?.base64image;
                                          LivenessController.instance.verify(
                                            // isPrototype: true,
                                            onSuccess: (data) async {
                                              if (qoin.DigitalIdController.instance.data.cardType ==
                                                  qoin.CardCode.ktpCardType) {
                                                DialogUtils.showMainPopup(
                                                    image: Assets.icAddKTP,
                                                    title: "KTP kamu berhasil ditambahkan",
                                                    mainButtonText: 'Mulai Explore INISA',
                                                    mainButtonFunction: () {
                                                      Get.offAll(HomeScreen());
                                                    });
                                              } else if (qoin
                                                      .DigitalIdController.instance.data.cardType ==
                                                  qoin.CardCode.simCardType) {
                                                DialogUtils.showMainPopup(
                                                    image: Assets.icAddSIM,
                                                    title: "SIM kamu berhasil ditambahkan",
                                                    mainButtonText: 'Mulai Explore INISA',
                                                    mainButtonFunction: () {
                                                      Get.offAll(HomeScreen());
                                                    });
                                              }
                                            },
                                            onFailed: (error) {
                                              loadingStatus.value = false;
                                              if (error == '500') {
                                                DialogUtils.showMainPopup(
                                                  radius: 10,
                                                  image: Assets.icErrorOccured,
                                                  title: 'Terjadi Masalah',
                                                  description:
                                                      "Kami sedang memperbaiki masalah yang terjadi, mohon coba beberapa saat lagi.",
                                                  mainButtonText: "Tutup",
                                                  color: Colors.white,
                                                  mainButtonFunction: () {
                                                    qoin.Get.back();
                                                  },
                                                );
                                                return;
                                              } else if (error == '400') {
                                                DialogUtils.showMainPopup(
                                                  radius: 10,
                                                  // image: Assets.icFaceNotMatch,
                                                  title: 'Verifikasi Wajah Gagal',
                                                  description:
                                                      "Foto selfie dengan hasil verifikasi wajah kamu tidak sesuai.",
                                                  mainButtonText: "Ulangi Foto Wajah",
                                                  color: Colors.white,
                                                  mainButtonFunction: () async {
                                                    qoin.Get.back();
                                                  },
                                                );
                                                return;
                                              } else {
                                                DialogUtils.showMainPopup(
                                                  radius: 10,
                                                  image: Assets.icErrorOccured,
                                                  title: 'Terjadi Masalah',
                                                  description:
                                                      "Kami sedang memperbaiki masalah yang terjadi, mohon coba beberapa saat lagi.",
                                                  mainButtonText: "Tutup",
                                                  color: Colors.white,
                                                  mainButtonFunction: () {
                                                    qoin.Get.back();
                                                  },
                                                );
                                                return;
                                              }
                                            },
                                          );
                                        } else {
                                          Get.to(() => VerificationGuideScreen(), binding: LivenessBindings());
                                        }
                                      },
                                      text: 'Gunakan Foto Ini',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      _cameraPreview(
                        key: controller.cameraWidgetKey,
                        controller: controller.selfieCameraController,
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            if (widget.frameType == FrameType.Card)
                              Container(
                                  width: double.infinity,
                                  key: headerKey,
                                  color: Get.theme.colorScheme.primary,
                                  padding: EdgeInsets.fromLTRB(
                                    20,
                                    20,
                                    20,
                                    30,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        qoin.DigitalIdController.instance.data.cardType == qoin.CardCode.ktpCardType
                                            ? "Ambil Foto E-KTP"
                                            : "Ambil Foto SIM",
                                        style: TextUI.subtitleWhite,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        "Posisikan ${qoin.DigitalIdController.instance.data.cardType == qoin.CardCode.ktpCardType ? 'E-KTP' : 'SIM'} kamu dalam kotak dan\npastikan dapat terbaca dengan jelas",
                                        style: TextUI.bodyTextWhite,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  )),
                            AspectRatio(
                              key: controller.cameraKey,
                              aspectRatio: widget.xRation / widget.yRation,
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.65), BlendMode.srcOut),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.w),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Get.theme.colorScheme.primary,
                                child: Column(
                                  children: [
                                    Spacer(),
                                    Row(
                                      children: [
                                        Spacer(),
                                        InkResponse(
                                          onTap: () async {
                                            controller.onTakePictureSelfieButtonPressed(
                                              xRation: widget.xRation,
                                              yRation: widget.yRation,
                                              onSuccess: () async {
                                                var bytes =
                                                    await qoin.QoinCameraController.to.selfieCroppedFile?.readAsBytes();
                                                qoin.DigitalIdController.instance.image = base64Encode(bytes!.toList());
                                              },
                                              onFailedCropped: (error) {},
                                            );
                                          },
                                          child: Center(
                                            child: Container(
                                              width: 64,
                                              height: 64,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Container(
                                                  margin: EdgeInsets.all(6.81),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Color(0xFF6F6F6F),
                                                      width: 2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Spacer()
                                      ],
                                    ),
                                    SizedBox(height: 40.w),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
          }),
        ),
      ),
    );
  }

  Widget _cameraPreview({required GlobalKey key, required CameraController? controller}) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }
    return Container(
      key: key,
      child: CameraPreview(
        controller,
      ),
    );
  }
}

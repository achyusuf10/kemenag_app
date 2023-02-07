import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:inisa_app/ui/screen/digital_id/form_g20_screen.dart';
import 'package:inisa_app/ui/screen/digital_id/form_passport_screen.dart';
import 'package:inisa_app/ui/screen/digital_id/form_sim_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/button_secondary.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/helpers/utils/qoin_extensions.dart';
import 'package:face_sdk/face_sdk.dart';

import 'digitalid_component.dart';
import 'form_ktp_screen.dart';

class OCRScreen extends StatefulWidget {
  @override
  State<OCRScreen> createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  final GlobalKey headerKey = new GlobalKey();

  final GlobalKey screenKey = new GlobalKey();

  final bool resultSent = false;

  var cardType;

  @override
  void initState() {
    cardType = DigitalIdComponent.getCardType(qoin.DigitalIdController.instance.data.cardType ?? 0);
    super.initState();

    qoin.QoinCameraController.to.initCamera(onFinish: () {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    debugPrint('dispose called');
    qoin.QoinCameraController.to.ocrCameraController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (qoin.QoinCameraController.to.ocrCameraController == null) {
      return Container();
    }
    if (qoin.QoinCameraController.to.ocrCameraController?.value.isInitialized == false) {
      return Container();
    }
    return Container(
      key: screenKey,
      width: double.infinity,
      height: double.infinity,
      child: ModalProgress(
        loadingStatus: qoin.OcrController.instance.isLoading.stream,
        child: Scaffold(
          appBar: AppBarWidget(
            title: DigitalIdLocalization.titleIdConfirmation.tr,
            actions: [
              qoin.GetBuilder<qoin.QoinCameraController>(
                builder: (controller) {
                  return controller.ocrCameraController != null && controller.ocrCroppedFile == null
                      ? IconButton(
                          icon: Icon(
                            controller.ocrCameraController?.value.flashMode == FlashMode.off
                                ? Icons.flash_off_rounded
                                : controller.ocrCameraController?.value.flashMode == FlashMode.torch
                                    ? Icons.flash_on_rounded
                                    : Icons.flash_off_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (controller.ocrCameraController?.value.flashMode == FlashMode.off) {
                              controller.onSetFlashModeButtonPressed(FlashMode.torch);
                            } else {
                              controller.onSetFlashModeButtonPressed(FlashMode.off);
                            }
                          },
                        )
                      : SizedBox();
                },
              )
            ],
          ),
          body: qoin.GetBuilder<qoin.QoinCameraController>(builder: (controller) {
            return controller.ocrCroppedFile != null
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 40, 24, 32),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              File(controller.ocrCroppedFile!.path),
                              width: Get.width,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
                          child: Column(
                            children: [
                              Text("${DigitalIdLocalization.resultPhoto.tr} $cardType",
                                  style: TextUI.subtitleBlack),
                              SizedBox(height: 16.w),
                              Text(
                                DigitalIdLocalization.ocrVerificationResult.tr,
                                style: TextUI.bodyTextBlack2,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 32.w),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SecondaryButton(
                                      text: DigitalIdLocalization.faceVerificationReshot.tr,
                                      onPressed: () async {
                                        controller.resetData();
                                        await controller.initCamera(onFinish: () {
                                          setState(() {});
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 15.w),
                                  Expanded(
                                    child: MainButton(
                                      onPressed: () async {
                                        print('screenKey w ${screenKey.globalPaintBounds!.topRight}');
                                        print('screenKey h ${screenKey.globalPaintBounds!.bottomRight}');
                                        // new OCR
                                        controller.ocrCameraController?.dispose();
                                        if (qoin.DigitalIdController.instance.data.cardType ==
                                            qoin.CardCode.ktpCardType) {
                                          await qoin.OcrController.instance.scan(
                                            controller.ocrCroppedFile,
                                            onFinished: () async {
                                              final bytes = controller.ocrCroppedFile?.readAsBytesSync();
                                              qoin.DigitalIdController.instance.ktpPhoto =
                                                  base64Encode(bytes!);
                                              qoin.DigitalIdController.instance.pictCropping =
                                                  await FaceSDK.cropFacePict(controller.ocrCroppedFile!);
                                              // log('${qoin.DigitalIdController.to.data.pictCropping}');
                                            },
                                          );
                                          Get.to(() => FormKTPScreen());
                                        } else if (qoin.DigitalIdController.instance.data.cardType ==
                                            qoin.CardCode.simCardType) {
                                          await qoin.OcrController.instance.ocrScanSimFromImage(
                                            imgRsc: controller.ocrCroppedFile!,
                                            onFinished: () async {
                                              final bytes = controller.ocrCroppedFile?.readAsBytesSync();
                                              qoin.DigitalIdController.instance.ktpPhoto =
                                                  base64Encode(bytes!);
                                            },
                                          );
                                          Get.to(() => FormSIMScreen());
                                        } else if (qoin.DigitalIdController.instance.data.cardType ==
                                            qoin.CardCode.passportCardType) {
                                          await qoin.OcrController.instance.ocrScanPassport(
                                            controller.ocrCroppedFile,
                                            onSuccess: (registerNo, mrzData) {
                                              qoin.DigitalIdController.instance.passportTypeCode =
                                                  mrzData.documentType;
                                              qoin.DigitalIdController.instance.registerNo = registerNo;
                                              qoin.DigitalIdController.instance.nationalityCode =
                                                  mrzData.countryCode;
                                              qoin.DigitalIdController.instance.nationality =
                                                  mrzData.countryCode == "IDN" ? "WNI" : "WNA";
                                              qoin.DigitalIdController.instance.name =
                                                  mrzData.givenNames + " " + mrzData.surnames;
                                              qoin.DigitalIdController.instance.docNo =
                                                  mrzData.documentNumber;
                                              qoin.DigitalIdController.instance.dob = mrzData.birthDate
                                                  .toString()
                                                  .replaceAll(" 00:00:00.000", "");
                                              if (mrzData.sex.toString() == "Sex.female") {
                                                qoin.DigitalIdController.instance.gender = 'female';
                                              } else {
                                                qoin.DigitalIdController.instance..gender = 'male';
                                              }
                                              qoin.DigitalIdController.instance.expired = mrzData.expiryDate
                                                  .toString()
                                                  .replaceAll(" 00:00:00.000", "");
                                              var splitExpiry = mrzData.expiryDate
                                                  .toString()
                                                  .replaceAll(" 00:00:00.000", "")
                                                  .split("-");
                                              int year = int.parse(splitExpiry[0]) - 5;
                                              qoin.DigitalIdController.instance.issuerDate = year.toString() +
                                                  '-' +
                                                  splitExpiry[1] +
                                                  '-' +
                                                  splitExpiry[2];
                                              final bytes = controller.ocrCroppedFile?.readAsBytesSync();
                                              qoin.DigitalIdController.instance.ktpPhoto =
                                                  base64Encode(bytes!);

                                              //
                                              qoin.DigitalIdController.instance.nik = "";
                                              qoin.DigitalIdController.instance.pob = "";
                                              qoin.DigitalIdController.instance.issuer = "";
                                            },
                                            onFailed: (error) {
                                              qoin.DigitalIdController.instance.passportTypeCode = "P";
                                              qoin.DigitalIdController.instance.registerNo = "";
                                              qoin.DigitalIdController.instance.nationalityCode = "IDN";
                                              qoin.DigitalIdController.instance.nationality = "WNI";
                                              qoin.DigitalIdController.instance.name =
                                                  qoin.AccountsController.instance.fullName();
                                              qoin.DigitalIdController.instance.docNo = "";
                                              qoin.DigitalIdController.instance.dob = "";
                                              qoin.DigitalIdController.instance..gender = 'male';
                                              qoin.DigitalIdController.instance.expired = "";
                                              qoin.DigitalIdController.instance.issuerDate = "";
                                              final bytes = controller.ocrCroppedFile?.readAsBytesSync();
                                              qoin.DigitalIdController.instance.ktpPhoto =
                                                  base64Encode(bytes!);

                                              //
                                              qoin.DigitalIdController.instance.nik = "";
                                              qoin.DigitalIdController.instance.pob = "";
                                              qoin.DigitalIdController.instance.issuer = "";
                                            },
                                          );
                                          Get.to(() => FormPassportScreen());
                                        } else {
                                          await qoin.OcrController.instance.scanOCRG20(
                                            imgRsc: controller.ocrCroppedFile!,
                                            onFinished: () async {
                                              final bytes = controller.ocrCroppedFile?.readAsBytesSync();
                                              qoin.DigitalIdController.instance.ktpPhoto =
                                                  base64Encode(bytes!);
                                              qoin.DigitalIdController.instance.pictCropping =
                                                  await FaceSDK.cropFacePict(controller.ocrCroppedFile!);
                                            },
                                          );
                                          Get.to(() => FormG20Screen());
                                        }
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
                  )
                : Stack(
                    children: [
                      _cameraPreview(
                        key: controller.cameraWidgetKey,
                        controller: controller.ocrCameraController,
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container(
                                width: double.infinity,
                                key: headerKey,
                                color: Get.theme.colorScheme.primary,
                                padding: EdgeInsets.fromLTRB(
                                  20.w,
                                  20.w,
                                  20.w,
                                  30.h,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${DigitalIdLocalization.verificationGuideButtonTakePhoto.tr} $cardType",
                                      style: TextUI.subtitleWhite,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      "${DigitalIdLocalization.ocrDesclaimer1.tr} $cardType ${DigitalIdLocalization.ocrDesclaimer2.tr}",
                                      style: TextUI.bodyTextWhite,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )),
                            AspectRatio(
                              key: controller.cameraKey,
                              aspectRatio: 5 / 4,
                              child: ColorFiltered(
                                colorFilter:
                                    ColorFilter.mode(Colors.black.withOpacity(0.65), BlendMode.srcOut),
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
                                            controller.onTakePictureOcrButtonPressed(
                                                onSuccess: () async {
                                                  await controller.initCamera(onFinish: () {
                                                    setState(() {});
                                                  });
                                                },
                                                onFailed: (error) {});
                                          },
                                          child: Center(
                                            child: Container(
                                              width: 64,
                                              height: 64,
                                              decoration:
                                                  BoxDecoration(color: Colors.white, shape: BoxShape.circle),
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/controllers/qoin_services/pl_controllers.dart';
import 'package:qoin_sdk/models/qoin_services/peduli_lindungi/preview_scan_data.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:location/location.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_settings/app_settings.dart';

import 'pl_checkin_detail_page.dart';
import 'powerby_widget.dart';

class PLCheckInConfirmationPage extends StatefulWidget {
  String? qrType;

  PLCheckInConfirmationPage({this.qrType});

  @override
  _PLCheckInConfirmationPageState createState() =>
      _PLCheckInConfirmationPageState();
}

class _PLCheckInConfirmationPageState extends State<PLCheckInConfirmationPage> {
  String qrType = "Check-In";
  String activityCategory = QoinServicesLocalization.plOutdoor.tr;
  PreviewScanData? previewScanData;
  Location location = new Location();
  double distanceInMeters = 0;
  double radius = 0;
  var canCheck = false.obs;

  @override
  void initState() {
    super.initState();
    previewScanData = PLController.to.previewScanData;
    if (previewScanData?.activityCategory == "indoor") {
      activityCategory = QoinServicesLocalization.plIndoor.tr;
    }
    if (widget.qrType == "checkout") {
      qrType = "Check-Out";
      radius = previewScanData!.checkoutPin!.radius!.toDouble();
    } else {
      radius = previewScanData!.checkpoint!.checkinpin!.radius!.toDouble();
    }
  }

  // void getDistanceInMeters(String qrType) async {
  //   var userLocation = await location.getLocation();
  //   distanceInMeters = Geolocator.distanceBetween(
  //       (widget.qrType == "checkout")
  //           ? previewScanData!.checkoutPin!.latitude!
  //           : previewScanData!.checkpoint!.checkinpin!.latitude!,
  //       (widget.qrType == "checkout")
  //           ? previewScanData!.checkoutPin!.longitude!
  //           : previewScanData!.checkpoint!.checkinpin!.longitude!,
  //       userLocation.latitude!,
  //       userLocation.longitude!);

  //   // print("distance in meters $distanceInMeters // radius $radius // user location ${userLocation.latitude}, ${userLocation.longitude}");
  // }

  _checkPermissionAndEnability() async {
    var _permissionStatus = await Permission.location.status;
    if (_permissionStatus.isDenied || _permissionStatus.isPermanentlyDenied) {
      canCheck.value = false;
      await Permission.location.request();
      _permissionStatus = await Permission.location.status;
      if (_permissionStatus.isDenied || _permissionStatus.isPermanentlyDenied) {
        DialogUtils.showMainPopup(
            image: Assets.accesLocation,
            title: QoinServicesLocalization.plAccessLoc.tr,
            description: QoinServicesLocalization.plAccessLocDesc.tr,
            mainButtonFunction: () async {
              Get.back();
              await openAppSettings();
            },
            mainButtonText: 'App Setting',
            secondaryButtonFunction: () async {
              Get.back();
            },
            secondaryButtonText: Localization.contactCancel.tr,
            mainPopupButtonDirection: MainPopupButtonDirection.Horizontal);
      }
      return;
    }
    var _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      canCheck.value = false;
      await DialogUtils.showMainPopup(
          image: Assets.accesLocation,
          title: 'Enable Location Setting',
          description:
              'Location setting is needed to use the Check In/Check Out feature',
          mainButtonFunction: () {
            Get.back();
            AppSettings.openLocationSettings();
          },
          mainButtonText: 'Enable',
          secondaryButtonFunction: () {
            Get.back();
          },
          secondaryButtonText: Localization.contactCancel.tr,
          mainPopupButtonDirection: MainPopupButtonDirection.Horizontal);
      if (!_serviceEnabled) {
        return;
      }
    }
    if (_serviceEnabled &&
        !_permissionStatus.isDenied &&
        !_permissionStatus.isPermanentlyDenied) {
      canCheck.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PLController());
    return Scaffold(
      appBar: AppBarWidget.light(
        title: '${QoinServicesLocalization.plConfirmation.tr} $qrType',
      ),
      body: ModalProgress(
        loadingStatus: PLController.to.isLoading.stream,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 180.h,
              color: Colors.grey[300],
              child: CachedNetworkImage(
                imageUrl: "${previewScanData?.image?.fileUrl}",
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: Container(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress))),
                errorWidget: (context, url, error) =>
                    Center(child: Text('Failed to load image.')),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${previewScanData?.name}",
                    style: TextUI.subtitleBlack,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    "${previewScanData?.location?.address}",
                    style: TextUI.bodyTextBlack,
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 0,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    QoinServicesLocalization.plCategory.tr,
                    style: TextUI.labelGrey,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    activityCategory,
                    style: TextUI.bodyTextYellow,
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Text(
                    QoinServicesLocalization.plCrowdTotal.tr,
                    style: TextUI.labelGrey,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        style: TextUI.bodyTextBlack
                            .copyWith(fontWeight: FontWeight.bold),
                        text: previewScanData?.crowd.toString()),
                    TextSpan(
                        style: TextUI.bodyText2Grey,
                        text: "/${previewScanData?.maxCapacity}")
                  ])),
                  SizedBox(
                    height: 24.h,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 0,
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MainButton(
                          text: 'Check-Out',
                          onPressed: (widget.qrType == 'checkout')
                              ? () async {
                                  await _checkPermissionAndEnability();
                                  if (canCheck.value) {
                                    PLController.to.confirmCheckOut(
                                        onSuccess: () {
                                      Get.to(() => PLCheckInDetailPage(
                                            qrType: widget.qrType,
                                          ));
                                    }, checkinManual: () {
                                      widget.qrType = 'checkin';
                                      qrType = "Check-In";
                                      setState(() {});
                                      showErrorDialog(
                                          'Anda belum melakukan checkin di tempat ini. Silahkan checkin',
                                          buttonPositiveText: 'Tutup');
                                    }, onFailed: (error, status) {
                                      showErrorDialog(error);
                                    });
                                  }
                                }
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: 16.h,
                      ),
                      Expanded(
                        child: MainButton(
                          onPressed: (widget.qrType == 'checkin')
                              ? () async {
                                  await _checkPermissionAndEnability();
                                  if (canCheck.value) {
                                    PLController.to.confirmCheckIn(
                                        onSuccess: () {
                                      Get.to(() => PLCheckInDetailPage(
                                            qrType: widget.qrType,
                                          ));
                                    }, checkoutManual: () {
                                      widget.qrType = 'checkout';
                                      qrType = "Check-Out";
                                      setState(() {});
                                      showErrorDialog(
                                          'Anda masih checkin di tempat ini, silahkan checkout',
                                          buttonPositiveText: 'Tutup');
                                    }, onFailed: (error, status) {
                                      showErrorDialog(error);
                                    });
                                  }
                                }
                              : null,
                          text: 'Check-In',
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Spacer(),
            PoweredBy(),
            SizedBox(
              height: 16.h,
            ),
          ],
        ),
      ),
    );
  }

  void showErrorDialog(String message, {String? buttonPositiveText}) {
    DialogUtils.showMainPopup(
        image: Assets.icErrorOccured,
        title: QoinServicesLocalization.plOops.tr,
        description: "$message",
        mainButtonFunction: () {
          Get.back();
        },
        mainButtonText: buttonPositiveText ?? Localization.tryAgain.tr,
        secondaryButtonFunction: () {
          Get.back();
        },
        secondaryButtonText: Localization.contactCancel.tr,
        mainPopupButtonDirection: MainPopupButtonDirection.Horizontal);
  }
}

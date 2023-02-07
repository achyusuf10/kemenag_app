import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:qoin_sdk/controllers/qoin_services/pl_controllers.dart';
import 'package:qoin_sdk/models/qoin_services/peduli_lindungi/confirm_scan_data.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'powerby_widget.dart';

class PLCheckInDetailPage extends StatefulWidget {
  String? qrType;

  PLCheckInDetailPage({this.qrType});

  @override
  _PLCheckInDetailPageState createState() => _PLCheckInDetailPageState();
}

class _PLCheckInDetailPageState extends State<PLCheckInDetailPage> {
  String imageName = "";
  String title = "";
  String message = "";
  String qrType = "Check-In";
  String activityCategory = QoinServicesLocalization.plOutdoor.tr;
  String dateAndTime = "";
  Color boxColor = Colors.green;
  bool isFailed = false;

  ConfirmScanData? confirmScanData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    confirmScanData = PLController.to.confirmScanData;
    if (confirmScanData?.place?.activityType == "indoor") {
      activityCategory = QoinServicesLocalization.plOutdoor.tr;
    }
    if (widget.qrType == "checkout") {
      qrType = "Check-Out";
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PLController());
    dateAndTime = (widget.qrType == 'checkin')
        ? confirmScanData!.checkInTime!
        : confirmScanData!.checkOutTime!;
    dateAndTime = DateFormat('dd MMMM yyyy, hh:mm a').format(DateTime.parse(dateAndTime).toLocal());
    setData(userStatus: PLController.to.confirmScanData?.userStatus);
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        Get.back();
        Get.back();
        return false;
      },
      child: Scaffold(
        backgroundColor: ColorUI.shape,
        appBar: AppBarWidget(
          backgroundColor: ColorUI.shape,
          textColor: ColorUI.text_1,
          onBack: () {
            Get.back();
            Get.back();
            Get.back();
            Get.back();
            Get.back();
          },
          elevation: 0,
          title: '',
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 21.h,
              ),
              Image.asset(
                Assets.successGreen,
                height: 80.h,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(
                height: 24.h,
              ),
              Text(title,
                  style: TextUI.subtitleBlack.copyWith(
                      color: (isFailed) ? Colors.black : Color(0xff2c8424),
                      fontSize: (isFailed) ? 16.sp : 21.sp),
                  textAlign: TextAlign.center),
              SizedBox(
                height: 12.h,
              ),
              (!isFailed)
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child:
                          Text(message, style: TextUI.subtitleBlack, textAlign: TextAlign.center),
                    ),
              SizedBox(
                height: (!isFailed) ? 40.h : 16.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(24.r), topLeft: Radius.circular(24.r))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 96.h,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: boxColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(4)),
                            padding: EdgeInsets.all(8),
                            child: QrImage(
                              padding: EdgeInsets.zero,
                              data: confirmScanData!.id!,
                              size: 56.h,
                            ),
                          ),
                          Container(
                            width: 142.h,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(14),
                                    elevation: 0,
                                    primary: Colors.white),
                                onPressed: () {
                                  DialogUtils.showGeneralPopup(
                                      radius: 4.r,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                                      content: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          QrImage(
                                            padding: EdgeInsets.zero,
                                            data: confirmScanData!.id!,
                                            size: 200.h,
                                          ),
                                          SizedBox(
                                            height: 24.h,
                                          ),
                                          MainButton(
                                            text: Localization.close.tr,
                                            onPressed: () => Get.back(),
                                          )
                                        ],
                                      ));
                                },
                                child: Text(
                                  QoinServicesLocalization.plShowQR.tr,
                                  style: TextUI.subtitleBlack,
                                )),
                          )
                        ],
                      ),
                    ),
                    (!isFailed)
                        ? SizedBox()
                        : Container(
                            margin: EdgeInsets.only(top: 20.h),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      Assets.warning,
                                      height: 24.h,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    SizedBox(
                                      width: 16.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            QoinServicesLocalization.plWhyBlack.tr,
                                            style: TextUI.subtitleBlack,
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          Text(QoinServicesLocalization.plWhyBlackDesc.tr,
                                              style: TextUI.bodyText2Black)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                Divider(
                                  color: Colors.grey,
                                  height: 0,
                                ),
                              ],
                            ),
                          ),
                    SizedBox(
                      height: 24.h,
                    ),
                    Text(
                      "${QoinServicesLocalization.plInformation.tr} $qrType",
                      style: TextUI.subtitleBlack,
                    ),
                    checkInInformation(
                        imagePath: Assets.iconBuilding,
                        title: '${QoinServicesLocalization.plLoc.tr} $qrType',
                        description: '${confirmScanData?.place?.name}'),
                    checkInInformation(
                        imagePath: Assets.iconCalendar,
                        title: QoinServicesLocalization.plDateTimeScan.tr,
                        description: '$dateAndTime'),
                    checkInInformation(
                        imagePath: Assets.iconPointsBlack,
                        title: QoinServicesLocalization.plCategory.tr,
                        description: QoinServicesLocalization.plIndoor.tr),
                    SizedBox(
                      height: 32.h,
                    ),
                    PoweredBy(),
                    SizedBox(
                      height: 16.h,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget checkInInformation(
      {required String imagePath, required String title, required String description}) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Image.asset(
              imagePath,
              height: 24.h,
              width: 24.h,
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextUI.labelGrey,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(description, style: TextUI.bodyTextBlack),
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: Divider(
                    height: 1,
                    color: ColorUI.text_4,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void setData({String? userStatus}) {
    switch (userStatus) {
      case "green":
        imageName = Assets.successGreen;
        title = "$qrType ${Localization.success.tr}";
        message = "";
        boxColor = Color(0xff2c8424);
        isFailed = false;
        break;
      case "yellow":
        imageName = Assets.successGreen;
        title = "$qrType ${Localization.success.tr}";
        message = "";
        boxColor = Color(0xfff7b500);
        isFailed = false;
        break;
      case "red":
        imageName = Assets.warning;
        title = QoinServicesLocalization.plCantEnter.tr;
        message = QoinServicesLocalization.plCantEnterDesc.tr;
        boxColor = Color(0xffeb5050);
        isFailed = true;
        break;
      case "black":
        imageName = Assets.warning;
        title = QoinServicesLocalization.plCantEnter.tr;
        message = QoinServicesLocalization.plCantEnterDesc.tr;
        boxColor = Colors.black;
        isFailed = true;
        break;
      default:
        return;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_bottom.dart';
import 'package:qoin_sdk/controllers/qoin_services/pl_controllers.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'pl_register_page.dart';

class PeduliLindungiScreen extends StatelessWidget {
  const PeduliLindungiScreen();

  @override
  Widget build(BuildContext context) {
    Get.put(PLController());
    return Scaffold(
      appBar: AppBarWidget.light(
        title: 'PeduliLindungi',
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 64.0.h, bottom: 24.0.h),
              child: Image.asset(
                Assets.scanQR,
                height: 128.h,
                width: 128.w,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                QoinServicesLocalization.plOpening.tr,
                style: TextUI.bodyTextBlack2,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      bottomSheet: ButtonBottom(
        text: QoinServicesLocalization.plStart.tr,
        onPressed: () async {
          var status = await Permission.location.status;
          if (status.isDenied || status.isPermanentlyDenied) {
            await Permission.location.request();
            status = await Permission.location.status;
            if (status.isDenied || status.isPermanentlyDenied) {
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
                  mainPopupButtonDirection:
                      MainPopupButtonDirection.Horizontal);
            }
          } else {
            Get.to(() => PLRegisterPage());
          }
        },
      ),
    );
  }
}

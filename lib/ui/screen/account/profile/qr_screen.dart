import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/qr_widget.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({Key? key}) : super(key: key);

  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  GlobalKey qrKey = GlobalKey();

  bool isHide = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorUI.shape,
        appBar: AppBarWidget.light(
          title: Localization.qrCode.tr,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 64,
            ),
            RepaintBoundary(
              key: qrKey,
              child: Container(
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(32, 48, 32, 24),
                      margin: EdgeInsets.fromLTRB(24, 32, 24, 0),
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(HiveData.userData!.fullname ?? Localization.qrCode.tr,
                              style: TextUI.subtitleBlack),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                              HiveData.userData?.qoinTag ??
                                  "${HiveData.userData?.phone?.substring(0, 4)}*****${HiveData.userData?.phone?.substring(HiveData.userData!.phone!.length - 3, HiveData.userData?.phone?.length)}",
                              style:
                                  Get.textTheme.headline6!.copyWith(fontWeight: FontWeight.w500)),
                          SizedBox(
                            height: 24,
                          ),
                          QrWidget.profile(),
                          SizedBox(
                            height: 24.0,
                          ),
                          Text(
                            Localization.qrCodeShow.tr,
                            style: Get.textTheme.headline6,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          if (!isHide)
                            MainButton(
                              text: Localization.share.tr,
                              onPressed: () async {
                                setState(() {
                                  isHide = true;
                                });
                                await Future.delayed(Duration(seconds: 1));
                                File image = await WidgetUtils.capture(qrKey);
                                AnyUtils.share(
                                  imagePaths: [image.path],
                                  message: Localization.qrCodeScanTo.tr,
                                );
                                setState(() {
                                  isHide = false;
                                });
                              },
                            )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32), color: Colors.grey.shade300),
                        clipBehavior: Clip.hardEdge,
                        child: HiveData.userData!.pict != null
                            ? Image.memory(
                                base64Decode(HiveData.userData!.pict!),
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                Assets.person,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

// Container(
//               padding: EdgeInsets.fromLTRB(32, 0, 32, 24),
//               margin: EdgeInsets.fromLTRB(24, 484, 24, 0),
//               decoration:
//                   BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//               child: MainButton(
//                 text: Localization.share.tr,
//                 onPressed: () async {
//                   File image = await WidgetUtils.capture(qrKey);
//                   print(image.path);
//                   AnyUtils.share(
//                     imagePaths: [image.path],
//                     message: Localization.qrCodeScanTo.tr,
//                   );
//                 },
//               ),
//             )

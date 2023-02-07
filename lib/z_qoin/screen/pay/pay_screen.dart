import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/contact/contact_widget.dart';
import 'package:inisa_app/ui/widget/image_scanner_animation.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:qoin_sdk/widgets/bottom_slide_up_widget.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../qris/qris_screen.dart';
import 'pay_input_amount_screen.dart';

class PayScreen extends StatefulWidget {
  PayScreen({Key? key}) : super(key: key);

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final double minHeight = 250;

  void animateScanAnimation(bool reverse) {
    if (reverse) {
      QrWalletController.to.animationController?.reverse(from: 1.0);
    } else {
      QrWalletController.to.animationController?.forward(from: 0.0);
    }
  }

  @override
  void initState() {
    super.initState();
    // qoin.Get.put(ContactController());
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (ContactController.to.datas.isNotEmpty) ContactController.to.searchContact('');
    });
    // QrWalletController.to.reqCameraPermission().then((value) => ContactController.to.fetchContact());

    //scan animation
    QrWalletController.to.animationController =
        new AnimationController(duration: new Duration(milliseconds: 1200), vsync: this);

    QrWalletController.to.animationController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animateScanAnimation(true);
      } else if (status == AnimationStatus.dismissed) {
        animateScanAnimation(false);
      }
    });

    animateScanAnimation(false);
    QrWalletController.to.animationStopped = false;
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      QrWalletController.to.qrViewController?.pauseCamera();
    } else if (Platform.isIOS) {
      QrWalletController.to.qrViewController?.resumeCamera();
    }
  }

  @override
  void dispose() {
    QrWalletController.to.animationController?.dispose();
    QrWalletController.to.qrViewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return SlideUpController.to.isCanBack(minHeight);
      },
      child: Theme(
        data: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
        ),
        child: ModalProgress(
          loadingStatus: QrWalletController.to.isMainLoading.stream,
          child: Scaffold(
            key: _scaffoldKey,
            body: BottomSlideUpWidget(
              mainWidget: _mainWidget(context),
              // title: "Kartu Pelajar",
              slideUpTitle: _slideUpTitleWidget(),
              // slideUpBody: _slideUpWidget(),
              // slideUpTitle: Container(),
              slideUpBody: Container(),
              sliderThumbHeight: minHeight,
              maxTopMargin: 0,
            ),
            endDrawer: SafeArea(
              child: Drawer(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _slideUpWidget() {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      child: Container(
        height: ScreenUtil().screenHeight - kToolbarHeight * 2,
        child: Column(
          children: [
            // ContactWidget.plain(onItemTap: (data) {
            //   String phoneNumber = data.phone.replaceAll("+", "").replaceAll("-", "").replaceAll(" ", "");
            //   if (phoneNumber.startsWith("62")) {
            //     phoneNumber = "0" + phoneNumber.substring(2);
            //   }
            //   if (phoneNumber.startsWith("0")) {
            //     qoin.QrWalletController.to.isMainLoading.value = true;
            //     qoin.QoinWalletController.to.getVa(
            //       phoneNumber: phoneNumber,
            //       onSuccess: () {
            //         qoin.QrWalletController.to.isMainLoading.value = false;
            //         qoin.Get.to(PayInputAmountScreen());
            //       },
            //       onError: (val) {
            //         qoin.QrWalletController.to.isMainLoading.value = false;
            //         DialogUtils.showMainPopup(
            //             image: Assets.icUnregistered,
            //             title: WalletLocalization.notINISAUser.tr,
            //             description: WalletLocalization.notINISAUserDesc.tr,
            //             mainButtonText: WalletLocalization.invite.tr,
            //             mainButtonFunction: () => qoin.Get.back());
            //       },
            //     );
            //   }
            // }),
          ],
        ),
      ),
    );
  }

  Widget _slideUpTitleWidget() {
    return new Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 12,
          ),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              WalletLocalization.selectMethodPayment.tr,
              style: TextUI.subtitleBlack,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: _rectangleOptions(icon: Assets.icQRScan, text: 'Scan QR Code', onTap: () {})),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: _rectangleOptions(icon: Assets.icQRCode, text: WalletLocalization.myQR.tr, onTap: () {})),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              WalletLocalization.scanQRDesc.tr,
              style: TextUI.bodyText2Black,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16.0),
            child: Row(
              children: [
                Expanded(child: Container(height: 1, color: Colors.grey[300])),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    WalletLocalization.orPayWith.tr,
                    style: TextUI.bodyText2Grey,
                  ),
                ),
                Expanded(
                    child: Container(
                  height: 1,
                  color: Colors.grey[300],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainWidget(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        _buildQrView(context),
        GetBuilder<QrWalletController>(builder: (controller) {
          return ImageScannerAnimation(
            controller.animationStopped,
            MediaQuery.of(context).size.width,
            animation: controller.animationController,
          );
        }),
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    // var scanArea =
    //     (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 200.0 : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: (ctr) {
        QrWalletController.to.onQrViewCreated(
          ctr,
          onSuccessQris: (data) async {
            print("qris result : $data");
            await Get.to(QRISScreen(
              inquiryData: data,
            ));
            ctr.resumeCamera();
          },
          onSuccessQtag: () {
            Get.to(PayInputAmountScreen());
            ctr.resumeCamera();
          },
          onErrorQris: (error) {
            print("scan qris error $error");
            DialogUtils.showMainPopup(
                animation: Assets.problemAnimation,
                title: WalletLocalization.scanQRFail.tr,
                description: WalletLocalization.scanQRFailDesc.tr,
                mainButtonText: Localization.close.tr,
                mainButtonFunction: () {
                  ctr.resumeCamera();
                  Get.back();
                });
          },
          onErrorQtag: (error) {
            print("get va error $error");
            DialogUtils.showMainPopup(
                image: Assets.icUnregistered,
                title: WalletLocalization.notINISAUser.tr,
                description: WalletLocalization.notINISAUserDesc.tr,
                mainButtonText: WalletLocalization.invite.tr,
                mainButtonFunction: () {
                  ctr.resumeCamera();
                  Get.back();
                });
          },
        );
      },
      // overlay: QrScannerOverlayShape(
      //     borderColor: QoinWallet.theme.accentColor,
      //     borderRadius: 10,
      //     borderLength: 30,
      //     borderWidth: 10,
      //     cutOutSize: scanArea
      // ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('no Permission')),
      // );
    }
  }

  Widget _rectangleOptions({required Function() onTap, required String icon, required String text}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: (_options[index].isActive ?? false) ? ColorUI.qoinSecondary : Colors.grey[300]!),
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 21.w,
              // color: (_options[index].isActive ?? false) ? ColorUI.qoinSecondary : Colors.grey,
              color: Colors.grey,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              text,
              style: TextUI.bodyText2Black.copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/widget/contact/contact_widget.dart';
import 'package:inisa_app/ui/widget/image_scanner_animation.dart';
// import 'package:inisa_app/ui/widget/contact/contact_widget.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:inisa_app/ui/widget/qr_widget.dart';
import 'package:inisa_app/z_qoin/screen/qris/qris_screen.dart';
import 'package:qoin_sdk/controllers/qoin_wallet/qoin_wallet_controller.dart';
import 'package:qoin_sdk/controllers/qoin_wallet/qr_wallet_controller.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'pay_input_amount_screen.dart';

class PaymentOptionsOld {
  String? title;
  String? image;
  bool? isActive;

  PaymentOptionsOld({this.title, this.image, this.isActive});
}

class PayScreenOld extends StatefulWidget {
  const PayScreenOld({key}) : super(key: key);

  @override
  _PayScreenOldState createState() => _PayScreenOldState();
}

class _PayScreenOldState extends State<PayScreenOld> with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  AnimationController? _animationController;
  bool _animationStopped = false;
  // String scanText = "Scan";
  // bool scanning = false;

  int _widgetIndex = 0;

  //auto expand bottomsheet
  static const double minExtent = 0.38;
  static const double maxExtent = 0.9;
  bool isExpanded = false;
  double initialExtent = minExtent;
  BuildContext? draggableSheetContext;

  List<PaymentOptionsOld> _options = [
    PaymentOptionsOld(title: 'Scan QR Code', image: Assets.icQRScan, isActive: true),
    PaymentOptionsOld(title: WalletLocalization.myQR.tr, image: Assets.icQRCode, isActive: false)
  ];

  void _toggleDraggableScrollableSheet() {
    if (draggableSheetContext != null) {
      setState(() {
        // initialExtent = isExpanded ? minExtent : maxExtent;
        print("call toggle");
        isExpanded = !isExpanded;
        initialExtent = maxExtent;
      });
      DraggableScrollableActuator.reset(draggableSheetContext!);
    }
  }

  void animateScanAnimation(bool reverse) {
    if (reverse) {
      _animationController?.reverse(from: 1.0);
    } else {
      _animationController?.forward(from: 0.0);
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qoin.QrWalletController.to.qrViewController?.pauseCamera();
    } else if (Platform.isIOS) {
      qoin.QrWalletController.to.qrViewController?.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
    qoin.Get.put(qoin.ContactController());
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (qoin.ContactController.to.datas.isNotEmpty) {
        qoin.ContactController.to.searchContact('');
      }
    });
    if (qoin.ContactController.to.datas.isEmpty) {
      qoin.ContactController.to.fetchContact();
    }
    // qoin.QrWalletController.to.reqCameraPermission().then((value) => qoin.ContactController.to.fetchContact());

    //scan animation
    _animationController = new AnimationController(duration: new Duration(milliseconds: 1200), vsync: this);

    _animationController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animateScanAnimation(true);
      } else if (status == AnimationStatus.dismissed) {
        animateScanAnimation(false);
      }
    });

    animateScanAnimation(false);
    setState(() {
      _animationStopped = false;
      // scanning = true;
      // scanText = "Stop";
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    qoin.QrWalletController.to.qrViewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
      ),
      child: ModalProgress(
        loadingStatus: qoin.QrWalletController.to.isMainLoading.stream,
        child: Scaffold(
          backgroundColor: ColorUI.qoinSecondary,
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Stack(
              children: [
                IndexedStack(
                  index: _widgetIndex,
                  children: [ 
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        _buildQrView(context),
                        Container(
                          child: Image(
                            image: AssetImage(
                              Assets.qris,
                            ),
                            height: 32,
                          ),
                          margin: EdgeInsets.only(bottom: 65),
                        ),
                        ImageScannerAnimation(
                          _animationStopped,
                          MediaQuery.of(context).size.width,
                          animation: _animationController,
                        ),
                      ],
                     ),
                     Container(
                        color: qoin.Get.theme.colorScheme.secondary,
                        padding: EdgeInsets.symmetric(vertical: 36, horizontal: 32),
                        child: Container(
                          margin: EdgeInsets.only(top: 37),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                WalletLocalization.qrCode.tr,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              // InkWell(
                              //   onTap: () => Get.to(PayDetailScreen()),
                              //   child: Center(
                              //     child: QrImage(
                              //       data: "${qoinController.mIdFrom},${QoinWallet.phone}",
                              //       // size: 280,
                              //     ),
                              //   ),
                              // ),
                              Center(child: QrWidget.wallet()),
                              SizedBox(
                                height: 16.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Qointag",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                                  ),
                                  Text(
                                    // "${qoinController.mIdFrom}",
                                    "${qoin.HiveData.userData!.qoinTag ?? '-'}",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 37.0),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        Expanded(
                            child: Text(
                          WalletLocalization.payment.tr,
                          textAlign: TextAlign.center,
                          style: TextUI.titleBlack,
                        )),
                      ],
                    ),
                  ]),
                ),
                NotificationListener<DraggableScrollableNotification>(
                  onNotification: (DraggableScrollableNotification DSNotification) {
                    if (DSNotification.extent <= 0.38) {
                      FocusScope.of(context).unfocus();
                      isExpanded = false;
                      initialExtent = minExtent;
                      setState(() {});
                    }
                    return true;
                  },
                  child: DraggableScrollableActuator(
                    child: DraggableScrollableSheet(
                      key: Key(initialExtent.toString()),
                      maxChildSize: maxExtent,
                      initialChildSize: initialExtent,
                      minChildSize: minExtent,
                      builder: (BuildContext context, ScrollController scrollController) {
                        draggableSheetContext = context;
                        return Container(
                          // padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  width: 40,
                                  height: 5,
                                  decoration:
                                      BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(20)),
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
                                      Expanded(child: _rectangleOptions(index: 0)),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(child: _rectangleOptions(index: 1)),
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
                                Container(
                                  height: ScreenUtil().screenHeight - kToolbarHeight * 2,
                                  child: Column(
                                    children: [
                                      ContactWidget.plain(onItemTap: (data) {
                                        String phoneNumber =
                                            data.phone.replaceAll("+", "").replaceAll("-", "").replaceAll(" ", "");
                                        if (phoneNumber.startsWith("62")) {
                                          phoneNumber = "0" + phoneNumber.substring(2);
                                        }
                                        if (phoneNumber.startsWith("0")) {
                                          qoin.QrWalletController.to.isMainLoading.value = true;
                                          qoin.QoinWalletController.to.getVa(
                                            phoneNumber: phoneNumber,
                                            onSuccess: () {
                                              qoin.QrWalletController.to.isMainLoading.value = false;
                                              qoin.Get.to(PayInputAmountScreen());
                                            },
                                            onError: (val) {
                                              qoin.QrWalletController.to.isMainLoading.value = false;
                                              DialogUtils.showMainPopup(
                                                  image: Assets.icUnregistered,
                                                  title: WalletLocalization.notINISAUser.tr,
                                                  description: WalletLocalization.notINISAUserDesc.tr,
                                                  mainButtonText: WalletLocalization.invite.tr,
                                                  mainButtonFunction: () => qoin.Get.back());
                                            },
                                          );
                                        }
                                      }),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _rectangleOptions({int index = 0}) {
    return InkWell(
      onTap: () {
        _options.forEach((element) {
          element.isActive = false;
        });
        _options[index].isActive = true;
        if (index == 1) {
          _widgetIndex = 1;
         } else {
          _widgetIndex = 0;
        }
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: (_options[index].isActive ?? false) ? ColorUI.qoinSecondary : Colors.grey[300]!),
            borderRadius: BorderRadius.circular(4)),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Image.asset(
              _options[index].image ?? '',
              width: 21.w,
              color: (_options[index].isActive ?? false) ? ColorUI.qoinSecondary : Colors.grey,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              _options[index].title ?? '',
              style: TextUI.bodyText2Black
                  .copyWith(color: (_options[index].isActive ?? false) ? ColorUI.qoinSecondary : Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    // var scanArea =
    //     (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 200.0 : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      child: QRView(
        key: qrKey,
        onQRViewCreated: (ctr) {
          qoin.QrWalletController.to.onQrViewCreated(
            ctr,
            onSuccessQris: (data) async {
              print("qris result : $data");
              await qoin.Get.to(QRISScreen(
                inquiryData: data,
              ));
              ctr.resumeCamera();
            },
            onSuccessQtag: () {
              qoin.Get.to(PayInputAmountScreen());
              ctr.resumeCamera();
            },
            onErrorQris: (error) {
              print("scan qris error $error");
              DialogUtils.showMainPopup(
                  image: Assets.problem,
                  title: WalletLocalization.scanQRFail.tr,
                  description: WalletLocalization.scanQRFailDesc.tr,
                  mainButtonText: Localization.close.tr,
                  mainButtonFunction: () {
                    ctr.resumeCamera();
                    qoin.Get.back();
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
                    qoin.Get.back();
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
      ),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('no Permission')),
      // );
    }
  }

  Widget getSusItem(BuildContext context, String tag, {double susHeight = 40}) {
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 25.0),
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: Text(
        '$tag',
        softWrap: false,
        style: TextUI.bodyText2Grey,
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/image_scanner_animation.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/controllers/qoin_services/pl_controllers.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/animation.dart';

import 'pl_checkin_confirmation_page.dart';

class PLScannerPage extends StatefulWidget {
  const PLScannerPage({key}) : super(key: key);

  @override
  _PLScannerPageState createState() => _PLScannerPageState();
}

class _PLScannerPageState extends State<PLScannerPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  bool _animationStopped = false;
  String scanText = "Scan";
  bool scanning = false;
  bool flashStatus = false;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // Barcode result;
  QRViewController? controller;

  bool onChecking = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //scan animation
    _animationController = new AnimationController(
        duration: new Duration(milliseconds: 1500), vsync: this);

    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animateScanAnimation(true);
      } else if (status == AnimationStatus.dismissed) {
        animateScanAnimation(false);
      }
    });

    animateScanAnimation(false);
    setState(() {
      _animationStopped = false;
      scanning = true;
      scanText = "Stop";
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      debugPrint("check scan data : ${scanData.code}");
      controller.pauseCamera();
      if (!onChecking) {
        onChecking = true;
        var controllerPL = Get.put(PLController());
        controllerPL.previewScan(scanData.code ?? "", onSuccess: () async {
          await Get.to(() => PLCheckInConfirmationPage(
                qrType: scanData.code?.split(':')[0],
              ));
          controller.resumeCamera();
          onChecking = false;
        }, onFailed: (error) {
          DialogUtils.showPopUp(type: DialogType.problem, description: error);
          controller.resumeCamera();
          onChecking = false;
        });
      }
    });
  }

  void animateScanAnimation(bool reverse) {
    if (reverse) {
      _animationController!.reverse(from: 1.0);
    } else {
      _animationController!.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.transparent),
      ),
      child: Scaffold(
        appBar: AppBarWidget.red(
          title: "Scan QR Code",
          actions: [
            IconButton(
                onPressed: () async {
                  controller!.toggleFlash();
                  flashStatus = (await controller?.getFlashStatus())!;
                  setState(() {});
                },
                icon: Icon((flashStatus) ? Icons.flash_on : Icons.flash_off))
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: ModalProgress(
          loadingStatus: PLController.to.isLoading.stream,
          child: Stack(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  _buildQrView(context),
                  ImageScannerAnimation(
                    _animationStopped,
                    MediaQuery.of(context).size.width,
                    animation: _animationController,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 230.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Container(
      height: MediaQuery.of(context).size.height,
      child: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }
}

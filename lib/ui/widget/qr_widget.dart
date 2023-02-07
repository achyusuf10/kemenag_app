import 'dart:async';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
// import 'package:qoin_account/qoin_account.dart';
// import 'package:qoin_account/ui/helper/assets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

class QrWidget extends StatelessWidget {
  final double qrSize;
  final double imageSize;

  QrWidget.profile()
      : qrSize = 180,
        imageSize = 25;

  QrWidget.wallet()
      : qrSize = ScreenUtil().screenHeight * 0.34,
      // : qrSize = 260.h,
        imageSize = 40;

  @override
  Widget build(BuildContext context) {
    final message =
        "${HiveData.userData!.memberId}, ${HiveData.userData!.phone}, ${HiveData.userData!.qoinTag}";
    // ignore: lines_longer_than_80_chars

    final qrFutureBuilder = FutureBuilder<ui.Image>(
      future: _loadOverlayImage(),
      builder: (ctx, snapshot) {
        final size = qrSize;
        if (!snapshot.hasData) {
          return Container(width: size, height: size);
        }
        return CustomPaint(
          size: Size.square(size),
          painter: QrPainter(
            data: message,
            version: QrVersions.auto,
            embeddedImage: snapshot.data,
            embeddedImageStyle: QrEmbeddedImageStyle(
              size: Size.square(imageSize),
            ),
          ),
        );
      },
    );

    return Center(child: Container(width: qrSize, child: qrFutureBuilder));
  }

  Future<ui.Image> _loadOverlayImage() async {
    final completer = Completer<ui.Image>();
    final byteData = await rootBundle.load(Assets.qoinWithBgWhite);
    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
    return completer.future;
  }
}

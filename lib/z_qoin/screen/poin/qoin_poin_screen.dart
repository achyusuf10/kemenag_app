import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/ui/widget/powerbyqoin.dart';
import 'package:qoin_sdk/helpers/utils/intl_formats.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

import 'poin_transaction_page.dart';

class QoinPoinScreen extends StatefulWidget {
  const QoinPoinScreen({Key? key}) : super(key: key);

  @override
  _QoinPoinScreenState createState() => _QoinPoinScreenState();
}

class _QoinPoinScreenState extends State<QoinPoinScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.qoin(
        title: 'Poin',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4.r)),
                      color: const Color(0xfff7b500).withOpacity(0.16)),
                  child: CustomPaint(
                    painter: CircularBackgroundPainter(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    Assets.qoin,
                                    height: 16,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Text(
                                    'Poin',
                                    style: TextUI.subtitleBlack.copyWith(fontSize: 13.sp),
                                  )
                                ],
                              ),
                              GetBuilder<QoinWalletController>(builder: (controller) {
                                return Text(
                                  QoinWalletController.to.point + " Poin",
                                  style: TextUI.header2Black,
                                );
                              }),
                              // SizedBox(
                              //   height: 8,
                              // ),
                              // Text(
                              //   "(120 Qoin)",
                              //   style: TextUI.bodyTextBlack,
                              // ),
                              SizedBox(
                                height: 16.h,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
                          height: 24.h,
                          decoration: BoxDecoration(color: Color(0xfff7b500).withOpacity(0.16)),
                          child: Row(
                            children: [
                              // Image.asset(
                              //   Assets.attention,
                              //   height: 16,
                              // ),
                              // SizedBox(
                              //   width: 8.w,
                              // ),
                              // Text(
                              //   "1 Qoin senilai dengan 100 Rupiah",
                              //   style: TextUI.labelBlack,
                              // )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32, bottom: 12),
                  child: Text(
                    "Riwayat Transaksi",
                    style: TextUI.title2Black,
                  ),
                ),
                Expanded(
                  //child: PoinTransactionPage(),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100.w,
                        ),
                        Image.asset(
                          Assets.emptyTransactionQoin,
                          height: 180.w,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Belum ada transaksi',
                            style: TextUI.subtitleBlack,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
          // PoweredByQoin()
        ],
      ),
    );
  }
}

class CircularBackgroundPainter extends CustomPainter {
  final Paint mainPaint;
  final Paint middlePaint;
  final Paint lowerPaint;

  CircularBackgroundPainter()
      : mainPaint = new Paint(),
        middlePaint = new Paint(),
        lowerPaint = new Paint() {
    mainPaint.color = new Color(0x14f7b500);
    mainPaint.isAntiAlias = true;
    mainPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    canvas.save();

    drawBellAndLeg(radius, canvas, size);

    canvas.restore();
  }

  void drawBellAndLeg(radius, canvas, Size size) {
    Path path = Path();
    path.moveTo(size.width - 70, 0);
    path.arcToPoint(
      Offset(size.width - 70, size.height),
      clockwise: false,
      radius: Radius.elliptical(15, 20),
    );
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    Path path1 = Path();
    path1.moveTo(size.width, size.height / 1.8);
    path1.arcToPoint(
      Offset(size.width - 180, size.height),
      clockwise: false,
      radius: Radius.elliptical(130, 130),
    );
    path1.lineTo(size.width, size.height);
    path1.close();

    Path path2 = Path();
    path2.moveTo(0, 0);
    path2.lineTo(100, 0);
    path2.arcToPoint(
      Offset(100, size.height),
      clockwise: true,
      radius: Radius.elliptical(15, 20),
    );
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path, mainPaint);
    canvas.drawPath(path1, mainPaint);
    canvas.drawPath(path2, mainPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

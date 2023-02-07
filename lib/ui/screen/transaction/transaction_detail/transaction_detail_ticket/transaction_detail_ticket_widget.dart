import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/intl_formats.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_design.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/qoin_transaction_localization.g.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/screen/payment/web_view_page.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/transaction/copy_text_widget.dart';
import 'package:inisa_app/ui/widget/transaction/custom_expansion_tile_widget.dart';
import 'package:inisa_app/ui/widget/transaction/separator_widget.dart';
import 'package:inisa_app/ui/widget/transaction/text_widget.dart';
import 'package:inisa_app/ui/widget/transaction/ticket_item_widget.dart';
import 'package:inisa_app/z_qoin/screen/wallet_screen.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:qoin_sdk/models/qoin_transaction/history_data.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:share_plus/share_plus.dart';
// import 'package:venturo_mobile/yukk/ui/screens/yukk_inapp_webview_screen.dart';

import 'transaction_buy_again_button.dart';
import 'transaction_detail_expanded_ticket_widget.dart';

class TransactionDetailTicketWidget extends StatefulWidget {
  final HistoryData? data;
  final GlobalKey? globalKey;

  TransactionDetailTicketWidget({
    Key? key,
    this.data,
    this.globalKey,
  }) : super(key: key);

  @override
  _TransactionDetailTicketWidgetState createState() =>
      _TransactionDetailTicketWidgetState();
}

class _TransactionDetailTicketWidgetState
    extends State<TransactionDetailTicketWidget> {
  Uint8List? shareImg;
  bool isHide = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (widget.data?.trxCode == "VA-IN-NTT" &&
          widget.data?.trxTopUpVaDateExpired != null) {
        qoin.QoinTransactionController.to
            .setCountDownExpired(widget.data?.trxTopUpVaDateExpired);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    if (widget.data?.trxCode == "VA-IN-NTT") {
      qoin.QoinTransactionController.to.countdownExpiredTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _capturePng() async {
      setState(() {
        isHide = true;
      });
      await Future.delayed(Duration(seconds: 1));
      try {
        var boundary = widget.globalKey?.currentContext?.findRenderObject()
            as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        var pngBytes = byteData?.buffer.asUint8List();
        setState(() {
          shareImg = pngBytes;
        });
        // Save to tmp folder
        final appDir = await syspaths.getTemporaryDirectory();
        String path = '${appDir.path}/${DateTime.now().millisecond}.png';
        File file = File(path);
        await file.writeAsBytes(pngBytes!.toList());
        await Share.shareFiles([path],
            text:
                '${QoinTransactionLocalization.trxNumber.tr}: ${widget.data?.trxReceipt}');

        return true;
      } catch (e) {
        print(e);
      }
      return false;
    }

    return Container(
      margin: EdgeInsets.all(
        ScreenUtil().setHeight(16),
      ),
      padding: EdgeInsets.all(
        ScreenUtil().setHeight(16),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            ScreenUtil().radius(5),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xffe8e8e8),
            offset: Offset(0, 2),
            blurRadius: ScreenUtil().radius(2),
            spreadRadius: ScreenUtil().radius(2),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                UIDesign.getTransactionImage(
                  trxFilter: widget.data?.trxFilter,
                  trxOrderType: widget.data?.trxOrderType,
                  trxCode: widget.data?.trxCode,
                ),
                height: ScreenUtil().setWidth(64),
                width: ScreenUtil().setWidth(64),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(16),
              ),
              Text(
                (widget.data?.trxAmountBill != 0
                            ? widget.data?.trxAmountBill
                            : widget.data?.trxAmount)
                        ?.formatCurrencyRp ??
                    'Rp-',
                style: TextUI.title2Black,
                textScaleFactor: 1.0,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(12),
              ),
              Text(
                widget.data?.trxGroup == 'PBB'
                    ? /* TextWidget.getTitle(widget.data).toUpperCase() */ 'Payment PBB'
                    : TextWidget.getTitle(widget.data).capitalizeFirstofEach,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextUI.subtitleBlack,
                textScaleFactor: 1.0,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(12),
              ),
              Visibility(
                visible:
                    (widget.data!.trxPaymentType!.toLowerCase() == 'yukk' &&
                            widget.data!.trxStatus == 9)
                        ? true
                        : false,
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxHeight: 100.h),
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 14,
                  ),
                  decoration: BoxDecoration(
                    color: ColorUI.yellow.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Buka aplikasi YUKK & selesaikan pembayaran.',
                    textAlign: ui.TextAlign.center,
                    style: TextStyle(
                      color: ColorUI.yellow,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              if (widget.data?.trxCode == "VA-IN-NTT")
                qoin.Obx(
                  () => qoin.QoinTransactionController.to.countdownExpired
                              .value >
                          0
                      ? Column(
                          children: [
                            Container(
                              width: qoin.Get.width,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color:
                                    const Color(0xfff7b500).withOpacity(0.16),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    // "Mohon selesaikan pembayaran dalam",
                                    QoinTransactionLocalization
                                        .trxCountdownWording.tr,
                                    style: TextUI.bodyText2Yellow,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      qoin.Utils.formatHH(qoin
                                                  .QoinTransactionController
                                                  .to
                                                  .countdownExpired
                                                  .value) !=
                                              null
                                          ? Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(3)),
                                                  color:
                                                      const Color(0xfff7b500)),
                                              child: Center(
                                                child: Text(
                                                  qoin.Utils.formatHH(qoin
                                                          .QoinTransactionController
                                                          .to
                                                          .countdownExpired
                                                          .value) ??
                                                      "0",
                                                  style: TextUI.bodyText2White,
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                      qoin.Utils.formatHH(qoin
                                                  .QoinTransactionController
                                                  .to
                                                  .countdownExpired
                                                  .value) !=
                                              null
                                          ? Text(
                                              ":",
                                              style: TextUI.bodyText2Yellow,
                                            )
                                          : SizedBox(),
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                            color: const Color(0xfff7b500)),
                                        child: Center(
                                          child: Text(
                                            qoin.Utils.formatMM(qoin
                                                .QoinTransactionController
                                                .to
                                                .countdownExpired
                                                .value),
                                            style: TextUI.bodyText2White,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        ":",
                                        style: TextUI.bodyText2Yellow,
                                      ),
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                            color: const Color(0xfff7b500)),
                                        child: Center(
                                          child: Text(
                                            qoin.Utils.formatSS(qoin
                                                .QoinTransactionController
                                                .to
                                                .countdownExpired
                                                .value),
                                            style: TextUI.bodyText2White,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(16),
                            ),
                          ],
                        )
                      : SizedBox(),
                ),
              SeparatorWidget(
                height: 1,
                color: Color(0XFFE5E5E5),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Theme(
                    data: qoin.Get.theme.copyWith(
                      dividerColor: Colors.transparent,
                      colorScheme: ColorScheme.fromSwatch()
                          .copyWith(secondary: Color(0xff111111)),
                    ),
                    child: CustomExpansionTileWidget(
                      backgroundColor: Colors.white,
                      initiallyExpanded: true,
                      title: Text(
                        QoinTransactionLocalization.trxdetailTrx.tr,
                        style: TextUI.subtitleBlack,
                        textScaleFactor: 1.0,
                      ),
                      tilePadding: EdgeInsets.zero,
                      trailing: Icon(Icons.chevron_right),
                      isTrailingQuarter: true,
                      children: [
                        // TODO:
                        TransactionDetailExpandedTicketWidget(
                          data: widget.data,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(12),
                  ),
                  SeparatorWidget(
                    height: 1,
                    color: Color(0XFFE5E5E5),
                  ),
                  if (widget.data?.trxCode != "MDREQ" &&
                      widget.data?.trxCode != "REDEEM")
                    Theme(
                      data: qoin.Get.theme.copyWith(
                        dividerColor: Colors.transparent,
                        colorScheme: ColorScheme.fromSwatch()
                            .copyWith(secondary: Color(0xff111111)),
                      ),
                      child: CustomExpansionTileWidget(
                        backgroundColor: Colors.white,
                        initiallyExpanded: true,
                        title: Text(
                          QoinTransactionLocalization.trxtrxReference.tr,
                          style: TextUI.subtitleBlack,
                          textScaleFactor: 1.0,
                        ),
                        tilePadding: EdgeInsets.zero,
                        trailing: Icon(Icons.chevron_right),
                        isTrailingQuarter: true,
                        children: [
                          TicketItemWidget(
                            title: QoinTransactionLocalization.trxNumber.tr,
                            child: CopyTextWidget(
                              text: widget.data!.trxReceipt,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(12),
                          ),
                          TicketItemWidget(
                            title:
                                QoinTransactionLocalization.trxnoReference.tr,
                            child: CopyTextWidget(
                              text: widget.data!.trxReceiptExtern,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (widget.data?.trxCode != "MDREQ" &&
                      widget.data?.trxCode != "REDEEM")
                    Column(
                      children: [
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                        SeparatorWidget(
                          height: 1,
                          color: Color(0XFFE5E5E5),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(14),
                        ),
                        TicketItemWidget(
                          title: QoinTransactionLocalization.trxTotalTicket.tr,
                          titleStyle: TextUI.subtitleBlack,
                          descStyle: TextUI.subtitleBlack,
                          desc: widget.data?.trxAmountBill != null
                              ? (widget.data?.trxAmountBill != 0
                                      ? widget.data?.trxAmountBill
                                      : widget.data?.trxAmount)
                                  ?.formatCurrencyRp
                              : '0',
                        ),
                      ],
                    ),
                  if (widget.data?.trxCode == "PLN" &&
                      widget.data?.trxPlnToken != null)
                    Column(
                      children: [
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                        SeparatorWidget(
                          height: 1,
                          color: Color(0XFFE5E5E5),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(14),
                        ),
                        TicketItemWidget(
                          title: 'Token',
                          titleStyle: TextUI.subtitleBlack,
                          // descStyle: TextUI.subtitleBlack,
                          // desc: TextWidget.tokenPln(widget.data?.trxPlnToken ?? ""),
                          child: CopyTextWidget(
                              text: TextWidget.tokenPln(
                                  widget.data?.trxPlnToken ?? ""),
                              textStyle: TextUI.subtitleBlack),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: ScreenUtil().setHeight(31),
                  ),
                  if (widget.data?.trxCode == "MDREQ")
                    MainButton(
                      text: QoinTransactionLocalization.trxremindMe.tr,
                      onPressed: () {
                        DialogUtils.showComingSoonDrawer();
                        // requestBalanceData
                        //     .add(qoin.RequestBalanceData(id: id, amount: int.parse(amount.replaceAll('.', ''))));
                        // qoin.RequestBalanceReq requestBalanceReq = qoin.RequestBalanceReq(data: requestBalanceData);
                        // qoin.QoinWalletController.to.requestBalance(
                        //     requestBalanceReq: requestBalanceReq,
                        //     onSuccess: () {
                        //       DialogUtils.showMainPopup(
                        //           image: Assets.icSuccessSplitBill,
                        //           title: 'Permintaan Dikirim',
                        //           description:
                        //               'Permintaan dana berhasil dikirimkan ke ${widget.contactDestination?.name}',
                        //           mainButtonText: 'Tutup',
                        //           mainButtonFunction: () {
                        //             qoin.Get.offAll(HomeScreen());
                        //           });
                        //     },
                        //     onError: (e) {
                        //       DialogUtils.showPopUp(type: DialogType.problem);
                        //     });
                      },
                    ),
                  if (widget.data?.trxPaymentType == "OTHERS")
                    if ([0, 9].contains(widget.data?.trxStatus) &&
                        widget.data?.trxNote != null &&
                        widget.data?.trxCode != "VA-IN-NTT")
                      MainButton(
                        text: QoinTransactionLocalization.trxcontinuePayment.tr,
                        onPressed: () {
                          if (widget.data?.trxCode == "VOUCHER") {
                            qoin.QoinTransactionController.to.isMainLoading
                                .value = true;
                            qoin.VoucherTopupController.instance
                                .payVoucherTopupWithPg(
                              referenceNumber: widget.data?.trxReceipt ?? "",
                              orderNumber: widget.data?.trxReceiptExtern ?? "",
                              id: widget.data?.trxVcrId,
                              masterId: widget.data?.trxVcrMasterId,
                              amountValue: (widget.data?.trxAmount ?? 0)
                                  .toInt()
                                  .toString(),
                              onSuccess: (url) {
                                qoin.QoinTransactionController.to.isMainLoading
                                    .value = false;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => WebViewPage(
                                      url: url,
                                      isPayment: false,
                                      onBack: () =>
                                          qoin.Get.offAll(HomeScreen()),
                                      title: '',
                                    ),
                                  ),
                                );
                              },
                              onError: (error) {
                                qoin.QoinTransactionController.to.isMainLoading
                                    .value = false;
                                DialogUtils.showPopUp(type: DialogType.problem);
                              },
                            );
                          } else {
                            qoin.Get.to(
                              () => WebViewPage(
                                url: widget.data?.trxNote ?? "",
                                onBack: () => qoin.Get.offAll(HomeScreen()),
                                title: '',
                              ),
                            );
                          }
                        },
                      ),
                  if (widget.data?.trxPaymentType == "YUKK DIRECT")
                    if (widget.data?.trxStatus == 9 &&
                        widget.data?.trxNote != null)
                      MainButton(
                        text: QoinTransactionLocalization.trxcontinuePayment.tr,
                        onPressed: () {
                          // qoin.Get.to(
                          //   () => YukkInAppWebViewScreen(
                          //     onSuccessPaymentInappYukk: () {
                          //       qoin.Get.offAll(HomeScreen());
                          //     },
                          //   ),
                          //   arguments: {
                          //     "whichProcess": "payment",
                          //     "url": widget.data?.trxNote ?? "",
                          //   },
                          // );
                        },
                      ),
                  if (!isHide && [1, 2].contains(widget.data?.trxStatus))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: TransactionBuyAgainButton(
                        data: widget.data!,
                      ),
                    ),
                  if (!isHide &&
                      (widget.data?.trxStatus == 1 &&
                          widget.data?.trxNote != null &&
                          widget.data?.trxCode != 'REDEEM'))
                    MainButton(
                      text: QoinTransactionLocalization.trxshareReceipt.tr,
                      onPressed: () async {
                        bool value = await _capturePng();
                        if (value) {
                          setState(() {
                            isHide = false;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Terjadi Kesalahan"),
                          ));
                          setState(() {
                            isHide = false;
                          });
                        }
                      },
                    ),
                  if (!isHide && widget.data?.trxCode == 'REDEEM')
                    MainButton(
                      text: QoinTransactionLocalization.trxshowBalance.tr,
                      onPressed: () async {
                        qoin.Get.offAll(HomeScreen());
                        qoin.Get.to(WalletScreen(
                          fromTransaction: true,
                        ));
                      },
                    ),
                  if (widget.data?.trxCode == "VA-IN-NTT")
                    MainButton(
                      text:
                          '${QoinTransactionLocalization.trxcopyVANo.tr} - ${widget.data?.trxTopUpVaNumber}',
                      onPressed: () async {
                        await Clipboard.setData(
                          new ClipboardData(
                            text: widget.data?.trxTopUpVaNumber,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              QoinTransactionLocalization.trxdoneCopied.tr,
                              style: TextUI.subtitleBlack.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                                fontSize: ScreenUtil().setSp(14),
                                color: Colors.white,
                              ),
                              textScaleFactor: 1.0,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/helper/constans.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_design.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/qoin_transaction_localization.g.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/button_secondary.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:qoin_sdk/qoin_sdk.dart';

class NotificationItemWidget extends StatelessWidget {
  final qoin.NotificationData? data;

  const NotificationItemWidget({
    key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setHeight(16)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              UIDesign.getTransactionImage(
                trxOrderType: data?.body == "Get Reward" ? "REWARD" : data?.qoinNotif?.trxOrderType,
                trxFilter: data?.qoinNotif?.trxFilter,
                trxCode: data?.qoinNotif?.trxCode,
              ),
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(12),
            ),
            Expanded(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        data?.body ?? "-",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextUI.subtitleBlack.copyWith(
                          fontSize: ScreenUtil().setSp(14),
                        ),
                        textScaleFactor: 1.0,
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(8),
                      ),
                      Text(
                        data?.dateTime != null && data?.dateTime != ''
                            ? AnyUtils.timeAgo(
                                DateTime.parse(data!.dateTime!))
                            : "-",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextUI.subtitleBlack.copyWith(
                          fontSize: ScreenUtil().setSp(14),
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ],
                  ),
                  if (data?.qoinNotif?.trxCode == 'MD')
                    Padding(
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SecondaryButton(
                            text: QoinTransactionLocalization.reject.tr,
                            borderColor: ColorUI.secondary,
                            textColor: ColorUI.secondary,
                            onPressed: () {
                              qoin.NotificationController.instance.deleteNotif(data?.qoinNotif?.trxReceipt ?? "");
                              // qoin.HiveData.notifData?.removeWhere((element) => element.trxReceipt == data?.trxReceipt);
                            },
                          ),
                          MainButton(
                            text: QoinTransactionLocalization.reject.tr,
                            onPressed: () async {
                              debugPrint("terima pressed");
                              qoin.QoinWalletController.to.mReceiptNumber = data?.qoinNotif?.trxReceipt;
                              qoin.QoinWalletController.to.noteToTransfer = "-";
                              await qoin.QoinWalletController.to.transferAssets(
                                isMintaDana: true,
                                onSuccess: () {
                                  qoin.NotificationController.instance.deleteNotif(data?.qoinNotif?.trxReceipt ?? "");
                                },
                                onError: (error) {},
                              );
                              debugPrint("terima pressed end");
                              // Get.to(
                              //   () => TransferQoinDetailScreen(
                              //     mReceiptNumber: data?.trxReceipt,
                              //   ),
                              // );
                            },
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

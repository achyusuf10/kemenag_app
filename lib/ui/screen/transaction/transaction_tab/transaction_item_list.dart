import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/helper/constans.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/intl_formats.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_design.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/qoin_transaction_localization.g.dart';
import 'package:inisa_app/logic/controller/transaction/transaction_ui_controller.dart';
import 'package:inisa_app/ui/screen/transaction/transaction_detail/transaction_detail_screen.dart';
import 'package:inisa_app/ui/widget/transaction/text_widget.dart';
import 'package:qoin_sdk/models/qoin_transaction/history_data.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionItemList extends StatelessWidget {
  final HistoryData? data;

  TransactionItemList({key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        16,
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Get.to(
                () => TransactionDetailScreen(
                  data: data,
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    UIDesign.getTransactionImage(
                      trxFilter: data?.trxFilter,
                      trxOrderType: data?.trxOrderType,
                      trxCode: data?.trxCode,
                    ),
                    width: 40.w,
                    height: 40.w,
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                TextWidget.getTitle(data),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: TextUI.subtitleBlack,
                                textScaleFactor: 1.0,
                              ),
                            ),
                            SizedBox(
                              width: 16.w,
                            ),
                            Expanded(
                              child: Text(
                                data?.trxFilter == 'TRXOUT'
                                    ? "-${(data?.trxAmountBill != 0 ? data?.trxAmountBill : data?.trxAmount)?.formatCurrencyRp}"
                                    : "+${(data?.trxAmount != 0 ? data?.trxAmount : data?.trxAmountBill)?.formatCurrencyRp}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: TextUI.subtitleBlack.copyWith(
                                  fontSize: 16.sp,
                                ),
                                textScaleFactor: 1.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                data?.trxDate != null && data?.trxDate != ''
                                    ? AnyUtils.timeAgo(
                                        DateTime.parse(data!.trxDate! + Constans.serverTimeStringAddition))
                                    : "-",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: TextUI.bodyTextBlack.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                textScaleFactor: 1.0,
                              ),
                            ),
                            SizedBox(
                              width: 16.w,
                            ),
                            Expanded(
                              child: Text(
                                TextWidget.getStatus(data?.trxStatus),
                                textAlign: TextAlign.end,
                                style: TextUI.bodyTextBlack.copyWith(
                                  color: UIDesign.getStatusColor(
                                    trxStatus: data?.trxStatus,
                                  ),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                                textScaleFactor: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          GetBuilder<TranscactionUIController>(builder: (controller) {
            return controller.deleteMode
                ? InkWell(
                    onTap: [1, 2].contains(data?.trxStatus)
                        ? () {
                            DialogUtils.showMainPopup(
                                title: QoinTransactionLocalization.deleteTitle.tr,
                                description: QoinTransactionLocalization.deleteDesc.tr,
                                buttonMainFirst: true,
                                mainPopupButtonDirection: MainPopupButtonDirection.Horizontal,
                                mainButtonText: Localization.no.tr,
                                mainButtonFunction: () => Get.back(),
                                secondaryButtonText: QoinTransactionLocalization.deleteYes.tr,
                                secondaryButtonFunction: () {
                                  Get.back();
                                  QoinTransactionController.to.deleteHistoryTransaction(
                                      type: controller.tabIndex.value,
                                      data: data!,
                                      onSuccess: () {},
                                      onError: (error) {
                                        DialogUtils.showPopUp(
                                            type: DialogType.problem,
                                            title: QoinTransactionLocalization.deleteFailed.tr,
                                            description: '$error');
                                      });
                                });
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.delete,
                            color: [1, 2].contains(data?.trxStatus) ? Colors.red : ColorUI.disabled,
                          ), //
                          Text(
                            QoinTransactionLocalization.delete.tr,
                            style: TextUI.bodyText2Grey.copyWith(
                                color: [1, 2].contains(data?.trxStatus) ? Colors.red : ColorUI.disabled),
                          )
                        ],
                      ),
                    ),
                  )
                : SizedBox();
          })
        ],
      ),
    );
  }
}

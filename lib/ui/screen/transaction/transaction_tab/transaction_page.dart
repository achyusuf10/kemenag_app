import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/qoin_transaction_localization.g.dart';
import 'package:inisa_app/logic/controller/transaction/transaction_ui_controller.dart';
import 'package:inisa_app/ui/widget/transaction/custom_loading_widget.dart';
import 'package:qoin_sdk/controllers/qoin_transaction/transaction_controller.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'transaction_list_widget.dart';

class TransactionPage extends StatefulWidget {
  final int tabIndex;
  final bool isQoin;
  final bool isFromWallet;
  TransactionPage(
      {key,
      required this.tabIndex,
      this.isQoin = false,
      this.isFromWallet = false})
      : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  RefreshController? _refreshController;
  ScrollController? _scrollController;

  var transactionUIController =
      Get.put<TranscactionUIController>(TranscactionUIController());

  void onFailed() async {
    DialogUtils.showPopUp(
      type: DialogType.problem,
      description: QoinTransactionLocalization.trxsorryReqFailed.tr,
      buttonText: Localization.back.tr,
    );
  }

  @override
  void initState() {
    super.initState();

    _refreshController = RefreshController(initialRefresh: false);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();

    _refreshController?.dispose();
    _scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!widget.isFromWallet)
        Container(
          height: 57.h,
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          decoration: BoxDecoration(color: ColorUI.shape),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Semua Transaksi',
                style: TextUI.subtitleBlack,
              ),
              GetBuilder<TranscactionUIController>(builder: (controller) {
                return GestureDetector(
                    onTap: () {
                      if (controller.deleteMode) {
                        controller.deleteMode = false;
                        controller.tabIndex.value = widget.tabIndex;
                      } else {
                        controller.deleteMode = true;
                        controller.tabIndex.value = widget.tabIndex;
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          controller.deleteMode ? Icons.close : Icons.delete,
                          color: ColorUI.text_4,
                        ),
                        if (controller.deleteMode)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              'Batal',
                              style: TextUI.bodyText2Grey,
                            ),
                          )
                      ],
                    ));
              })
            ],
          ),
        ),
        Expanded(
          child: SmartRefresher(
            controller: _refreshController!,
            scrollController: _scrollController!,
            physics: BouncingScrollPhysics(),
            enablePullUp: true,
            enablePullDown: true,
            footer: ClassicFooter(
              loadStyle: LoadStyle.ShowWhenLoading,
            ),
            onRefresh: () async {
              QoinTransactionController.to.getHistoryData(widget.tabIndex);
              _refreshController!.refreshCompleted();
            },
            onLoading: () async {
              if (!QoinTransactionController.to.isLoadingLoadMore.value) {
                QoinTransactionController.to.getHistoryData(
                  widget.tabIndex,
                  isLoadMore: true,
                );
              }
              _refreshController!.loadComplete();
            },
            child: GetBuilder<QoinTransactionController>(
                init: QoinTransactionController(),
                builder: (controller) {
                  if (controller.errorData != null) {
                    return Center(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                          text: 'Something went wrong, ',
                        ),
                        TextSpan(
                            text: 'try again',
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                QoinTransactionController.to
                                    .getHistoryData(widget.tabIndex);
                              },
                            style: TextUI.bodyTextBlack
                                .copyWith(color: ColorUI.qoinSecondary)),
                      ], style: TextUI.bodyTextBlack)),
                    );
                  }

                  if (controller.isMainLoading.value) {
                    return CustomLoadingWidget(
                      itemCount: 5,
                    );
                  }
                  return TransactionListWidget(
                    data: widget.tabIndex == 0
                        ? controller.historyAll
                        : widget.tabIndex == 1
                            ? controller.historyIn
                            : widget.tabIndex == 2
                                ? controller.historyOut
                                : controller.historyAll,
                    isQoin: widget.isQoin,
                  );
                }),
          ),
        ),
        if (!widget.isFromWallet)
          SizedBox(
            height: 64,
          ),
      ],
    );
  }
}

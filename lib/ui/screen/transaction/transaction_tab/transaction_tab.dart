import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/qoin_transaction_localization.g.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'transaction_page.dart';

class TransactionTab extends StatefulWidget {
  final bool isQoin;

  TransactionTab({key, this.isQoin = false}) : super(key: key);

  @override
  _TransactionTabStateNew createState() => _TransactionTabStateNew();
}

class _TransactionTabStateNew extends State<TransactionTab> with SingleTickerProviderStateMixin {
  TabController? tabController;
  int? listItemValue;

  @override
  void initState() {
    qoin.QoinTransactionController.to.getHistoryData(0);
    tabController = TabController(vsync: this, length: 4);
    tabController!.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: qoin.QoinTransactionController.to.isLoadingDelete.stream,
      child: Scaffold(
          appBar: AppBarWidget.light(
            title: QoinTransactionLocalization.trxTitleNewText.tr,
          ),
          body: Column(
            children: [
              SizedBox(
                height: 16.h,
              ),
              Container(
                height: 40.sp,
                child: TabBar(
                  controller: tabController,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 0,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        4.r,
                      ),
                      color: ColorUI.secondary),
                  labelPadding: EdgeInsets.symmetric(horizontal: 4.w),
                  physics: NeverScrollableScrollPhysics(),
                  onTap: (index) {
                    if (index == 3) {
                      tabController?.animateTo(tabController!.previousIndex);
                      DialogUtils.showComingSoonDrawer();
                    } else {
                      qoin.QoinTransactionController.to.getHistoryData(index);
                    }
                  },
                  tabs: [
                    Tab(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            4.r,
                          ),
                          border: Border.all(
                            color: tabController?.index == 0 ? ColorUI.secondary : Color(0xffdedede),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.w,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              QoinTransactionLocalization.trxAllTab.tr,
                              style: TextUI.subtitleWhite.copyWith(
                                  fontSize: 14.sp,
                                  color: tabController?.index == 0 ? Colors.white : ColorUI.text_1),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            4.r,
                          ),
                          border: Border.all(
                            color: tabController?.index == 1 ? ColorUI.secondary : Color(0xffdedede),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.w,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              QoinTransactionLocalization.trxInTab.tr,
                              style: TextUI.subtitleWhite.copyWith(
                                  fontSize: 14.sp,
                                  color: tabController?.index == 1 ? Colors.white : ColorUI.text_1),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: tabController?.index == 2 ? ColorUI.secondary : Color(0xffdedede),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.w),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              QoinTransactionLocalization.trxOutTab.tr,
                              style: TextUI.subtitleWhite.copyWith(
                                  fontSize: 14.sp,
                                  color: tabController?.index == 2 ? Colors.white : ColorUI.text_1),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: tabController?.index == 3 ? ColorUI.secondary : Color(0xffdedede),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.w),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              QoinTransactionLocalization.trxReqTab.tr,
                              style: TextUI.subtitleWhite.copyWith(
                                  fontSize: 14.sp,
                                  color: tabController?.index == 3 ? Colors.white : ColorUI.text_1),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              Divider(height: 1, color: Colors.grey),
              Expanded(
                child: Container(
                  color: qoin.Get.theme.backgroundColor,
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: tabController,
                    dragStartBehavior: DragStartBehavior.start,
                    children: [
                      TransactionPage(
                        tabIndex: tabController!.index,
                        isQoin: widget.isQoin,
                      ),
                      TransactionPage(
                        tabIndex: tabController!.index,
                        isQoin: widget.isQoin,
                      ),
                      TransactionPage(
                        tabIndex: tabController!.index,
                        isQoin: widget.isQoin,
                      ),
                      TransactionPage(
                        tabIndex: tabController!.index,
                        isQoin: widget.isQoin,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qoin_sdk/controllers/qoin_voucher_topup/voucher_topup_controller.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:shimmer/shimmer.dart';

import 'top_up_voucher_buy_detail.dart';
import 'top_up_voucher_item.dart';

class TopUpVoucherScreen extends StatefulWidget {
  const TopUpVoucherScreen({Key? key}) : super(key: key);

  @override
  _TopUpVoucherScreenState createState() => _TopUpVoucherScreenState();
}

class _TopUpVoucherScreenState extends State<TopUpVoucherScreen> {
  @override
  void initState() {
    super.initState();

    VoucherTopupController.instance.fetchVoucherTopupList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.light(
        title: 'Voucher Top Up',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.w),
                child: Text(
                  QoinServicesLocalization.voucherTopUpSelect.tr,
                  style: TextUI.subtitleBlack,
                ),
              ),
              Expanded(
                child: GetBuilder<VoucherTopupController>(builder: (controller) {
                  return ListView.builder(
                      itemCount: controller.isLoading ? 5 : controller.voucherTopupList.length,
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (_, i) {
                        if (controller.isLoading) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 64,
                              width: Get.width,
                              color: Colors.white,
                              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            ),
                          );
                        }
                        return TopUpVoucherItem(
                          data: controller.voucherTopupList[i],
                          onButtonTap: () {
                            Get.to(() => TopUpVoucherBuyDetail(
                                  data: controller.voucherTopupList[i],
                                ));
                          },
                        );
                      });
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

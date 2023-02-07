import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:qoin_sdk/helpers/utils/intl_formats.dart';
import 'package:qoin_sdk/models/qoin_voucher_topup/voucher_topup_list_resp.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class TopUpVoucherItem extends StatelessWidget {
  final VoucherTopupData? data;
  final GestureTapCallback? onButtonTap;
  const TopUpVoucherItem({Key? key, this.data, this.onButtonTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 16.w),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            const Color(0xffcc1d15),
            const Color(0xfff1734b),
          ]),
          borderRadius: BorderRadius.all(Radius.circular(10.r))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Voucher Top Up',
                style: TextUI.bodyTextWhite,
              ),
              SizedBox(
                height: 8.w,
              ),
              Text(
                (data?.amountValue ?? 0).formatCurrencyRp,
                style: TextUI.subtitleWhite,
              ),
            ],
          ),
          MainButton(
            text: QoinServicesLocalization.servicePlnBuyNow.tr,
            mini: true,
            padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 12.w),
            color: Color(0xffcc1d15),
            onPressed: onButtonTap ?? () {},
          )
        ],
      ),
    );
  }
}

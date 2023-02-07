import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:qoin_sdk/helpers/utils/intl_formats.dart';
import 'package:qoin_sdk/models/qoin_voucher_topup/voucher_topup_list_resp.dart';

class TopUpVoucherBuyWidget extends StatelessWidget {
  final VoucherTopupData? data;
  final GestureTapCallback? onTapButton;
  const TopUpVoucherBuyWidget({Key? key, this.data, this.onTapButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 379.w,
      height: 233.17.w,
      margin: EdgeInsets.only(bottom: 8.w),
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.emptyVoucher),
            fit: BoxFit.fill,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[BoxShadow(color: Colors.black54, blurRadius: 6.0, offset: Offset(0.0, 0.75))]),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 25, 24, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Voucher Top Up",
              style: TextUI.subtitleWhite.copyWith(fontSize: 24.sp),
            ),
            SizedBox(
              height: 16.w,
            ),
            Text(
              (data?.amountValue ?? 0).formatCurrencyRp,
              style: TextUI.subtitleWhite.copyWith(fontSize: 38.sp),
            ),
          ],
        ),
      ),
    );
  }
}

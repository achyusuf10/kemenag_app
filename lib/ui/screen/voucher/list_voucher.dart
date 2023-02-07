import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/voucher_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

class ListVoucherScreen extends StatefulWidget {
  const ListVoucherScreen({Key? key}) : super(key: key);

  @override
  _ListVoucherScreenState createState() => _ListVoucherScreenState();
}

class _ListVoucherScreenState extends State<ListVoucherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUI.shape,
      appBar: AppBarWidget.light(
        title: QoinServicesLocalization.listVoucher.tr,
      ),
      body: qoin.GetBuilder<qoin.OtaController>(builder: (controller) {
        return ListView.builder(
            itemCount: controller.vouchers.length,
            itemBuilder: (_, index) {
              return Container(
                padding: EdgeInsets.all(24.w),
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 16.h),
                child: Stack(
                  children: [
                    VoucherWidget(
                      voucherData: controller.vouchers[index],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(34)),
                            color: Colors.white),
                        child: Image.asset(
                          Assets.icFavoriteContact,
                          height: 24,
                          width: 24,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      }),
    );
  }
}

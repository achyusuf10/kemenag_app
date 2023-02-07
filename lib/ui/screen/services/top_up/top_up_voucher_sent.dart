import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/screen/account/pin/pin_screen.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/background.dart';
import 'package:inisa_app/ui/widget/button_bottom.dart';
import 'package:inisa_app/ui/widget/contact/contact_item.dart';
import 'package:inisa_app/ui/widget/topup_voucher_widget.dart';
import 'package:qoin_sdk/models/others/contact_data.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class VoucherTopUpSent extends StatefulWidget {
  final ContactData data;
  VoucherTopUpSent({Key? key, required this.data}) : super(key: key);

  @override
  _VoucherTopUpSentState createState() => _VoucherTopUpSentState();
}

class _VoucherTopUpSentState extends State<VoucherTopUpSent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: QoinServicesLocalization.voucherTopUpDetail.tr,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Background(
              height: 133.h,
            ),
            Center(
              child: Column(
                children: [
                  TopUpVoucherBuyWidget(),
                  Container(
                      color: Colors.white,
                      margin: EdgeInsets.only(top: 24.w),
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            QoinServicesLocalization.voucherTopUpSentTo.tr,
                            style: TextUI.subtitleBlack,
                          ),
                          SizedBox(
                            height: 16.w,
                          ),
                          ContactItem(
                              contactData: widget.data,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                  border: Border.all(color: const Color(0xffdedede), width: 1),
                                  color: const Color(0xfff5f6f8))),
                          SizedBox(
                            height: 16.w,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: WalletLocalization.writeToReceiver.tr,
                              hintStyle: TextUI.placeHolderBlack,
                              counterText: "",
                              filled: true,
                              fillColor: ColorUI.shape,
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Color(0xffdedede)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Get.theme.colorScheme.secondary),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Color(0xffdedede)),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.red),
                              ),
                            ),
                            style: TextUI.bodyTextBlack,
                          )
                        ],
                      ))
                ],
              ),
            )
          ],
        ),
      ),
      bottomSheet: ButtonBottom(
          text: QoinServicesLocalization.voucherTopUpSend.tr,
          onPressed: () async {
            // var pin = await Get.to(() => PinScreen());
            // if (pin != null) {
            //   DialogUtils.showPopUpSuccess(
            //       title: QoinServicesLocalization.voucherTopUpSuccess.tr,
            //       desc:
            //           '${QoinServicesLocalization.voucherTopUpSuccessDesc.tr} Rp10.000 ${QoinServicesLocalization.voucherTopUpSuccessDesc2.tr} ${widget.data.name}',
            //       textButton: QoinServicesLocalization.backToHome.tr,
            //       buttonOnTap: () {
            //         Get.offAll(() => HomeScreen());
            //       });
            // }
          }),
    );
  }
}

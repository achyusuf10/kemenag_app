import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/ui_design.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/background.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/button_secondary.dart';
import 'package:inisa_app/ui/widget/contact/contact_widget.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:inisa_app/ui/widget/topup_voucher_redeem_widget.dart';
import 'package:inisa_app/z_qoin/model/wallet_model.dart';
import 'package:qoin_sdk/helpers/services/environment.dart';
import 'package:qoin_sdk/helpers/utils/intl_formats.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

import 'package:qoin_sdk/models/qoin_voucher_topup/voucher_topup_purchased_list_resp.dart';

import 'top_up_voucher_sent.dart';

class TopUpVoucherRedeemDetail extends StatefulWidget {
  final VoucherTopupPurchasedData? data;
  TopUpVoucherRedeemDetail({Key? key, this.data}) : super(key: key);

  @override
  _TopUpVoucherRedeemDetailState createState() => _TopUpVoucherRedeemDetailState();
}

class _TopUpVoucherRedeemDetailState extends State<TopUpVoucherRedeemDetail> {
  late List<HowToTopUp> infoTopUp;

  @override
  void initState() {
    super.initState();
    infoTopUp = getHowTo();
  }

  getHowTo() {
    var syaratDanKetentuanHelper = widget.data?.voucherTC;
    List<String>? syaratDanKetentuan;
    if (syaratDanKetentuanHelper != null) {
      syaratDanKetentuanHelper = syaratDanKetentuanHelper.replaceAll("Persyaratan:\r\n- ", "");
      syaratDanKetentuanHelper = syaratDanKetentuanHelper.replaceAll("\r\n", "");
      syaratDanKetentuan = syaratDanKetentuanHelper.split("- ");
    }
    return [
      HowToTopUp(
        title: QoinServicesLocalization.voucherTopUpDetail.tr,
        description: [
          '${QoinServicesLocalization.voucherTopUpValue.tr} ${(widget.data?.amountValue ?? 0).formatCurrencyRp}'
        ],
        isExpanded: false,
      ),
      HowToTopUp(
        title: QoinServicesLocalization.voucherTopUpHowTo.tr,
        description: [
          QoinServicesLocalization.voucherTopUpHowToTip1.tr,
          QoinServicesLocalization.voucherTopUpHowToTip2.tr,
          QoinServicesLocalization.voucherTopUpHowToTip3.tr,
          QoinServicesLocalization.voucherTopUpHowToTip4.tr,
          QoinServicesLocalization.voucherTopUpHowToTip5.tr,
        ],
        isExpanded: false,
      ),
      HowToTopUp(
        title: Localization.buttonTermAndCondition.tr,
        description: syaratDanKetentuan != null
            ? syaratDanKetentuan
            : [
                QoinServicesLocalization.voucherTopUpSnK1.tr,
                QoinServicesLocalization.voucherTopUpSnK2.tr,
                QoinServicesLocalization.voucherTopUpSnK3.tr,
              ],
        isExpanded: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: VoucherTopupController.instance.isLoadingMain.stream,
      child: Scaffold(
        appBar: AppBarWidget(
          title: QoinServicesLocalization.voucherTopUpDetail.tr,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Background(
                      height: 133.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Center(
                        child: Column(
                          children: [
                            TopUpVoucherRedeemWidget(data: widget.data),
                            Padding(
                              padding: EdgeInsets.only(top: 24.w, bottom: 80.h),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: infoTopUp.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(4.r)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: const Color(0x28000000),
                                                offset: Offset(0, 2),
                                                blurRadius: 10,
                                                spreadRadius: 0)
                                          ],
                                          color: Colors.white),
                                      margin: EdgeInsets.only(bottom: 16.w),
                                      child: ExpansionPanelList(
                                        elevation: 0,
                                        expansionCallback: (int idx, bool isExpanded) {
                                          setState(() {
                                            //close other panel
                                            infoTopUp.forEach((element) {
                                              if (element != infoTopUp[index]) {
                                                element.isExpanded = false;
                                              }
                                            });
                                            //change current panel status
                                            infoTopUp[index].isExpanded = !infoTopUp[index].isExpanded!;
                                          });
                                        },
                                        children: [
                                          ExpansionPanel(
                                            canTapOnHeader: true,
                                            headerBuilder: (BuildContext context, bool isExpanded) {
                                              return ListTile(
                                                title: Text(
                                                  infoTopUp[index].title ?? '-',
                                                  style: TextUI.subtitleBlack,
                                                ),
                                              );
                                            },
                                            body: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                    child: ListView.separated(
                                                        separatorBuilder: (context, index) => SizedBox(
                                                              height: 8,
                                                            ),
                                                        physics: NeverScrollableScrollPhysics(),
                                                        itemCount: infoTopUp[index].description?.length ?? 0,
                                                        shrinkWrap: true,
                                                        itemBuilder: (context, dIndex) {
                                                          if (infoTopUp[index].description?.length == 1) {
                                                            return Text("${infoTopUp[index].description?[dIndex]}",
                                                                style: TextUI.bodyText2Black);
                                                          }
                                                          return Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text("${dIndex + 1}. ", style: TextUI.bodyText2Black),
                                                              Expanded(
                                                                child: Text("${infoTopUp[index].description?[dIndex]}",
                                                                    style: TextUI.bodyText2Black),
                                                              )
                                                            ],
                                                          );
                                                        }),
                                                  ),
                                                  SizedBox(
                                                    height: 24.w,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            isExpanded: infoTopUp[index].isExpanded ?? false,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 64.h,
                )
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.all(16.w),
          decoration: UIDesign.bottomButton,
          child: Row(
            children: [
              Expanded(
                child: SecondaryButton(
                    text: 'Kirim Voucher',
                    onPressed: () {
                      if (EnvironmentConfig.flavor == Flavor.Production) {
                        DialogUtils.showComingSoonDrawer();
                      } else {
                        DialogUtils.showGeneralDrawer(
                            radius: 16.r,
                            withStrip: true,
                            padding: EdgeInsets.only(top: 16.0),
                            content: SizedBox(
                                height: ScreenUtil().screenHeight - (kToolbarHeight * 3),
                                child: Column(
                                  children: [
                                    ContactWidget.plain(onItemTap: (data) {
                                      Get.to(() => VoucherTopUpSent(
                                            data: data,
                                          ));
                                    }),
                                  ],
                                )));
                      }
                    }),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: MainButton(
                    text: 'Pakai Voucher',
                    onPressed: () {
                      VoucherTopupController.instance.redeemVoucherTopup(
                        voucherNo: widget.data?.voucherNo,
                        isPrototype: VoucherTopupController.instance.isPrototype,
                        onSuccess: () {
                          DialogUtils.showPopUpSuccess(
                            title: "Top Up Berhasil",
                            desc: "Saldo kamu berhasil di tambahkan",
                            buttonOnTap: () {
                              Get.offAll(HomeScreen());
                            },
                          );
                        },
                        onOverLimit: () {
                          DialogUtils.showPopUp(type: DialogType.overLimitSaldo);
                        },
                        onFailed: () {
                          DialogUtils.showPopUp(type: DialogType.problem);
                        },
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

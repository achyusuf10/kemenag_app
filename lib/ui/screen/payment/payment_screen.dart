import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/functions.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_design.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/localization/qoin_transaction_localization.g.dart';
// import 'package:inisa_app/ui/screen/account/pin/pin_screen.dart';
import 'package:inisa_app/ui/screen/account/pin/pin_screen_old.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/screen/payment/web_view_page.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/models/qoin_services/inquiry_ppob_resp.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:qoin_sdk/helpers/utils/intl_formats.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:shimmer/shimmer.dart';
import 'payment_method_screen.dart';
import 'widgets/payment_tile_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentScreen extends StatelessWidget {
  final int idService;
  final String provider;
  final String customerId;
  final int tabIndex;
  final String textTotal;
  final InquiryPpobResult? inquiryResult;
  const PaymentScreen(
      {key,
      required this.idService,
      this.provider = "",
      required this.customerId,
      required this.tabIndex,
      required this.textTotal,
      required this.inquiryResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (idService == qoin.Services.servicesId.pajakPBB) {
      qoin.PaymentController.to.isOnlyPgPayment.value = true;
    }
    return ModalProgress(
      loadingStatus: qoin.PaymentController.to.isMainLoading.stream,
      child: Scaffold(
        appBar: AppBarWidget.light(
          title: QoinServicesLocalization.servicePaymentPayTransaction.tr,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 25, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xfff6f6f6),
                        width: 12,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        QoinServicesLocalization
                            .servicePaymentTransactionDetails.tr,
                        style: TextUI.subtitleBlack,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      if (provider.isNotEmpty)
                        PaymentTileWidget(
                          descText: "Provider",
                          valueText: provider,
                        ),
                      if (inquiryResult?.idpel1 != null &&
                          inquiryResult!.idpel1!.isNotEmpty)
                        PaymentTileWidget(
                          descText: QoinServicesLocalization
                              .servicePaymentCustomerId.tr,
                          valueText:
                              (idService == qoin.Services.servicesId.telephone)
                                  ? (inquiryResult?.idpel1 ?? "") +
                                      (inquiryResult?.idpel2 ?? "")
                                  : (inquiryResult?.idpel1 ?? ""),
                        ),
                      if (inquiryResult?.idpel2 != null &&
                          inquiryResult!.idpel2!.isNotEmpty &&
                          idService != qoin.Services.servicesId.telephone)
                        PaymentTileWidget(
                          descText:
                              QoinServicesLocalization.servicePlnNoMeter.tr,
                          valueText: inquiryResult!.idpel2!,
                        ),
                      if (inquiryResult?.produk != null &&
                          inquiryResult!.produk!.isNotEmpty)
                        PaymentTileWidget(
                          descText:
                              QoinServicesLocalization.serviceTextProduct.tr,
                          valueText: inquiryResult!.produk!,
                        ),
                      if (inquiryResult?.namaPelanggan != null &&
                          inquiryResult!.namaPelanggan!.isNotEmpty)
                        PaymentTileWidget(
                          descText: QoinServicesLocalization
                              .servicePaymentCustomerName.tr,
                          valueText: inquiryResult!.namaPelanggan!,
                        ),
                      if (inquiryResult?.periode != null &&
                          inquiryResult!.periode!.isNotEmpty)
                        PaymentTileWidget(
                          descText:
                              QoinServicesLocalization.servicePaymentPeriods.tr,
                          valueText: Functions.convertPeriode(
                                  serviceId: idService,
                                  value: inquiryResult?.periode) ??
                              "",
                        ),
                      // PaymentTileWidget(
                      //   descText: textTotal,
                      //   valueText: idService == qoin.Services.servicesId.mobileRecharge
                      //       ? (inquiryResult?.totalPrice ?? 0).toInt().formatCurrencyRp
                      //       : (inquiryResult?.totalPriceWithoutAdmin ?? 0).toInt().formatCurrencyRp,
                      // ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xfff6f6f6),
                        width: 12,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        QoinServicesLocalization.servicePaymentMethod.tr,
                        style: TextUI.subtitleBlack,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      qoin.GetBuilder<qoin.PaymentController>(
                          builder: (controller) {
                        return controller.isPaymentMethodLoading.value
                            ? Shimmer.fromColors(
                                highlightColor: Colors.grey[300]!,
                                baseColor: Colors.grey[100]!,
                                child: Container(
                                  height: 56,
                                  width: qoin.Get.width,
                                  color: Colors.white,
                                ),
                              )
                            : ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Image.asset(
                                  controller.paymentMethod?.assetIcon ??
                                      Assets.qoin,
                                  package: qoin.QoinSdk.packageName,
                                  color: controller.paymentMethod?.method ==
                                          qoin.PaymentMethod.Paprika
                                      ? Colors.red
                                      : null,
                                  width: 28,
                                  height: 38,
                                ),
                                title: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTitle(controller.paymentMethod?.name),
                                      style: TextUI.subtitleBlack,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    if (controller.paymentMethod?.balance !=
                                        null)
                                      Text(
                                        controller.paymentMethod?.balance ?? '',
                                        style: TextUI.bodyTextBlack,
                                      ),
                                  ],
                                ),
                                trailing: InkWell(
                                  onTap: () {
                                    qoin.Get.to(() => PaymentMethodScreen());
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        QoinServicesLocalization
                                            .serviceMenuMore.tr
                                            .replaceAll("\n", " "),
                                        style: TextUI.buttonTextRed,
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_right,
                                        color: ColorUI.secondary,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                      }),
                      // Divider(),
                      // qoin.GetBuilder<qoin.PaymentController>(builder: (controller) {
                      //   return ListTile(
                      //     contentPadding: EdgeInsets.zero,
                      //     leading: Image.asset(
                      //       Assets.iconQoinPoints,
                      //       width: 28,
                      //       height: 38,
                      //     ),
                      //     title: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           QoinServicesLocalization.serviceTextQoinPoint.tr,
                      //           style: TextUI.subtitleBlack,
                      //         ),
                      //         SizedBox(
                      //           height: 4,
                      //         ),
                      //         Text(
                      //           "${NumberFormat.currency(locale: "id", symbol: "", decimalDigits: 0).format(controller.qoinPoint)}",
                      //           style: TextUI.bodyTextBlack,
                      //         ),
                      //       ],
                      //     ),
                      //     trailing: Switch(value: false, onChanged: (value) {}),
                      //   );
                      // }),
                    ],
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                //   decoration: BoxDecoration(
                //     border: Border(
                //       bottom: BorderSide(
                //         color: Color(0xfff6f6f6),
                //         width: 12,
                //       ),
                //     ),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         QoinServicesLocalization.serviceMenuVoucher.tr,
                //         style: TextUI.subtitleBlack,
                //       ),
                //       SizedBox(
                //         height: 16,
                //       ),
                //       Container(
                //         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.all(Radius.circular(4)),
                //           border: Border.all(color: qoin.Get.theme.colorScheme.secondary, width: 1),
                //           color: qoin.Get.theme.colorScheme.secondary.withOpacity(0.1),
                //         ),
                //         child: Row(
                //           children: [
                //             Image.asset(
                //               Assets.iconVoucher,
                //               width: 32,
                //               height: 32,
                //             ),
                //             Text(
                //               "Ada 2 voucher yang siap digunakan",
                //               style: TextUI.bodyTextBlack,
                //             )
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xfff6f6f6),
                        width: 12,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        QoinServicesLocalization.servicePaymentPayDetails.tr,
                        style: TextUI.subtitleBlack,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      PaymentTileWidget(
                        descText: textTotal,
                        valueText:
                            idService == qoin.Services.servicesId.mobileRecharge
                                ? (inquiryResult?.totalPrice ?? 0)
                                    .toInt()
                                    .formatCurrencyRp
                                : (inquiryResult?.totalPriceWithoutAdmin ?? 0)
                                    .toInt()
                                    .formatCurrencyRp,
                      ),
                      if (idService != qoin.Services.servicesId.pajakPBB)
                        PaymentTileWidget(
                          descText:
                              QoinServicesLocalization.servicePaymentAdmin.tr,
                          valueText: idService ==
                                  qoin.Services.servicesId.mobileRecharge
                              ? int.parse("0").formatCurrencyRp
                              : (inquiryResult?.adminFeeQoin ?? 0)
                                  .toInt()
                                  .formatCurrencyRp,
                        ),
                      if (idService == qoin.Services.servicesId.pajakPBB)
                        PaymentTileWidget(
                          descText: QoinServicesLocalization
                              .servicePaymentPlatform.tr,
                          valueText: 10000.formatCurrencyRp,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.all(16),
          decoration: UIDesign.bottomButton,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    QoinServicesLocalization.servicePaymentTotalAmount.tr,
                    style: TextUI.bodyTextBlack,
                  ),
                  if (idService == qoin.Services.servicesId.pajakPBB)
                    Text(
                      ((inquiryResult?.totalPrice ?? 0) + 10000)
                          .formatCurrencyRp,
                      style: TextUI.titleYellow,
                    ),
                  if (idService != qoin.Services.servicesId.pajakPBB)
                    Text(
                      ((inquiryResult?.totalPrice ?? 0)).formatCurrencyRp,
                      style: TextUI.titleYellow,
                    )
                ],
              ),
              MainButton(
                text: QoinServicesLocalization.servicePaymentPay.tr,
                mini: true,
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 50.w),
                onPressed: () {
                  if (idService == qoin.Services.servicesId.pajakPBB) {
                    if (qoin.PaymentController.to.paymentMethod?.method ==
                        qoin.PaymentMethod.Qoin) {
                      DialogUtils.showGeneralDrawer(
                          content: Text(QoinServicesLocalization
                              .servicePBBPaymetWarning.tr));
                    } else {
                      int pay =
                          (inquiryResult?.totalPrice ?? 0).round() + 10000;
                      qoin.PaymentController.to.payPbbWithPg(
                        idm: qoin.PbbController.to.inquiryData?.idm,
                        nop: qoin.PbbController.to.inquiryData?.data?.nOP,
                        tahun: qoin.PbbController.to.inquiryData?.data?.tAHUN,
                        rrnInq: qoin.PbbController.to.inquiryData?.rrn,
                        nominal: pay
                            .toString(), //qoin.PbbController.to.inquiryData?.data?.tOTALBAYAR,
                        onSuccess: (url) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WebViewPage(
                                url: url ?? "",
                                isPayment: true,
                                onBack: () => qoin.Get.offAll(HomeScreen()),
                                title: '',
                              ),
                            ),
                          );
                        },
                        onPaid: () {
                          DialogUtils.showPopUp(type: DialogType.noBill);
                        },
                        onFailed: (error) {
                          DialogUtils.showPopUp(type: DialogType.problem);
                        },
                      );
                    }
                  } else {
                    qoin.PaymentController.to.paymentPpob(
                      onPgSuccess: (url) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WebViewPage(
                            url: url,
                            isPayment: true,
                            onBack: () => qoin.Get.offAll(HomeScreen()),
                            title: '',
                          ),
                        ),
                      ),
                      onPaprikaSuccess: () {
                        qoin.Get.offAll(HomeScreen());
                      },
                      onQoinUe: (req) async {
                        String result = await qoin.Get.to(PinScreenOld(
                            pinType: qoin.PinTypeEnum.confirmationTransaction));
                        if (result.isNotEmpty) {
                          await qoin.PaymentController.to.paymentPpobQoinUe(
                            id: idService,
                            token: result,
                            paymentReq: req,
                            onQoinSuccess: () {
                              DialogUtils.showPopUp(
                                type: DialogType.successPaymet,
                                barrierDismissible: false,
                                description: QoinTransactionLocalization
                                    .onProcessDesc.tr,
                                buttonFunction: () {
                                  qoin.Get.offAll(HomeScreen(
                                    toTransaction: true,
                                  ));
                                },
                              );
                            },
                            onFailed: (error) {
                              DialogUtils.showPopUp(
                                type: DialogType.problem,
                                barrierDismissible: false,
                                description: error,
                                buttonFunction: () {
                                  qoin.Get.offAll(HomeScreen(
                                    toTransaction: true,
                                  ));
                                },
                              );
                            },
                          );
                        }
                      },
                      onFailed: (message) => DialogUtils.showPopUp(
                          type: DialogType.problem, description: message),
                      onNotEnoughPaprikaBalance: () {
                        DialogUtils.showPopUp(
                            type: DialogType.insufficientBalance,
                            description: QoinServicesLocalization
                                .servicePaymentBalanceNotEnough.tr);
                      },
                      onNotEnoughQoinBalance: () {
                        DialogUtils.showPopUp(
                            type: DialogType.insufficientBalance,
                            description: QoinServicesLocalization
                                .servicePaymentBalanceNotEnough.tr);
                      },
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  String getTitle(name) {
    if (name == 'Saldo') {
      return QoinServicesLocalization.serviceTextQoinCash.tr;
    } else {
      return QoinServicesLocalization.serviceTextOther.tr;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:inisa_app/helper/functions.dart';
import 'package:inisa_app/ui/widget/services/customer_ids_widget.dart';
import 'package:inisa_app/ui/widget/services/latests_used_item.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:qoin_sdk/helpers/utils/intl_formats.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/widget/services/invoice_tile_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlnPostpaidTab extends StatefulWidget {
  const PlnPostpaidTab({Key? key}) : super(key: key);

  @override
  _PlnPostpaidTabState createState() => _PlnPostpaidTabState();
}

class _PlnPostpaidTabState extends State<PlnPostpaidTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: GetBuilder<ServicesController>(builder: (controller) {
        return Container(
          padding: EdgeInsets.only(top: 20.h, bottom: controller.product != null ? 100.h : 0, left: 16.w, right: 16.w),
          child: controller.inquiryResult != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      QoinServicesLocalization.servicePostpaidPaymentInvoiceDetail.tr,
                      style: TextUI.title2Black,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 16,
                        bottom: kBottomNavigationBarHeight * 2,
                      ),
                      child: Column(
                        children: [
                          InvoiceTile(
                            invoiceTitle: QoinServicesLocalization.servicePlnIdPelanggan.tr,
                            invoiceBody: controller.inquiryResult?.idpel1 ?? "-",
                          ),
                          if (controller.inquiryResult?.idpel2 != null && controller.inquiryResult!.idpel2!.isNotEmpty)
                            InvoiceTile(
                              invoiceTitle: QoinServicesLocalization.servicePlnNoMeter.tr,
                              invoiceBody: controller.inquiryResult?.idpel2 ?? "-",
                            ),
                          InvoiceTile(
                            invoiceTitle: QoinServicesLocalization.servicePaymentCustomerName.tr,
                            invoiceBody: controller.inquiryResult?.namaPelanggan ?? "-",
                          ),
                          if (controller.inquiryResult?.periode != null && controller.inquiryResult!.periode!.isNotEmpty)
                            InvoiceTile(
                              invoiceTitle: QoinServicesLocalization.servicePaymentPeriods.tr,
                              invoiceBody: Functions.convertPeriode(
                                serviceId: 0,
                                value: controller.inquiryResult?.periode,
                              ),
                            ),
                          InvoiceTile(
                            invoiceTitle: QoinServicesLocalization.servicePostpaidPaymentTotalUsage.tr,
                            // invoiceBody: (int.parse(
                            //             controller.inquiryResult?.nominal ??
                            //                 "0") +
                            //         int.parse(
                            //             controller.inquiryResult?.admin ?? "0"))
                            //     .formatCurrencyRp,
                            invoiceBody: int.parse(controller.inquiryResult?.nominal ?? "0").formatCurrencyRp,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : controller.savedCustomerId.length != 0
                  ? CustomerIdsWidget(
                      child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: controller.savedCustomerId.length,
                      itemBuilder: (_, i) {
                        return ItemLatestUsed(
                          serviceId: Services.servicesId.electricityPostpaid,
                          customerId: controller.savedCustomerId[i],
                          onTap: () {
                            controller.validateCustomerId(controller.savedCustomerId[i], minLength: 11);
                            controller.setProviderNameCode(plnGroupCode);
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                    ))
                  : SizedBox(),
        );
      }),
    );
  }
}

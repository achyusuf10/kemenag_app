import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'widgets/payment_method_card_widget.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: QoinServicesLocalization.servicePaymentMethod.tr,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: qoin.PaymentController.to.paymentMethods
              .map((e) => PaymentMethodCardWidget(
                    onTap: () {
                      _selectMethodPayment(e.method);
                    },
                    icon: e.assetIcon,
                    title: getTitle(e.name),
                    subTitle: e.isActive
                        ? null
                        : QoinServicesLocalization.servicePaprikaLetsActive.tr,
                    trailing: e.isActive
                        ? Text(
                            e.balance != null ? "${e.balance}" : "",
                            style: GoogleFonts.manrope(
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.right,
                          )
                        : Text(
                            QoinServicesLocalization.servicePaprikaActivate.tr,
                            style: GoogleFonts.manrope(
                              color: Color(0xfff7b500),
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.right,
                          ),
                  ))
              .toList(),
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

  void _selectMethodPayment(qoin.PaymentMethod value) {
    qoin.PaymentController.to.selectPaymentMethod(
      value,
      // isQoinActive: (EnvironmentConfig.flavor != qoin.Flavor.Production),
      isQoinActive: true,
      onSelectedQoin: () {
        qoin.Get.back();
        // if (EnvironmentConfig.flavor == qoin.Flavor.Production) {
        //   DialogUtils.showComingSoonDrawer();
        // } else {
        //   qoin.Get.back();
        // }
      },
      onSelectedPg: () {
        qoin.Get.back();
      },
      onPaprikaNotActivated: () {
        // DialogUtils.generalDrawer(
        //   Get.context,
        //   asset: paprikaActivation,
        //   title: QoinServicesLocalization.servicePaprikaHavntActivate.tr,
        //   description: QoinServicesLocalization.servicePaprikaEnjoyActivate.tr,
        //   mainButtonText: QoinServicesLocalization.servicePaprikaActiveNow.tr,
        //   mainButtonFunction: () async {
        //     Get.back();
        //     final bool result = await Get.to(() => PaprikaActivationPage());
        //     printDebug("await page: $result");

        //     if (result) {
        //       PaymentController.to.getBalance();
        //     }
        //   },
        //   secondButtonText:
        //       QoinServicesLocalization.servicePaprikaActiveLater.tr,
        //   secondButtonFunction: () {
        //     Get.back();
        //   },
        // );
      },
      onSelectedPaprika: () {
        qoin.Get.back();
      },
    );
  }
}

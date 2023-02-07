import 'package:flutter/material.dart';
import 'package:inisa_app/logic/controller/pbb_bindings.dart';
import 'package:inisa_app/ui/screen/services/bpjs/healthy_bpjs_screen.dart';
import 'package:inisa_app/ui/screen/services/gas/gas_screen.dart';

import 'package:inisa_app/ui/screen/services/pln/pln_screen.dart';
import 'package:inisa_app/ui/screen/services/postpaid/postpaid_screen.dart';
import 'package:inisa_app/ui/screen/services/telephone/telephone_page.dart';
import 'package:inisa_app/ui/screen/services/widget_menu/models/service_data_model.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:qoin_sdk/models/qoin_transaction/history_data.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class TransactionBuyAgainButton extends StatelessWidget {
  final HistoryData data;
  const TransactionBuyAgainButton({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // trx group for more detail
    if ([
          'PULSA',
          'PLN',
          'PBB',
          'ASURANSI',
          'HP PASCABAYAR',
          'TV KABEL',
          'GAS',
          'PLNPASCA',
          'TELKOM',
        ].contains(data.trxCode) ||
        (data.trxOrderType == 'PPOB' && data.trxCode!.contains('PDAM')))
      return MainButton(
        text: 'Beli Lagi',
        onPressed: () async {
          if (data.trxCode == 'PULSA') {
            return;
          } else if (data.trxCode == 'PLN') {
            Get.to(() => PlnScreen(tabIndex: 0), binding: ServiceBinding());
            return;
          } else if (data.trxCode == 'PBB') {
            return;
          } else if (data.trxCode == 'ASURANSI') {
            Get.to(() => HealthyBpjsScreen(), binding: ServiceBinding());
            return;
          } else if (data.trxCode == 'HP PASCABAYAR') {
            Get.to(() => PostpaidScreen(), binding: ServiceBinding());
            return;
          } else if (data.trxCode == 'TV KABEL') {
            return;
          } else if (data.trxCode == 'GAS') {
            Get.to(() => GasScreen(), binding: ServiceBinding());
            return;
          } else if (data.trxCode == 'TELKOM') {
            Get.to(() => TelephoneScreen(), binding: ServiceBinding());
            return;
          } else if (data.trxCode == 'PLNPASCA') {
            Get.to(() => PlnScreen(tabIndex: 1), binding: ServiceBinding());
            return;
          } else if (data.trxCode == 'PDAM') {
            return;
          }
        },
      );
    else
      return SizedBox();
  }
}

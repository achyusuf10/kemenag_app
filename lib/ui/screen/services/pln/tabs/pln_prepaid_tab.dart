import 'package:flutter/material.dart';
import 'package:inisa_app/helper/intl_formats.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/ui/widget/services/card_choice_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

class PlnPrepaidTab extends StatefulWidget {
  const PlnPrepaidTab({Key? key}) : super(key: key);

  @override
  _PlnPrepaidTabState createState() => _PlnPrepaidTabState();
}

class _PlnPrepaidTabState extends State<PlnPrepaidTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: qoin.GetBuilder<qoin.ServicesController>(builder: (controller) {
        return GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.only(
              top: 20, bottom: controller.products.isNotEmpty ? 100 : 0, right: 16, left: 16),
          physics: BouncingScrollPhysics(),
          childAspectRatio:
              MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 2.8),
          children: controller.isLoadingInquiry.value
              ? List.generate(
                  6,
                  (index) => Shimmer.fromColors(
                      child: Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      ),
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100))
              : controller.products
                  .map(
                    (e) => CardChoiceWidget(
                      onTap: () {
                        controller.product = e;
                      },
                      bgColor: controller.product == e ? Color(0xfff9f3f2) : Colors.white,
                      borderColor: controller.product == e ? ColorUI.secondary : Colors.transparent,
                      title: e.pGroup?.toUpperCase(),
                      denom: double.parse(e.pDenom ?? "0").formatCurrency,
                      // price: (e.pPrice != null && e.pPrice != 0) ? (e.pPrice ?? 0).formatCurrencyRp : "Rp.-",
                    ),
                  )
                  .toList(),
        );
      }),
    );
  }
}

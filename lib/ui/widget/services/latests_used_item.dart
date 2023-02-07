import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/ui_design.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/screen/services/widget_menu/models/services_id_model.dart';

class ItemLatestUsed extends StatelessWidget {
  final int serviceId;
  final String customerId;
  final GestureTapCallback? onTap;

  const ItemLatestUsed({Key? key, required this.serviceId, required this.customerId, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ServicesIdModel servicesIdModel = ServicesIdModel();

    return InkResponse(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  UIDesign.getMenuImage(serviceId: serviceId),
                  width: 24.w,
                ),
                SizedBox(
                  width: 16.w,
                ),
                Text(
                  customerId,
                  style: TextUI.subtitleBlack,
                )
              ],
            ),
            if (serviceId == servicesIdModel.mobileRecharge ||
                serviceId == servicesIdModel.postpaid)
              Image.asset(
                UIDesign.getProviderAssets(phoneNumber: customerId),
                width: 24.w,
              ),
          ],
        ),
      ),
    );
  }
}

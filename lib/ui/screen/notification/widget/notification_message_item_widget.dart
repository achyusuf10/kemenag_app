import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/ui_design.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/screen/notification/notification_detail_screen.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class NotificationMsgInfItem extends StatelessWidget {
  final NotificationData? data;

  const NotificationMsgInfItem({
    key,
    @required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (data?.qoinNotif?.trxFilter == 'DIGITALID' && data?.qoinNotif?.trxStatus == 2) {
          Get.to(
            () => NotificationDetailScreen(
              data: data!,
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(UIDesign.getMsgInf(
                trxFilter: '${data?.qoinNotif?.trxFilter}',
                trxOrderType: '${data?.qoinNotif?.trxOrderType}',
                trxStatus: '${data?.qoinNotif?.trxStatus}',
              ),
              width: 16.w,
              height: 16.w,
            ),
            SizedBox(
              width: 12.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${data?.qoinNotif?.trxFilter}",
                        style: TextUI.labelGrey2,
                      ),
                      Text(
                        data?.dateTime != null && data?.dateTime != ''
                            ? Utils.timeAgo(DateTime.parse(data!.dateTime!))
                            : "-",
                        style: TextUI.labelGrey2)
                    ],
                  ),
                  Text(
                    '${data?.title}',
                    style: TextUI.bodyTextBlack),
                  Text(
                    '${data?.body}',
                    style: TextUI.bodyTextBlack3
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

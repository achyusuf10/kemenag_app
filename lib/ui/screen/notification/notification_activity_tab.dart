import 'package:flutter/material.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'notification_empty_screen.dart';
import 'widget/notification_item_widget.dart';
import 'widget/notification_message_item_widget.dart';

class NotificationActivityTab extends StatefulWidget {
  final int? tabIndex;
  NotificationActivityTab({Key? key, required this.tabIndex}) : super(key: key);

  @override
  _NotificationActivityTabState createState() =>
      _NotificationActivityTabState();
}

class _NotificationActivityTabState extends State<NotificationActivityTab> {
  @override
  Widget build(BuildContext context) {
    return qoin.GetBuilder<qoin.NotificationController>(builder: (controller) {
      if ((controller.notifData != null &&
              controller.notifData?.length == 0 &&
              widget.tabIndex == 0) ||
          (controller.notifMessageData != null &&
              controller.notifMessageData?.length == 0 &&
              widget.tabIndex == 1)) {
        return NotificationEmptyScreen(
          tabIndex: widget.tabIndex,
        );
      }
      if (widget.tabIndex == 0) {
        return ListView.separated(
          itemCount: controller.notifData!.length,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) =>
              NotificationItemWidget(
            data: controller.notifData![index],
          ),
          separatorBuilder: (BuildContext context, int index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Divider(
              height: 1,
              color: Color(0xffdedede),
            ),
          ),
        );
      }
      return ListView.separated(
        itemCount: controller.notifMessageData!.length,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) =>
            NotificationMsgInfItem(
          data: controller.notifMessageData![index],
        ),
        separatorBuilder: (BuildContext context, int index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Divider(
            height: 1,
            color: Color(0xffdedede),
          ),
        ),
      );
    });
  }
}

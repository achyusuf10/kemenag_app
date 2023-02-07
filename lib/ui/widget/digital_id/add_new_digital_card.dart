import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum EmptyStateType { Identity, Voucher, Ticket }

class AddNewDigitalCard extends StatelessWidget {
  final VoidCallback? onTap;
  final double width;
  final double height;
  final bool isFullscreen;
  final EmptyStateType type;

  const AddNewDigitalCard(
      {Key? key,
      this.onTap,
      this.width = 379,
      this.height = 233.17,
      this.isFullscreen = false,
      required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width.w,
        height: height.w,
        margin: EdgeInsets.only(bottom: 8.w),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(getBackground()),
            fit: BoxFit.fill,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black54, blurRadius: 3.0, offset: Offset(0.0, 0.75))
          ],
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 25, 24, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getTitle(),
                    style: TextUI.subtitleWhite,
                  ),
                  SizedBox(
                    height: 16.w,
                  ),
                  Text(
                    getDesc(),
                    style: TextUI.bodyText2White,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getBackground() {
    switch (type) {
      case EmptyStateType.Identity:
        return Assets.emptyIdentity;
      case EmptyStateType.Voucher:
        return Assets.emptyVoucher;
      default:
        return Assets.emptyTicket;
    }
  }

  String getTitle() {
    switch (type) {
      case EmptyStateType.Identity:
        return Localization.emptyDigitalIds.tr;
      case EmptyStateType.Voucher:
        return Localization.emptyVoucher.tr;
      default:
        return Localization.emptyTicket.tr;
    }
  }

  String getDesc() {
    switch (type) {
      case EmptyStateType.Identity:
        return Localization.emptyDigitalIdsDesc.tr;
      case EmptyStateType.Voucher:
        return Localization.emptyVoucherDesc.tr;
      default:
        return Localization.emptyTicketDesc.tr;
    }
  }
}

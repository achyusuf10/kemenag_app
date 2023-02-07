import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/digital_id/bussiness_card.dart';
import 'package:inisa_app/ui/widget/digital_id/g20_card.dart';
import 'package:inisa_app/ui/widget/digital_id/ktp_national_card.dart';
import 'package:inisa_app/ui/widget/digital_id/otaqu_membership_card.dart';
import 'package:inisa_app/ui/widget/digital_id/passport_card.dart';
import 'package:inisa_app/ui/widget/digital_id/sim_national_card.dart';
import 'package:qoin_sdk/models/qoin_digitalid/document_user_data.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class CardFullscreen extends StatelessWidget {
  final DocumentUserData? data;
  const CardFullscreen({Key? key, required this.data}) : super(key: key);

  Widget? _displayCard() {
    double width = ScreenUtil().screenWidth - 50;

    switch (data?.docCardType) {
      case "${CardCode.ktpCardType}":
        return InteractiveViewer(
          child: Transform.scale(
            scale: 1.5,
            child: Center(
              child: RotatedBox(
                quarterTurns: 1,
                child: KTPNationalCard(
                  data: data,
                ),
              ),
            ),
          ),
        );
      case "${CardCode.simCardType}":
        return InteractiveViewer(
          child: Transform.scale(
            scale: 1.5,
            child: Center(
              child: RotatedBox(
                quarterTurns: 1,
                child: SIMNationalCard(
                  data: data,
                ),
              ),
            ),
          ),
        );
      case "${CardCode.passportCardType}":
        return InteractiveViewer(
          child: Transform.scale(
            scale: 1.5,
            child: Center(
              child: RotatedBox(
                quarterTurns: 1,
                child: PassportCard(
                  data: data,
                ),
              ),
            ),
          ),
        );
      case "${CardCode.businessCardType}":
        return InteractiveViewer(
          child: Transform.scale(
            scale: 1.5,
            child: Center(
              child: RotatedBox(
                quarterTurns: 1,
                child: BusinessCard(
                  data: data,
                ),
              ),
            ),
          ),
        );
      case "${CardCode.g20CardType}":
        return InteractiveViewer(
          child: Transform.scale(
            scale: 1.5,
            child: Center(
              child: RotatedBox(
                quarterTurns: 1,
                child: G20Card(
                  data: data,
                ),
              ),
            ),
          ),
        );
      case "${CardCode.otaquMembership}":
        return InteractiveViewer(
          child: Transform.scale(
            scale: 1.5,
            child: Center(
              child: RotatedBox(
                quarterTurns: 1,
                child: OtaquMembershipCard(
                  data: data,
                ),
              ),
            ),
          ),
        );  
      default:
        return SizedBox();
    }
  }

  double getWidthRatio(double width) {
    double defaultRatio = 379 / 233.17;
    return width * defaultRatio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.primary,
      appBar: AppBarWidget(
        title: DigitalIdLocalization.detailDigitalDocTitle.tr,
      ),
      body: _displayCard(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:inisa_app/ui/widget/digital_id/g20_card.dart';
import 'package:inisa_app/ui/widget/digital_id/otaqu_membership_card.dart';
import 'package:qoin_sdk/models/qoin_digitalid/document_user_data.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

import 'bussiness_card.dart';
import 'ktp_national_card.dart';
import 'passport_card.dart';
import 'sim_national_card.dart';

class DocHolderWidget extends StatelessWidget {
  final DocumentUserData data;
  final VoidCallback? onTap;
  final double height;
  final double width;

  const DocHolderWidget({
    Key? key,
    required this.data,
    this.onTap,
    this.width = 379,
    this.height = 233.17,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (data.docCardType) {
      case '${qoin.CardCode.ktpCardType}':
        return Center(
          child: KTPNationalCard(
            data: data,
            width: width,
            height: height,
            onTap: onTap,
          ),
        );
      case '${qoin.CardCode.simCardType}':
        return Center(
          child: SIMNationalCard(
            data: data,
            width: width, //339,
            height: height, //202,
            onTap: onTap,
          ),
        );
      case '${qoin.CardCode.passportCardType}':
        return Center(
          child: PassportCard(
            data: data,
            width: width,
            height: height,
            onTap: onTap,
          ),
        );
      case '${qoin.CardCode.businessCardType}':
        return Center(
          child: BusinessCard(
            data: data,
            width: width,
            height: height,
            onTap: onTap,
          ),
        );
      case '${qoin.CardCode.otaquMembership}':
        return Center(
          child: OtaquMembershipCard(
            data: data,
            width: width,
            height: height,
            onTap: onTap,
          ),
        );  
      case '${qoin.CardCode.g20CardType}':
        return Center(
          child: G20Card(
            data: data,
            width: width,
            height: height,
            onTap: onTap,
          ),
        );
      default:
        return Center(child: SizedBox());
    }
  }
}

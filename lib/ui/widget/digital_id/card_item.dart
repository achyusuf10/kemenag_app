import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/ui/screen/digital_id/detail_digital_doc_screen.dart';
import 'package:qoin_sdk/models/qoin_digitalid/document_user_data.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

import 'package:inisa_app/helper/assets.dart';

import '../voucher_widget.dart';
import 'doc_holder_widget.dart';

enum TypeCard { idcard, voucher }

abstract class CardItem {
  String? docNumber;
  bool isFavorite = false;
  TypeCard typeCard = TypeCard.idcard;
  Widget buildContent(BuildContext context);
}

class DocumentsItem implements CardItem {
  final DocumentUserData data;
  @override
  String? docNumber;
  @override
  bool isFavorite;
  @override
  TypeCard typeCard = TypeCard.idcard;

  DocumentsItem(
      {required this.data, required this.docNumber, required this.isFavorite});

  @override
  Widget buildContent(BuildContext context) {
    return DocHolderWidget(
        data: data,
        width: 379.w, //340
        height: 233.17.w, //202
        onTap: () {
          qoin.Get.to(
            () => DetailDigitalDocScreen(data: data),
          );
        });
  }
}

class VouchersItem implements CardItem {
  final qoin.VouchersData data;
  @override
  String? docNumber;
  @override
  bool isFavorite;
  @override
  TypeCard typeCard = TypeCard.voucher;

  VouchersItem(
      {required this.data, required this.docNumber, required this.isFavorite});

  @override
  Widget buildContent(BuildContext context) {
    return VoucherWidget(
      voucherData: data,
    );
  }
}

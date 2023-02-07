import 'package:flutter/material.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

// import 'package:venturo_mobile/sentra_kependudukan/logic/models/riwayat_detail.dart';
// import 'package:venturo_mobile/shared_inisa/inisa_venturo_methods.dart';
// import 'package:venturo_mobile/shared_inisa/models/digitalisasi_tni_res/digitalisasi_tni_data.dart';
// import 'package:venturo_mobile/shared_inisa/models/relawan_jokowi.dart';
// import 'package:venturo_mobile/voucher_bansos/logic/models/vouchers.dart';
// import 'package:venturo_mobile/otaqu/logic/models/list_otaqu_ticket_res/otaqu_ticket.dart';

class DigitalArchiveUIController extends GetxController {
  static DigitalArchiveUIController get to => Get.find();

  var digitalIdController = UiDigitalIdController.to;

  List<CardItem> _cardsItem = [];
  set cardsItem(List<CardItem> value) {
    _cardsItem = value;
    try {
      update();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<CardItem> get cardsItem => _cardsItem;

  void joinAllCard() {
    List<CardItem> helper = [];

    digitalIdController.joinAllCard();

    // kk docs
    // List<KKItem> kkItem = [];
    // var kkData = InisaVenturoMethods.allRiwayatKk;
    // for (var i = 0; i < kkData!.length; i++) {
    //   kkItem.add(KKItem(
    //       data: kkData[i],
    //       docNumber: kkData[i].rincian_pemohon?.no_registrasi,
    //       isFavorite: false,
    //       ket: TypeCardExternal.kk.toString()));
    // }

    // akta docs
    // List<AktaItem> aktaItem = [];
    // var aktaData = InisaVenturoMethods.allRiwayatAktaKelahiran;
    // for (var i = 0; i < aktaData!.length; i++) {
    //   aktaItem.add(AktaItem(
    //       data: aktaData[i],
    //       docNumber: aktaData[i].rincian_pemohon?.no_registrasi,
    //       isFavorite: false,
    //       ket: TypeCardExternal.aktaLahir.toString()));
    // }

    // voucher bansos
    // List<BansosItem> bansosItem = [];
    // var bansosData = InisaVenturoMethods.allVoucherBansos;
    // for (var i = 0; i < bansosData!.length; i++) {
    //   bansosItem.add(BansosItem(
    //       data: bansosData[i],
    //       docNumber: bansosData[i].kode_voucher,
    //       isFavorite: false,
    //       ket: TypeCardExternal.bansos.toString()));
    // }

    //* [TAKE OUT] RELAWAN JOKOWI
    // if (InisaVenturoMethods.statusRelawanJokowi()) {
    //   RelawanJokowiItem relawanJokowiItem = RelawanJokowiItem(
    //     data: RelawanJokowi(
    //       userQoinTag: HiveData.userData!.qoinTag,
    //       userAvatar: HiveData.userData!.pict,
    //       userFullname: HiveData.userData!.fullname,
    //       userPhoneNumber: HiveData.userData!.phone,
    //     ),
    //     docNumber: "relawan_jokowi",
    //     isFavorite: false,
    //     ket: TypeCard.idcard.toString(),
    //   );

    //   helper.add(relawanJokowiItem);
    // }

    // var digitalisasiTniData = InisaVenturoMethods.checkDigitalisasiTniData;
    // if (digitalisasiTniData != null) {
    //   DigitalisasiTniItem digitalisasiTniItem = DigitalisasiTniItem(
    //     data: digitalisasiTniData,
    //     docNumber: "digitalisasi_tni",
    //     isFavorite: false,
    //     ket: TypeCard.idcard.toString(),
    //   );

    //   helper.add(digitalisasiTniItem);
    // }

    // ///* Otaqu Ticket
    // List<OtaquTicketItem> listOtaquTicketItem = [];
    // var listOtaquTicketData = InisaVenturoMethods.listOtaquTicket;
    // listOtaquTicketData.forEach(
    //   (element) {
    //     listOtaquTicketItem.add(
    //       OtaquTicketItem(
    //           data: element,
    //           isFavorite: false,
    //           ket: null,
    //           docNumber: element.voucherNumber),
    //     );
    //   },
    // );

    // helper.addAll(kkItem);
    // helper.addAll(aktaItem);
    // helper.addAll(bansosItem);
    // add from qoin_sdk DigitalArchiveUIController
    helper.addAll(digitalIdController.cardsItem);
    // helper.addAll(listOtaquTicketItem);

    helper.sort((a, b) {
      if (b.isFavorite) {
        return 1;
      }
      return -1;
    });

    cardsItem = helper;
    print('cardsItem: ${cardsItem.length}');
    debugPrint("---");
  }

  void saveToFavorite(CardItem value) {
    var helpers = cardsItem;
    var helper =
        helpers.firstWhere((element) => element.docNumber == value.docNumber);
    helper.isFavorite = !helper.isFavorite;
    helpers.sort((a, b) {
      if (b.isFavorite) {
        return 1;
      }
      return -1;
    });
    cardsItem = helpers;
    if (value.typeCard == TypeCard.idcard) {
      _editDocumentsFromHiveData(value.docNumber);
    } else if (value.typeCard == TypeCard.voucherTopup) {
      _editVouchersTopupFromHiveData(value.docNumber);
    } else {
      _editVouchersFromHiveData(value.docNumber);
    }
  }

  void _editDocumentsFromHiveData(String? docNumb) {
    var helpers = HiveData.docData;
    var helper = helpers?.firstWhere((element) => element?.docNo == docNumb);
    helper?.isFavorite = !helper.isFavorite!;
    HiveData.docData = helpers;
  }

  void _editVouchersFromHiveData(String? voucherNumb) {
    var helpers = HiveData.vouchers;
    var helper =
        helpers?.firstWhere((element) => element.voucherNumber == voucherNumb);
    helper?.isFavorite = !helper.isFavorite!;
    HiveData.vouchers = helpers;
  }

  void _editVouchersTopupFromHiveData(String? voucherNo) {
    var helpers = HiveData.vouchersTopupPurchased;
    var helper =
        helpers?.firstWhere((element) => element.voucherNo == voucherNo);
    helper?.isFavorite = !helper.isFavorite!;
    HiveData.vouchersTopupPurchased = helpers;
  }

  void deleteCard(CardItem value) {
    var helpers = cardsItem;
    helpers.removeWhere((element) => element.docNumber == value.docNumber);
    cardsItem = helpers;
  }
}

enum TypeCardExternal { kk, aktaLahir, bansos }

// class KKItem implements CardItem {
//   final RiwayatDetailData data;
//   @override
//   String? docNumber;
//   @override
//   bool isFavorite;
//   @override
//   TypeCard typeCard = TypeCard.others;

//   KKItem(
//       {required this.data,
//       required this.docNumber,
//       required this.isFavorite,
//       this.ket});

//   @override
//   String? ket;
// }

// class AktaItem implements CardItem {
//   final RiwayatDetailData data;
//   @override
//   String? docNumber;
//   @override
//   bool isFavorite;
//   @override
//   TypeCard typeCard = TypeCard.others;

//   AktaItem(
//       {required this.data,
//       required this.docNumber,
//       required this.isFavorite,
//       this.ket});

//   @override
//   String? ket;
// }

// class BansosItem implements CardItem {
//   final Voucher data;
//   @override
//   String? docNumber;
//   @override
//   bool isFavorite;
//   @override
//   TypeCard typeCard = TypeCard.others;

//   BansosItem({
//     required this.data,
//     required this.docNumber,
//     required this.isFavorite,
//     required this.ket,
//   });

//   @override
//   String? ket;
// }

// class RelawanJokowiItem implements CardItem {
//   final RelawanJokowi data;
//   @override
//   String? docNumber;
//   @override
//   bool isFavorite;
//   @override
//   TypeCard typeCard = TypeCard.idcard;

//   RelawanJokowiItem({
//     required this.data,
//     required this.docNumber,
//     required this.isFavorite,
//     required this.ket,
//   });

//   @override
//   String? ket;
// }

// class DigitalisasiTniItem implements CardItem {
//   final DigitalisasiTniData data;
//   @override
//   String? docNumber;
//   @override
//   bool isFavorite;
//   @override
//   TypeCard typeCard = TypeCard.idcard;

//   DigitalisasiTniItem({
//     required this.data,
//     required this.docNumber,
//     required this.isFavorite,
//     required this.ket,
//   });

//   @override
//   String? ket;
// }

// class OtaquTicketItem implements CardItem {
//   OtaquTicket data;

//   @override
//   String? docNumber;

//   @override
//   bool isFavorite;

//   @override
//   String? ket;

//   @override
//   TypeCard typeCard = TypeCard.eticket;

//   OtaquTicketItem({
//     required this.data,
//     required this.docNumber,
//     required this.isFavorite,
//     required this.ket,
//   });
// }

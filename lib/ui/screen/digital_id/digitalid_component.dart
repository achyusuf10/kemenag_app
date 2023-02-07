import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

class DigitalIdComponent{
  static String getCardType(int docCardType) {
    switch (docCardType) {
      case qoin.CardCode.ktpCardType:
        return DigitalIdLocalization.idTypeKTP.tr;
      case qoin.CardCode.simCardType:
        return DigitalIdLocalization.idTypeSimCard.tr;
      case qoin.CardCode.passportCardType:
        return DigitalIdLocalization.idTypePassport.tr;
      case qoin.CardCode.g20CardType:
        return DigitalIdLocalization.idTypeG20Card.tr;
      default:
        return '-';
    }
  }
}
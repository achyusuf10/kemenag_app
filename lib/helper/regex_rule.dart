import 'package:inisa_app/localization/localization.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';

class RegexRule {
  static RegexValidation get numberValidationRule =>
      RegexValidation(regex: r'^[0-9]*$', errorMesssage: Localization.phoneValidation.tr);
  static RegexValidation get emailValidationRule => RegexValidation(
      regex:
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
      errorMesssage: Localization.emailValidation.tr);

  static RegexValidation get emptyValidationRule =>
      RegexValidation(regex: r'^(?!\s*$).+', errorMesssage: Localization.mustFilled.tr);

  static RegexValidation get nikValidationRule => RegexValidation(
      regex: r'^[0-9]{16}', errorMesssage: DigitalIdLocalization.messageNikValidation.tr);

  static String newSimRule = r'^[0-9]{4}-[0-9]{4}-[0-9]{6}';
  static String oldSimRule = r'^[0-9]{12}';
  static String smartSimRule = r'^[A-Z]{1}-[0-9]{4}-[0-9]{4}-[0-9]{6}';
  static String dobNewSIM = r'^[0-9]{2}-[0-9]{2}-[0-9]{4}';
  static String masaBerlakuRule = r'^[0-9]{2}-[0-9]{2}-[0-9]{4}';
  static String passportRule = r'^[A-Z]{1}[ ]{0,1}[0-9]{7}';
  static String datePassport = r'^[0-9]{2}[ ]{0,1}[A-Z]{3}[ ]{0,1}[0-9]{4}';
}

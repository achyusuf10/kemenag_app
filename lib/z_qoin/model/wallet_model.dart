import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:qoin_sdk/helpers/utils/intl_formats.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

class WalletModel {
  static List<Bank>? bankList;

  static init() async {
    var va = qoin.QoinWalletController.to.vaData?.mVaNumber ?? '123456789';
    var name = qoin.QoinWalletController.to.vaData?.mFullname ?? "-";
    bankList = [
      Bank(
        name: "Bank NTT",
        logo: Assets.bankNTT,
        vaData: va,
        vaName: name,
        isActive: qoin.QoinRemoteConfigController.instance.isTopupBankNtt,
      ),
      Bank(
        name: "Bank BCA",
        logo: Assets.lgBca,
        vaData: va,
        vaName: name,
        isActive: qoin.QoinRemoteConfigController.instance.isTopupBankBca,
        howToTopUpList: [
          HowToTopUp(
              title: "ATM BCA",
              description: [
                "Masukkan kartu, pilih bahasa, dan masukkan PIN",
                "Pilih Menu Lain > Transfer > Dari Rekening Tabungan > Virtual Account Billing",
                "Masukkan $va",
                "Masukkan nominal top up yang kamu inginkan",
                "Konfirmasi transaksi"
              ],
              isExpanded: false,
              notes: "Minimum top up Rp20.000\nBiaya admin Rp1.000 dipotong dari nominal top up"),
          HowToTopUp(
              title: "Mobile Banking BCA",
              description: [
                "Masukkan kartu, pilih bahasa, dan masukkan PIN",
                "Pilih Menu Lain > Transfer > Dari Rekening Tabungan > Virtual Account Billing",
                "Masukkan $va",
                "Masukkan nominal top up yang kamu inginkan",
                "Konfirmasi transaksi"
              ],
              isExpanded: false,
              notes: "Minimum top up Rp20.000\nBiaya admin Rp1.000 dipotong dari nominal top up"),
          HowToTopUp(
              title: "Internet Banking BCA",
              description: [
                "Masukkan kartu, pilih bahasa, dan masukkan PIN",
                "Pilih Menu Lain > Transfer > Dari Rekening Tabungan > Virtual Account Billing",
                "Masukkan $va",
                "Masukkan nominal top up yang kamu inginkan",
                "Konfirmasi transaksi"
              ],
              isExpanded: false,
              notes: "Minimum top up Rp20.000\nBiaya admin Rp1.000 dipotong dari nominal top up")
        ],
      ),
      Bank(
        name: "Bank BNI",
        logo: Assets.lgBni,
        vaData: va,
        vaName: name,
        isActive: qoin.QoinRemoteConfigController.instance.isTopupBankBni,
        howToTopUpList: [
          HowToTopUp(
              title: "ATM BNI",
              description: [
                "Masukkan kartu, pilih bahasa, dan masukkan PIN",
                "Pilih Menu Lain > Transfer > Dari Rekening Tabungan > Virtual Account Billing",
                "Masukkan $va",
                "Masukkan nominal top up yang kamu inginkan",
                "Konfirmasi transaksi"
              ],
              isExpanded: false,
              notes: "Minimum top up Rp20.000\nBiaya admin Rp1.000 dipotong dari nominal top up"),
          HowToTopUp(
              title: "Mobile Banking BNI",
              description: [
                "Masukkan kartu, pilih bahasa, dan masukkan PIN",
                "Pilih Menu Lain > Transfer > Dari Rekening Tabungan > Virtual Account Billing",
                "Masukkan $va",
                "Masukkan nominal top up yang kamu inginkan",
                "Konfirmasi transaksi"
              ],
              isExpanded: false,
              notes: "Minimum top up Rp20.000\nBiaya admin Rp1.000 dipotong dari nominal top up"),
          HowToTopUp(
              title: "Internet Banking BNI",
              description: [
                "Masukkan kartu, pilih bahasa, dan masukkan PIN",
                "Pilih Menu Lain > Transfer > Dari Rekening Tabungan > Virtual Account Billing",
                "Masukkan $va",
                "Masukkan nominal top up yang kamu inginkan",
                "Konfirmasi transaksi"
              ],
              isExpanded: false,
              notes: "Minimum top up Rp20.000\nBiaya admin Rp1.000 dipotong dari nominal top up")
        ],
      ),
      Bank(
        name: "Bank BRI",
        logo: Assets.lgBri,
        vaData: va,
        vaName: name,
        isActive: qoin.QoinRemoteConfigController.instance.isTopupBankBri,
        howToTopUpList: [
          HowToTopUp(
              title: "ATM BNI",
              description: [
                "Masukkan kartu, pilih bahasa, dan masukkan PIN",
                "Pilih Menu Lain > Transfer > Dari Rekening Tabungan > Virtual Account Billing",
                "Masukkan $va",
                "Masukkan nominal top up yang kamu inginkan",
                "Konfirmasi transaksi"
              ],
              isExpanded: false,
              notes: "Minimum top up Rp20.000\nBiaya admin Rp1.000 dipotong dari nominal top up"),
          HowToTopUp(
              title: "Mobile Banking BNI",
              description: [
                "Masukkan kartu, pilih bahasa, dan masukkan PIN",
                "Pilih Menu Lain > Transfer > Dari Rekening Tabungan > Virtual Account Billing",
                "Masukkan $va",
                "Masukkan nominal top up yang kamu inginkan",
                "Konfirmasi transaksi"
              ],
              isExpanded: false,
              notes: "Minimum top up Rp20.000\nBiaya admin Rp1.000 dipotong dari nominal top up"),
          HowToTopUp(
              title: "Internet Banking BNI",
              description: [
                "Masukkan kartu, pilih bahasa, dan masukkan PIN",
                "Pilih Menu Lain > Transfer > Dari Rekening Tabungan > Virtual Account Billing",
                "Masukkan $va",
                "Masukkan nominal top up yang kamu inginkan",
                "Konfirmasi transaksi"
              ],
              isExpanded: false,
              notes: "Minimum top up Rp20.000\nBiaya admin Rp1.000 dipotong dari nominal top up")
        ],
      ),
      Bank(
        name: "Bank Mandiri",
        logo: Assets.lgMandiri,
        vaData: va,
        vaName: name,
        isActive: qoin.QoinRemoteConfigController.instance.isTopupBankMandiri,
        howToTopUpList: [
          HowToTopUp(
              title: "ATM BNI",
              description: [
                "Masukkan kartu, pilih bahasa, dan masukkan PIN",
                "Pilih Menu Lain > Transfer > Dari Rekening Tabungan > Virtual Account Billing",
                "Masukkan $va",
                "Masukkan nominal top up yang kamu inginkan",
                "Konfirmasi transaksi"
              ],
              isExpanded: false,
              notes: "Minimum top up Rp20.000\nBiaya admin Rp1.000 dipotong dari nominal top up"),
          HowToTopUp(
              title: "Mobile Banking BNI",
              description: [
                "Masukkan kartu, pilih bahasa, dan masukkan PIN",
                "Pilih Menu Lain > Transfer > Dari Rekening Tabungan > Virtual Account Billing",
                "Masukkan $va",
                "Masukkan nominal top up yang kamu inginkan",
                "Konfirmasi transaksi"
              ],
              isExpanded: false,
              notes: "Minimum top up Rp20.000\nBiaya admin Rp1.000 dipotong dari nominal top up"),
          HowToTopUp(
              title: "Internet Banking BNI",
              description: [
                "Masukkan kartu, pilih bahasa, dan masukkan PIN",
                "Pilih Menu Lain > Transfer > Dari Rekening Tabungan > Virtual Account Billing",
                "Masukkan $va",
                "Masukkan nominal top up yang kamu inginkan",
                "Konfirmasi transaksi"
              ],
              isExpanded: false,
              notes: "Minimum top up Rp20.000\nBiaya admin Rp1.000 dipotong dari nominal top up")
        ],
      ),
      Bank(
        name: "Bank AGI",
        logo: Assets.lgArthaGraha,
        vaData: va,
        vaName: name,
        isActive: qoin.QoinRemoteConfigController.instance.isTopupBankBag,
        howToTopUpList: [
          HowToTopUp(
            title: "ATM Bank AGI",
            description: [
              WalletLocalization.bagiAtmTips1.tr,
              WalletLocalization.bagiAtmTips2.tr,
              WalletLocalization.bagiAtmTips3.tr,
              '${WalletLocalization.bagiAtmTips4.tr} $va.',
              WalletLocalization.bagiAtmTips5.tr,
              WalletLocalization.bagiAtmTips6.tr,
            ],
            isExpanded: false,
            notes: WalletLocalization.bagiAtmTipsNotes.tr,
          ),
          HowToTopUp(
            title: "Internet Banking Bank AGI",
            description: [
              WalletLocalization.bagiInternetTips1.tr,
              WalletLocalization.bagiInternetTips2.tr,
              '${WalletLocalization.bagiInternetTips3.tr} $va.',
              WalletLocalization.bagiInternetTips4.tr,
              WalletLocalization.bagiInternetTips5.tr,
              WalletLocalization.bagiInternetTips6.tr,
            ],
            isExpanded: false,
            notes: WalletLocalization.bagiInternetTipsNotes.tr,
          ),
          HowToTopUp(
            title: "Mobile Banking Bank AGI",
            description: [
              WalletLocalization.bagiMobileTips1.tr,
              WalletLocalization.bagiMobileTips2.tr,
              WalletLocalization.bagiMobileTips3.tr,
              '${WalletLocalization.bagiMobileTips4.tr} $va.',
              WalletLocalization.bagiMobileTips5.tr,
              WalletLocalization.bagiMobileTips6.tr,
              WalletLocalization.bagiMobileTips7.tr,
            ],
            isExpanded: false,
            notes: WalletLocalization.bagiMobileTipsNotes.tr,
          ),
          HowToTopUp(
            title: WalletLocalization.bagiOtherTitle.tr,
            description: [
              WalletLocalization.bagiOtherTips1.tr,
              WalletLocalization.bagiOtherTips2.tr,
              WalletLocalization.bagiOtherTips3.tr,
              '${WalletLocalization.bagiOtherTips4.tr} $va.',
              WalletLocalization.bagiOtherTips5.tr,
              WalletLocalization.bagiOtherTips6.tr,
            ],
            isExpanded: false,
            notes: WalletLocalization.bagiOtherNotes.tr,
          ),
        ],
      ),
    ];
  }

  static List<HowToTopUp>? getHowTo(bankName, va, {double? fee, double? minimum}) {
    if (bankName == "Bank NTT") {
      return [
        HowToTopUp(
            title: "ATM Bank NTT",
            description: [
              WalletLocalization.bnttAtmTips1.tr,
              WalletLocalization.bnttAtmTips2.tr,
              WalletLocalization.bnttAtmTips3.tr,
              '${WalletLocalization.bnttAtmTips4.tr} $va',
              WalletLocalization.bnttAtmTips5.tr,
              WalletLocalization.bnttAtmTips6.tr,
              WalletLocalization.bnttAtmTips7.tr,
            ],
            isExpanded: false,
            notes:
                "${WalletLocalization.bnttAtmTipsNotes1.tr} ${(minimum ?? 0.0).formatCurrencyRp}${WalletLocalization.bnttAtmTipsNotes2.tr} ${(fee ?? 0).formatCurrencyRp} ${WalletLocalization.bnttAtmTipsNotes3.tr}"),
        HowToTopUp(
            title: "Internet Banking Bank NTT",
            description: [
              WalletLocalization.bnttInternetTips1.tr,
              WalletLocalization.bnttInternetTips2.tr,
              WalletLocalization.bnttInternetTips3.tr,
              '${WalletLocalization.bnttInternetTips4.tr} $va',
              WalletLocalization.bnttInternetTips5.tr,
              WalletLocalization.bnttInternetTips6.tr,
            ],
            isExpanded: false,
            notes:
                "${WalletLocalization.bnttAtmTipsNotes1.tr} ${(minimum ?? 0.0).formatCurrencyRp}${WalletLocalization.bnttAtmTipsNotes2.tr} ${(fee ?? 0).formatCurrencyRp} ${WalletLocalization.bnttAtmTipsNotes3.tr}"),
        HowToTopUp(
            title: "Mobile Banking Bank NTT",
            description: [
              WalletLocalization.bnttMobileTips1.tr,
              WalletLocalization.bnttMobileTips2.tr,
              WalletLocalization.bnttMobileTips3.tr,
              '${WalletLocalization.bnttMobileTips4.tr} $va',
              WalletLocalization.bnttMobileTips5.tr,
              WalletLocalization.bnttMobileTips6.tr,
              WalletLocalization.bnttMobileTips7.tr,
            ],
            isExpanded: false,
            notes:
                "${WalletLocalization.bnttAtmTipsNotes1.tr} ${(minimum ?? 0.0).formatCurrencyRp}${WalletLocalization.bnttAtmTipsNotes2.tr} ${(fee ?? 0).formatCurrencyRp} ${WalletLocalization.bnttAtmTipsNotes3.tr}"),
        HowToTopUp(
            title: WalletLocalization.bagiOtherTitle.tr,
            description: [
              WalletLocalization.bnttOtherTips1.tr,
              WalletLocalization.bnttOtherTips2.tr,
              WalletLocalization.bnttOtherTips3.tr,
              '${WalletLocalization.bnttOtherTips4.tr} $va',
              WalletLocalization.bnttOtherTips5.tr,
              WalletLocalization.bnttOtherTips6.tr,
            ],
            isExpanded: false,
            notes:
                "${WalletLocalization.bnttAtmTipsNotes1.tr} ${(minimum ?? 0.0).formatCurrencyRp}${WalletLocalization.bnttAtmTipsNotes2.tr} ${(fee ?? 0).formatCurrencyRp} ${WalletLocalization.bnttAtmTipsNotes3.tr}"),
      ];
    } else {
      return null;
    }
  }
}

class HowToTopUp {
  String? title;
  List<String>? description;
  String? notes;
  bool? isExpanded;

  HowToTopUp({this.title, this.description, this.notes, this.isExpanded});
}

class Bank {
  final String? name;
  final String? logo;
  List<HowToTopUp>? howToTopUpList;
  String? vaData;
  String? vaName;
  final bool? isActive;

  Bank({this.name, this.logo, this.howToTopUpList, this.vaData, this.vaName, this.isActive});
}

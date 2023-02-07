import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inisa_app/logic/controller/pbb_bindings.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/screen/services/bpjs/healthy_bpjs_screen.dart';
import 'package:inisa_app/ui/screen/services/gas/gas_screen.dart';
// import 'package:inisa_app/ui/screen/services/internet_and_tvcabel.dart/internet_tvcable_screen.dart';
// import 'package:inisa_app/ui/screen/services/mobile_recharge/mobile_recharge_screen.dart';
import 'package:inisa_app/ui/screen/services/ota/ota_screen.dart';
// import 'package:inisa_app/ui/screen/services/pam/pam_screen.dart';
// import 'package:inisa_app/ui/screen/services/pbb/pbb_screen.dart';
import 'package:inisa_app/ui/screen/services/peduli_lindungi/peduli_lindungi_screen.dart';
import 'package:inisa_app/ui/screen/services/pln/pln_screen.dart';
import 'package:inisa_app/ui/screen/services/postpaid/postpaid_screen.dart';
import 'package:inisa_app/ui/screen/services/qoin_services_page.dart';
import 'package:inisa_app/ui/screen/services/telephone/telephone_page.dart';
import 'package:inisa_app/ui/screen/services/top_up/top_up_voucher_screen.dart';
import 'package:inisa_app/ui/screen/services/widget_menu/controller/menu_services_binding.dart';
import 'package:qoin_sdk/controllers/qoin_services/pl_controllers.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
// import 'package:venturo_mobile/sentra_kependudukan/ui/screens/sentra_kependudukan_screen.dart';
// import 'package:venturo_mobile/sentra_lokasi/ui/screens/sentra_lokasi_screen.dart';
import 'services_id_model.dart';

class ServiceDataModel {
  int id;
  String category;
  String name;
  String imageAsset;
  String? imageAssetGrey;
  bool isActive;

  ServicesIdModel servicesIdModel = ServicesIdModel();
  Widget? get page {
    if (id == 0) {
      return QoinServicesPage();
    } else if (id == servicesIdModel.mobileRecharge) {
      // return MobileRechargeScreen();
    } else if (id == servicesIdModel.electricityTokens) {
      return PlnScreen(tabIndex: 0);
    } else if (id == servicesIdModel.postpaid) {
      return PostpaidScreen();
    } else if (id == servicesIdModel.electricityPostpaid) {
      return PlnScreen(tabIndex: 1);
    } else if (id == servicesIdModel.gas) {
      return GasScreen();
    } else if (id == servicesIdModel.pdam) {
      // return PamScreen();
    } else if (id == servicesIdModel.telephone) {
      return TelephoneScreen();
    } else if (id == servicesIdModel.bpjsKesehatan) {
      return HealthyBpjsScreen();
    } else if (id == servicesIdModel.internet) {
      // return InternetTVCableScreen();
    } else if (id == servicesIdModel.pajakPBB) {
      // return PBBScreen();
    } else if (id == servicesIdModel.tvCable) {
      // return InternetTVCableScreen(
      //   tabIndex: 1,
      // );
    } else if (id == servicesIdModel.premiInsurance) {
      return null;
    } else if (id == servicesIdModel.onlineCommerce) {
      // return OnlineCommercePage();
    } else if (id == servicesIdModel.streaming) {
      return null;
    } else if (id == servicesIdModel.game) {
      return null;
    } else if (id == servicesIdModel.flight) {
      return null;
    } else if (id == servicesIdModel.hotel) {
      return null;
    } else if (id == servicesIdModel.gold) {
      return null;
    } else if (id == servicesIdModel.remittance) {
      return null;
    } else if (id == servicesIdModel.moneyCharger) {
      return null;
    } else if (id == servicesIdModel.onlineLoan) {
      return null;
    } else if (id == servicesIdModel.donation) {
      return null;
    } else if (id == servicesIdModel.panicButton) {
      return null;
    } else if (id == servicesIdModel.security) {
      return null;
    } else if (id == servicesIdModel.cssr) {
      return null;
    } else if (id == servicesIdModel.health) {
      return null;
    } else if (id == servicesIdModel.voucher) {
      return TopUpVoucherScreen();
    } else if (id == servicesIdModel.ticketWisata) {
      return OtaScreen();
    } else if (id == servicesIdModel.travel) {
      return OtaScreen(
        otaType: OtaType.Travel,
      );
    } else if (id == servicesIdModel.otaquMembership) {
      return OtaScreen(
        otaType: OtaType.Membership,
      );
    } else if (id == servicesIdModel.screeningCovid) {
      // return WebViewPage(
      //   url: "https://visitor.agparthakes.id/?phone=${QoinServices.userNoHp}",
      //   onBack: () {
      //     Get.back();
      //   },
      // );
      // return HealthQRPage();
    } else if (id == servicesIdModel.peduliLindungi) {
      return PeduliLindungiScreen();
      // } else if (id == servicesIdModel.locationCenter) {
      //   return SentraLokasiScreen();
      // } else if (id == servicesIdModel.civilRegistration) {
      //   return SentraKependudukanScreen(
      //     onFinishCreateAktaKelahiran: () {
      //       Get.offAll(() => HomeScreen(), binding: OnloginBindings());
      //     },
      //     onFinishCreateKk: () {
      //       Get.offAll(() => HomeScreen(), binding: OnloginBindings());
      //     },
      //   );
    } else {
      return null;
    }
  }

  dynamic get binding {
    if (id == 0) {
      return MenuServicesBinding();
    } else if (id == servicesIdModel.mobileRecharge) {
      return ServiceBinding();
    } else if (id == servicesIdModel.electricityTokens) {
      return ServiceBinding();
    } else if (id == servicesIdModel.postpaid) {
      return ServiceBinding();
    } else if (id == servicesIdModel.electricityPostpaid) {
      return ServiceBinding();
    } else if (id == servicesIdModel.gas) {
      return ServiceBinding();
    } else if (id == servicesIdModel.pdam) {
      return ServiceBinding();
    } else if (id == servicesIdModel.telephone) {
      return ServiceBinding();
    } else if (id == servicesIdModel.bpjsKesehatan) {
      return ServiceBinding();
    } else if (id == servicesIdModel.internet) {
      return ServiceBinding();
    } else if (id == servicesIdModel.tvCable) {
      return ServiceBinding();
    } else if (id == servicesIdModel.premiInsurance) {
      return null;
    } else if (id == servicesIdModel.onlineCommerce) {
      // return OnlineCommerceBinding();
    } else if (id == servicesIdModel.streaming) {
      return null;
    } else if (id == servicesIdModel.game) {
      return null;
    } else if (id == servicesIdModel.flight) {
      return null;
    } else if (id == servicesIdModel.hotel) {
      return null;
    } else if (id == servicesIdModel.gold) {
      return null;
    } else if (id == servicesIdModel.remittance) {
      return null;
    } else if (id == servicesIdModel.moneyCharger) {
      return null;
    } else if (id == servicesIdModel.onlineLoan) {
      return null;
    } else if (id == servicesIdModel.donation) {
      return null;
    } else if (id == servicesIdModel.panicButton) {
      return null;
    } else if (id == servicesIdModel.security) {
      return null;
    } else if (id == servicesIdModel.cssr) {
      return null;
    } else if (id == servicesIdModel.health) {
      return null;
    } else if (id == servicesIdModel.voucher) {
      return null;
    } else if (id == servicesIdModel.screeningCovid) {
      // return HealthBinding();
    } else if (id == servicesIdModel.peduliLindungi) {
      return PLBindings();
    } else if (id == servicesIdModel.pajakPBB) {
      return PbbBindings();
    } else {
      return null;
    }
  }

  ServiceDataModel({
    required this.id,
    required this.category,
    required this.name,
    required this.imageAsset,
    this.imageAssetGrey,
    this.isActive = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'name': name,
      'imageAsset': imageAsset,
      'imageAssetGrey': imageAssetGrey,
      'isActive': isActive,
    };
  }

  factory ServiceDataModel.fromMap(Map<String, dynamic> map) {
    return ServiceDataModel(
      id: map['id'],
      category: map['category'],
      name: map['name'],
      imageAsset: map['imageAsset'],
      imageAssetGrey: map['imageAssetGrey'],
      isActive: map['isActive'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceDataModel.fromJson(String source) =>
      ServiceDataModel.fromMap(json.decode(source));
}

class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    //* [TAKE OUT] YUKK INQUIRY PPOB
    // Get.put(YukkInquiryPpobController());
    Get.put<ServicesController>(ServicesController());
  }
}

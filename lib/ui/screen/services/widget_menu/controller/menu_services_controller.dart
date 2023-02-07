import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/ui/screen/services/widget_menu/models/service_data_model.dart';
import 'package:inisa_app/ui/screen/services/widget_menu/models/services_id_model.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';

class MenuServicesController extends GetxController {
  static MenuServicesController get to => Get.find();

  ServicesIdModel servicesId = ServicesIdModel();

  static List<ShowServices> showServices = [
    ShowServices.PajakPBB,
    ShowServices.HealthyBpjs,
    ShowServices.ElectricityTokens,
    ShowServices.MobileRecharge,
    ShowServices.Travel,
    ShowServices.OtaquMembership,
    // ShowServices.TicketWisata,
    // ShowServices.PeduliLindungi,
    ShowServices.ElectricityPostpaid,
    ShowServices.Postpaid,
    ShowServices.InternetTvCable,
    ShowServices.PDAM,
    ShowServices.Gas,
    ShowServices.Telephone,
    ShowServices.LocationCenter,
    ShowServices.CivilRegistration,
    ShowServices.VoucherTopUp,
    // ShowServices.RentalCar,
    // ShowServices.Hotel,
    // ShowServices.Flight,
  ];

  bool _isEditFavorite = false;
  bool _isSearching = false;

  static int? helperFavorites;

  List<String> _helperCategoryServices = [];
  List<String> _categoryServices = [];
  String _selectedCategory = '';
  List<ServiceDataModel> _helperServices = [];
  List<ServiceDataModel> _services = [];
  List<ServiceDataModel> _menuServicesHome = [];
  List<ServiceDataModel> _menuServicesFavorite = [];
  List<ServiceDataModel> _menuServicesOthers = [];
  List<ServiceDataModel> _menuServicesTagihan = [];
  List<ServiceDataModel> _menuServicesWisata = [];
  List<ServiceDataModel> _menuServicesPajak = [];
  List<ServiceDataModel> _menuServicesLocation = [];
  List<ServiceDataModel> _menuCivilRegistration = [];

  set menuServicesTagihan(List<ServiceDataModel> value) {
    _menuServicesTagihan = value;
    update();
  }

  List<ServiceDataModel> get menuServicesTagihan => _menuServicesTagihan;

  set menuServicesWisata(List<ServiceDataModel> value) {
    _menuServicesWisata = value;
    update();
  }

  List<ServiceDataModel> get menuServicesWisata => _menuServicesWisata;

  set menuServicesPajak(List<ServiceDataModel> value) {
    _menuServicesPajak = value;
    update();
  }

  List<ServiceDataModel> get menuServicesPajak => _menuServicesPajak;

  set menuServicesLocation(List<ServiceDataModel> value) {
    _menuServicesLocation = value;
    update();
  }

  List<ServiceDataModel> get menuServicesLocation => _menuServicesLocation;

  set menuCivilRegistration(List<ServiceDataModel> value) {
    _menuCivilRegistration = value;
    update();
  }

  List<ServiceDataModel> get menuCivilRegistration => _menuCivilRegistration;

  set menuServiceOthers(List<ServiceDataModel> value) {
    _menuServicesOthers = value;
    update();
  }

  List<ServiceDataModel> get menuServiceOthers => _menuServicesOthers;

  set menuServicesFavorite(List<ServiceDataModel> value) {
    _menuServicesFavorite = value;
    update();
  }

  List<ServiceDataModel> get menuServicesFavorite => _menuServicesFavorite;

  set menuServicesHome(List<ServiceDataModel> value) {
    _menuServicesHome = value;
    update();
  }

  List<ServiceDataModel> get menuServicesHome => _menuServicesHome;

  set services(List<ServiceDataModel> value) {
    _services = value;
    update();
  }

  List<ServiceDataModel> get services => _services;

  set helperServices(List<ServiceDataModel> value) {
    _helperServices = value;
    update();
  }

  List<ServiceDataModel> get helperServices => _helperServices;

  set selectedCategory(String value) {
    _selectedCategory = value;
    update();
  }

  String get selectedCategory => _selectedCategory;

  set categoryServices(List<String> value) {
    _categoryServices = value;
    update();
  }

  List<String> get categoryServices => _categoryServices;

  set helperCategoryServices(List<String> value) {
    _helperCategoryServices = value;
    update();
  }

  List<String> get helperCategoryServices => _helperCategoryServices;

  set isSearching(bool value) {
    _isSearching = value;
    update();
  }

  bool get isSearching => _isSearching;

  set isEditFavorite(bool value) {
    _isEditFavorite = value;
    update();
  }

  bool get isEditFavorite => _isEditFavorite;

  @override
  void onInit() async {
    debugPrint("==========> onInit called <===========");
    updateServices();
    debugPrint("==========> onInit end <===========");
    super.onInit();
  }

  void updateServices() async {
    await _setMenusServices();
    _init();
  }

  void searchMenu(String? value) {
    List<ServiceDataModel> helper = [];
    List<String> helperCat = [];
    if (value != null && value.isNotEmpty) {
      helper.addAll(helperServices);
      services = helper
          .where((element) =>
              element.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
      for (var i = 0; i < services.length; i++) {
        if (!helperCat.contains(services[i].category)) {
          helperCat.add(services[i].category);
        }
      }
      categoryServices = helperCat;
    } else {
      services = helperServices;
      categoryServices = helperCategoryServices;
    }
    debugPrint(
        "category length: ${categoryServices.length}, services length: ${services.length}");
    _init();
  }

  void addFavorite(ServiceDataModel value) {
    bool isAlready =
        menuServicesFavorite.any((element) => element.id == value.id);
    if (!isAlready) {
      menuServicesFavorite.add(value);
      menuServicesFavorite = menuServicesFavorite;
    }
  }

  void removeFavorite(ServiceDataModel value) {
    menuServicesFavorite.removeWhere((element) => element.id == value.id);
    menuServicesFavorite = menuServicesFavorite;
  }

  void _init() {
    // debugPrint(
    //     "QoinServices.favorites ${QoinServices.favorites}, QoinServices.isFirstLogedin ${QoinServices.helperFavorites}");
    List<ServiceDataModel> favorites = List<ServiceDataModel>.from(HiveData
        .favServices!
        .map((e) => ServiceDataModel?.fromJson(jsonDecode(e!)))
        .toList());
    if (favorites.length == 0) {
      menuServicesFavorite = services.take(7).toList();
    } else {
      List<ServiceDataModel> helperFav = [];
      // List<ServiceDataModel> favorites = List<ServiceDataModel>.from(HiveData
      //     .favServices!
      //     .map((json) => ServiceDataModel?.fromJson(json!))
      //     .toList());
      helperFav.addAll(favorites);
      menuServicesFavorite = helperFav;
    }
    //
    if (menuServicesFavorite.length < 7) {
      List<ServiceDataModel> menuServicesHomeHelper = [];
      menuServicesHomeHelper.addAll(menuServicesFavorite);
      services.forEach((element) {
        if (!menuServicesHomeHelper
            .any((elementHelper) => elementHelper.id == element.id)) {
          menuServicesHomeHelper.add(element);
        }
      });
      menuServicesHome = menuServicesHomeHelper.take(7).toList();
      menuServicesHome.add(
        ServiceDataModel(
          id: 0,
          category: "-",
          name: QoinServicesLocalization.serviceMenuMore.tr,
          imageAsset: "assets/images/services/menuMore.png",
          isActive: true,
        ),
      );
    } else {
      menuServicesHome = menuServicesFavorite.take(7).toList();
      menuServicesHome.add(
        ServiceDataModel(
          id: 0,
          category: "-",
          name: QoinServicesLocalization.serviceMenuMore.tr,
          imageAsset: "assets/images/services/menuMore.png",
          isActive: true,
        ),
      );
      debugPrint("menuServicesFavorite3: $menuServicesFavorite");
    }
    menuServicesTagihan = services
        .where((element) => element.category == QoinServicesLocalization.serviceMenuCategoryBill.tr)
        .toList();
    menuServicesWisata = services
        .where(
            (element) => element.category == QoinServicesLocalization.serviceMenuCategoryTour.tr)
        .toList();
    menuServicesPajak = services
        .where((element) => element.category == QoinServicesLocalization.serviceMenuCategoryTax.tr)
        .toList();
    menuServicesLocation = services
        .where((element) =>
            element.category ==
            QoinServicesLocalization.serviceMenuCategoryLocation.tr)
        .toList();
    menuCivilRegistration = services
        .where((element) =>
            element.category ==
            QoinServicesLocalization.serviceMenuCategoryPopulation.tr)
        .toList();
    menuServiceOthers = services
        .where((element) =>
            element.category ==
            QoinServicesLocalization.serviceMenuCategoryOthers.tr)
        .toList();
  }

  Future<void> _setMenusServices() async {
    helperServices = [];
    services = [];
    var catServices = [
      QoinServicesLocalization.serviceMenuCategoryAll.tr,
      QoinServicesLocalization.serviceMenuCategoryFavorite.tr,
      QoinServicesLocalization.serviceMenuCategoryBill.tr,
      QoinServicesLocalization.serviceMenuCategoryTour.tr,
      QoinServicesLocalization.serviceMenuCategoryTax.tr,
      QoinServicesLocalization.serviceMenuCategoryLocation.tr,
      QoinServicesLocalization.serviceMenuCategoryPopulation.tr,
      QoinServicesLocalization.serviceMenuCategoryOthers.tr,
    ];
    helperCategoryServices = catServices;
    categoryServices = catServices;
    selectedCategory = QoinServicesLocalization.serviceMenuCategoryAll.tr;

    for (var i = 0; i < showServices.length; i++) {
      helperServices.add(_service(showServices[i])!);
      services.add(_service(showServices[i])!);
    }
  }

  ServiceDataModel? _service(ShowServices service) {
    switch (service) {
      // topup & isi pulsa
      case ShowServices.MobileRecharge:
        return ServiceDataModel(
          id: servicesId.mobileRecharge,
          category: QoinServicesLocalization.serviceMenuCategoryBill.tr,
          name: QoinServicesLocalization.serviceMenuMobileRecharge.tr,
          imageAsset: 'assets/images/services/menuPulsa.png',
          isActive: QoinRemoteConfigController.instance.isMobileRechargeActive,
        );
      case ShowServices.ElectricityTokens:
        return ServiceDataModel(
          id: servicesId.electricityTokens,
          category: QoinServicesLocalization.serviceMenuCategoryBill.tr,
          name: QoinServicesLocalization.serviceMenuElectricityTokens.tr,
          imageAsset: 'assets/images/services/menuPln.png',
          isActive:
              QoinRemoteConfigController.instance.isElectricityTokenActive,
        );
      // tagihan
      case ShowServices.Postpaid:
        return ServiceDataModel(
          id: servicesId.postpaid,
          category: QoinServicesLocalization.serviceMenuCategoryBill.tr,
          name: QoinServicesLocalization.serviceMenuPostpaid.tr,
          imageAsset: 'assets/images/services/menuPascabayar.png',
          isActive: QoinRemoteConfigController.instance.isMobilePascaActive,
        );
      case ShowServices.ElectricityPostpaid:
        return ServiceDataModel(
          id: servicesId.electricityPostpaid,
          category: QoinServicesLocalization.serviceMenuCategoryBill.tr,
          name: QoinServicesLocalization.serviceMenuElectricityPostpaid.tr,
          imageAsset: 'assets/images/services/menuListrikPascabayar.png',
          isActive:
              QoinRemoteConfigController.instance.isElectricityPascaActive,
        );
      case ShowServices.Gas:
        return ServiceDataModel(
          id: servicesId.gas,
          category: QoinServicesLocalization.serviceMenuCategoryBill.tr,
          name: QoinServicesLocalization.serviceMenuGas.tr,
          imageAsset: 'assets/images/services/menuGas.png',
          isActive: QoinRemoteConfigController.instance.isGasActive,
        );
      case ShowServices.PDAM:
        return ServiceDataModel(
          id: servicesId.pdam,
          category: QoinServicesLocalization.serviceMenuCategoryBill.tr,
          name: QoinServicesLocalization.serviceMenuPdam.tr,
          imageAsset: 'assets/images/services/menuPam.png',
          isActive: QoinRemoteConfigController.instance.isPdamActive,
        );
      case ShowServices.Telephone:
        return ServiceDataModel(
          id: servicesId.telephone,
          category: QoinServicesLocalization.serviceMenuCategoryBill.tr,
          name: QoinServicesLocalization.serviceMenuTelephone.tr,
          imageAsset: 'assets/images/services/menuTelepon.png',
          isActive: QoinRemoteConfigController.instance.isTelephoneActive,
        );
      case ShowServices.HealthyBpjs:
        return ServiceDataModel(
          id: servicesId.bpjsKesehatan,
          category: QoinServicesLocalization.serviceMenuCategoryBill.tr,
          name: QoinServicesLocalization.serviceMenuHealthyBpjs.tr,
          imageAsset: 'assets/images/services/menuHealthyBpjs.png',
          isActive: QoinRemoteConfigController.instance.isBpjsHealthActive,
        );
      case ShowServices.InternetTvCable:
        return ServiceDataModel(
          id: servicesId.internet,
          category: QoinServicesLocalization.serviceMenuCategoryBill.tr,
          name: QoinServicesLocalization.serviceMenuInternerTvcable.tr,
          imageAsset: 'assets/images/services/menuInternetAndTvCable.png',
          isActive:
              QoinRemoteConfigController.instance.isInternetAndTvCableActive,
        );
      // Travel
      case ShowServices.Flight:
        return ServiceDataModel(
          id: servicesId.flight,
          category: QoinServicesLocalization.serviceMenuCategoryTour.tr,
          name: QoinServicesLocalization.serviceMenuFlights.tr,
          imageAsset: 'assets/images/services/menuPesawat.png',
          isActive: QoinRemoteConfigController.instance.isFlightTicketActive,
        );
      case ShowServices.Hotel:
        return ServiceDataModel(
          id: servicesId.hotel,
          category: QoinServicesLocalization.serviceMenuCategoryTour.tr,
          name: QoinServicesLocalization.serviceMenuHotels.tr,
          imageAsset: 'assets/images/services/menuHotel.png',
          isActive: QoinRemoteConfigController.instance.isHotelActive,
        );
      case ShowServices.TicketWisata:
        return ServiceDataModel(
          id: servicesId.ticketWisata,
          category: QoinServicesLocalization.serviceMenuCategoryTour.tr,
          name: QoinServicesLocalization.serviceMenuTour.tr,
          imageAsset: 'assets/images/services/menuTicketWisata.png',
          isActive: QoinRemoteConfigController.instance.isTourTicketActive,
        );
      case ShowServices.Travel:
        return ServiceDataModel(
          id: servicesId.travel,
          category: QoinServicesLocalization.serviceMenuCategoryTour.tr,
          name: QoinServicesLocalization.serviceMenuTravel.tr,
          imageAsset: 'assets/images/services/menuTravel.png',
          isActive: QoinRemoteConfigController.instance.isTravelActive,
        );
      case ShowServices.RentalCar:
        return ServiceDataModel(
          id: servicesId.rentalCar,
          category: QoinServicesLocalization.serviceMenuCategoryTour.tr,
          name: QoinServicesLocalization.serviceMenuRentalCar.tr,
          imageAsset: 'assets/images/services/menuRentalCar.png',
          isActive: QoinRemoteConfigController.instance.isRentalCarActive,
        );
      case ShowServices.PajakPBB:
        return ServiceDataModel(
          id: servicesId.pajakPBB,
          category: QoinServicesLocalization.serviceMenuCategoryTax.tr,
          name: QoinServicesLocalization.serviceMenuTaxPBB.tr,
          imageAsset: 'assets/images/services/menuPajak.png',
          isActive: QoinRemoteConfigController.instance.isPbbTaxActive,
        );
      case ShowServices.PeduliLindungi:
        return ServiceDataModel(
          id: servicesId.peduliLindungi,
          category: QoinServicesLocalization.serviceMenuCategoryOthers.tr,
          name: "PeduliLindungi",
          imageAsset: 'assets/images/services/peduliLindungi.png',
          isActive: QoinRemoteConfigController.instance.isPeduliLindungiActive,
        );
      case ShowServices.VoucherTopUp:
        return ServiceDataModel(
          id: servicesId.voucher,
          category: QoinServicesLocalization.serviceMenuCategoryOthers.tr,
          name: QoinServicesLocalization.serviceMenuVoucher.tr,
          imageAsset: 'assets/images/services/menuVoucher.png',
          isActive: QoinRemoteConfigController.instance.isVoucherTopupActive,
        );
      case ShowServices.LocationCenter:
        return ServiceDataModel(
          id: servicesId.locationCenter,
          category: QoinServicesLocalization.serviceMenuCategoryLocation.tr,
          name: QoinServicesLocalization.serviceMenuLocation.tr,
          imageAsset: 'assets/images/services/menuLocationCenter.png',
          isActive: QoinRemoteConfigController.instance.isLocationCenterActive,
        );
      case ShowServices.CivilRegistration:
        return ServiceDataModel(
          id: servicesId.civilRegistration,
          category: QoinServicesLocalization.serviceMenuCategoryPopulation.tr,
          name: QoinServicesLocalization.serviceMenuPopulation.tr,
          imageAsset: 'assets/images/services/menuPascabayar.png',
          isActive: QoinRemoteConfigController.instance.IsCitizenshipCenter,
        );
      case ShowServices.OtaquMembership:
        return ServiceDataModel(
          id: servicesId.otaquMembership,
          category: QoinServicesLocalization.serviceMenuCategoryTour.tr,
          name: QoinServicesLocalization.serviceMenuOtaquMembership.tr,
          imageAsset: Assets.komodoMembership2,
          isActive: QoinRemoteConfigController.instance.IsKomodoMembershipActive,
        );  
      default:
        return null;
    }
  }
}

enum ShowServices {
  MobileRecharge,
  ElectricityTokens,
  Postpaid,
  ElectricityPostpaid,
  Gas,
  PDAM,
  Telephone,
  HealthyBpjs,
  InternetTvCable,
  InsurancePremium,
  OnlineCommerce,
  Streaming,
  Games,
  Hotel,
  Flight,
  Gold,
  Remittance,
  MoneyCharger,
  OnlineLoan,
  Donation,
  PanicButton,
  Security,
  Cssr,
  Insurance,
  Health,
  VoucherTopUp,
  ScreeningCovid19,
  TicketWisata,
  PajakPBB,
  RentalCar,
  PeduliLindungi,
  LocationCenter,
  Travel,
  CivilRegistration,
  OtaquMembership
}

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:qoin_sdk/models/qoin_accounts/file_upload_result.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

enum GenderType { male, female }
enum ExpireType { livetime, validuntil }
enum FaceMatchType { vida, authentika }

class RegisterFormDigitalIdController extends GetxController {
  static RegisterFormDigitalIdController get to => Get.find();

  var docNik = ''.obs;
  var docNo = ''.obs;
  var docName = ''.obs;
  var docCompanyName = ''.obs;
  var docPosition = ''.obs;
  var docPhoneNumber = ''.obs;
  var docCompanyPhone = ''.obs;
  var docCompanyEmail = ''.obs;
  var docCompanyAddress = ''.obs;
  var docCompanyWebsite = ''.obs;
  var docBirthPlace = ''.obs;
  RxString? docBirthDate = ''.obs;
  RxString? docGender = ''.obs;
  RxString? docBloodType = ''.obs;
  var docAddress = ''.obs;
  var docRt = ''.obs;
  var docRw = ''.obs;
  var docSubDistrict = ''.obs;
  var docDistrict = ''.obs;
  var docCity = ''.obs;
  var docProvince = ''.obs;
  RxString? docReligion = ''.obs;
  RxString? docMaritalStatus = ''.obs;
  RxString? docProfession = ''.obs;
  RxString? docNationality = ''.obs;
  var docImage = ''.obs;
  var photoFileUpload = ''.obs;
  var profileFileUpload = ''.obs;
  var livenessImage = ''.obs;
  var simTypeCode = ''.obs;
  var passportTypeCode = ''.obs;
  var docIssuer = ''.obs;
  RxString? docExpireType = ''.obs;
  RxString? docExpire = ''.obs;
  RxString? docIssuerDate = ''.obs;
  var docRegistrationNo = ''.obs;
  var docNationalityCode = ''.obs;

  File? ocrImage;
  RxBool validateBirthDate = false.obs;
  RxBool validateExpire = false.obs;
  RxBool validateIssuerDate = false.obs;
  RxBool validateUploadImage = false.obs;
  RxBool validateGender = false.obs;
  RxBool validateProvince = false.obs;
  RxBool validateCity = false.obs;
  RxBool validateDistrict = false.obs;
  RxBool validateSubDistrict = false.obs;
  RxBool validateProfileUploadImage = true.obs;
  RxInt difference = 0.obs;

  String get fullAddress =>
      "$docAddress, RT/RW $docRt/$docRw, Kel/Desa $docSubDistrict, Kecamatan $docDistrict";

  RxInt documentLength = 0.obs;
  RxInt reqDocLength = 0.obs;
  RxInt formStep = 1.obs;

  FileUploadResult? tempFileUpload;
  FileUploadResult? businessProfilePict;

  final docBirthDateController = TextEditingController().obs;

  var formKey = GlobalKey<FormState>();
  var businessFormKey = GlobalKey<FormState>();
  var formKey2 = GlobalKey<FormState>();

  final provinceController = TextEditingController().obs;
  // var provinceId = ''.obs;
  // var provinceList = <ProvinceData>[].obs;

  final cityController = TextEditingController().obs;
  // var cityId = ''.obs;
  // var cityList = <CityData>[].obs;

  final districtController = TextEditingController().obs;
  // var districtId = ''.obs;
  // var districtList = <DistrictData>[].obs;

  final subDistrictController = TextEditingController().obs;
  // var subDistrictId = ''.obs;
  // var subDistrictList = <SubDistrictData>[].obs;

  List<Map<String, String>> genderType = [
    {
      'label': DigitalIdLocalization.registerGenderTypeMale.tr,
      'value': 'male',
    },
    {
      'label': DigitalIdLocalization.registerGenderTypeFemale.tr,
      'value': 'female',
    },
  ];

  List<Map<String, String>> bloodType = [
    {
      'label': 'A',
      'value': 'A',
    },
    {
      'label': 'B',
      'value': 'B',
    },
    {
      'label': 'AB',
      'value': 'AB',
    },
    {
      'label': 'O',
      'value': 'O',
    },
  ];

  List<Map<String, String>> religionType = [
    {
      'label': DigitalIdLocalization.registerReligionMuslim.tr,
      'value': 'Islam',
    },
    {
      'label': DigitalIdLocalization.registerReligionCatholic.tr,
      'value': 'Katolik',
    },
    {
      'label': DigitalIdLocalization.registerReligionHindu.tr,
      'value': 'Hindu',
    },
    {
      'label': DigitalIdLocalization.registerReligionBuddha.tr,
      'value': 'Budha',
    },
    {
      'label': DigitalIdLocalization.registerReligionProtestant.tr,
      'value': 'Protestan',
    },
    {
      'label': DigitalIdLocalization.registerReligionConfucianism.tr,
      'value': 'Khonghucu',
    },
    {
      'label': DigitalIdLocalization.registerReligionOther.tr,
      'value': 'Other',
    },
  ];

  List<Map<String, String>> maritalType = [
    {
      'label': DigitalIdLocalization.registerMaritalTypeSingle.tr,
      'value': 'Belum Kawin',
    },
    {
      'label': DigitalIdLocalization.registerMaritalTypeMarried.tr,
      'value': 'Kawin',
    },
    {
      'label': DigitalIdLocalization.registerMaritalTypeDivorced.tr,
      'value': 'Cerai Hidup',
    },
    {
      'label': DigitalIdLocalization.registerMaritalTypeDeadDivorce.tr,
      'value': 'Cerai Mati',
    },
  ];

  List<Map<String, String>> workList = [
    {
      'label': DigitalIdLocalization.workTypeAbri.tr,
      'value': 'ABRI',
    },
    {
      'label': DigitalIdLocalization.workTypeLaborer.tr,
      'value': 'Buruh',
    },
    {
      'label': DigitalIdLocalization.workTypeDoctor.tr,
      'value': 'Dokter',
    },
    {
      'label': DigitalIdLocalization.workTypeLecturer.tr,
      'value': 'Dosen',
    },
    {
      'label': DigitalIdLocalization.workTypeAmbassador.tr,
      'value': 'Duta Besar',
    },
    {
      'label': DigitalIdLocalization.workTypeTeacher.tr,
      'value': 'Guru',
    },
    {
      'label': DigitalIdLocalization.workTypeJudge.tr,
      'value': 'Hakim',
    },
    {
      'label': DigitalIdLocalization.workTypeHouseWife.tr,
      'value': 'Ibu Rumah Tangga',
    },
    {
      'label': DigitalIdLocalization.workTypeProsecutor.tr,
      'value': 'Jaksa',
    },
    {
      'label': DigitalIdLocalization.workTypeSeller.tr,
      'value': 'Pedagang',
    },
    {
      'label': DigitalIdLocalization.workTypeBumd.tr,
      'value': 'Pegawai BUMD',
    },
    {
      'label': DigitalIdLocalization.workTypeBumn.tr,
      'value': 'Pegawai BUMN',
    },
    {
      'label': DigitalIdLocalization.workTypeGovEmployee.tr,
      'value': 'Pegawai Negeri',
    },
    {
      'label': DigitalIdLocalization.workTypeEmployee.tr,
      'value': 'Pegawai Swasta',
    },
    {
      'label': DigitalIdLocalization.workTypeStudent.tr,
      'value': 'Pelajar',
    },
    {
      'label': DigitalIdLocalization.workTypeLawyer.tr,
      'value': 'Pengacara',
    },
    {
      'label': DigitalIdLocalization.workTypeDriver.tr,
      'value': 'Pengemudi',
    },
    {
      'label': DigitalIdLocalization.workTypePolri.tr,
      'value': 'POLRI',
    },
    {
      'label': DigitalIdLocalization.workTypePensioner.tr,
      'value': 'Purnawirawan',
    },
    {
      'label': DigitalIdLocalization.workTypeAD.tr,
      'value': 'TNI AD',
    },
    {
      'label': DigitalIdLocalization.workTypeAL.tr,
      'value': 'TNI AL',
    },
    {
      'label': DigitalIdLocalization.workTypeAU.tr,
      'value': 'TNI AU',
    },
    {
      'label': DigitalIdLocalization.workTypeTNI.tr,
      'value': 'TNI/POLRI',
    },
    {
      'label': DigitalIdLocalization.workTypeJournalist.tr,
      'value': 'Wartawan',
    },
    {
      'label': DigitalIdLocalization.workTypeWiraswasta.tr,
      'value': 'Wiraswasta',
    },
    {
      'label': DigitalIdLocalization.workTypeArtist.tr,
      'value': 'Artis',
    },
    {
      'label': DigitalIdLocalization.workTypeOther.tr,
      'value': 'Lainnya',
    },
  ];

  List<Map<String, String>> companyList = [];

  List<Map<String, String>> idTypeList = [];

  List<Map<String, String>> simType = [
    {
      'label': 'SIM A',
      'value': 'A',
    },
    {
      'label': 'SIM C',
      'value': 'C',
    },
  ];

  List<Map<String, String>> passportType = [
    {
      'label': 'P',
      'value': 'P',
    },
  ];

  List<Map<String, String>> nationalityType = [
    {
      'label': 'WARGA NEGARA INDONESIA',
      'value': 'WNI',
    },
    {
      'label': 'WARGA NEGARA ASING',
      'value': 'WNA',
    },
  ];

  List<Map<String, String>> nationalityPassportType = [
    {
      'label': 'REPUBLIK INDONESIA',
      'value': 'REPUBLIK INDONESIA',
    },
    {
      'label': 'REPUBLIC OF CHINA',
      'value': 'REPUBLIC OF CHINA',
    },
    {
      'label': 'REPUBLIC OF SINGAPORE',
      'value': 'REPUBLIC OF SINGAPORE',
    },
  ];

  void dobValidate() {
    if (docBirthDate!.value.isEmpty) {
      validateBirthDate.value = true;
    } else {
      DateTime dateOfBirth = DateTime.parse(docBirthDate!.value);
      DateTime currentDate = DateTime.now();
      difference.value = currentDate.difference(dateOfBirth).inDays;
      if (difference.value < 6209) {
        validateBirthDate.value = true;
      } else {
        validateBirthDate.value = false;
      }
    }
    update();
  }

  void photoValidate() {
    if (photoFileUpload.value == '') {
      validateUploadImage.value = true;
    } else {
      validateUploadImage.value = false;
    }
    update();
  }

  void profilePhotoValidate() {
    if (profileFileUpload.value == '') {
      validateProfileUploadImage.value = true;
    } else {
      validateProfileUploadImage.value = false;
    }
    update();
  }

  void onChangePhoto(FileUploadResult? data) {
    if (data != null) {
      photoFileUpload.value = data.base64Value!;
      tempFileUpload = data;
      if (documentLength.value < reqDocLength.value) {
        documentLength.value++;
      }
    } else {
      photoFileUpload.value = '';
      tempFileUpload = null;
    }
    update();
  }

  void onProfileChange(FileUploadResult? data) {
    if (data != null) {
      profileFileUpload.value = data.base64Value!;
      businessProfilePict = data;
      if (documentLength.value < reqDocLength.value) {
        documentLength.value++;
      }
    } else {
      profileFileUpload.value = '';
      businessProfilePict = null;
    }
    update();
  }

  void genderValidate() {
    if (docGender!.value.isEmpty) {
      validateGender.value = true;
    } else {
      validateGender.value = false;
    }
    update();
  }

  void expireValidate() {
    if (docExpireType!.value.isEmpty) {
      validateExpire.value = true;
    } else if (docExpireType!.value == describeEnum(ExpireType.livetime)) {
      validateExpire.value = false;
    } else {
      if (docExpire!.value.length == 0) {
        validateExpire.value = true;
      } else {
        validateExpire.value = false;
      }
    }
    update();
  }

  void issuerDateValidate() {
    if (docIssuerDate!.value.length == 0) {
      validateIssuerDate.value = true;
    } else {
      validateIssuerDate.value = false;
    }
    update();
  }

  void locationValidate(RxString field, RxBool status) {
    if (field.value == '') {
      status.value = true;
    } else {
      status.value = false;
    }
    update();
  }

  void clearForm() {
    debugPrint('clearing form....');
    docNik.value = '';
    docNo.value = '';
    docName.value = '';
    docCompanyName.value = '';
    docPosition.value = '';
    docPhoneNumber.value = '';
    docCompanyPhone.value = '';
    docCompanyEmail.value = '';
    docCompanyAddress.value = '';
    docCompanyWebsite.value = '';
    docBirthPlace.value = '';
    docBirthDate!.value = '';
    docGender!.value = '';
    docBloodType!.value = '';
    docAddress.value = '';
    docRt.value = '';
    docRw.value = '';
    docSubDistrict.value = '';
    docDistrict.value = '';
    docCity.value = '';
    docProvince.value = '';
    docReligion!.value = '';
    docMaritalStatus!.value = '';
    docProfession!.value = '';
    docImage.value = '';
    photoFileUpload.value = '';
    profileFileUpload.value = '';
    documentLength.value = 0;
    reqDocLength.value = 0;
    ocrImage = null;
    docExpireType!.value = '';
    docExpire!.value = '';
    tempFileUpload = null;
    businessProfilePict = null;
    // provinceList.value = [];
    provinceController.value.text = '';
    // cityList.value = [];
    cityController.value.text = '';
    // districtList.value = [];
    districtController.value.text = '';
    // subDistrictList.value = [];
    subDistrictController.value.text = '';
    simTypeCode.value = '';
    passportTypeCode.value = '';
    docBirthDateController.value.text = '';
    docRegistrationNo.value = '';
    docNationalityCode.value = '';
  }

  Future<bool> onWillpop() async {
    if (formStep.value == 2) {
      formStep.value--;
    } else {
      return true;
    }
    return false;
  }

  // Future<void> getProvinceList({String? query}) async {
  //   setBusy();

  //   var request = ProvinceListReq(page: '1', limit: '100', search: query);

  //   final response = await _repo.getProvinceList(request);
  //   if (response.statusCode == 200 && response.message == 'Success') {
  //     provinceList.value = response.data;
  //   }

  //   setIdle();
  // }

  // Future<void> getCityList({String? query, String? provID}) async {
  //   setBusy();

  //   var request = CityListReq(
  //     page: '1',
  //     provId: provID,
  //     limit: '1000',
  //     search: query,
  //   );

  //   final response = await _repo.getCityList(request);
  //   if (response.statusCode == 200 && response.message == 'Success') {
  //     cityList.value = response.data;
  //   }

  //   setIdle();
  // }

  // Future<void> getDistrictList({String? query, String? cityID}) async {
  //   setBusy();

  //   var request = DistrictListReq(
  //     page: '1',
  //     cityId: cityID,
  //     limit: '1000',
  //     search: query,
  //   );

  //   final response = await _repo.getDistrictList(request);
  //   if (response.statusCode == 200 && response.message == 'Success') {
  //     districtList.value = response.data;
  //   }

  //   setIdle();
  // }

  // Future<void> getSubDistrictList({String? query, String? districtID}) async {
  //   setBusy();

  //   var request = SubDistrictListReq(
  //     page: '1',
  //     districtId: districtID,
  //     limit: '1000',
  //     search: query,
  //   );

  //   final response = await _repo.getSubDistrictList(request);
  //   if (response.statusCode == 200 && response.message == 'Success') {
  //     subDistrictList.value = response.data;
  //   }

  //   setIdle();
  // }

  // void onProvinceSelected(ProvinceData? val) {
  //   cityList.value = [];
  //   docCity.value = '';
  //   cityController.value.text = '';
  //   districtList.value = [];
  //   docDistrict.value = '';
  //   districtController.value.text = '';
  //   subDistrictList.value = [];
  //   docSubDistrict.value = '';
  //   subDistrictController.value.text = '';
  //   provinceController.value.text = val!.provinceName!;
  //   docProvince.value = val.provinceName!;
  //   provinceId.value = val.provinceId!;
  //   getCityList(provID: val.provinceId!);
  // }

  // Future<List<ProvinceData>> onProvinceSuggestionsCallback(String pattern) async {
  //   docProvince.value = '';
  //   if (provinceList.isEmpty || provinceList.length == 1) {
  //     await getProvinceList();
  //   }
  //   var result = provinceList.where((e) => e.provinceName!.toUpperCase().contains(pattern.toUpperCase())).toList();

  //   return result;
  // }

  // void onCitySelected(CityData? val) {
  //   districtList.value = [];
  //   docDistrict.value = '';
  //   districtController.value.text = '';
  //   subDistrictList.value = [];
  //   docSubDistrict.value = '';
  //   subDistrictController.value.text = '';
  //   cityController.value.text = val!.cityName!;
  //   docCity.value = val.cityName!;
  //   cityId.value = val.cityId!;
  //   getDistrictList(cityID: val.cityId!);
  // }

  // Future<List<CityData>> onCitySuggestionsCallback(String pattern) async {
  //   docCity.value = '';
  //   if (cityList.isEmpty || cityList.length == 1) {
  //     await getCityList(provID: provinceId.value != '' ? provinceId.value : null);
  //   }
  //   var result = cityList.where((e) => e.cityName!.toUpperCase().contains(pattern.toUpperCase())).toList();
  //   return result;
  // }

  // void onDistrictSelected(DistrictData? val) {
  //   subDistrictList.value = [];
  //   docSubDistrict.value = '';
  //   subDistrictController.value.text = '';
  //   districtController.value.text = val!.districtName!;
  //   docDistrict.value = val.districtName!;
  //   districtId.value = val.districtId!;
  //   getSubDistrictList(districtID: val.districtId!);
  // }

  // Future<List<DistrictData>> onDistrictSuggestionsCallback(String pattern) async {
  //   docDistrict.value = '';
  //   if (districtList.isEmpty || districtList.length == 1) {
  //     await getDistrictList(cityID: cityId.value != '' ? cityId.value : null);
  //   }
  //   var result = districtList.where((e) => e.districtName!.toUpperCase().contains(pattern.toUpperCase())).toList();
  //   return result;
  // }

  // void onSubDistrictSelected(SubDistrictData? val) {
  //   subDistrictController.value.text = val!.subDistrictName!;
  //   docSubDistrict.value = val.subDistrictName!;
  //   subDistrictId.value = val.subDistrictId!;
  // }

  // Future<List<SubDistrictData>> onSubDistrictSuggestionsCallback(String pattern) async {
  //   docSubDistrict.value = '';
  //   if (subDistrictList.isEmpty || subDistrictList.length == 1) {
  //     await getSubDistrictList(districtID: districtId.value != '' ? districtId.value : null);
  //   }
  //   var result = subDistrictList.where((e) => e.subDistrictName!.toUpperCase().contains(pattern.toUpperCase())).toList();
  //   return result;
  // }
}

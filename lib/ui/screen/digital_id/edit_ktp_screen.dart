// TEMP NOT USED

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/regex_rule.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/digital_id/date_picker_field.dart';
import 'package:inisa_app/ui/widget/digital_id/dropdown_search.dart';
import 'package:inisa_app/ui/widget/digital_id/labeled_radio_widget.dart';
import 'package:inisa_app/ui/widget/main_textfield.dart';
import 'package:inisa_app/ui/widget/more_field.dart';
import 'package:qoin_sdk/models/qoin_digitalid/document_user_data.dart';
import 'package:qoin_sdk/models/qoin_digitalid/location_resp.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditKTPScreen extends StatelessWidget {
  final DocumentUserData? data;
  EditKTPScreen({Key? key, this.data}) : super(key: key);

  final provinceController = TextEditingController().obs;
  final cityController = TextEditingController().obs;
  final districtController = TextEditingController().obs;
  final subDistrictController = TextEditingController().obs;
  final genderRadioGroup = "gender";

  @override
  Widget build(BuildContext context) {
    // var registerController =
    //     Get.isRegistered<RegisterDigitalIdController>()
    //         ? Get.find<RegisterDigitalIdController>()
    //         : Get.put(RegisterDigitalIdController());

    provinceController.value.text = data?.docIssuer != ''
        ? data!.docIssuer!.split(',').first.replaceFirst('PROVINSI ', '')
        : '';
    cityController.value.text = data?.docIssuer != '' ? data!.docIssuer!.split(',').last : '';
    districtController.value.text =
        data?.docDetails?.docKecamatan != '' ? data!.docDetails!.docKecamatan! : '';
    subDistrictController.value.text =
        data?.docDetails?.docKelDesa != '' ? data!.docDetails!.docKelDesa! : '';
    // viewController.docGender!.value =
    //     data?.docGender != '' ? data?.docGender!.toLowerCase() : '';

    var profesiHelper = ParameterDigidConst.workList
        .any((element) => element['value']?.toUpperCase() == data?.docProfession?.toUpperCase());

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Lihat Data',
        onBack: () async {
          // bool willPop = await viewController.onWillpop();

          // if (willPop) {
          //   Get.back();
          // }
        },
        actions: [
          // !viewController.editingStatus.value
          //     ? IconButton(
          //         icon: Icon(
          //           Icons.edit,
          //           color: Color(0xff111111),
          //         ),
          //         onPressed: () {
          //           viewController.editingStatus.value = !viewController.editingStatus.value;
          //           viewController.update();
          //         },
          //       )
          //     : SizedBox()
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.05,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              // key: controller.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MainTextField(
                    enabled: false,
                    initialValue: data?.nIK,
                    labelText: 'NIK',
                    hintText: 'Masukkan NIK',
                    textInputType: TextInputType.number,
                    maxLength: 16,
                    validation: [
                      RegexRule.emptyValidationRule,
                      RegexRule.nikValidationRule,
                      RegexRule.numberValidationRule,
                    ],
                    onAction: TextInputAction.next,
                    suffixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Image.asset(
                        Assets.iconSuccess,
                        width: 24,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  MainTextField(
                    enabled: false,
                    initialValue: data?.docName,
                    // onChange: (val) {
                    //   controller.docName.value = val;
                    // },
                    labelText: 'Nama Lengkap',
                    hintText: 'Masukkan nama lengkap',
                    textInputType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    validation: [RegexRule.emptyValidationRule],
                    onAction: TextInputAction.next,
                  ),
                  SizedBox(height: 10),
                  MainTextField(
                    enabled: false,
                    initialValue: data?.docPoB,
                    // onChange: (val) {
                    //   controller.docBirthPlace.value = val;
                    // },
                    labelText: 'Tempat Lahir',
                    hintText: 'Masukkan tempat lahir',
                    textInputType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    validation: [RegexRule.emptyValidationRule],
                    onAction: TextInputAction.next,
                  ),
                  SizedBox(height: 10),
                  data?.docDoB!.substring(0, 10) == '0001-01-01'
                      ? DatePickerField(
                          enabled: false,
                          dateFormat: 'dd-MM-yyyy',
                          labelText: 'Tanggal Lahir',
                          minTime: DateTime.tryParse("1940-01-01"),
                          // errorText: controller.validateBirthDate.value == false
                          //     ? null
                          //     : controller.difference.value == 0
                          //         ? DigitalIdLocalization.messageRequired.tr
                          //         : DigitalIdLocalization.messageAgeValidation.tr,
                          hintText: 'Masukkan tanggal lahir',
                          // onPicked: (date) async {
                          //   controller.docBirthDate?.value = date.toFormatsString(format: 'yyyy-MM-dd');
                          //   controller.dobValidate();
                          //   controller.update();
                          // },
                          initialValue: null,
                        )
                      : DatePickerField(
                          enabled: false,
                          dateFormat: 'dd-MM-yyyy',
                          labelText: 'Tanggal Lahir',
                          minTime: DateTime.tryParse("1940-01-01"),
                          // errorText: controller.validateBirthDate.value == false
                          //     ? null
                          //     : controller.difference.value == 0
                          //         ? DigitalIdLocalization.messageRequired.tr
                          //         : DigitalIdLocalization.messageAgeValidation.tr,
                          hintText: 'Masukkan tanggal lahir',
                          // onPicked: (date) async {
                          //   controller.docBirthDate?.value = date.toFormatsString(format: 'yyyy-MM-dd');
                          //   controller.dobValidate();
                          //   controller.update();
                          // },
                          initialValue: data?.docDoB != ''
                              ? DateTime.tryParse(data!.docDoB!.substring(0, 10))
                              : null,
                        ),
                  SizedBox(height: 10),
                  Text("Jenis Kelamin"),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: LabeledRadio<String>(
                          value: describeEnum(GenderType.male),
                          groupValue: data?.docGender?.toLowerCase(),
                          title: Text("Laki-Laki", style: TextUI.bodyTextBlack),
                          onChanged: (String? val) {
                            // viewController.docGender!.value = val!;
                          },
                          activeColor: Color(0xff111111),
                          contentPadding: EdgeInsets.zero,
                          toggleable: true,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: LabeledRadio<String>(
                          value: describeEnum(GenderType.female),
                          groupValue: data?.docGender?.toLowerCase(),
                          title: Text("Perempuan", style: TextUI.bodyTextBlack),
                          onChanged: (String? val) {
                            // viewController.docGender!.value = val!;
                          },
                          activeColor: Color(0xff111111),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  data?.docBlood != null && data?.docBlood != ''
                      ? MoreField(
                          labelText: DigitalIdLocalization.formKTPBloodType.tr,
                          value: data?.docBlood?.toUpperCase(),
                          hint: Text(
                            DigitalIdLocalization.hintformKTPBloodType.tr,
                            style: TextUI.placeHolderBlack,
                          ),
                          validator: (val) {
                            if (val == null) {
                              return DigitalIdLocalization.messageRequired.tr;
                            }
                          },
                          items: ParameterDigidConst.bloodType
                              .map((e) => DropdownMenuItem(
                                    child: Text(
                                      e['label']!,
                                      style: TextUI.bodyTextBlack,
                                    ),
                                    value: e['value'],
                                  ))
                              .toList(),
                          onChanged:
                              /* viewController.editingStatus.value == false
                                  ? null
                                  : */
                              null,
                        )
                      : MoreField(
                          labelText: DigitalIdLocalization.formKTPBloodType.tr,
                          hint: Text(
                            DigitalIdLocalization.hintformKTPBloodType.tr,
                            style: TextUI.placeHolderBlack,
                          ),
                          validator: (val) {
                            if (val == null) {
                              return DigitalIdLocalization.messageRequired.tr;
                            }
                          },
                          items: ParameterDigidConst.bloodType
                              .map((e) => DropdownMenuItem(
                                    child: Text(
                                      e['label']!,
                                      style: TextUI.bodyTextBlack,
                                    ),
                                    value: e['value'],
                                  ))
                              .toList(),
                          onChanged:
                              /* viewController.editingStatus.value == false
                                  ? null
                                  : */
                              null,
                        ),
                  SizedBox(height: 10),
                  MainTextField(
                    enabled: false,
                    initialValue: data?.docAddress,
                    // onChange: (val) {
                    //   controller.docAddress.value = val;
                    // },
                    labelText: DigitalIdLocalization.formKTPAddress.tr,
                    hintText: DigitalIdLocalization.hintformKTPAddress.tr,
                    textInputType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    validation: [RegexRule.emptyValidationRule],
                    onAction: TextInputAction.next,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainTextField(
                              enabled: false,
                              initialValue: data?.docDetails?.docRtRw != null &&
                                      data?.docDetails?.docRtRw != ''
                                  ? data?.docDetails!.docRtRw!.split('/').first
                                  : null,
                              onChange: (val) {},
                              labelText: DigitalIdLocalization.formKTPRt.tr,
                              hintText: DigitalIdLocalization.hintformKTPRt.tr,
                              textInputType: TextInputType.number,
                              maxLength: 3,
                              validation: [
                                RegexRule.emptyValidationRule,
                                RegexRule.numberValidationRule,
                              ],
                              onAction: TextInputAction.next,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainTextField(
                              enabled: false,
                              initialValue: data?.docDetails?.docRtRw != null &&
                                      data?.docDetails?.docRtRw != ''
                                  ? data?.docDetails!.docRtRw!.split('/').last
                                  : null,
                              onChange: (val) {},
                              labelText: DigitalIdLocalization.formKTPRw.tr,
                              hintText: DigitalIdLocalization.hintformKTPRw.tr,
                              textInputType: TextInputType.number,
                              maxLength: 3,
                              validation: [
                                RegexRule.emptyValidationRule,
                                RegexRule.numberValidationRule,
                              ],
                              onAction: TextInputAction.next,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    DigitalIdLocalization.formKTPProvince.tr,
                    style: TextUI.bodyTextBlack,
                  ),
                  SizedBox(height: 10),
                  DropdownSearchWidget<ProvinceData?>(
                    enabled: false,
                    controller: provinceController.value,
                    hintText: 'Pilih Provinsi',
                    // errorText: viewController.errorProvince?.value,
                    noItemsFoundBuilder: (_) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: /* viewController.loadingStatus.value
                            ? Center(
                                child: CircularProgressIndicator(
                                    backgroundColor: Get.theme.colorScheme.primary))
                            :  */
                            Text(
                          'Tidak ditemukan untuk ${provinceController.value.text}...',
                          style: TextUI.placeHolderBlack,
                        ),
                      );
                    },
                    itemBuilder: (context, val) {
                      return ListTile(
                        title: Text(
                          val!.provinceName!,
                          style: TextUI.bodyTextBlack,
                        ),
                      );
                    },
                    onSuggestionSelected: (val) {
                      // viewController
                      //   .onLocationSelected<ProvinceData>(value: val)
                    },
                    suggestionsCallback: (pattern) {
                      return [];
                      // viewController
                      //   .onLocationSuggestionsCallback<ProvinceData>(pattern)
                    },
                    errorBuilder: (_, __) => Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Provinsi tidak ditemukan',
                        style: TextUI.placeHolderBlack,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    DigitalIdLocalization.formKTPCity.tr,
                    style: TextUI.bodyTextBlack,
                  ),
                  SizedBox(height: 10),
                  DropdownSearchWidget<CityData?>(
                    enabled: false,
                    controller: cityController.value,
                    hintText: 'Pilih Kota/Kabupaten',
                    // errorText: viewController.errorCity?.value,
                    noItemsFoundBuilder: (_) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: /* viewController.loadingStatus.value
                            ? Center(
                                child: CircularProgressIndicator(
                                    backgroundColor: Get.theme.colorScheme.primary))
                            :  */
                            Text(
                          'Tidak ditemukan untuk ${cityController.value.text}...',
                          style: TextUI.placeHolderBlack,
                        ),
                      );
                    },
                    itemBuilder: (context, val) {
                      return ListTile(
                        title: Text(
                          val!.cityName!,
                          style: TextUI.bodyTextBlack,
                        ),
                      );
                    },
                    onSuggestionSelected: (val) {
                      // viewController
                      //   .onLocationSelected<CityData>(value: val)
                    },
                    suggestionsCallback: (pattern) {
                      return [];
                      // viewController
                      //   .onLocationSuggestionsCallback<CityData>(pattern)
                    },
                    errorBuilder: (_, __) => Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Kota/Kabupaten tidak ditemukan',
                        style: TextUI.placeHolderBlack,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    DigitalIdLocalization.formKTPDistrict.tr,
                    style: TextUI.bodyTextBlack,
                  ),
                  SizedBox(height: 10),
                  DropdownSearchWidget<DistrictData?>(
                    enabled: false,
                    controller: districtController.value,
                    hintText: 'Pilih Kecamatan',
                    // errorText: viewController.errorDistrict?.value,
                    noItemsFoundBuilder: (_) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: /* viewController.loadingStatus.value
                              ? Center(
                                  child: CircularProgressIndicator(
                                      backgroundColor:
                                          Get.theme.colorScheme.primary))
                              : */
                            Text(
                          'Tidak ditemukan untuk ${districtController.value.text}...',
                          style: TextUI.placeHolderBlack,
                        ),
                      );
                    },
                    itemBuilder: (context, val) {
                      return ListTile(
                        title: Text(
                          val!.districtName!,
                          style: TextUI.bodyTextBlack,
                        ),
                      );
                    },
                    onSuggestionSelected: (val) {
                      // viewController
                      //   .onLocationSelected<DistrictData>(value: val)
                    },
                    suggestionsCallback: (pattern) {
                      return [];
                      // viewController.onLocationSuggestionsCallback<
                      //     DistrictData>(pattern);
                    },
                    errorBuilder: (_, __) => Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Kecamatan tidak ditemukan',
                        style: TextUI.placeHolderBlack,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    DigitalIdLocalization.formKTPSubDistrict.tr,
                    style: TextUI.bodyTextBlack,
                  ),
                  SizedBox(height: 10),
                  DropdownSearchWidget<SubDistrictData?>(
                    enabled: false,
                    controller: subDistrictController.value,
                    hintText: 'Pilih Kelurahan/Desa',
                    // errorText: viewController.errorSubDistrict?.value,
                    noItemsFoundBuilder: (_) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: /* viewController.loadingStatus.value
                              ? Center(
                                  child: CircularProgressIndicator(
                                      backgroundColor:
                                          Get.theme.colorScheme.primary))
                              : */
                            Text(
                          'Tidak ditemukan untuk ${subDistrictController.value.text}...',
                          style: TextUI.placeHolderBlack,
                        ),
                      );
                    },
                    itemBuilder: (context, val) {
                      return ListTile(
                        title: Text(
                          val!.subDistrictName!,
                          style: TextUI.bodyTextBlack,
                        ),
                      );
                    },
                    onSuggestionSelected: (val) {
                      // viewController
                      //   .onLocationSelected<SubDistrictData>(value: val)
                    },
                    suggestionsCallback: (pattern) {
                      return [];
                      // viewController
                      //   .onLocationSuggestionsCallback<SubDistrictData>(
                      //       pattern)
                    },
                    errorBuilder: (_, __) => Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Kelurahan/Desa tidak ditemukan',
                        style: TextUI.placeHolderBlack,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  data?.docReligion != ''
                      ? MoreField(
                          labelText: 'Agama',
                          hint: Text(
                            'Pilih agama',
                            style: TextUI.placeHolderBlack,
                          ),
                          value: data?.docReligion,
                          validator: (val) {
                            if (val == null) {
                              return DigitalIdLocalization.messageRequired.tr;
                            }
                          },
                          items: ParameterDigidConst.religionType
                              .map((e) => DropdownMenuItem(
                                    child: Text(
                                      e['label']!,
                                      style: TextUI.bodyTextBlack,
                                    ),
                                    value: e['value'],
                                  ))
                              .toList(),
                          onChanged:
                              /* viewController.editingStatus.value == false
                                  ? null
                                  : */
                              null,
                        )
                      : MoreField(
                          labelText: 'Agama',
                          hint: Text(
                            'Pilih agama',
                            style: TextUI.placeHolderBlack,
                          ),
                          validator: (val) {
                            if (val == null) {
                              return DigitalIdLocalization.messageRequired.tr;
                            }
                          },
                          items: ParameterDigidConst.religionType
                              .map((e) => DropdownMenuItem(
                                    child: Text(
                                      e['label']!,
                                      style: TextUI.bodyTextBlack,
                                    ),
                                    value: e['value'],
                                  ))
                              .toList(),
                          onChanged:
                              /*  viewController.editingStatus.value == false
                                  ? null
                                  : */
                              null,
                        ),
                  SizedBox(height: 10),
                  data?.docMarital != ''
                      ? MoreField(
                          labelText: 'Status Perkawinan',
                          hint: Text(
                            'Pilih status perkawinan',
                            style: TextUI.placeHolderBlack,
                          ),
                          value: data?.docMarital,
                          validator: (val) {
                            if (val == null) {
                              return DigitalIdLocalization.messageRequired.tr;
                            }
                          },
                          items: ParameterDigidConst.maritalType
                              .map((e) => DropdownMenuItem(
                                    child: Text(
                                      e['label']!,
                                      style: TextUI.bodyTextBlack,
                                    ),
                                    value: e['value'],
                                  ))
                              .toList(),
                          onChanged:
                              /* viewController.editingStatus.value == false
                                  ? null
                                  : */
                              null,
                        )
                      : MoreField(
                          labelText: 'Status Perkawinan',
                          hint: Text(
                            'Pilih status perkawinan',
                            style: TextUI.placeHolderBlack,
                          ),
                          validator: (val) {
                            if (val == null) {
                              return DigitalIdLocalization.messageRequired.tr;
                            }
                          },
                          items: ParameterDigidConst.maritalType
                              .map((e) => DropdownMenuItem(
                                    child: Text(
                                      e['label']!,
                                      style: TextUI.bodyTextBlack,
                                    ),
                                    value: e['value'],
                                  ))
                              .toList(),
                          onChanged:
                              /* viewController.editingStatus.value == false
                                  ? null
                                  : */
                              null,
                        ),
                  SizedBox(height: 10),
                  data?.docProfession != null && data?.docProfession != '' && profesiHelper
                      ? MoreField(
                          labelText: 'Pekerjaan',
                          hint: Text(
                            'Pilih pekerjaan',
                            style: TextUI.placeHolderBlack,
                          ),
                          value: data?.docProfession,
                          validator: (val) {
                            if (val == null) {
                              return DigitalIdLocalization.messageRequired.tr;
                            }
                          },
                          items: ParameterDigidConst.workList
                              .map((e) => DropdownMenuItem(
                                    child: Text(
                                      e['label']!,
                                      style: TextUI.bodyTextBlack,
                                    ),
                                    value: e['value'],
                                  ))
                              .toList(),
                          onChanged:
                              /* viewController.editingStatus.value == false
                                  ? null
                                  : */
                              null,
                        )
                      : MoreField(
                          labelText: 'Pekerjaan',
                          hint: Text(
                            'Pilih pekerjaan',
                            style: TextUI.placeHolderBlack,
                          ),
                          validator: (val) {
                            if (val == null) {
                              return DigitalIdLocalization.messageRequired.tr;
                            }
                          },
                          items: ParameterDigidConst.workList
                              .map((e) => DropdownMenuItem(
                                    child: Text(
                                      e['label']!,
                                      style: TextUI.bodyTextBlack,
                                    ),
                                    value: e['value'],
                                  ))
                              .toList(),
                          onChanged:
                              /* viewController.editingStatus.value == false
                                  ? null
                                  : */
                              null,
                        ),
                  SizedBox(height: 10),
                  data?.docNationality != null && data?.docNationality != ''
                      ? MoreField(
                          labelText: 'Kewarganegaraan',
                          hint: Text(
                            'Pilih kewarganegaraan',
                            style: TextUI.bodyTextBlack,
                          ),
                          value: data?.docNationality,
                          validator: (val) {
                            if (val == null) {
                              return DigitalIdLocalization.messageRequired.tr;
                            }
                          },
                          items: ParameterDigidConst.nationalityType
                              .map((e) => DropdownMenuItem(
                                    child: Text(
                                      e['label']!,
                                      style: TextUI.bodyTextBlack,
                                    ),
                                    value: e['value'],
                                  ))
                              .toList(),
                          onChanged:
                              /* viewController.editingStatus.value == false
                                  ? null
                                  : */
                              null,
                        )
                      : MoreField(
                          labelText: 'Kewarganegaraan',
                          hint: Text(
                            'Pilih kewarganegaraan',
                            style: TextUI.placeHolderBlack,
                          ),
                          validator: (val) {
                            if (val == null) {
                              return DigitalIdLocalization.messageRequired.tr;
                            }
                          },
                          items: ParameterDigidConst.nationalityType
                              .map((e) => DropdownMenuItem(
                                    child: Text(
                                      e['label']!,
                                      style: TextUI.bodyTextBlack,
                                    ),
                                    value: e['value'],
                                  ))
                              .toList(),
                          onChanged:
                              /* viewController.editingStatus.value == false
                                  ? null
                                  : */
                              null,
                        ),
                  SizedBox(height: 10),
                  (data?.docExpired != null && data?.docExpired != '')
                      ? data?.docExpired?.substring(0, 10) == '2050-12-31'
                          ? DatePickerField(
                              enabled: false,
                              dateFormat: 'dd-MM-yyyy',
                              labelText: 'Berlaku Hingga',
                              // errorText: controller.validateExpire.value == false ? null : DigitalIdLocalization.messageRequired.tr,
                              hintText: 'SEUMUR HIDUP',
                              onPicked: (date) async {},
                              initialValue: null,
                            )
                          : DatePickerField(
                              enabled: false,
                              dateFormat: 'dd-MM-yyyy',
                              labelText: 'Berlaku Hingga',
                              // errorText: controller.validateExpire.value == false ? null : DigitalIdLocalization.messageRequired.tr,
                              hintText: 'Pilih tanggal masa berlaku',
                              onPicked: (date) async {},
                              initialValue: /* data?.docExpired != ''
                                ? DateFormat("yyyy-MM-dd")
                                    .parse(data!.docExpired!.substring(0, 10))
                                : */
                                  null,
                            )
                      : DatePickerField(
                          enabled: false,
                          dateFormat: 'dd-MM-yyyy',
                          labelText: 'Berlaku Hingga',
                          // errorText: controller.validateExpire.value == false ? null : DigitalIdLocalization.messageRequired.tr,
                          hintText: 'SEUMUR HIDUP',
                          onPicked: (date) async {},
                          initialValue: null,
                        ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(),
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     boxShadow: [
      //       BoxShadow(
      //         color: Color(0x80cacccf),
      //         offset: Offset(0, -1),
      //         blurRadius: 4,
      //         spreadRadius: 0,
      //       ),
      //     ],
      //     color: Colors.white,
      //   ),
      //   child: Padding(
      //     padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
      //     child: MainButton(
      //       text: 'Simpan Data',
      //       onPressed: () async {
      //         // FocusScope.of(context).requestFocus(FocusNode());

      //         // viewController.editingStatus.value =
      //         //     !viewController.editingStatus.value;
      //         // viewController.update();
      //       },
      //     ),
      //   ),
      // ),
    );
  }
}

class ParameterDigidConst {

  static List<Map<String, dynamic>> cardColor = [
    {'label': 'Black', 'value': 0},
    {'label': 'Yellow', 'value': 1},
    {'label': 'Blue', 'value': 2},
  ];
  
  static List<Map<String, String>> genderType = [
    {
      'label': DigitalIdLocalization.registerGenderTypeMale.tr,
      'value': 'male',
    },
    {
      'label': DigitalIdLocalization.registerGenderTypeFemale.tr,
      'value': 'female',
    },
  ];

  static List<Map<String, String>> bloodType = [
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

  static List<Map<String, String>> religionType = [
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

  static List<Map<String, String>> maritalType = [
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

  static List<Map<String, String>> workList = [
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

  static List<Map<String, String>> companyList = [];

  static List<Map<String, String>> idTypeList = [];

  static List<Map<String, String>> simType = [
    {
      'label': 'SIM A',
      'value': 'A',
    },
    {
      'label': 'SIM C',
      'value': 'C',
    },
  ];

  static List<Map<String, String>> passportType = [
    {
      'label': 'P',
      'value': 'P',
    },
  ];

  static List<Map<String, String>> nationalityType = [
    {
      'label': 'WARGA NEGARA INDONESIA',
      'value': 'WNI',
    },
    {
      'label': 'WARGA NEGARA ASING',
      'value': 'WNA',
    },
  ];
}

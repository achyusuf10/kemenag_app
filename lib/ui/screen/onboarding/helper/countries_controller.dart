import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

import 'package:inisa_app/helper/constans.dart';

class CountriesController extends GetxController {
  static CountriesController get to => Get.find();

  List<Country> _data = [];
  List<Country> _searchResult = [];

  List<Country> get data => _data;
  set data(List<Country> value) {
    _data = value;
    update();
  }

  List<Country> get searchResult => _searchResult;
  set searchResult(List<Country> value) {
    _searchResult = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();

    loaddata();
  }

  void loaddata() {
    data = Constans.dataFlags;
    data = data.map((v) {
      Country model = v;
      String tag = model.name!.substring(0, 1).toUpperCase();
      if (RegExp("[A-Z]").hasMatch(tag)) {
        model.tagIndex = tag;
      } else {
        model.tagIndex = "#";
      }
      return model;
    }).toList();
    _handleList(data);
  }

  void search(String keyword, {bool reset = false, bool useMe = true}) async {
    List<Country> _helper = data.where((v) {
      return v.name!.toLowerCase().contains(keyword.toLowerCase()) ||
          v.countryCode!.toLowerCase().contains(keyword.toLowerCase());
    }).toList();
    _handleList(_helper);
    update();
  }

  void _handleList(List<Country>? list) {
    searchResult = list ?? [];

    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(searchResult);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(searchResult);
  }
}

class Country with ISuspensionBean {
  String? name;
  String? image;
  String? countryCode;
  String? tagIndex;

  Country({this.name, this.image, this.countryCode, this.tagIndex});

  @override
  String getSuspensionTag() {
    return tagIndex!;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'countryCode': countryCode,
      'tagIndex': tagIndex,
    };
  }

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      name: map['name'],
      image: map['image'],
      countryCode: map['countryCode'],
      tagIndex: map['tagIndex'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Country.fromJson(String source) => Country.fromMap(json.decode(source));
}

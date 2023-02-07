import 'dart:convert';

class SaveCustomerIdModel {
  int? idService;
  List<String>? customerId;
  // List<int> idData;
  // String idPel1;
  // String idPel2;
  // String idPel3;
  // int tabIndex;

  SaveCustomerIdModel({
    this.idService,
    this.customerId,
    // this.idData,
    // this.idPel1,
    // this.idPel2,
    // this.idPel3,
    // this.tabIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'idService': idService,
      'customerId': customerId,
      // 'idData': idData,
      // 'idPel1': idPel1,
      // 'idPel2': idPel2,
      // 'idPel3': idPel3,
      // 'tabIndex': tabIndex,
    };
  }

  factory SaveCustomerIdModel.fromMap(Map<String, dynamic> map) {
    return SaveCustomerIdModel(
      idService: map['idService'],
      customerId: List<String>.from(map['customerId']),
      // idData: List<int>.from(map['idData']),
      // idPel1: map['idPel1'],
      // idPel2: map['idPel2'],
      // idPel3: map['idPel3'],
      // tabIndex: map['tabIndex'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SaveCustomerIdModel.fromJson(String source) =>
      SaveCustomerIdModel.fromMap(json.decode(source));
}

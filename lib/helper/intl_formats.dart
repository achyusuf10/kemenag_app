import 'package:flutter/material.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

extension IntlFormatsDouble on double {
  String get formatCurrency {
    return this.formatCurrencyRp.substring(2);
  }

  String get formatCurrencyRp {
    return NumberFormat.simpleCurrency(locale: "in_ID", decimalDigits: 0)
        .format(this);
  }
}

extension TextExtension on String {
  String get capitalizeFirstofEach {
    List<String> temp = this.split(' ');

    List<String> res = [];
    temp.forEach((element) {
      res.add(
        '${element[0].toUpperCase()}${element.substring(1).toLowerCase()}',
      );
    });
    return '${res.join(' ')}';
  }
}

extension InitialExtension on String {
  String get initialWords {
    List<String> temp = this.split(' ');
    debugPrint("$temp");
    List<String> res = [];

    temp.forEach((element) {
      if (res.length < 2) {
        res.add(
          '${element[0].toUpperCase()}',
        );
      }
    });
    return '${res.join('')}';
  }
}

extension NameExtension on String {
  String get firstName {
    var temp = this;
    var name;

    if (temp.length != 0) {
      name = temp.split(' ');
      if (name.length >= 1) {
        name = name.first;
      } else {
        name = temp;
      }
    } else {
      name = '-';
    }
    return name;
  }

  String get lastName {
    var temp = this;
    var name;

    if (temp.length != 0) {
      name = temp.split(' ');
      if (name.length >= 2) {
        name = name.last;
      } else {
        name = '';
      }
    } else {
      name = '';
    }
    return name;
  }
}

/// Convert [DateTime] to Indonesia specific date
extension FormatDateTime on String {
  String get datetimeFormat {
    DateTime tempDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(this);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${tempDate.day} ${_convertToLocalMonth(tempDate.month)} ${tempDate.year} ${twoDigits(tempDate.hour)}:${twoDigits(tempDate.minute)}";
  }

  String get dateFormat {
    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(this);
    return "${tempDate.day} ${_convertToLocalMonth(tempDate.month)} ${tempDate.year}";
  }
}

List _longMonth = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember'
];

String _convertToLocalMonth(int month) {
  return _longMonth[month - 1];
}

String convertMonth(String key) {
  String month = '';
  if (key == "01") {
    month = "JAN";
  } else if (key == "02") {
    month = "FEB";
  } else if (key == "03") {
    month = "MAR";
  } else if (key == "04") {
    month = "APR";
  } else if (key == "05") {
    month = "MAY";
  } else if (key == "06") {
    month = "JUN";
  } else if (key == "07") {
    month = "JUL";
  } else if (key == "08") {
    month = "AUG";
  } else if (key == "09") {
    month = "SEP";
  } else if (key == "10") {
    month = "OCT";
  } else if (key == "11") {
    month = "NOV";
  } else if (key == "12") {
    month = "DEC";
  } else {
    month = "";
  }
  return month;
}

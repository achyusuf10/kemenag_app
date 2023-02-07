
class Doc /* extends DocumentUserData */ {
  String? docAddress;
  String? docIssuer;
  String? docGender;

  Doc({this.docAddress, this.docIssuer, this.docGender});

  String get address {
    if (this.docAddress == null || this.docAddress == '-') {
      return '-';
    }
    var temp = this.docAddress!.split(', ');
    return temp.first;
  }

  String? get rt {
    if (this.docAddress == null || this.docAddress == '-') {
      return '-';
    }
    var temp = this.docAddress!.split(', ');
    var temp2 = temp[1].replaceFirst('RT/RW ', '');
    var value = temp2.split('/');
    return value.first;
  }

  String? get rw {
    if (this.docAddress == null || this.docAddress == '-') {
      return '-';
    }
    var temp = this.docAddress!.split(', ');
    var temp2 = temp[1].replaceFirst('RT/RW ', '');
    var value = temp2.split('/');
    return value.last;
  }

  String get subDistrict {
    if (this.docAddress == null || this.docAddress == '-') {
      return '-';
    }
    var temp = this.docAddress!.split(', ');
    var value = temp[2].replaceFirst('Kel/Desa ', '');
    return value;
  }

  String get district {
    if (this.docAddress == null || this.docAddress == '-') {
      return '-';
    }
    var temp = this.docAddress!.split(', ');
    var value = temp[3].replaceAll('Kecamatan ', '');
    return value;
  }

  String get city {
    if (this.docIssuer == null || this.docIssuer == '-') {
      return '-';
    }
    var city = docIssuer!.split(', ');
    return city.last;
  }

  String get province {
    if (this.docIssuer == null || this.docIssuer == '-') {
      return '-';
    }
    var prov = docIssuer!.split(', ');
    return prov.first;
  }

  String get genderTranslate {
    switch (docGender!.toLowerCase()) {
      case 'male':
        return 'LAKI-LAKI';
      case 'female':
        return 'PEREMPUAN';
      default:
        return '';
    }
  }
}

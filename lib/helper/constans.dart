import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/ui/screen/onboarding/helper/countries_controller.dart';
import 'package:qoin_sdk/helpers/services/environment.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'assets.dart';

class Constans {
  static String appVersion = '-';
  static String csPhoneNumber = "+62 811-9349-088"; // 628119349088

  static List<List<String>> onboarding = [
    [
      Assets.animationNew1,
      Localization.onboarding1Title,
      Localization.onboarding1Description,
    ],
    [
      Assets.animationNew2,
      Localization.onboarding2Title,
      Localization.onboarding2Description,
    ],
    [
      Assets.animationNew3,
      Localization.onboarding3Title,
      Localization.onboarding3Description,
    ],
    [
      Assets.animationNew4,
      Localization.onboarding4Title,
      Localization.onboarding4Description,
    ],
    [
      Assets.animationNew5,
      Localization.onboarding5Title,
      Localization.onboarding5Description,
    ],
  ];

  static List<String> demoPhoneNumbers = [
    "628119152600",
    "6285604154335",
    "6285749322633",
    "628983997958",
  ];
  static String serverTimeLocation = 'Asia/Jakarta';
  static String serverTimeStringAddition = '.000+0700';

  static String getStringENV() {
    if (EnvironmentConfig.flavor == Flavor.Development) {
      return "dev-";
    } else if (EnvironmentConfig.flavor == Flavor.Staging) {
      return "qa-";
    } else {
      return "";
    }
  }

  static List<Country> get dataFlags {
    return flags.map((e) => Country.fromMap(e)).toList();
  }

  static List<Map<String, dynamic>> flags = [
    {
      "countryCode": "1",
      "image": "assets/images/flags/canada.png",
      "name": "Canada"
    },
    {
      "countryCode": "1",
      "image": "assets/images/flags/united-states.png",
      "name": "United States"
    },
    {
      "countryCode": "7",
      "image": "assets/images/flags/kazakhstan.png",
      "name": "Kazakhstan"
    },
    {
      "countryCode": "7",
      "image": "assets/images/flags/russia.png",
      "name": "Russia"
    },
    {
      "countryCode": "20",
      "image": "assets/images/flags/egypt.png",
      "name": "Egypt"
    },
    {
      "countryCode": "27",
      "image": "assets/images/flags/south-africa.png",
      "name": "South Africa"
    },
    {
      "countryCode": "30",
      "image": "assets/images/flags/greece.png",
      "name": "Greece"
    },
    {
      "countryCode": "31",
      "image": "assets/images/flags/netherlands.png",
      "name": "Netherlands"
    },
    {
      "countryCode": "32",
      "image": "assets/images/flags/belgium.png",
      "name": "Belgium"
    },
    {
      "countryCode": "33",
      "image": "assets/images/flags/france.png",
      "name": "France"
    },
    {
      "countryCode": "34",
      "image": "assets/images/flags/spain.png",
      "name": "Spain"
    },
    {
      "countryCode": "36",
      "image": "assets/images/flags/hungary.png",
      "name": "Hungary"
    },
    {
      "countryCode": "39",
      "image": "assets/images/flags/italy.png",
      "name": "Italy"
    },
    {
      "countryCode": "40",
      "image": "assets/images/flags/romania.png",
      "name": "Romania"
    },
    {
      "countryCode": "41",
      "image": "assets/images/flags/switzerland.png",
      "name": "Switzerland"
    },
    {
      "countryCode": "43",
      "image": "assets/images/flags/austria.png",
      "name": "Austria"
    },
    {
      "countryCode": "44",
      "image": "assets/images/flags/united-kingdom.png",
      "name": "United Kingdom"
    },
    {
      "countryCode": "45",
      "image": "assets/images/flags/denmark.png",
      "name": "Denmark"
    },
    {
      "countryCode": "46",
      "image": "assets/images/flags/sweden.png",
      "name": "Sweden"
    },
    {
      "countryCode": "47",
      "image": "assets/images/flags/norway.png",
      "name": "Norway"
    },
    {
      "countryCode": "48",
      "image": "assets/images/flags/poland.png",
      "name": "Poland"
    },
    {
      "countryCode": "49",
      "image": "assets/images/flags/germany.png",
      "name": "Germany"
    },
    {
      "countryCode": "51",
      "image": "assets/images/flags/peru.png",
      "name": "Peru"
    },
    {
      "countryCode": "52",
      "image": "assets/images/flags/mexico.png",
      "name": "Mexico"
    },
    {
      "countryCode": "53",
      "image": "assets/images/flags/cuba.png",
      "name": "Cuba"
    },
    {
      "countryCode": "54",
      "image": "assets/images/flags/argentina.png",
      "name": "Argentina"
    },
    {
      "countryCode": "55",
      "image": "assets/images/flags/brazil.png",
      "name": "Brazil"
    },
    {
      "countryCode": "56",
      "image": "assets/images/flags/chile.png",
      "name": "Chile"
    },
    {
      "countryCode": "57",
      "image": "assets/images/flags/colombia.png",
      "name": "Colombia"
    },
    {
      "countryCode": "58",
      "image": "assets/images/flags/venezuela.png",
      "name": "Venezuela"
    },
    {
      "countryCode": "60",
      "image": "assets/images/flags/malaysia.png",
      "name": "Malaysia"
    },
    {
      "countryCode": "61",
      "image": "assets/images/flags/australia.png",
      "name": "Australia"
    },
    {
      "countryCode": "62",
      "image": "assets/images/flags/indonesia.png",
      "name": "Indonesia"
    },
    {
      "countryCode": "63",
      "image": "assets/images/flags/philippines.png",
      "name": "Philippines"
    },
    {
      "countryCode": "64",
      "image": "assets/images/flags/new-zealand.png",
      "name": "New Zealand"
    },
    {
      "countryCode": "65",
      "image": "assets/images/flags/singapore.png",
      "name": "Singapore"
    },
    {
      "countryCode": "66",
      "image": "assets/images/flags/thailand.png",
      "name": "Thailand"
    },
    {
      "countryCode": "81",
      "image": "assets/images/flags/japan.png",
      "name": "Japan"
    },
    {
      "countryCode": "82",
      "image": "assets/images/flags/south-korea.png",
      "name": "South Korea"
    },
    {
      "countryCode": "84",
      "image": "assets/images/flags/vietnam.png",
      "name": "Vietnam"
    },
    {
      "countryCode": "86",
      "image": "assets/images/flags/china.png",
      "name": "China"
    },
    {
      "countryCode": "90",
      "image": "assets/images/flags/turkey.png",
      "name": "Turkey"
    },
    {
      "countryCode": "91",
      "image": "assets/images/flags/india.png",
      "name": "India"
    },
    {
      "countryCode": "92",
      "image": "assets/images/flags/pakistan.png",
      "name": "Pakistan"
    },
    {
      "countryCode": "93",
      "image": "assets/images/flags/afghanistan.png",
      "name": "Afghanistan"
    },
    {
      "countryCode": "94",
      "image": "assets/images/flags/sri-lanka.png",
      "name": "Sri Lanka"
    },
    {
      "countryCode": "95",
      "image": "assets/images/flags/myanmar.png",
      "name": "Myanmar"
    },
    {
      "countryCode": "98",
      "image": "assets/images/flags/iran.png",
      "name": "Iran"
    },
    {
      "countryCode": "212",
      "image": "assets/images/flags/morocco.png",
      "name": "Morocco"
    },
    {
      "countryCode": "213",
      "image": "assets/images/flags/algeria.png",
      "name": "Algeria"
    },
    {
      "countryCode": "216",
      "image": "assets/images/flags/tunisia.png",
      "name": "Tunisia"
    },
    {
      "countryCode": "218",
      "image": "assets/images/flags/libya.png",
      "name": "Libya"
    },
    {
      "countryCode": "220",
      "image": "assets/images/flags/gambia.png",
      "name": "Gambia"
    },
    {
      "countryCode": "221",
      "image": "assets/images/flags/senegal.png",
      "name": "Senegal"
    },
    {
      "countryCode": "222",
      "image": "assets/images/flags/mauritania.png",
      "name": "Mauritania"
    },
    {
      "countryCode": "223",
      "image": "assets/images/flags/mali.png",
      "name": "Mali"
    },
    {
      "countryCode": "224",
      "image": "assets/images/flags/guinea.png",
      "name": "Guinea"
    },
    // {"countryCode": "225", "image": "assets/images/flags/", "name": "Cote D'Ivoire"},
    {
      "countryCode": "226",
      "image": "assets/images/flags/burkina-faso.png",
      "name": "Burkina Faso"
    },
    {
      "countryCode": "227",
      "image": "assets/images/flags/niger.png",
      "name": "Niger"
    },
    {
      "countryCode": "228",
      "image": "assets/images/flags/togo.png",
      "name": "Togo"
    },
    {
      "countryCode": "229",
      "image": "assets/images/flags/benin.png",
      "name": "Benin"
    },
    {
      "countryCode": "230",
      "image": "assets/images/flags/mauritius.png",
      "name": "Mauritius"
    },
    {
      "countryCode": "231",
      "image": "assets/images/flags/liberia.png",
      "name": "Liberia"
    },
    {
      "countryCode": "232",
      "image": "assets/images/flags/sierra-leone.png",
      "name": "Sierra Leone"
    },
    {
      "countryCode": "233",
      "image": "assets/images/flags/ghana.png",
      "name": "Ghana"
    },
    {
      "countryCode": "234",
      "image": "assets/images/flags/nigeria.png",
      "name": "Nigeria"
    },
    {
      "countryCode": "235",
      "image": "assets/images/flags/chad.png",
      "name": "Chad"
    },
    {
      "countryCode": "237",
      "image": "assets/images/flags/cameroon.png",
      "name": "Cameroon"
    },
    {
      "countryCode": "238",
      "image": "assets/images/flags/cape-verde.png",
      "name": "Cape Verde"
    },
    {
      "countryCode": "239",
      "image": "assets/images/flags/sao-tome-and-prince.png",
      "name": "São Tomé and Príncipe"
    },
    {
      "countryCode": "241",
      "image": "assets/images/flags/gabon.png",
      "name": "Gabon"
    },
    // {"countryCode": "242", "image": "assets/images/flags/", "name": "Congo - Brazzaville"},
    {
      "countryCode": "242",
      "image": "assets/images/flags/republic-of-the-congo.png",
      "name": "Congo, Republic of the"
    },
    // {"countryCode": "243", "image": "assets/images/flags/", "name": "Congo - Kinshasa"},
    {
      "countryCode": "243",
      "image": "assets/images/flags/democratic-republic-of-congo.png",
      "name": "Congo, Democratic Republic of the"
    },
    {
      "countryCode": "244",
      "image": "assets/images/flags/angola.png",
      "name": "Angola"
    },
    {
      "countryCode": "245",
      "image": "assets/images/flags/guinea-bissau.png",
      "name": "Guinea-Bissau"
    },
    {
      "countryCode": "248",
      "image": "assets/images/flags/seychelles.png",
      "name": "Seychelles"
    },
    {
      "countryCode": "249",
      "image": "assets/images/flags/sudan.png",
      "name": "Sudan"
    },
    {
      "countryCode": "250",
      "image": "assets/images/flags/rwanda.png",
      "name": "Rwanda"
    },
    {
      "countryCode": "252",
      "image": "assets/images/flags/somalia.png",
      "name": "Somalia"
    },
    {
      "countryCode": "253",
      "image": "assets/images/flags/djibouti.png",
      "name": "Djibouti"
    },
    {
      "countryCode": "254",
      "image": "assets/images/flags/kenya.png",
      "name": "Kenya"
    },
    {
      "countryCode": "255",
      "image": "assets/images/flags/tanzania.png",
      "name": "Tanzania"
    },
    {
      "countryCode": "256",
      "image": "assets/images/flags/uganda.png",
      "name": "Uganda"
    },
    {
      "countryCode": "258",
      "image": "assets/images/flags/mozambique.png",
      "name": "Mozambique"
    },
    {
      "countryCode": "260",
      "image": "assets/images/flags/zambia.png",
      "name": "Zambia"
    },
    {
      "countryCode": "261",
      "image": "assets/images/flags/madagascar.png",
      "name": "Madagascar"
    },
    {
      "countryCode": "263",
      "image": "assets/images/flags/zimbabwe.png",
      "name": "Zimbabwe"
    },
    {
      "countryCode": "264",
      "image": "assets/images/flags/namibia.png",
      "name": "Namibia"
    },
    {
      "countryCode": "265",
      "image": "assets/images/flags/malawi.png",
      "name": "Malawi"
    },
    // {"countryCode": "267", "image": "assets/images/flags/", "name": "Botswana"},
    // {"countryCode": "268", "image": "assets/images/flags/", "name": "Eswatini"},
    {
      "countryCode": "269",
      "image": "assets/images/flags/comoros.png",
      "name": "Comoros"
    },
    {
      "countryCode": "291",
      "image": "assets/images/flags/eritrea.png",
      "name": "Eritrea"
    },
    {
      "countryCode": "297",
      "image": "assets/images/flags/aruba.png",
      "name": "Aruba"
    },
    {
      "countryCode": "350",
      "image": "assets/images/flags/gibraltar.png",
      "name": "Gibraltar"
    },
    {
      "countryCode": "351",
      "image": "assets/images/flags/portugal.png",
      "name": "Portugal"
    },
    {
      "countryCode": "352",
      "image": "assets/images/flags/luxembourg.png",
      "name": "Luxembourg"
    },
    {
      "countryCode": "353",
      "image": "assets/images/flags/ireland.png",
      "name": "Ireland"
    },
    {
      "countryCode": "354",
      "image": "assets/images/flags/iceland.png",
      "name": "Iceland"
    },
    {
      "countryCode": "355",
      "image": "assets/images/flags/albania.png",
      "name": "Albania"
    },
    {
      "countryCode": "356",
      "image": "assets/images/flags/malta.png",
      "name": "Malta"
    },
    {
      "countryCode": "357",
      "image": "assets/images/flags/cyprus.png",
      "name": "Cyprus"
    },
    {
      "countryCode": "358",
      "image": "assets/images/flags/finland.png",
      "name": "Finland"
    },
    {
      "countryCode": "359",
      "image": "assets/images/flags/bulgaria.png",
      "name": "Bulgaria"
    },
    {
      "countryCode": "370",
      "image": "assets/images/flags/lithuania.png",
      "name": "Lithuania"
    },
    {
      "countryCode": "371",
      "image": "assets/images/flags/latvia.png",
      "name": "Latvia"
    },
    {
      "countryCode": "372",
      "image": "assets/images/flags/estonia.png",
      "name": "Estonia"
    },
    {
      "countryCode": "373",
      "image": "assets/images/flags/moldova.png",
      "name": "Moldova"
    },
    {
      "countryCode": "374",
      "image": "assets/images/flags/armenia.png",
      "name": "Armenia"
    },
    {
      "countryCode": "375",
      "image": "assets/images/flags/belarus.png",
      "name": "Belarus"
    },
    {
      "countryCode": "377",
      "image": "assets/images/flags/monaco.png",
      "name": "Monaco"
    },
    {
      "countryCode": "378",
      "image": "assets/images/flags/san-marino.png",
      "name": "San Marino"
    },
    {
      "countryCode": "379",
      "image": "assets/images/flags/vatican-city.png",
      "name": "Vatican City"
    },
    {
      "countryCode": "380",
      "image": "assets/images/flags/ukraine.png",
      "name": "Ukraine"
    },
    {
      "countryCode": "381",
      "image": "assets/images/flags/serbia.png",
      "name": "Serbia"
    },
    {
      "countryCode": "382",
      "image": "assets/images/flags/montenegro.png",
      "name": "Montenegro"
    },
    {
      "countryCode": "383",
      "image": "assets/images/flags/kosovo.png",
      "name": "Kosovo"
    },
    {
      "countryCode": "385",
      "image": "assets/images/flags/croatia.png",
      "name": "Croatia"
    },
    {
      "countryCode": "386",
      "image": "assets/images/flags/slovenia.png",
      "name": "Slovenia"
    },
    {
      "countryCode": "387",
      "image": "assets/images/flags/bosnia-and-herzegovina.png",
      "name": "Bosnia and Herzegovina"
    },
    {
      "countryCode": "389",
      "image": "assets/images/flags/republic-of-macedonia.png",
      "name": "North Macedonia"
    },
    {
      "countryCode": "420",
      "image": "assets/images/flags/czech-republic.png",
      "name": "Czech Republic"
    },
    {
      "countryCode": "421",
      "image": "assets/images/flags/slovakia.png",
      "name": "Slovakia"
    },
    // {"countryCode": "423", "image": "assets/images/flags/", "name": "Liechtenstein"},
    {
      "countryCode": "501",
      "image": "assets/images/flags/belize.png",
      "name": "Belize"
    },
    {
      "countryCode": "502",
      "image": "assets/images/flags/guatemala.png",
      "name": "Guatemala"
    },
    {
      "countryCode": "503",
      "image": "assets/images/flags/el-salvador.png",
      "name": "El Salvador"
    },
    {
      "countryCode": "504",
      "image": "assets/images/flags/honduras.png",
      "name": "Honduras"
    },
    {
      "countryCode": "505",
      "image": "assets/images/flags/nicaragua.png",
      "name": "Nicaragua"
    },
    {
      "countryCode": "506",
      "image": "assets/images/flags/costa-rica.png",
      "name": "Costa Rica"
    },
    {
      "countryCode": "507",
      "image": "assets/images/flags/panama.png",
      "name": "Panama"
    },
    {
      "countryCode": "509",
      "image": "assets/images/flags/haiti.png",
      "name": "Haiti"
    },
    {
      "countryCode": "591",
      "image": "assets/images/flags/bolivia.png",
      "name": "Bolivia"
    },
    // {"countryCode": "592", "image": "assets/images/flags/", "name": "Guyana"},
    {
      "countryCode": "593",
      "image": "assets/images/flags/ecuador.png",
      "name": "Ecuador"
    },
    {
      "countryCode": "595",
      "image": "assets/images/flags/paraguay.png",
      "name": "Paraguay"
    },
    {
      "countryCode": "597",
      "image": "assets/images/flags/suriname.png",
      "name": "Suriname"
    },
    {
      "countryCode": "598",
      "image": "assets/images/flags/uruguay.png",
      "name": "Uruguay"
    },
    {
      "countryCode": "599",
      "image": "assets/images/flags/curacao.png",
      "name": "Curaçao"
    },
    {
      "countryCode": "673",
      "image": "assets/images/flags/brunei.png",
      "name": "Brunei"
    },
    {
      "countryCode": "674",
      "image": "assets/images/flags/nauru.png",
      "name": "Nauru"
    },
    {
      "countryCode": "675",
      "image": "assets/images/flags/papua-new-guinea.png",
      "name": "Papua New Guinea"
    },
    {
      "countryCode": "676",
      "image": "assets/images/flags/tonga.png",
      "name": "Tonga"
    },
    {
      "countryCode": "677",
      "image": "assets/images/flags/solomon-islands.png",
      "name": "Solomon Islands"
    },
    {
      "countryCode": "678",
      "image": "assets/images/flags/vanuatu.png",
      "name": "Vanuatu"
    },
    {
      "countryCode": "679",
      "image": "assets/images/flags/fiji.png",
      "name": "Fiji"
    },
    {
      "countryCode": "680",
      "image": "assets/images/flags/palau.png",
      "name": "Palau"
    },
    {
      "countryCode": "685",
      "image": "assets/images/flags/samoa.png",
      "name": "Samoa"
    },
    {
      "countryCode": "691",
      "image": "assets/images/flags/micronesia.png",
      "name": "Micronesia"
    },
    {
      "countryCode": "852",
      "image": "assets/images/flags/hong-kong.png",
      "name": "Hong Kong"
    },
    {
      "countryCode": "853",
      "image": "assets/images/flags/macao.png",
      "name": "Macao"
    },
    {
      "countryCode": "855",
      "image": "assets/images/flags/cambodia.png",
      "name": "Cambodia"
    },
    {
      "countryCode": "856",
      "image": "assets/images/flags/laos.png",
      "name": "Laos"
    },
    {
      "countryCode": "880",
      "image": "assets/images/flags/bangladesh.png",
      "name": "Bangladesh"
    },
    {
      "countryCode": "886",
      "image": "assets/images/flags/taiwan.png",
      "name": "Taiwan"
    },
    {
      "countryCode": "960",
      "image": "assets/images/flags/maldives.png",
      "name": "Maldives"
    },
    {
      "countryCode": "961",
      "image": "assets/images/flags/lebanon.png",
      "name": "Lebanon"
    },
    {
      "countryCode": "962",
      "image": "assets/images/flags/jordan.png",
      "name": "Jordan"
    },
    {
      "countryCode": "964",
      "image": "assets/images/flags/iraq.png",
      "name": "Iraq"
    },
    {
      "countryCode": "965",
      "image": "assets/images/flags/kwait.png",
      "name": "Kuwait"
    },
    {
      "countryCode": "966",
      "image": "assets/images/flags/saudi-arabia.png",
      "name": "Saudi Arabia"
    },
    {
      "countryCode": "967",
      "image": "assets/images/flags/yemen.png",
      "name": "Yemen"
    },
    {
      "countryCode": "968",
      "image": "assets/images/flags/oman.png",
      "name": "Oman"
    },
    {
      "countryCode": "971",
      "image": "assets/images/flags/united-arab-emirates.png",
      "name": "United Arab Emirates"
    },
    {
      "countryCode": "972",
      "image": "assets/images/flags/israel.png",
      "name": "Israel"
    },
    {
      "countryCode": "973",
      "image": "assets/images/flags/bahrain.png",
      "name": "Bahrain"
    },
    {
      "countryCode": "974",
      "image": "assets/images/flags/qatar.png",
      "name": "Qatar"
    },
    {
      "countryCode": "975",
      "image": "assets/images/flags/bhutan.png",
      "name": "Bhutan"
    },
    {
      "countryCode": "976",
      "image": "assets/images/flags/mongolia.png",
      "name": "Mongolia"
    },
    {
      "countryCode": "977",
      "image": "assets/images/flags/nepal.png",
      "name": "Nepal"
    },
    {
      "countryCode": "992",
      "image": "assets/images/flags/tajikistan.png",
      "name": "Tajikistan"
    },
    {
      "countryCode": "993",
      "image": "assets/images/flags/turkmenistan.png",
      "name": "Turkmenistan"
    },
    {
      "countryCode": "994",
      "image": "assets/images/flags/azerbaijan.png",
      "name": "Azerbaijan"
    },
    {
      "countryCode": "995",
      "image": "assets/images/flags/georgia.png",
      "name": "Georgia"
    },
    {
      "countryCode": "996",
      "image": "assets/images/flags/kyrgyzstan.png",
      "name": "Kyrgyzstan"
    },
    {
      "countryCode": "998",
      "image": "assets/images/flags/uzbekistan.png",
      "name": "Uzbekistan"
    },
    {
      "countryCode": "1-242",
      "image": "assets/images/flags/bahamas.png",
      "name": "Bahamas"
    },
    {
      "countryCode": "1-246",
      "image": "assets/images/flags/barbados.png",
      "name": "Barbados"
    },
    {
      "countryCode": "1-264",
      "image": "assets/images/flags/anguilla.png",
      "name": "Anguilla"
    },
    {
      "countryCode": "1-268",
      "image": "assets/images/flags/antigua-and-barbuda.png",
      "name": "Antigua and Barbuda"
    },
    {
      "countryCode": "1-284",
      "image": "assets/images/flags/british-virgin-islands.png",
      "name": "British Virgin Islands"
    },
    {
      "countryCode": "1-345",
      "image": "assets/images/flags/cayman-islands.png",
      "name": "Cayman Islands"
    },
    {
      "countryCode": "1-441",
      "image": "assets/images/flags/bermuda.png",
      "name": "Bermuda"
    },
    {
      "countryCode": "1-473",
      "image": "assets/images/flags/grenada.png",
      "name": "Grenada"
    },
    {
      "countryCode": "1-649",
      "image": "assets/images/flags/turks-and-caicos.png",
      "name": "Turks & Caicos Islands"
    },
    {
      "countryCode": "1-664",
      "image": "assets/images/flags/montserrat.png",
      "name": "Montserrat"
    },
    {
      "countryCode": "1-758",
      "image": "assets/images/flags/st-lucia.png",
      "name": "St. Lucia"
    },
    {
      "countryCode": "1-767",
      "image": "assets/images/flags/dominica.png",
      "name": "Dominica"
    },
    {
      "countryCode": "1-784",
      "image": "assets/images/flags/st-vincent-and-the-grenadines.png",
      "name": "St. Vincent and the Grenadines"
    },
    {
      "countryCode": "1-809",
      "image": "assets/images/flags/dominican-republic.png",
      "name": "Dominican Republic"
    },
    {
      "countryCode": "1-868",
      "image": "assets/images/flags/trinidad-and-tobago.png",
      "name": "Trinidad & Tobago"
    },
    {
      "countryCode": "1-869",
      "image": "assets/images/flags/saint-kitts-and-nevis.png",
      "name": "St. Kitts and Nevis"
    },
    {
      "countryCode": "1-876",
      "image": "assets/images/flags/jamaica.png",
      "name": "Jamaica"
    }
  ];
}

class WebUrl {
  static bool isBackToApp(String urlChanges) {
    return urlChanges.contains("/backtoapps");
  }

  static String eci =
      "https://old.electronic-city.com/qoin/home/index/token/TSxTJFMsIyxTLFM4UywjLFQ5RjRULFYoUy1DNFQsUzBTOUY0WCwjPFAtUzlGLVMsUSxTLFMtIyxVLFM4Uwo1LVMsWCxTRFMsQyxQLFMoUywzLFAsUyRTLDMsVApgCg==";
}

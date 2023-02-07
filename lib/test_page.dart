// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:inisa_app/helper/intl_formats.dart';
// import 'package:face_sdk/face_sdk.dart';

// class TextPage extends StatefulWidget {
//   const TextPage({Key? key}) : super(key: key);

//   @override
//   _TextPageState createState() => _TextPageState();
// }

// class _TextPageState extends State<TextPage> {
//   @override
//   void initState() {
//     // var date = Utils.dateFormat.format(DateTime.now().toLocal());
//     // print('TANGGAL $date');
//     // try {
//     //   // final DateTime now = DateTime.now();
//     //   // final DateFormat formatter = DateFormat('YYYY-MM-DDThh:mm:ssTZD');
//     //   // final String formatted = formatter.format(now);
//     //   // print(formatted);
//     //   tz.initializeTimeZones();
//     //   String now = tz.TZDateTime.now(tz.getLocation('Africa/Abidjan')).toString();
//     //   String now2 = tz.TZDateTime.now(tz.getLocation('Africa/Abidjan')).toIso8601String();
//     //   String now3 = DateTime.now().toIso8601String();
//     //   print('1 formatted $now');
//     //   print('2 formatted $now2 $now3');
//     //   var dateHit = DateTime.tryParse(now);
//     //   print('3 formatted ${dateHit.toString()}');
//     //   var dateHit2 = DateTime.tryParse(now2);
//     //   print('4 formatted $dateHit2');
//     //   // string to date time
//     //   test();
//     // } catch (e) {
//     //   print('formatted error: $e');
//     // }
//     // print('FIRST NAME => ${"Lu'lu' Al-Maknun".firstName}');
//     // print('LAST NAME => ${"Lu'lu' Al-Maknun".lastName}');
//     // print('FIRST NAME => ${"Lu'lu' Al Maknun".firstName}');
//     // print('LAST NAME => ${"Lu'lu' Al Maknun".lastName}');
//     // print('FIRST NAME => ${"Lu'lu' Al Maknun ".firstName}');
//     // print('LAST NAME => ${"Lu'lu' Al Maknun ".lastName}');
//     // print('FIRST NAME => ${" ".firstName}');
//     // print('LAST NAME => ${" ".lastName}');
//     // print('FIRST NAME => ${"".firstName}');
//     // print('LAST NAME => ${"".lastName}');
//     // print('FIRST NAME => ${"".firstName}');
//     // print('LAST NAME => ${"".lastName}');
//     // print('FIRST NAME => ${"LULU".firstName}');
//     // print('LAST NAME => ${"LULU".lastName}');
//     // print('FIRST NAME => ${"LULU ".firstName}');
//     // print('LAST NAME => ${"LULU ".lastName}');
//     super.initState();
//   }

// //   test() async {
// //     final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
// //     print('6 formatted $currentTimeZone');
// //   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('TEST'),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(16.0),
//         child: Center(child: TextButton(onPressed: () {
//           FaceSDK.showLiveness(
//               motionCount: 1,
//               onSuccess: (res) {
//                 log("liveness success: $res");
//               },
//               onFailed: (error) {
//                 debugPrint("liveness error: $error");
//               },
//               // card: true
//             );
//         },
//         child: Text('TEXT', ),),),
//       ),
//     );
//   }
// }

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:encrypt/encrypt.dart';
// import 'package:flutter/services.dart';
// import 'package:inisa_app/ui/screen/payment/web_view_page.dart';
// import 'package:inisa_app/ui/widget/button_main.dart';
// import 'package:pointycastle/asymmetric/api.dart';
// import 'package:qoin_sdk/qoin_sdk.dart';

// class TestPage extends StatefulWidget {
//   @override
//   State<TestPage> createState() => _TestPageState();
// }

// class _TestPageState extends State<TestPage> {
//   var data;

//   @override
//   void initState() {
//     // var forDecode = "{\"Product\":\"TELKOMSEL 5000\",\"Amount\":10000,\"OrderNo\":\"QW12ER12\"}";
//     // log('TEST ENKRIPSI FOR DECODE ${jsonDecode(forDecode)}');

//     // data = {
//     //   "OrderNo": "1234",
//     //   "Amount": 6000,
//     //   "Description": [
//     //     {"Product": "telkomsel5", "Price": 6000},
//     //   ],
//     //   "UrlCallback": "http://test.com/"
//     // };

//     // log('TEST ENKRIPSI ${data.toString()}');

//     // encrypytRSA(jsonEncode(data));

//     super.initState();
//   }

//   // encrypytRSA(String data) async {
//   //   // final publicKey =
//   //   //     await parseKeyFromFile<RSAPublicKey>('assets/keys/qoin/public_key.txt');
//   //   // final privKey = await parseKeyFromFile<RSAPrivateKey>('test/private.pem');
//   //   var publicKeyString =
//   //       await rootBundle.loadString('assets/keys/qoin/public_key.txt');
//   //   log('TEST ENKRIPSI PUBLIC KEY STRING $publicKeyString');
//   //   final publicKey = RSAKeyParser().parse(publicKeyString) as RSAPublicKey;

//   //   final plainText = data;
//   //   final encrypter = Encrypter(RSA(publicKey: publicKey));

//   //   final encrypted = encrypter.encrypt(plainText);
//   //   // final decrypted = encrypter.decrypt(encrypted);

//   //   // print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
//   //   log('TEST ENKRIPSI CHIPER BASE64: ${encrypted.base64}');
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           child: MainButton(
//             text: 'LIVENESS',
//             onPressed: () {
//               Get.to(()=> WebViewPage(url: '', title: 'Qoin Crypto',));
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:coding_buddy/coding_buddy.dart';
// import 'package:qoin_widgets/qoin_widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:qoin_services/helper/app_theme.dart';
// import 'package:qoin_services/helper/screen_utils.dart';
// import 'package:qoin_services/qoin_services.dart';
// import 'package:qoin_services/helper/assets.dart';
// import 'package:qoin_services/z_services/payment/controllers/payment_controller.dart';

// class PaprikaActivationPage extends StatelessWidget {
//   const PaprikaActivationPage({key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ModalProgress(
//       loadingStatus: PaymentController.paprika.loadingStatus.stream,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             QoinServicesLocalization.servicePaprikaActivationTitle.tr,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.w900,
//             ),
//           ),
//           titleSpacing: 0,
//           leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back_ios,
//               color: Colors.white,
//             ),
//             onPressed: () => Get.back(result: false),
//           ),
//           backgroundColor: Colors.transparent,
//         ),
//         extendBodyBehindAppBar: true,
//         body: Column(
//           children: [
//             Image(
//               image: AssetImage(paprikaActivationPage, package: QoinServices.packageName),
//               width: percentWidth(context, 100),
//               fit: BoxFit.fitWidth,
//             ),
//             SizedBox(
//               height: percentWidth(context, 5),
//             ),
//             Text(
//               QoinServicesLocalization.servicePaprikaLetsActive.tr,
//               style: TextStyle(
//                 color: Color(0xff3f4144),
//                 fontSize: 26,
//                 fontWeight: FontWeight.w900,
//               ),
//             ),
//             SizedBox(
//               height: percentWidth(context, 5),
//             ),
//             Text(
//               QoinServicesLocalization.servicePaprikaByActivate.tr,
//               style: TextStyle(
//                 color: Color(0xff3f4144),
//                 fontSize: 16,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(
//               height: percentWidth(context, 5),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 50),
//               child: MaterialButton(
//                 color: AppTheme.accentColor,
//                 minWidth: double.infinity,
//                 onPressed: () {
//                   PaymentController.to.activatePaprika(onSuccess: () {
//                     Get.back(result: true);
//                   }, onFailed: () {
//                     Get.back(result: false);
//                   });
//                 },
//                 height: kBottomNavigationBarHeight,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
//                 child: Text(
//                   QoinServicesLocalization.servicePaprikaStartActive.tr,
//                   style: TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.w900, fontStyle: FontStyle.normal, fontSize: 18),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

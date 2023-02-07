import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/ui/screen/payment/web_view_page.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

class VoucherType {
  // Tour, FB, CarRental, Flight, Hotel
  static const int tourType = 1;
  static const int fAndBType = 2;
  static const int carRentalType = 3;
  static const int flightType = 4;
  static const int hotelType = 5;
}

class Design {
  static Color getBgColor(String? value) {
    String sColor = value != null && value != "" ? "ff$value" : "ff800080";
    int iColor = int.parse(sColor, radix: 16);
    return Color(iColor);
  }
}

class VoucherWidget extends StatelessWidget {
  // final int? voucherType;
  final qoin.VouchersData voucherData;

  const VoucherWidget({Key? key, required this.voucherData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        debugPrint("voucherData.voucherNumber: ${voucherData.voucherNumber}");
        if (voucherData.voucherNumber != null) {
          qoin.OtaController.to.openOtaVoucherDetails(
            voucherCode: voucherData.voucherNumber!,
            onSuccess: (url) {
              qoin.Get.to(() => WebViewPage(title: "E-Tiket", url: url!));
            },
            onFailed: (error) {},
          );
        } else {
          qoin.OtaController.to.openOtaTicketManifestDetail(
            ticketNumber: voucherData.ticketNumber!,
            onSuccess: (url) {
              qoin.Get.to(() => WebViewPage(title: "E-Ticket Digital SPB", url: url!));
            },
            onFailed: (error) {},
          );
        }
      },
      child: Container(
        width: 379.w,
        height: 233.17.w,
        margin: EdgeInsets.only(bottom: 8.w),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.voucherCard),
              fit: BoxFit.fill,
            ),
            color: Design.getBgColor(voucherData.color),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: <BoxShadow>[BoxShadow(color: Colors.black54, blurRadius: 3.0, offset: Offset(0.0, 0.75))]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(23, 35, 10, 23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        voucherData.ticketNumber != null ? 'Perjalanan' : (voucherData.packageType ?? '-'),
                        style: TextUI.labelBlack.copyWith(color: Color(0xffcc1d15), fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: 200.w,
                        child: Text(
                          voucherData.ticketNumber != null ? (voucherData.shipName ?? '-') : (voucherData.packageName ?? '-'),
                          maxLines: 2,
                          style: TextUI.header2Black.copyWith(fontSize: 24.sp, color: Color(0xfff4ba71)),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 43.w,
                        height: 3.h,
                        margin: EdgeInsets.only(bottom: 2.h),
                        decoration: BoxDecoration(color: Color(0xff3f4144), borderRadius: BorderRadius.all(Radius.circular(2))),
                      ),
                      Text((voucherData.voucherNumber != null ? voucherData.voucherNumber : voucherData.ticketNumber) ?? "",
                          style: GoogleFonts.manrope(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${QoinServicesLocalization.servicePaymentPeriods.tr}:', style: GoogleFonts.manrope(fontSize: 10.sp)),
                      Text('${voucherData.validFrom} - ${voucherData.validTo}', style: GoogleFonts.manrope(fontSize: 10.sp)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

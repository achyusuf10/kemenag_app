import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class PaymentMethodCardWidget extends StatelessWidget {
  final String? icon;
  final String title;
  final String? subTitle;
  final String? package;
  final Widget? trailing;

  final Function() onTap;
  const PaymentMethodCardWidget(
      {key,
      this.icon,
      required this.title,
      this.subTitle,
      this.package,
      this.trailing,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 10,
            color: Color(0xfff6f6f6),
          ),
        ),
      ),
      child: ListTile(
        onTap: () {
          onTap();
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Image.asset(
          icon ?? Assets.qoin,
          package: package ?? QoinSdk.packageName,
          height: 30,
          width: 30,
          // color: icon == paprikaIcon ? Colors.red : null,
        ),
        title: Text(
          "$title",
          style: GoogleFonts.manrope(
            color: Color(0xFF333333),
            fontStyle: FontStyle.normal,
            fontSize: 16.0,
          ),
        ),
        subtitle: subTitle != null
            ? Text(
                "$subTitle",
                style: GoogleFonts.manrope(
                  color: Color(0xff666666),
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0,
                ),
              )
            : null,
        trailing: trailing,
      ),
    );
  }
}

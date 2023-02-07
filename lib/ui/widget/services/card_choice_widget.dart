import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_text.dart';

class CardChoiceWidget extends StatelessWidget {
  final Function() onTap;
  final Color bgColor;
  final Color borderColor;
  final String? title;
  final String denom;
  final String? price;
  const CardChoiceWidget({
    key,
    required this.onTap,
    required this.bgColor,
    required this.borderColor,
    this.title,
    required this.denom,
    this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: borderColor, width: 1),
            color: bgColor,
            boxShadow: [
              BoxShadow(color: const Color(0x29111111), offset: Offset(0, 2), blurRadius: 10, spreadRadius: 0)
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: TextUI.bodyTextBlack,
                  textAlign: TextAlign.center,
                ),
              Text(
                denom,
                style: TextUI.titleBlack,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 4,
              ),
              if (price != null)
                Text(
                  price ?? "",
                  style: TextUI.buttonTextRed,
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

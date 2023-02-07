import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';

class MerchantItem extends StatelessWidget {
  final String merchant;
  final String location;

  const MerchantItem({
    Key? key,
    required this.merchant,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          image: AssetImage(Assets.qoinLogoOnly),
          height: 32,
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                merchant,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                location,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

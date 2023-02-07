import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:qoin_sdk/models/others/contact_data.dart';

class SelectedContactItem extends StatelessWidget {
  final ContactData contactData;
  final VoidCallback? onTap;

  SelectedContactItem({required this.contactData, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64.0,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 64.0,
              ),
              CircleAvatar(
                  radius: 24,
                  backgroundColor: contactData.color,
                  child: Text(contactData.initial, style: TextUI.title2White)),
              SizedBox(
                height: 4,
              ),
              Text(
                '${contactData.name}',
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          InkWell(
            onTap: onTap,
            child: Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.cancel,
                color: const Color(0xffd8d8d8),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

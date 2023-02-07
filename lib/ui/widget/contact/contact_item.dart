import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:qoin_sdk/models/others/contact_data.dart';

class ContactItem extends StatelessWidget {
  final ContactData contactData;
  Function(ContactData)? onTap;
  bool withRadio = false;
  final Decoration? decoration;

  ContactItem({required this.contactData, this.onTap, this.decoration});

  ContactItem.withRadio({required this.contactData, this.onTap, this.decoration})
      : withRadio = true;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap!(contactData);
      },
      leading: CircleAvatar(
        backgroundColor: contactData.color,
        child: Text(contactData.initial, style: TextUI.title2White),
        radius: 20,
      ),
      title: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${contactData.name}",
                      style: TextUI.subtitleBlack,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${contactData.phone}",
                      style: TextUI.bodyText2Grey,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              if (withRadio)
                Checkbox(
                  value: contactData.selected,
                  onChanged: (val) {
                    onTap!(contactData);
                  },
                  activeColor: ColorUI.yellow,
                )
            ],
          ),
          if (decoration == null)
            Divider(
              color: ColorUI.border,
              height: 1,
            )
        ],
      ),
    );
  }
}

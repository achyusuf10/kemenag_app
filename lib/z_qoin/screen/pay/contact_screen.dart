import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/contact/contact_widget.dart';
import 'package:qoin_sdk/models/others/contact_data.dart';

class ContactScreen extends StatefulWidget {
  final Function(ContactData)? onItemTap;
  const ContactScreen({key, this.onItemTap}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Kontak',
      ),
      body: Column(
        children: [
          ContactWidget(
            onItemTap: widget.onItemTap ??
                (val) {
                  String phoneNumber = val.phone
                      .replaceAll("+", "")
                      .replaceAll("-", "")
                      .replaceAll(" ", "");
                  if (phoneNumber.startsWith("62")) {
                    phoneNumber = "0" + phoneNumber.substring(2);
                  }
                  if (phoneNumber.startsWith("0")) {}
                },
          ),
        ],
      ),
    );
  }

  Widget getSusItem(BuildContext context, String tag, {double susHeight = 40}) {
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 25.0),
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: Text(
        '$tag',
        softWrap: false,
        style: TextUI.bodyText2Grey,
      ),
    );
  }
}

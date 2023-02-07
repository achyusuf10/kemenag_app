import 'package:flutter/material.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/contact/contact_widget.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.light(
        title: 'Kontak',
      ),
      body: Column(
        children: [
          ContactWidget.plain(onItemTap: (data) {
            Get.back(result: data);
          }),
        ],
      ),
    );
  }
}

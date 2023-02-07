import 'dart:math';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/ui/widget/contact/contact_loading.dart';
import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/wallet_localization.dart';
import 'package:inisa_app/ui/widget/search_textfield.dart';
import 'package:qoin_sdk/models/others/contact_data.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:inisa_app/helper/assets.dart';
// import 'package:inisa_app/logic/controller/contact_controller.dart';
import 'package:inisa_app/helper/ui_color.dart';

import '../button_main.dart';
import '../button_secondary.dart';
import '../main_textfield.dart';
import 'contact_item.dart';
import 'selected_contact_item.dart';

class ContactWidget extends StatefulWidget {
  final Function(ContactData data)? onItemTap;
  final Function(List<ContactData> data)? onChange;
  final Function(ContactData data)? onDataAdded;
  final List<ContactData> selectedContact;
  bool multi = false;
  bool plain = false;
  final String? hintText;
  final int? maxSelected;

  ContactWidget(
      {required this.onItemTap,
      this.hintText,
      this.selectedContact = const [],
      this.onChange,
      this.onDataAdded,
      this.maxSelected});

  ContactWidget.multi({
    required this.onChange,
    this.hintText,
    this.selectedContact = const [],
    this.maxSelected,
    this.onItemTap,
    this.onDataAdded,
  }) : multi = true;

  ContactWidget.plain(
      {required this.onItemTap,
      this.hintText,
      this.selectedContact = const [],
      this.onChange,
      this.onDataAdded,
      this.maxSelected})
      : plain = true;

  @override
  _ContactWidgetState createState() => _ContactWidgetState();
}

class _ContactWidgetState extends State<ContactWidget> {
  var controller = Get.put(ContactController(), permanent: true);
  var addContact = false;
  var textValue = ''.obs;
  late ContactData me;

  @override
  void initState() {
    super.initState();
    // Get.put(ContactController());
    me = ContactData(null, HiveData.userData?.fullname ?? HiveData.userData!.phone!, HiveData.userData!.phone!,
        InitialName.parseName(HiveData.userData?.fullname ?? HiveData.userData!.phone!),
        selected: true, color: Colors.purple, me: true);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      print('${ContactController.to.searchResult}');
      if (ContactController.to.datas.isNotEmpty) {
        print('data not null');
        if (widget.multi) {
          ContactController.to.searchContact('', reset: true, useMe: true);
          widget.selectedContact.add(me);
        } else {
          ContactController.to.searchContact('', reset: true);
        }
      }
    });
    if (ContactController.to.datas.isEmpty) {
      ContactController.to.fetchContact(saya: me);
      if (widget.multi) {
        widget.selectedContact.add(me);
      }
    }
    // else {
    //   WidgetsBinding.instance?.addPostFrameCallback((_) {
    //     if (widget.multi) widget.selectedContact.add(me);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: Stack(children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SearchTextField(
                        hint: widget.hintText ?? Localization.contactSearch.tr,
                        onChanged: (val) {
                          ContactController.to.searchContact(val);
                        },
                      ),
                    ),
                    if (!widget.plain)
                      Container(
                        margin: EdgeInsets.only(left: 16),
                        height: 40,
                        width: 40,
                        child: Material(
                          color: ColorUI.text_4,
                          child: IconButton(
                            onPressed: () {
                              addContact = true;
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
              Expanded(
                child: GetBuilder<ContactController>(
                  init: ContactController(),
                  builder: (controller) {
                    if (!controller.isLoading.value) {
                      if (controller.searchResult.isNotEmpty) {
                        return AzListView(
                          data: controller.searchResult,
                          itemCount: controller.searchResult.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (widget.multi &&
                                controller.searchResult[index].name == '-' &&
                                controller.searchResult[index].phone == '-' &&
                                index == 0)
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  widget.selectedContact.length != 0 && widget.multi
                                      ? SizedBox(
                                          height: 74,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: widget.selectedContact.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Padding(
                                                padding: EdgeInsets.only(right: 16.0, left: index == 0 ? 16.0 : 0),
                                                child: SelectedContactItem(
                                                  contactData: widget.selectedContact[index],
                                                  onTap: () {
                                                    int a = controller.datas.indexWhere((element) =>
                                                        element.phone == widget.selectedContact[index].phone &&
                                                        element.name == widget.selectedContact[index].name &&
                                                        element.me == widget.selectedContact[index].me);
                                                    print('INDEX FOUND $a');
                                                    controller.datas[a].selected = false;
                                                    widget.selectedContact
                                                        .removeWhere((item) => item == widget.selectedContact[index]);
                                                    if (widget.onChange != null) {
                                                      setState(() {});
                                                      widget.onChange!(widget.selectedContact);
                                                    }
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : SizedBox(),
                                  widget.selectedContact.length != 0
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 8,
                                            ),
                                            if (widget.maxSelected != null)
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${Localization.contactSendTo.tr} ${widget.selectedContact.length}/${widget.maxSelected}",
                                                    ),
                                                    InkResponse(
                                                      onTap: () {
                                                        widget.selectedContact.forEach((element) {
                                                          element.selected = false;
                                                        });
                                                        widget.selectedContact.clear();
                                                        setState(() {});
                                                      },
                                                      child: Text(
                                                        Localization.contactEmptyIt.tr,
                                                        style: TextUI.subtitleRed,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            Container(height: 12, decoration: new BoxDecoration(color: ColorUI.shape)),
                                          ],
                                        )
                                      : SizedBox(),
                                  if (controller.searchFav.isNotEmpty && !widget.plain)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                                      child: Text(Localization.contactFavList.tr),
                                    ),
                                  if (controller.searchFav.isNotEmpty && !widget.plain)
                                    ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: controller.searchFav.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return ContactItem.withRadio(
                                            contactData: controller.searchFav[index],
                                            onTap: (data) {
                                              if (data.selected == false) {
                                                data.selected = true;
                                                widget.selectedContact.add(data);
                                                if (widget.onChange != null) {
                                                  widget.onChange!(widget.selectedContact);
                                                }
                                                setState(() {});
                                              }
                                            },
                                          );
                                        }),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                                    child: Text(Localization.contactAll.tr),
                                  ),
                                ],
                              );
                            if (!widget.multi &&
                                controller.searchResult[index].name == '-' &&
                                controller.searchResult[index].phone == '-')
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (controller.searchFav.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                                      child: Text(Localization.contactFavList.tr),
                                    ),
                                  if (controller.searchFav.isNotEmpty)
                                    ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: controller.searchFav.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return ContactItem(
                                            contactData: controller.searchFav[index],
                                            onTap: (data) {
                                              if (widget.onItemTap != null) {
                                                widget.onItemTap!(data);
                                              }
                                            },
                                          );
                                        }),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                                    child: Align(alignment: Alignment.topLeft, child: Text(Localization.contactAll.tr)),
                                  ),
                                ],
                              );
                            if (widget.multi)
                              return ContactItem.withRadio(
                                contactData: controller.searchResult[index],
                                onTap: (data) {
                                  if (widget.maxSelected != null) {
                                    if (widget.selectedContact.length >= (widget.maxSelected as int)) {
                                      // Get.snackbar(
                                      //   'message',
                                      //   'message body',
                                      //   duration: Duration(seconds: 4),
                                      //   animationDuration:
                                      //       Duration(milliseconds: 800),
                                      //   snackPosition: SnackPosition.TOP,
                                      // );
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Container(
                                          width: double.infinity,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.warning_rounded,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 16.0,
                                              ),
                                              Expanded(
                                                child: Text(
                                                    '${Localization.contactWarning1.tr} ${widget.maxSelected} ${Localization.contactWarning2.tr}'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.red,
                                        margin: EdgeInsets.fromLTRB(
                                            16, 16, 16, (MediaQuery.of(context).size.height - (kToolbarHeight * 3))),
                                      ));
                                      return;
                                    }
                                  }
                                  if (data.selected == false) {
                                    data.selected = true;
                                    widget.selectedContact.add(controller.searchResult[index]);
                                    if (widget.onChange != null) {
                                      widget.onChange!(widget.selectedContact);
                                    }
                                    setState(() {});
                                  }
                                },
                              );
                            return ContactItem(
                              contactData: controller.searchResult[index],
                              onTap: (data) {
                                if (widget.onItemTap != null) {
                                  widget.onItemTap!(data);
                                }
                              },
                            );
                          },
                          susItemBuilder: (BuildContext context, int index) {
                            ContactData contactItem = controller.searchResult[index];
                            if (contactItem.tagIndex == "选") return Container();
                            return getSusItem(context, contactItem.getSuspensionTag());
                          },
                          indexBarData: [],
                        );
                      } else {
                        return Center(child: Text(Localization.contactNotFound.tr));
                      }
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ContactLoading(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          if (addContact)
            Container(
              color: Color(0xff66111111),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    color: ColorUI.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 65.h,
                        height: 5.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(2.5)), color: Color(0xffe8e8e8)),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        Localization.contactAdd.tr,
                        style: TextUI.subtitleBlack,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        Localization.contactInputHint.tr,
                        style: TextUI.bodyTextBlack,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      MainTextField(
                          initialValue: '',
                          hintText: WalletLocalization.transferLabelPhoneTag.tr,
                          onChange: (value) => textValue.value = value),
                      SizedBox(
                        height: 32,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SecondaryButton(
                              text: Localization.contactCancel.tr,
                              onPressed: () {
                                addContact = false;
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: MainButton(
                                text: Localization.contactAdded.tr,
                                onPressed: () async {
                                  // await ContactsService.addContact(Contact(
                                  //     phones: [
                                  //       Item(
                                  //           label: "mobile",
                                  //           value: textValue.value)
                                  //     ],
                                  //     familyName: textValue.value,
                                  //     givenName: textValue.value));
                                  ContactData newData = new ContactData(null, textValue.value, textValue.value, '0',
                                      selected: true,
                                      color: Colors.primaries[Random().nextInt(Colors.primaries.length)]);
                                  if (widget.multi) {
                                    ContactController.to.updateContact(newData);
                                    widget.selectedContact.add(newData);
                                    addContact = false;
                                    setState(() {});
                                    if (widget.onChange != null) {
                                      widget.onChange!(widget.selectedContact);
                                    }
                                  } else {
                                    addContact = false;
                                    if (widget.onItemTap != null) {
                                      widget.onItemTap!(newData);
                                    }
                                  }
                                }),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
        ]),
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

import 'dart:convert';

import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/ui/widget/services/textfield_widget.dart';

import 'widget_menu/controller/menu_services_controller.dart';
import 'widget_menu/menu_services_widget.dart';
import 'widget_menu/models/service_data_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QoinServicesPage extends StatelessWidget {
  const QoinServicesPage({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (MenuServicesController.to.isEditFavorite) {
          return _popUpConfirmationFavorite();
        } else {
          if (MenuServicesController.to.isSearching) {
            MenuServicesController.to.searchMenu("");
            MenuServicesController.to.isSearching = false;
            return false;
          } else {
            return true;
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Get.theme.backgroundColor,
          leading: IconButton(
            padding: EdgeInsets.all(4),
            constraints: BoxConstraints(),
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: const Color(0xff111111),
            ),
            onPressed: () {
              if (MenuServicesController.to.isEditFavorite) {
                return _popUpConfirmationFavorite();
              } else {
                if (MenuServicesController.to.isSearching) {
                  MenuServicesController.to.searchMenu("");
                  MenuServicesController.to.isSearching = false;
                } else {
                  Get.back();
                }
              }
            },
          ),
          title: GetBuilder<MenuServicesController>(builder: (controller) {
            return controller.isSearching
                ? TextfieldWidget(
                    hintText: QoinServicesLocalization.serviceTextSearchMenu.tr,
                    keyboardType: TextInputType.text,
                    maxLength: 20,
                    suffix: Icon(
                      Icons.search,
                      color: Color(0xff979797),
                      size: 20,
                    ),
                    onChanged: (value) {
                      controller.searchMenu(value);
                    },
                  )
                : Text(
                    QoinServicesLocalization.serviceMenuTitle.tr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      color: const Color(0xff231f20),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0,
                    ),
                  );
          }),
          actions: [
            GetBuilder<MenuServicesController>(builder: (controller) {
              return (!controller.isSearching)
                  ? IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Color(0xff979797),
                        size: 26,
                      ),
                      onPressed: () {
                        controller.isSearching = true;
                      },
                    )
                  : SizedBox();
            }),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: kBottomNavigationBarHeight,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: GetBuilder<MenuServicesController>(
                    init: MenuServicesController(),
                    builder: (controller) {
                      return ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.helperCategoryServices.length,
                        itemBuilder: (BuildContext context, int index) {
                          var category =
                              controller.helperCategoryServices[index];
                          return CustomChoiceChip(
                            text: category,
                            selected: controller.selectedCategory == category,
                            onSelected: (val) {
                              if (controller.isEditFavorite) {
                                _popUpConfirmationFavorite();
                              } else {
                                if (val) {
                                  controller.selectedCategory = category;
                                }
                              }
                            },
                            padding: EdgeInsets.symmetric(
                                vertical: 8.w, horizontal: 10.w),
                          );
                        },
                        separatorBuilder: (_, __) => SizedBox(
                          width: 8,
                        ),
                      );
                    }),
              ),
              Container(
                height: 1,
                width: Get.size.width,
                color: Color(0xffdedede),
              ),
              //
              GetBuilder<MenuServicesController>(
                  init: MenuServicesController(),
                  builder: (controller) {
                    return controller.selectedCategory ==
                            QoinServicesLocalization.serviceMenuCategoryAll.tr
                        ? Column(
                            children: controller.categoryServices
                                .map((e) => e !=
                                        QoinServicesLocalization
                                            .serviceMenuCategoryAll.tr
                                    ? Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Color(0xfff6f6f6),
                                              width: 10,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(20),
                                              child: title(e, controller),
                                            ),
                                            content(e, controller),
                                          ],
                                        ),
                                      )
                                    : SizedBox())
                                .toList(),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                              color: Color(0xfff6f6f6),
                              width: 10,
                            ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: title(
                                      controller.selectedCategory, controller),
                                ),
                                content(
                                    controller.selectedCategory, controller),
                              ],
                            ),
                          );
                  }),
            ],
          ),
        ),
        // bottomNavigationBar: GetBuilder<MenuServicesController>(builder: (controller) {
        //   return controller.isEditFavorite
        //       ? ButtonBottomWidget(
        //           text: QoinServicesLocalization.serviceTextSave.tr,
        //           onPressed: () {
        //             _popUpConfirmationFavorite();
        //           },
        //         )
        //       : SizedBox();
        // }),
      ),
    );
  }

  Widget title(String title, MenuServicesController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: title == QoinServicesLocalization.serviceMenuCategoryFavorite.tr
          ? Row(
              children: [
                Text(
                  title,
                  style: TextUI.subtitleBlack,
                ),
                Spacer(),
                controller.isEditFavorite
                    ? InkWell(
                        onTap: () {
                          _popUpConfirmationFavorite();
                        },
                        child: Text(
                          QoinServicesLocalization.serviceTextSave.tr,
                          style: TextUI.subtitleRed,
                          textAlign: TextAlign.right,
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          controller.isEditFavorite = true;
                        },
                        child: Text(
                          QoinServicesLocalization.serviceTextEdit.tr,
                          style: TextUI.subtitleRed,
                          textAlign: TextAlign.right,
                        ),
                      ),
              ],
            )
          : Text(
              title,
              style: TextUI.subtitleBlack,
            ),
    );
  }

  Widget content(String category, MenuServicesController controller) {
    List<ServiceDataModel> datas = [];
    bool isFav = false;
    if (category == QoinServicesLocalization.serviceMenuCategoryFavorite.tr) {
      datas = controller.menuServicesFavorite;
      isFav = true;
    } else if (category ==
        QoinServicesLocalization.serviceMenuCategoryBill.tr) {
      datas = controller.menuServicesTagihan;
      isFav = false;
    } else if (category ==
        QoinServicesLocalization.serviceMenuCategoryTour.tr) {
      datas = controller.menuServicesWisata;
      isFav = false;
    } else if (category == QoinServicesLocalization.serviceMenuCategoryTax.tr) {
      datas = controller.menuServicesPajak;
      isFav = false;
    } else if (category == QoinServicesLocalization.serviceMenuCategoryLocation.tr) {
      datas = controller.menuServicesLocation;
      isFav = false;
    } else if (category == QoinServicesLocalization.serviceMenuCategoryPopulation.tr) {
      datas = controller.menuCivilRegistration;
      isFav = false;
    } else {
      datas = controller.menuServiceOthers;
      isFav = false;
    }
    return datas.isNotEmpty
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: MenuServicesWidget(
              services: datas,
              isFavorite: isFav,
              isEdit: controller.isEditFavorite,
            ),
          )
        : Container(
            height: 100,
            width: Get.size.width,
            alignment: Alignment.center,
            child: Text(
              QoinServicesLocalization.serviceTextEmptyMenu.tr,
              textAlign: TextAlign.center,
              style: TextUI.placeHolderBlack,
            ),
          );
  }

  _popUpConfirmationFavorite() {
    DialogUtils.showMainPopup(
        title: QoinServicesLocalization.serviceFavoritePopupSaveTitle.tr,
        mainPopupButtonDirection: MainPopupButtonDirection.Horizontal,
        mainButtonText: QoinServicesLocalization.serviceFavoritePopupSaveYes.tr,
        mainButtonFunction: () {
          List<String> listString = MenuServicesController
              .to.menuServicesFavorite
              .map((data) => jsonEncode(data.toJson()))
              .toList();
          HiveData.favServices = listString;
          MenuServicesController.to.updateServices();
          MenuServicesController.to.isEditFavorite = false;
          MenuServicesController.to.isSearching = false;
          Get.back();
        },
        secondaryButtonText:
            QoinServicesLocalization.serviceFavoritePopupSaveCancel.tr,
        secondaryButtonFunction: () {
          MenuServicesController.to.updateServices();
          MenuServicesController.to.isEditFavorite = false;
          MenuServicesController.to.isSearching = false;
          Get.back();
        });
  }
}

class CustomChoiceChip extends StatefulWidget {
  final String text;
  final bool selected;
  final Function(bool)? onSelected;
  final Color? selectedBackgroundColor;
  final Color? selectedBorderColor;
  final Color? selectedTextColor;
  final EdgeInsetsGeometry? padding;

  const CustomChoiceChip(
      {key,
      required this.text,
      this.selected = false,
      this.onSelected,
      this.selectedBackgroundColor,
      this.selectedTextColor,
      this.selectedBorderColor,
      this.padding = const EdgeInsets.all(14.0)})
      : super(key: key);

  @override
  _CustomChoiceChip createState() => _CustomChoiceChip();
}

class _CustomChoiceChip extends State<CustomChoiceChip> {
  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        widget.text,
        style: TextUI.bodyText2White.copyWith(
            color: widget.selected
                ? widget.selectedTextColor ?? Colors.white
                : Get.theme.disabledColor),
      ),
      padding: widget.padding,
      selected: widget.selected,
      selectedColor: widget.selectedBackgroundColor ?? ColorUI.secondary,
      disabledColor: Colors.white,
      backgroundColor: Get.theme.backgroundColor,
      shape: widget.selected
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(
                  color: widget.selectedBorderColor ?? ColorUI.secondary,
                  width: 1))
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: Color(0xffdedede), width: 1)),
      onSelected: widget.onSelected,
    );
  }
}

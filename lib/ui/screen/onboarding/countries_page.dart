import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:azlistview/azlistview.dart';

import 'helper/countries_controller.dart';

class CountriesPage extends StatelessWidget {
  final Function(Country data) onChange;

  CountriesPage({Key? key, required this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put<CountriesController>(CountriesController());
    CountriesController.to.search('');
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: TextField(
            style: TextUI.bodyTextBlack,
            decoration: InputDecoration(
              hintText: 'Cari negara disini',
              hintStyle: TextUI.placeHolderBlack,
              counterText: "",
              filled: true,
              fillColor: ColorUI.shape,
              isDense: true,
              suffixIcon: Icon(
                Icons.search_rounded,
                color: Color(0xffcacccf),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Color(0xffdedede)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Get.theme.colorScheme.secondary),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Color(0xffdedede)),
              ),
            ),
            onChanged: (val) {
              CountriesController.to.search(val);
            },
          ),
        ),
        SizedBox(
          height: 22.h,
        ),
        Expanded(
          child: GetBuilder<CountriesController>(builder: (controller) {
            return AzListView(
              data: controller.searchResult,
              itemCount: controller.searchResult.length,
              itemBuilder: (BuildContext context, int index) {
                return InkResponse(
                  onTap: () {
                    onChange(controller.searchResult[index]);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: ColorUI.shape_2,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.w),
                          child: Image.asset(
                            controller.searchResult[index].image!,
                            height: 28.h,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        SizedBox(
                          width: 16.w,
                        ),
                        Text(
                          controller.searchResult[index].name!,
                          style: TextUI.bodyTextBlack,
                        ),
                      ],
                    ),
                  ),
                );
              },
              susItemBuilder: (BuildContext context, int index) {
                Country contactItem = controller.searchResult[index];
                return getSusItem(context, contactItem.getSuspensionTag());
              },
              indexBarData: [],
            );
          }),
        )
      ],
    );
  }

  Widget getSusItem(BuildContext context, String tag) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 16.0, top: 6.w, bottom: 6.w),
      color: ColorUI.shape,
      alignment: Alignment.centerLeft,
      child: Text(
        '$tag',
        softWrap: false,
        style: TextUI.bodyText2Grey,
      ),
    );
  }
}

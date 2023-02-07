import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:qoin_sdk/models/qoin_digitalid/document_user_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusinessCard extends StatelessWidget {
  final VoidCallback? onTap;
  final DocumentUserData? data;
  final double width;
  final double height;
  final bool isFullscreen;

  const BusinessCard({
    Key? key,
    this.onTap,
    this.data,
    this.width = 379,
    this.height = 233,
    this.isFullscreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var temp = data?.docName ?? null;
    var name;

    if (temp != null) {
      name = temp.split(' ');
      if (name.length > 2) {
        name = '${name.first} ${name.last}';
      } else {
        name = temp;
      }
    } else {
      name = '-';
    }
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width.w,
        height: height.w,
        margin: EdgeInsets.only(bottom: 8.w),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(data?.docColor == 1
                ? Assets.bgNameCardYellow
                : data?.docColor == 2
                    ? Assets.bgNameCardBlue
                    : Assets.bgNameCardBlack),
            fit: BoxFit.fill,
            
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black54,
                blurRadius: 3.0,
                offset: Offset(0.0, 0.75))
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(45.w),
                    child: data?.docPictPrimary != null
                        ? CachedNetworkImage(
                            imageUrl: data!.docPictPrimary!,
                            width: 90.w,
                            height: 90.w,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.asset(
                              Assets.defaultProfileKTP,
                              fit: BoxFit.cover,
                              width: 90.w,
                              height: 90.w,
                            ),
                          )
                        : Image.asset(
                            Assets.defaultProfileKTP,
                            width: 90.w,
                            height: 90.w,
                            fit: BoxFit.cover,
                          ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        name,
                        style: TextUI.title2White,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      data?.docCompany ?? '-',
                      style: TextUI.subtitleWhite.copyWith(fontSize: 10.5.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 5.w),
                  Container(
                    height: 1.w,
                    width: 70.w,
                    color: ColorUI.white,
                  ),
                  SizedBox(height: 5.w),
                  FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      data?.docDepartment ?? '-',
                      style: TextUI.subtitleWhite.copyWith(fontSize: 10.5.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

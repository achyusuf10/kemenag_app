import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:qoin_sdk/helpers/constants/digital_doc_status.dart';
import 'package:qoin_sdk/models/qoin_digitalid/document_user_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class G20Card extends StatelessWidget {
  final VoidCallback? onTap;
  final DocumentUserData? data;
  final double width;
  final double height;
  final bool isFullscreen;

  const G20Card({
    Key? key,
    this.onTap,
    this.data,
    this.width = 379,
    this.height = 233,
    this.isFullscreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width.w,
        height: height.w,
        margin: EdgeInsets.only(bottom: 8.w),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.bgG20Card),
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
          padding: EdgeInsets.all(20.w),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data?.docName ?? '-',
                        style: TextUI.subtitleWhite
                            .copyWith(fontSize: 12.sp, letterSpacing: 0.2),
                      ),
                      SizedBox(
                          width: 90.w,
                          child: Divider(color: Colors.white, thickness: 2)),
                      Text(
                        data?.docDetails?.citizenship ?? '-',
                        style: TextUI.subtitleWhite
                            .copyWith(fontSize: 12.sp, letterSpacing: 0.2),
                      ),
                    ],
                  ),
                  data?.docDetails?.docPictCropping != null &&
                          data?.docDetails?.docPictCropping != "No Image" &&
                          data?.docDetails?.docPictCropping != ""
                      ? CachedNetworkImage(
                          imageUrl: data!.docDetails!.docPictCropping!,
                          width: 104.h,
                          height: 120.h,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Image.asset(
                            Assets.defaultProfileKTP,
                            fit: BoxFit.cover,
                            width: 104.h,
                            height: 120.h,
                          ),
                        )
                      : data?.docPictPrimary != null
                          ? CachedNetworkImage(
                              imageUrl: data!.docPictPrimary!,
                              width: 104.h,
                              height: 120.h,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Image.asset(
                                Assets.defaultProfileKTP,
                                fit: BoxFit.cover,
                                width: 104.h,
                                height: 120.h,
                              ),
                            )
                          : Image.asset(
                              Assets.defaultProfileKTP,
                              width: 104.h,
                              height: 120.h,
                              fit: BoxFit.fitHeight,
                            ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    data?.docDepartment ?? '-',
                    style: TextUI.subtitleWhite
                        .copyWith(fontSize: 14.sp, letterSpacing: 0.2),
                  ),
                ],
              ),
              if (data?.status != DigitalDocStatus.active)
                Container(
                  child: Image.asset(
                    Assets.bgUnverified,
                    height: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
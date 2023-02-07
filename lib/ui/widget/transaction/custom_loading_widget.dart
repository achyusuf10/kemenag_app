import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'separator_widget.dart';

class CustomLoadingWidget extends StatelessWidget {
  final int? itemCount;

  const CustomLoadingWidget({key, this.itemCount = 5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: itemCount!,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Padding(
              padding: EdgeInsets.all(
                ScreenUtil().setHeight(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: ScreenUtil().setWidth(40),
                    height: ScreenUtil().setWidth(40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        ScreenUtil().radius(40),
                      ),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(15),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    ScreenUtil().radius(8),
                                  ),
                                ),
                                child: Container(
                                  width: ScreenUtil().setWidth(172),
                                  height: ScreenUtil().setHeight(22),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(16),
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    ScreenUtil().radius(8),
                                  ),
                                ),
                                child: Container(
                                  width: ScreenUtil().setWidth(172),
                                  height: ScreenUtil().setHeight(22),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(4),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(4),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                child: Container(
                                  width: ScreenUtil().setWidth(134),
                                  height: ScreenUtil().setHeight(18),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(16),
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                child: Container(
                                  width: ScreenUtil().setWidth(134),
                                  height: ScreenUtil().setHeight(18),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setHeight(16),
          ),
          child: SeparatorWidget(
            height: 1,
            color: Color(0XFFE5E5E5),
          ),
        );
      },
    );
  }
}

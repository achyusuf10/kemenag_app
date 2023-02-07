import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:shimmer/shimmer.dart';

class ContactLoading extends StatelessWidget {
  const ContactLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.grey.shade300,
      baseColor: Colors.grey.shade100,
      child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: ColorUI.yellow, shape: BoxShape.circle),
                    child: Center(
                      child: Image.asset(
                        Assets.icAvatar,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              8,
                            ),
                          ),
                          child: Container(
                            width: 200,
                            height: 15,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                8,
                              ),
                            ),
                            child: Container(height: 14, width: 150, color: Colors.grey)),
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          width: double.infinity,
                          height: 1,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                ],
              ),
          itemCount: 4),
    );
  }
}

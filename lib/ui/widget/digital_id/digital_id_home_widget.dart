import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qoin_sdk/controllers/others/qoin_remote_config_controller.dart';
import 'package:qoin_sdk/helpers/utils/hive_data.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
// import 'package:venturo_mobile/digitalisasi_tni/screens/digitalisasi_tni_detail_screen.dart';
// import 'package:venturo_mobile/otaqu/ui/widgets/otaqu_ticket_card.dart';
// import 'package:venturo_mobile/relawan_jokowi/logic/controllers/relawan_jokowi_controller.dart';
// import 'package:venturo_mobile/sentra_kependudukan/ui/screens/riwayat_aktivitas/riwayat_detail_akta_lahir/digital_akta_lahir_doc.dart';
// import 'package:venturo_mobile/sentra_kependudukan/ui/screens/riwayat_aktivitas/riwayat_detail_kk/digital_kk_doc.dart';
// import 'package:venturo_mobile/sentra_kependudukan/ui/screens/riwayat_aktivitas/riwayat_detail_kk/kk_card.dart';
// import 'package:venturo_mobile/sentra_kependudukan/ui/screens/sentra_kependudukan_screen.dart';
// import 'package:venturo_mobile/shared_inisa/inisa_venturo_methods.dart';
// import 'package:venturo_mobile/shared_inisa/widgets/akta_kelahiran_header_card.dart';
// import 'package:venturo_mobile/shared_inisa/widgets/tni_card.dart';
// import 'package:venturo_mobile/shared_inisa/widgets/voucher_bansos_card.dart';
// import 'package:venturo_mobile/voucher_bansos/ui/screens/detail_voucher_bansos_screen.dart';

import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:inisa_app/logic/controller/digitalid/digital_archive_ui_controller.dart';
import 'package:inisa_app/ui/screen/digital_id/detail_digital_doc_screen.dart';
import 'package:inisa_app/ui/screen/digital_id/digital_id_helper.dart';
import 'package:inisa_app/ui/screen/digital_id/list_card/list_cards_screen.dart';
import 'package:inisa_app/ui/screen/digital_id/select_id_type_screen.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/screen/home/tooltips.dart';
import 'package:inisa_app/ui/screen/services/ota/ota_screen.dart';
import 'package:inisa_app/ui/screen/services/top_up/top_up_voucher_screen.dart';
import 'package:inisa_app/ui/screen/services/top_up/topup_voucher_redeem_detail.dart';

import '../topup_voucher_redeem_widget.dart';
import '../voucher_widget.dart';
import 'add_new_digital_card.dart';
import 'doc_holder_widget.dart';
import 'qoin_member_card.dart';

class DigitalIdHomeWidget extends StatefulWidget {
  /// if [true] show indicator, default [false]
  final bool isUsingIndicator;

  /// distance between indicator and container
  final double? space;

  /// height for outer container
  final double? height;

  /// if [true] show See All Document, default [false]
  final bool isUsingSeeAllButton;

  /// indicator and button See All Document margin
  final EdgeInsetsGeometry? bottomInsets;

  /// title for See All Document Button
  final String? buttonTitle;

  final GlobalKey addCardTutorialKey;

  const DigitalIdHomeWidget({
    Key? key,
    this.isUsingIndicator = false,
    this.space,
    this.height,
    this.isUsingSeeAllButton = false,
    this.bottomInsets,
    this.buttonTitle,
    required this.addCardTutorialKey,
  }) : super(key: key);

  @override
  _DigitalIdHomeWidgetState createState() => _DigitalIdHomeWidgetState();
}

class _DigitalIdHomeWidgetState extends State<DigitalIdHomeWidget>
    with SingleTickerProviderStateMixin {
  var selectedTab = DigitalIdLocalization.cardListTabFav.tr.obs;

  late TabController _tabController;

  final carouselController = CarouselController();
  int carouselIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> tabCards = [
      DigitalIdLocalization.cardListTabFav.tr,
      DigitalIdLocalization.cardListTab1.tr,
      DigitalIdLocalization.cardListTab2.tr,
      DigitalIdLocalization.cardListTab3.tr,
      DigitalIdLocalization.cardListTab4.tr
    ];
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            key: widget.addCardTutorialKey,
            width: 379.w,
            height: 320.w,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40.sp,
              width: ScreenUtil().screenWidth,
              margin: EdgeInsets.only(bottom: 16.sp, left: 16.sp, right: 16.sp),
              decoration: BoxDecoration(
                color: ColorUI.shape_2.withOpacity(0.2),
                borderRadius: BorderRadius.circular(
                  4.r,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 0,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      4.r,
                    ),
                    color: ColorUI.secondary),
                labelPadding: EdgeInsets.zero,
                // physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 2.sp),
                onTap: (indexTab) {
                  if (_tabController.indexIsChanging) {
                    selectedTab.value = tabCards[indexTab];
                    carouselIndex = 0;
                    carouselController.jumpToPage(0);
                    if (mounted) setState(() {});
                  }
                },
                tabs: tabCards.map((String items) {
                  return Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                      ),
                      child: Text(
                        items,
                        style: TextUI.subtitleWhite.copyWith(
                            fontSize: 14.sp,
                            color: selectedTab.value == items
                                ? ColorUI.white
                                : ColorUI.shape),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: widget.height != null ? widget.height : 233.17,
              child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _favorit(),
                  _identitas(),
                  _voucher(),
                  _eticket(),
                  _eDocument()
                ],
              ),
            ),
            if (!widget.isUsingSeeAllButton)
              SizedBox(
                height: widget.space != null ? widget.space : 0,
              ),
            Padding(
              padding: EdgeInsets.only(left: 12.w, right: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.isUsingIndicator
                      ? qoin.GetBuilder<DigitalArchiveUIController>(
                          builder: (controller) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: ((getDotted(controller) as List).length ==
                                    1)
                                ? []
                                : (getDotted(controller) as List)
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: SizedBox(
                                          height: 12,
                                          width: 12,
                                          child: Container(
                                            padding: EdgeInsets.all(1),
                                            color: carouselIndex == entry.key
                                                ? Colors.black
                                                : qoin.Get.theme
                                                    .unselectedWidgetColor,
                                            child: carouselIndex == entry.key
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      border: Border.all(
                                                        color: qoin.Get.theme
                                                            .backgroundColor,
                                                        width: 1,
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                          );
                        })
                      : SizedBox(),
                  widget.isUsingSeeAllButton
                      ? Row(
                          children: [
                            InkWell(
                              onTap: () {
                                qoin.Get.to(() => ListCardScreen());
                              },
                              child: Text(
                                widget.buttonTitle != null
                                    ? widget.buttonTitle!
                                    : DigitalIdLocalization.widgetAllCard.tr,
                                style: TextUI.subtitleBlack
                                    .copyWith(fontSize: 14.sp),
                              ),
                            ),
                            Icon(Icons.arrow_right)
                          ],
                        )
                      : SizedBox(),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _favorit() {
    return qoin.GetBuilder<DigitalArchiveUIController>(builder: (controller) {
      var cards = controller.cardsItem
          .where((element) => element.isFavorite)
          .take(5)
          .toList();
      return CarouselSlider.builder(
        itemCount: cards.length + 1,
        itemBuilder: (BuildContext context, int index, _) {
          if (index == 0)
            return Center(
              child: QoinMemberCard(
                width: 379,
                height: 233.17,
                onTap: () {},
              ),
            );
          var cardData = cards.elementAt(index - 1);
          if (cardData.typeCard == qoin.TypeCard.voucher &&
              cardData.ket == null) {
            var data = qoin.HiveData.vouchers?.firstWhere(
                (element) => element.voucherNumber == cardData.docNumber);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: qoin.Get.width * 0.05),
              child: VoucherWidget(
                voucherData: data!,
              ),
            );
          } else if (cardData.typeCard == qoin.TypeCard.voucherTopup) {
            var data = qoin.HiveData.vouchersTopupPurchased?.firstWhere(
                (element) => element.voucherNo == cardData.docNumber);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: qoin.Get.width * 0.05),
              child: TopUpVoucherRedeemWidget(
                data: data,
                onTapButton: () {
                  qoin.Get.to(() => TopUpVoucherRedeemDetail(
                        data: data,
                      ));
                },
              ),
            );
          } else {
            var data = qoin.HiveData.docData
                ?.firstWhere((element) => element?.docNo == cardData.docNumber);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: qoin.Get.width * 0.05),
              child: DocHolderWidget(
                data: data!,
                width: 379, //340
                height: 233.17, //202
                onTap: () {
                  // qoin.DigitalIdController.instance.getQrImage(data: data);
                  DigitalIdHelper.getQRData(data);
                  qoin.Get.to(
                    () => DetailDigitalDocScreen(data: data),
                  );
                },
              ),
            );
          }
        },
        carouselController: carouselController,
        options: CarouselOptions(
          enableInfiniteScroll: false,
          height: 233.17,
          pageSnapping: true,
          // disableCenter: true,
          // enlargeStrategy: CenterPageEnlargeStrategy.height,
          // enlargeCenterPage: true,
          // viewportFraction: cb.Get.width > 600 ? 0.8 : 1,
          viewportFraction: 1,
          onPageChanged: (index, _) {
            if (mounted) {
              setState(() {
                carouselIndex = index;
              });
            }
          },
        ),
      );
    });
  }

  Widget _identitas() {
    return qoin.GetBuilder<DigitalArchiveUIController>(builder: (controller) {
      var cards = controller.cardsItem
          .where((element) => element.typeCard == qoin.TypeCard.idcard)
          .toList()
          .take(5)
          .toList();
      return CarouselSlider.builder(
        itemCount: cards.isEmpty ? 1 : cards.length,
        itemBuilder: (BuildContext context, int index, _) {
          if (cards.isEmpty) {
            return Center(
              child: AddNewDigitalCard(
                width: 379,
                height: 233.17,
                type: EmptyStateType.Identity,
                onTap: () {
                  qoin.Get.to(() => SelectIdTypeScreen());
                },
              ),
            );
          } else {
            var data = qoin.HiveData.docData?.firstWhere(
                (element) => element?.docNo == cards[index].docNumber);
            return Container(
              width: 379,
              height: 233.17,
              child: DocHolderWidget(
                data: data!,
                width: 379, //340
                height: 233.17, //202
                onTap: () {
                  // qoin.DigitalIdController.instance.getQrImage(data: data);
                  DigitalIdHelper.getQRData(data);
                  qoin.Get.to(
                    () => DetailDigitalDocScreen(data: data),
                  );
                },
              ),
            );
          }
        },
        carouselController: carouselController,
        options: CarouselOptions(
          enableInfiniteScroll: false,
          height: 233.17,
          pageSnapping: true,
          viewportFraction: 1,
          onPageChanged: (index, _) {
            setState(() {
              carouselIndex = index;
            });
          },
        ),
      );
    });
  }

  Widget _voucher() {
    return qoin.GetBuilder<DigitalArchiveUIController>(builder: (controller) {
      var cards = controller.cardsItem
          .where((element) =>
              element.typeCard == qoin.TypeCard.voucherTopup ||
              (element.typeCard == qoin.TypeCard.others &&
                  element.ket == TypeCardExternal.bansos.toString()))
          .toList()
          .take(5)
          .toList();
      return CarouselSlider.builder(
        itemCount: cards.length == 0 ? 1 : cards.length,
        itemBuilder: (BuildContext context, int index, _) {
          if (cards.length == 0 && index == 0)
            return Center(
              child: AddNewDigitalCard(
                width: 379,
                height: 233.17,
                type: EmptyStateType.Voucher,
                onTap: () {
                  if (QoinRemoteConfigController
                      .instance.isVoucherTopupActive) {
                    qoin.Get.to(() => TopUpVoucherScreen());
                  } else {
                    DialogUtils.showComingSoonDrawer();
                  }
                },
              ),
            );
          var data = qoin.HiveData.vouchersTopupPurchased?.firstWhere(
              (element) => element.voucherNo == cards[index].docNumber);
          return TopUpVoucherRedeemWidget(
            data: data,
            onTapButton: () {
              qoin.Get.to(() => TopUpVoucherRedeemDetail(data: data));
            },
          );
        },
        carouselController: carouselController,
        options: CarouselOptions(
          enableInfiniteScroll: false,
          height: 233.17,
          pageSnapping: true,
          viewportFraction: 1,
          onPageChanged: (index, _) {
            if (mounted) {
              setState(() {
                carouselIndex = index;
              });
            }
          },
        ),
      );
    });
  }

  Widget _eticket() {
    return qoin.GetBuilder<DigitalArchiveUIController>(builder: (controller) {
      var cards = controller.cardsItem
          .where((element) =>
              element.typeCard == qoin.TypeCard.voucher ||
              element.typeCard == qoin.TypeCard.eticket)
          .toList()
          .take(5)
          .toList();
      return CarouselSlider.builder(
        itemCount: cards.length == 0 ? 1 : cards.length,
        itemBuilder: (BuildContext context, int index, _) {
          if (cards.length == 0 && index == 0)
            return Center(
              child: AddNewDigitalCard(
                width: 379,
                height: 233.17,
                type: EmptyStateType.Ticket,
                onTap: () {
                  if (QoinRemoteConfigController
                      .instance.IsKomodoMembershipActive) {
                    qoin.Get.to(() => OtaScreen(
                          otaType: qoin.OtaType.Membership,
                        ));
                  } else {
                    DialogUtils.showComingSoonDrawer();
                  }
                },
              ),
            );
          var data;
          var widget;
          if (cards[index].ket == null) {
            if (cards[index].typeCard == qoin.TypeCard.voucher) {
              data = qoin.HiveData.vouchers?.firstWhere(
                  (element) => element.voucherNumber == cards[index].docNumber);
              widget = VoucherWidget(
                voucherData: data!,
              );
            } else {
              data = qoin.HiveData.ticketManifests?.firstWhere(
                  (element) => element.ticketNumber == cards[index].docNumber);
              widget = VoucherWidget(
                voucherData: data!,
              );
            }

            // widget = TicketPerjalananCard(voucherData: null);
          } else {
            data = qoin.HiveData.docData?.firstWhere(
                (element) => element?.docNo == cards[index].docNumber);
            widget = DocHolderWidget(
              data: data!,
              onTap: () {
                // qoin.DigitalIdController.instance.getQrImage(data: data);
                DigitalIdHelper.getQRData(data);
                qoin.Get.to(
                  () => DetailDigitalDocScreen(data: data),
                );
              },
            );
          }
          return widget;
        },
        carouselController: carouselController,
        options: CarouselOptions(
          enableInfiniteScroll: false,
          height: 233.17,
          pageSnapping: true,
          viewportFraction: 1,
          onPageChanged: (index, _) {
            if (mounted) {
              setState(() {
                carouselIndex = index;
              });
            }
          },
        ),
      );
    });
  }

  Widget _eDocument() {
    return qoin.GetBuilder<DigitalArchiveUIController>(builder: (controller) {
      var cards = controller.cardsItem
          .where((element) =>
              element.ket == TypeCardExternal.kk.toString() ||
              element.ket == TypeCardExternal.aktaLahir.toString())
          .toList()
          .take(5)
          .toList();
      return CarouselSlider.builder(
        itemCount: cards.length == 0 ? 1 : cards.length,
        itemBuilder: (BuildContext context, int index, _) {
          if (cards.length == 0 && index == 0)
            return Center(
              child: AddNewDigitalCard(
                width: 379,
                height: 233.17,
                type: EmptyStateType.Identity,
                onTap: () {},
              ),
            );

          return SizedBox();
        },
        carouselController: carouselController,
        options: CarouselOptions(
          enableInfiniteScroll: false,
          height: 233.17,
          pageSnapping: true,
          viewportFraction: 1,
          onPageChanged: (index, _) {
            if (mounted) {
              setState(() {
                carouselIndex = index;
              });
            }
          },
        ),
      );
    });
  }

  getDotted(DigitalArchiveUIController controller) {
    if (selectedTab.value == DigitalIdLocalization.cardListTabFav.tr) {
      if (controller.cardsItem
              .where((element) => element.isFavorite)
              .toList()
              .length ==
          0)
        return [1];
      else {
        if (controller.cardsItem
                .where((element) => element.isFavorite)
                .toList()
                .length <=
            5)
          return [
            ...controller.cardsItem.where((element) => element.isFavorite),
            1
          ];
        else
          return [1, 2, 3, 4, 5];
      }
    } else if (selectedTab.value == DigitalIdLocalization.cardListTab1.tr) {
      if (controller.cardsItem
              .where((element) => element.typeCard == qoin.TypeCard.idcard)
              .length ==
          0)
        return [1];
      else {
        if (controller.cardsItem
                .where((element) => element.typeCard == qoin.TypeCard.idcard)
                .length <=
            5)
          return [
            ...controller.cardsItem
                .where((element) => element.typeCard == qoin.TypeCard.idcard)
          ];
        else
          return [1, 2, 3, 4, 5];
      }
    } else if (selectedTab.value == DigitalIdLocalization.cardListTab2.tr) {
      if (controller.cardsItem
              .where((element) =>
                  element.typeCard == qoin.TypeCard.voucherTopup ||
                  (element.typeCard == qoin.TypeCard.others &&
                      element.ket == TypeCardExternal.bansos.toString()))
              .length ==
          0)
        return [1];
      else {
        if (controller.cardsItem
                .where((element) =>
                    element.typeCard == qoin.TypeCard.voucherTopup ||
                    (element.typeCard == qoin.TypeCard.others &&
                        element.ket == TypeCardExternal.bansos.toString()))
                .length <=
            5)
          return [
            ...controller.cardsItem.where((element) =>
                element.typeCard == qoin.TypeCard.voucherTopup ||
                (element.typeCard == qoin.TypeCard.others &&
                    element.ket == TypeCardExternal.bansos.toString()))
          ];
        else
          return [1, 2, 3, 4, 5];
      }
    } else if (selectedTab.value == DigitalIdLocalization.cardListTab4.tr) {
      if (controller.cardsItem
              .where((element) =>
                  element.ket == TypeCardExternal.kk.toString() ||
                  element.ket == TypeCardExternal.aktaLahir.toString())
              .length ==
          0)
        return [1];
      else {
        if (controller.cardsItem
                .where((element) =>
                    element.ket == TypeCardExternal.kk.toString() ||
                    element.ket == TypeCardExternal.aktaLahir.toString())
                .length <=
            5)
          return [
            ...controller.cardsItem.where((element) =>
                element.ket == TypeCardExternal.kk.toString() ||
                element.ket == TypeCardExternal.aktaLahir.toString())
          ];
        else
          return [1, 2, 3, 4, 5];
      }
    } else {
      if (controller.cardsItem
              .where((element) =>
                  element.typeCard == qoin.TypeCard.voucher ||
                  element.typeCard == qoin.TypeCard.eticket)
              .length ==
          0)
        return [1];
      else {
        if (controller.cardsItem
                .where((element) =>
                    element.typeCard == qoin.TypeCard.voucher ||
                    element.typeCard == qoin.TypeCard.eticket)
                .length <=
            5)
          return [
            ...controller.cardsItem.where((element) =>
                element.typeCard == qoin.TypeCard.voucher ||
                element.typeCard == qoin.TypeCard.eticket)
          ];
        else
          return [1, 2, 3, 4, 5];
      }
    }
  }
}

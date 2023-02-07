import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/digital_id_localization.dart';
import 'package:inisa_app/logic/controller/digitalid/digital_archive_ui_controller.dart';
import 'package:inisa_app/ui/screen/digital_id/list_card/list_nested_tab.dart';
import 'package:inisa_app/ui/screen/digital_id/list_card/generate_card.dart';
import 'package:inisa_app/ui/screen/digital_id/select_id_type_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/digital_id/add_new_digital_card.dart';
import 'package:inisa_app/ui/widget/digital_id/qoin_member_card.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

class ListCardScreen extends StatefulWidget {
  @override
  State<ListCardScreen> createState() => _ListCardScreenState();
}

class _ListCardScreenState extends State<ListCardScreen> with SingleTickerProviderStateMixin {
  GenerateCard _generateCard = GenerateCard();
  var _selectedCategory = DigitalIdLocalization.cardListTab0.tr.obs;

  late TabController _tabController;

  var deleteMode = false.obs;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> cardCategory = [
      DigitalIdLocalization.cardListTab0.tr,
      DigitalIdLocalization.cardListTab1.tr,
      DigitalIdLocalization.cardListTab2.tr,
      DigitalIdLocalization.cardListTab3.tr,
      DigitalIdLocalization.cardListTab4.tr,
    ];

    return ModalProgress(
      loadingStatus: qoin.DigitalIdController.instance.isMainLoading.stream,
      child: WillPopScope(
        onWillPop: () async {
          if (deleteMode.value) {
            deleteMode.value = false;
            return false;
          } else
            return true;
        },
        child: Scaffold(
          backgroundColor: ColorUI.shape,
          appBar: AppBarWidget.light(
            title: DigitalIdLocalization.cardListTitle.tr,
            onBack: () {
              if (deleteMode.value) {
              } else {
                qoin.Get.back();
              }
            },
            actions: [
              qoin.Obx(
                () => IconButton(
                  icon: deleteMode.value
                      ? Icon(
                          Icons.check,
                          color: ColorUI.text_1,
                        )
                      : Icon(
                          Icons.delete,
                          color: ColorUI.text_1,
                        ),
                  onPressed: () {
                    if (deleteMode.value)
                      deleteMode.value = false;
                    else
                      deleteMode.value = true;
                  },
                ),
              )
            ],
          ),
          body: qoin.GetBuilder<DigitalArchiveUIController>(
            builder: (controller) {
              return Column(
                children: [
                  // TAB BAR
                  Container(
                    height: kBottomNavigationBarHeight,
                    width: ScreenUtil().screenWidth,
                    color: qoin.Get.theme.backgroundColor,
                    child: Center(
                      child: Container(
                        height: 36.sp,
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
                          labelPadding: EdgeInsets.symmetric(horizontal: 4.w),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          onTap: (indexTab) {
                            debugPrint("TEST KLIK 1");
                            if (_tabController.indexIsChanging) {
                              if (_tabController.index == 3) {
                                debugPrint("TEST KLIK indeks 3");
                                qoin.OtaController.to.getListTicketManifest(
                                    onSuccess: () {
                                      debugPrint("SUKSES KELUAR DATANYA");
                                      DigitalArchiveUIController.to.joinAllCard();
                                    },
                                    onProfileNotComplete: () {},
                                    onFailed: (error) {});
                              }
                              _selectedCategory.value = cardCategory[indexTab];
                              // controller.tabListCard = indexTab;
                            }
                          },
                          tabs: cardCategory.map((String items) {
                            return Tab(
                              child: qoin.Obx(
                                () => Container(
                                  height: 36.sp,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 18.w,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      4.r,
                                    ),
                                    border: Border.all(
                                      color: _selectedCategory.value == items ? ColorUI.secondary : ColorUI.disabled,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      items,
                                      style: TextUI.subtitleWhite.copyWith(
                                        fontSize: 14.sp,
                                        color: _selectedCategory.value == items ? ColorUI.white : ColorUI.disabled,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                    controller: _tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _allTab(),
                      _identityTab(0),
                      NestedTabCard(ListType.Voucher),
                      NestedTabCard(ListType.Ticket),
                      NestedTabCard(ListType.Documents),
                    ],
                  ))
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _allTab() => qoin.GetBuilder<DigitalArchiveUIController>(
        builder: (controller) {
          var helper = controller.cardsItem;
          var cards = helper.reversed.toList();

          print('REBUILD WIDGET ${cards.length + 1}');

          return Swiper(
            itemCount: cards.length + 1,
            layout: SwiperLayout.STACK,
            scrollDirection: Axis.vertical,
            loop: true,
            itemHeight: 300,
            itemWidth: double.infinity,
            itemBuilder: (BuildContext context, int index) {
              if (index == cards.length)
                return Container(
                  padding: EdgeInsets.all(24.w),
                  margin: EdgeInsets.only(bottom: 16.h),
                  child: Center(
                    child: QoinMemberCard(
                      onTap: () {},
                    ),
                  ),
                );
              if (cards[index].typeCard == qoin.TypeCard.idcard)
                return _generateCard.generateIdentity(
                  cards[index],
                  controller,
                );
              if (cards[index].typeCard == qoin.TypeCard.voucher || cards[index].typeCard == qoin.TypeCard.eticket)
                return _generateCard.generateTicket(
                  cards[index],
                  controller,
                );
              if (cards[index].typeCard == qoin.TypeCard.voucherTopup && cards[index].ket == null)
                return _generateCard.generateVoucherTopUp(
                  cards[index],
                  controller,
                );
              if (cards[index].ket == TypeCardExternal.bansos.toString())
                return _generateCard.generateVoucherBansos(
                  cards[index],
                  controller,
                );
              if (cards[index].ket == TypeCardExternal.kk.toString() || cards[index].ket == TypeCardExternal.aktaLahir.toString())
                return _generateCard.generateEDocument(
                  cards[index],
                  controller,
                );
              return Container();
            },
          );
        },
      );

  _identityTab(int index) => qoin.GetBuilder<DigitalArchiveUIController>(
        builder: (controller) {
          var helper = [];
          if (index == 0)
            helper = controller.cardsItem
                .where(
                  (element) => element.typeCard == qoin.TypeCard.idcard,
                )
                .toList();
          else if (index == 1)
            helper = controller.cardsItem
                .where(
                  (element) => element.typeCard == qoin.TypeCard.idcard && element.ket == '2',
                )
                .toList();
          else if (index == 2)
            helper = controller.cardsItem
                .where(
                  (element) => element.typeCard == qoin.TypeCard.idcard && element.ket == '3',
                )
                .toList();
          else
            helper = controller.cardsItem
                .where(
                  (element) => element.typeCard == qoin.TypeCard.idcard && element.ket == '6',
                )
                .toList();
          var cards = helper.reversed.toList();
          if (cards.isEmpty)
            return Column(
              children: [
                SizedBox(
                  height: 16.0,
                ),
                AddNewDigitalCard(
                  type: EmptyStateType.Identity,
                  onTap: () {
                    qoin.Get.to(() => SelectIdTypeScreen());
                  },
                ),
              ],
            );
          return Swiper(
            itemCount: cards.length,
            layout: SwiperLayout.STACK,
            scrollDirection: Axis.vertical,
            loop: true,
            itemHeight: 300,
            itemWidth: double.infinity,
            itemBuilder: (BuildContext context, int index) {
              return _generateCard.generateIdentity(cards[index], controller);
            },
          );
        },
      );
}

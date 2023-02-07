import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/logic/controller/digitalid/digital_archive_ui_controller.dart';
import 'package:inisa_app/ui/screen/digital_id/list_card/generate_card.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/screen/services/ota/ota_screen.dart';
import 'package:inisa_app/ui/screen/services/top_up/top_up_voucher_screen.dart';
import 'package:inisa_app/ui/widget/digital_id/add_new_digital_card.dart';
import 'package:inisa_app/ui/widget/digital_id/card_item.dart';
import 'package:qoin_sdk/controllers/others/qoin_remote_config_controller.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
// import 'package:venturo_mobile/sentra_kependudukan/ui/screens/sentra_kependudukan_screen.dart';

enum ListType { Identity, Voucher, Documents, Ticket }

class NestedTabCard extends StatefulWidget {
  final ListType listType;

  const NestedTabCard(this.listType);

  @override
  _NestedTabCardState createState() => _NestedTabCardState();
}

class _NestedTabCardState extends State<NestedTabCard>
    with TickerProviderStateMixin {
  TabController? _nestedTabController;
  GenerateCard _generateCard = GenerateCard();

  var _selectedCategory = 'Semua'.obs;

  List<List<String>> _categories = [
    // ['Semua', 'E-KTP', 'SIM', 'Paspor'],
    ['Semua', 'Top Up', 'Event'],
    ['Semua', 'Akta Lahir', 'Kartu Keluarga'],
    [
      'Semua',
      'Perjalanan',
      'Wisata',
      'Membership',
      'Lainnya',
    ]
  ];
  List<String> _activeCategory = [];

  @override
  void initState() {
    super.initState();
    if (widget.listType == ListType.Voucher) {
      _activeCategory = _categories[0];
    } else if (widget.listType == ListType.Ticket) {
      _activeCategory = _categories[2];
    } else {
      _activeCategory = _categories[1];
    }
    var length = _activeCategory.length;
    _nestedTabController = new TabController(length: length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Colors.white,
          height: 36.sp,
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: _nestedTabController,
              indicatorColor: ColorUI.secondary,
              labelColor: ColorUI.secondary,
              unselectedLabelColor: ColorUI.disabled,
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              onTap: (indexTab) {
                if (_nestedTabController!.indexIsChanging) {
                  _selectedCategory.value = _activeCategory[indexTab];
                  // controller.tabListCard = indexTab;
                }
              },
              tabs: _activeCategory.map((String items) {
                return Tab(
                    child: qoin.Obx(() => Text(
                          items,
                          style: TextUI.buttonTextRed.copyWith(
                              color: _selectedCategory.value == items
                                  ? ColorUI.secondary
                                  : ColorUI.disabled),
                        )));
              }).toList(),
            ),
          ),
        ),
        Container(
          height: screenHeight * 0.70,
          child: TabBarView(
              controller: _nestedTabController,
              children:
                  // widget.listType == ListType.Identity
                  //     ? <Widget>[
                  //         _identityTab(0),
                  //         _identityTab(1),
                  //         _identityTab(2),
                  //         _identityTab(3),
                  //       ]
                  //     :
                  widget.listType == ListType.Voucher
                      ? <Widget>[
                          _voucherTopUpTab(0),
                          _voucherTopUpTab(1),
                          _voucherTopUpTab(2),
                        ]
                      : widget.listType == ListType.Ticket
                          ? <Widget>[
                              _eTicketTab(0),
                              _eTicketTab(1),
                              _eTicketTab(2),
                              _eTicketTab(3),
                              _eTicketTab(4),
                            ]
                          : <Widget>[
                              _eDocumentTab(0),
                              _eDocumentTab(1),
                              _eDocumentTab(2),
                            ]),
        )
      ],
    );
  }

  // _identityTab(int index) =>
  //     qoin.GetBuilder<DigitalArchiveUIController>(builder: (controller) {
  //       var helper = [];
  //       if (index == 0)
  //         helper = controller.cardsItem
  //             .where((element) => element.typeCard == qoin.TypeCard.idcard)
  //             .toList();
  //       else if (index == 1)
  //         helper = controller.cardsItem
  //             .where((element) =>
  //                 element.typeCard == qoin.TypeCard.idcard &&
  //                 element.ket == '2')
  //             .toList();
  //       else if (index == 2)
  //         helper = controller.cardsItem
  //             .where((element) =>
  //                 element.typeCard == qoin.TypeCard.idcard &&
  //                 element.ket == '3')
  //             .toList();
  //       else
  //         helper = controller.cardsItem
  //             .where((element) =>
  //                 element.typeCard == qoin.TypeCard.idcard &&
  //                 element.ket == '6')
  //             .toList();
  //       var cards = helper.reversed.toList();
  //       if (cards.isEmpty)
  //         return Column(
  //           children: [
  //             SizedBox(
  //               height: 16.0,
  //             ),
  //             AddNewDigitalCard(
  //               type: EmptyStateType.Identity,
  //               onTap: () {
  //                 qoin.Get.to(() => SelectIdTypeScreen());
  //               },
  //             ),
  //           ],
  //         );
  //       return Swiper(
  //         itemCount: cards.length,
  //         layout: SwiperLayout.STACK,
  //         scrollDirection: Axis.vertical,
  //         loop: true,
  //         itemHeight: 300,
  //         itemWidth: double.infinity,
  //         itemBuilder: (BuildContext context, int index) {
  //           return _generateCard.generateIdentity(cards[index], controller);
  //         },
  //       );
  //     });

  _voucherTopUpTab(int index) =>
      qoin.GetBuilder<DigitalArchiveUIController>(builder: (controller) {
        var helper = [];
        if (index == 0)
          helper = controller.cardsItem
              .where((element) =>
                  element.typeCard == qoin.TypeCard.voucherTopup ||
                  element.ket == TypeCardExternal.bansos.toString())
              .toList();
        else if (index == 1)
          helper = controller.cardsItem
              .where(
                  (element) => element.typeCard == qoin.TypeCard.voucherTopup)
              .toList();
        else
          helper = controller.cardsItem
              .where((element) =>
                  element.ket == TypeCardExternal.bansos.toString())
              .toList();

        var cards = helper.reversed.toList();
        if (cards.isEmpty)
          return Column(
            children: [
              SizedBox(
                height: 16.0,
              ),
              AddNewDigitalCard(
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
            if (cards[index].ket == null)
              return _generateCard.generateVoucherTopUp(
                  cards[index], controller);
            else
              return _generateCard.generateVoucherBansos(
                  cards[index], controller);
          },
        );
      });

  _eDocumentTab(int index) =>
      qoin.GetBuilder<DigitalArchiveUIController>(builder: (controller) {
        var helper = [];
        if (index == 0)
          helper = controller.cardsItem
              .where((element) =>
                  element.ket == TypeCardExternal.kk.toString() ||
                  element.ket == TypeCardExternal.aktaLahir.toString())
              .toList();
        else if (index == 1)
          helper = controller.cardsItem
              .where((element) =>
                  element.ket == TypeCardExternal.aktaLahir.toString())
              .toList();
        else
          helper = controller.cardsItem
              .where((element) => element.ket == TypeCardExternal.kk.toString())
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
                  // qoin.Get.to(() => SentraKependudukanScreen(
                  //       onFinishCreateAktaKelahiran: () {
                  //         qoin.Get.offAll(() => HomeScreen(),
                  //             binding: qoin.OnloginBindings());
                  //       },
                  //       onFinishCreateKk: () {
                  //         qoin.Get.offAll(() => HomeScreen(),
                  //             binding: qoin.OnloginBindings());
                  //       },
                  //     ));
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
            return _generateCard.generateEDocument(cards[index], controller);
          },
        );
      });

  _eTicketTab(int index) =>
      qoin.GetBuilder<DigitalArchiveUIController>(builder: (controller) {
        var helper = [];

        /// * Otaqu Ticket
        /// * 0 = Semua ; 1 = Perjalanan/Travel; 2 = Wisata/Tour ; 3 :Membership
        if (index == 0) {
          // var allOtaqu = controller.cardsItem
          //     .where((element) =>
          //         element.runtimeType == OtaquTicketItem &&
          //         element.typeCard == qoin.TypeCard.eticket)
          //     .toList();

          // /// Adding Otaqu Member
          // var memberOtaqu = controller.cardsItem
          //     .where((element) =>
          //         element.typeCard == qoin.TypeCard.voucher &&
          //         element.ket == qoin.TypeCard.idcard.toString())
          //     .toList();
          // helper.addAll(allOtaqu);
          // helper.addAll(memberOtaqu);
        }

        //  else if (index == 1)
        // helper = controller.cardsItem
        //     .where((element) =>
        //         element.runtimeType == OtaquTicketItem &&
        //         element.typeCard == qoin.TypeCard.eticket &&
        //         (element as OtaquTicketItem).data.packageType == 'Travel')
        //     .toList();
        // else if (index == 2)
        //   helper = controller.cardsItem
        //       .where(
        //         (element) =>
        //             element.runtimeType == OtaquTicketItem &&
        //             element.typeCard == qoin.TypeCard.eticket &&
        //             (element as OtaquTicketItem).data.packageType == 'Tour',
        //       )
        //       .toList();

        /// Masuk Lainnya
        // else if (index == 4)
        //   helper = controller.cardsItem
        //       .where((element) =>
        //           element.runtimeType == OtaquTicketItem &&
        //           element.typeCard == qoin.TypeCard.eticket &&
        //           (element as OtaquTicketItem).data.packageType != 'Travel' &&
        //           (element).data.packageType != 'Tour')
        //       .toList();
        else
          helper = controller.cardsItem
              .where((element) =>
                  element.typeCard == qoin.TypeCard.voucher &&
                  element.ket == qoin.TypeCard.idcard.toString())
              .toList();
        var cards = helper.reversed.toList();
        if (cards.isEmpty)
          return Column(
            children: [
              SizedBox(
                height: 16.0,
              ),
              AddNewDigitalCard(
                type: EmptyStateType.Ticket,
                onTap: () {
                  if ((qoin.AccountsController.instance.userData?.phone ??
                              qoin.HiveData.userData?.phone) !=
                          null &&
                      (qoin.AccountsController.instance.userData?.email ??
                              qoin.HiveData.userData?.email) !=
                          null &&
                      (qoin.AccountsController.instance.userData?.fullname ??
                              qoin.HiveData.userData?.fullname) !=
                          null) {
                    if (QoinRemoteConfigController
                        .instance.IsKomodoMembershipActive) {
                      qoin.Get.to(() => OtaScreen(
                            otaType: qoin.OtaType.Membership,
                          ));
                    } else {
                      DialogUtils.showComingSoonDrawer();
                    }
                  } else {
                    DialogUtils.showCompleteProfileDrawer();
                  }
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
            return _generateCard.generateTicket(cards[index], controller);
          },
        );
      });
}

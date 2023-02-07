import 'package:flutter/material.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/functions.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/screen/payment/controllers/payment_binding.dart';
import 'package:inisa_app/ui/screen/payment/payment_screen.dart';
import 'package:inisa_app/ui/screen/services/constants/product_code.dart';
import 'package:inisa_app/ui/screen/transaction/transaction_detail/transaction_detail_screen.dart';
import 'package:inisa_app/ui/widget/button_bottom.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:inisa_app/ui/widget/services/customer_ids_widget.dart';
import 'package:inisa_app/ui/widget/services/empty_latest.dart';
import 'package:inisa_app/ui/widget/services/latests_used_item.dart';
import 'package:inisa_app/ui/widget/services/textfield_autocomplete.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'tabs/pln_postpaid_tab.dart';
import 'tabs/pln_prepaid_tab.dart';

class PlnScreen extends StatefulWidget {
  final int tabIndex;
  const PlnScreen({Key? key, this.tabIndex = 0}) : super(key: key);

  @override
  _PlnScreenState createState() => _PlnScreenState();
}

class _PlnScreenState extends State<PlnScreen> {
  final TextEditingController _customerIdController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _autocompleteKey = GlobalKey();
  bool _isPrototype = false;
  var tabIndex = 0.obs;
  bool canProceed = false;

  @override
  void initState() {
    tabIndex.value = widget.tabIndex;
    if (tabIndex.value == 0) {
      qoin.ServicesController.to.serviceId =
          qoin.Services.servicesId.electricityTokens;
    } else {
      qoin.ServicesController.to.serviceId =
          qoin.Services.servicesId.electricityPostpaid;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: qoin.ServicesController.to.isLoadingMain.stream,
      child: Scaffold(
        backgroundColor: ColorUI.white,
        appBar: AppBarWidget.light(
          title: QoinServicesLocalization.servicePlnTitle.tr,
        ),
        body: SafeArea(
          child: Column(
            children: [
              qoin.GetBuilder<qoin.ServicesController>(
                builder: (controller) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xfff6f6f6),
                          width: 10,
                        ),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    child: TextfieldAutocompleteWidget(
                      autoCompleteKey: _autocompleteKey,
                      textEditingController: _customerIdController,
                      focusNode: _focusNode,
                      listData: [],
                      onSelected: (value) {
                        _customerIdController.text = value;
                        controller.validateCustomerId(value, minLength: 11);
                        controller.setProviderNameCode(qoin.plnGroupCode);
                      },
                      title: QoinServicesLocalization
                          .servicePlnPaymentCustomerId.tr,
                      hintText: QoinServicesLocalization
                          .servicePlnHintInputPlnNumber.tr,
                      errorText: controller.customerIdError != null
                          ? QoinServicesLocalization.customerIdFormatWrong.tr
                          : null,
                      suffix: IconButton(
                        icon: _customerIdController.text.isNotEmpty
                            ? Icon(
                                Icons.close,
                                color: ColorUI.secondary,
                              )
                            : SizedBox(),
                        onPressed: _customerIdController.text.isNotEmpty
                            ? () {
                                _customerIdController.clear();
                                controller.products = [];
                                controller.customerId =
                                    _customerIdController.text;
                                if (controller.inquiryResult != null)
                                  controller.inquiryResult = null;
                              }
                            : null,
                      ),
                      onChanged: (val) {
                        controller.validateCustomerId(val, minLength: 11);
                        controller.customerId = val;
                        controller.setProviderNameCode(qoin.plnGroupCode);
                        if (controller.inquiryResult != null)
                          controller.inquiryResult = null;
                      },
                    ),
                  );
                },
              ),
              SizedBox(
                height: 16.h,
              ),
              qoin.GetBuilder<qoin.ServicesController>(builder: (controller) {
                return controller.customerId != ""
                    ? Expanded(
                        child: DefaultTabController(
                          length: 2,
                          initialIndex: tabIndex.value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                child: TabBar(
                                  onTap: (value) {
                                    tabIndex.value = value;
                                    qoin.ServicesController.to.inquiryResult =
                                        null;
                                    if (tabIndex.value == 0) {
                                      qoin.ServicesController.to.serviceId =
                                          qoin.Services.servicesId
                                              .electricityTokens;
                                    } else {
                                      qoin.ServicesController.to.serviceId =
                                          qoin.Services.servicesId
                                              .electricityPostpaid;
                                    }
                                  },
                                  physics: NeverScrollableScrollPhysics(),
                                  labelColor: Color(0xff111111),
                                  labelStyle: TextUI.subtitleBlack,
                                  unselectedLabelColor: ColorUI.disabled,
                                  indicatorColor: Colors.black,
                                  tabs: [
                                    Tab(
                                        text: QoinServicesLocalization
                                            .servicePlnPrepaid.tr),
                                    Tab(
                                        text: QoinServicesLocalization
                                            .servicePlnPostpaid.tr),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  physics: NeverScrollableScrollPhysics(),
                                  children: <Widget>[
                                    PlnPrepaidTab(),
                                    PlnPostpaidTab(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : controller.savedCustomerId.length != 0
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: CustomerIdsWidget(
                                child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: controller.savedCustomerId.length,
                              itemBuilder: (_, i) {
                                return ItemLatestUsed(
                                  serviceId:
                                      qoin.ServicesController.to.serviceId,
                                  customerId: controller.savedCustomerId[i],
                                  onTap: () {
                                    _customerIdController.clear();
                                    _customerIdController.text =
                                        controller.savedCustomerId[i];
                                    // controller.customerId =
                                    //     _customerIdController.text;
                                    // controller.quotaType = null;
                                    // controller.checkProvider(
                                    //     _customerIdController.text,
                                    //     isPrototype: _isPrototype);
                                    controller.customerId =
                                        _customerIdController.text;
                                    controller.validateCustomerId(
                                        _customerIdController.text,
                                        minLength: 11);
                                    controller
                                        .setProviderNameCode(qoin.plnGroupCode);
                                  },
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider();
                              },
                            )),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, left: 8.0, right: 8.0),
                            child: EmptyLatest(),
                          );
              })
            ],
          ),
        ),
        bottomSheet:
            qoin.GetBuilder<qoin.ServicesController>(builder: (controller) {
          if (tabIndex.value == 0) {
            if (controller.product != null) {
              return ButtonBottom(
                text: QoinServicesLocalization.servicePlnBuyNow.tr,
                onPressed: () {
                  Functions.checkEmailConfirmedBeforeInquiry(
                    onInquiry: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      controller.inquiryPpob(
                        _customerIdController.text,
                        isCallInqByGroup: true,
                        isPrototype: _isPrototype,
                        onSuccess: () {
                          print(
                              'periksa nih: ${qoin.ServicesController.to.inquiryResult?.admin}');
                          qoin.Get.to(
                            () => PaymentScreen(
                              idService:
                                  qoin.Services.servicesId.electricityTokens,
                              customerId: _customerIdController.text,
                              inquiryResult: controller.inquiryResult,
                              tabIndex: controller.tabIndex,
                              textTotal: QoinServicesLocalization
                                  .serviceMobileRechargeTotalPrice.tr,
                            ),
                            binding: PaymentBinding(typeServicePpob: 'listrik'),
                          );
                        },
                        onAlreadyPaid: () {
                          DialogUtils.showPopUp(type: DialogType.noBill);
                        },
                        onAlreadyBuy: (message, data) {
                          if (data != null) {
                            DialogUtils.showPopUp(
                              type: DialogType.transactionExist,
                              buttonFunction: () {
                                qoin.Get.back();
                                qoin.Get.to(() => TransactionDetailScreen(
                                      data: data,
                                    ));
                              },
                            );
                          } else {
                            DialogUtils.showPopUp(
                                type: DialogType.transactionExist,
                                buttonFunction: () {
                                  qoin.Get.offAll(HomeScreen(
                                    toTransaction: true,
                                  ));
                                },
                                buttonText: Localization.showTransaction.tr);
                          }
                        },
                        onNotRegistered: () {
                          DialogUtils.showPopUp(
                              type: DialogType.problem,
                              description: QoinServicesLocalization
                                  .servicePostpaidNotRegistered.tr);
                        },
                        onFailed: (error) {
                          DialogUtils.showPopUp(
                              type: DialogType.problem, description: error);
                        },
                        onOthersError: (error) {
                          DialogUtils.showPopUp(
                              type: DialogType.problem, description: error);
                        },
                      );
                    },
                  );
                },
              );
            }
            return SizedBox();
          } else {
            return controller.customerIdError == null &&
                    _customerIdController.text.isNotEmpty
                ? ButtonBottom(
                    text: controller.inquiryResult == null
                        ? QoinServicesLocalization.servicePlnCheckBill.tr
                        : QoinServicesLocalization.servicePaymentPayNow.tr,
                    onPressed: () {
                      Functions.checkEmailConfirmedBeforeInquiry(
                        onInquiry: () {
                          if (controller.inquiryResult == null) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            Functions.checkEmailConfirmedBeforeInquiry(
                              onInquiry: () {
                                controller.providerProductCode =
                                    plnPostPaidCode;
                                controller.inquiryPpob(
                                  _customerIdController.text,
                                  isCallInqByGroup: false,
                                  isPrototype: false,
                                  onSuccess: () {},
                                  onAlreadyPaid: () {
                                    DialogUtils.showPopUp(
                                        type: DialogType.noBill);
                                  },
                                  onAlreadyBuy: (message, data) {
                                    if (data != null) {
                                      DialogUtils.showPopUp(
                                        type: DialogType.transactionExist,
                                        buttonFunction: () {
                                          qoin.Get.back();
                                          qoin.Get.to(
                                              () => TransactionDetailScreen(
                                                    data: data,
                                                  ));
                                        },
                                      );
                                    } else {
                                      DialogUtils.showPopUp(
                                          type: DialogType.transactionExist,
                                          buttonFunction: () {
                                            qoin.Get.offAll(HomeScreen(
                                              toTransaction: true,
                                            ));
                                          },
                                          buttonText:
                                              Localization.showTransaction.tr);
                                    }
                                  },
                                  onNotRegistered: () {
                                    DialogUtils.showPopUp(
                                        type: DialogType.problem,
                                        description: QoinServicesLocalization
                                            .servicePostpaidNotRegistered.tr);
                                  },
                                  onFailed: (error) {
                                    DialogUtils.showPopUp(
                                        type: DialogType.problem);
                                  },
                                  onOthersError: (error) {
                                    DialogUtils.showPopUp(
                                        type: DialogType.problem,
                                        description: error);
                                  },
                                );
                              },
                            );
                          } else {}
                        },
                      );
                    },
                  )
                : SizedBox();
          }
        }),
      ),
    );
  }
}

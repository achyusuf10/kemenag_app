import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/screen/payment/controllers/payment_binding.dart';
import 'package:inisa_app/ui/screen/payment/payment_screen.dart';
import 'package:inisa_app/ui/screen/transaction/transaction_detail/transaction_detail_screen.dart';
import 'package:inisa_app/ui/widget/button_bottom.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:inisa_app/ui/widget/services/empty_latest.dart';
import 'package:inisa_app/ui/widget/services/latests_used_item.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:qoin_sdk/helpers/utils/intl_formats.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/helper/functions.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/ui/widget/services/textfield_autocomplete.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/services/invoice_tile_widget.dart';
import 'package:qoin_sdk/helpers/constants/provider_name_code.dart';

class TelephoneScreen extends StatefulWidget {
  TelephoneScreen({key}) : super(key: key);

  @override
  State<TelephoneScreen> createState() => _TelephoneScreenState();
}

class _TelephoneScreenState extends State<TelephoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customerIdController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _autocompleteKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    ServicesController.to.serviceId = Services.servicesId.telephone;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: ServicesController.to.isLoadingMain.stream,
      child: Scaffold(
        appBar: AppBarWidget.light(
          title: QoinServicesLocalization.serviceTelephoneTitle.tr,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xfff6f6f6),
                          width: 10,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 24.h),
                      child: GetBuilder<ServicesController>(builder: (controller) {
                        return TextfieldAutocompleteWidget(
                          autoCompleteKey: _autocompleteKey,
                          textEditingController: _customerIdController,
                          focusNode: _focusNode,
                          listData: [],
                          onSelected: (value) {
                            _customerIdController.text = value;
                            // controller.inquiryResult = null;
                            // controller.validateCustomerId(_customerIdController.text);
                          },
                          title: QoinServicesLocalization.servicePaymentCustomerId.tr,
                          hintText: QoinServicesLocalization.serviceGasHintInputCustomerId.tr,
                          errorText: controller.customerIdError != null
                              ? QoinServicesLocalization.customerIdFormatWrong.tr
                              : null,
                          prefix: Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(right: 8),
                            child: Image.asset(
                              Assets.telkomIndonesiaIcon,
                              height: 19,
                              width: 34,
                            ),
                          ),
                          suffix: IconButton(
                            icon: _customerIdController.text.isNotEmpty ? Icon(Icons.close) : SizedBox(),
                            onPressed: _customerIdController.text.isNotEmpty
                                ? () {
                                    _customerIdController.clear();
                                    controller.inquiryResult = null;
                                    controller.validateCustomerIdTelehone(_customerIdController.text);
                                  }
                                : null,
                          ),
                          onChanged: (val) {
                            controller.inquiryResult = null;
                            controller.validateCustomerIdTelehone(_customerIdController.text);
                          },
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight * 2),
                              child: Column(
                                children: [
                                  GetBuilder<ServicesController>(builder: (controller) {
                                    return controller.inquiryResult != null
                                        ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                  QoinServicesLocalization
                                                      .servicePostpaidPaymentInvoiceDetail.tr,
                                                  style: TextUI.subtitleBlack),
                                              Divider(
                                                height: 32,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: kBottomNavigationBarHeight * 2),
                                                child: Column(
                                                  children: [
                                                    InvoiceTile(
                                                      invoiceTitle: QoinServicesLocalization
                                                          .servicePaymentCustomerName.tr,
                                                      invoiceBody: controller.inquiryResult?.namaPelanggan,
                                                    ),
                                                    InvoiceTile(
                                                      invoiceTitle:
                                                          QoinServicesLocalization.servicePaymentPeriods.tr,
                                                      invoiceBody: Functions.convertPeriode(
                                                        serviceId: 0,
                                                        value: controller.inquiryResult?.periode,
                                                      ),
                                                    ),
                                                    InvoiceTile(
                                                      invoiceTitle:
                                                          QoinServicesLocalization.serviceTotalBill.tr,
                                                      invoiceBody:
                                                          int.parse(controller.inquiryResult?.nominal ?? "0")
                                                              .formatCurrencyRp,
                                                    ),
                                                    // if (controller.inquiryResult.admin != null &&
                                                    //     controller.inquiryResult.admin.isNotEmpty)
                                                    //   InvoiceTile(
                                                    //     invoiceTitle: QoinServicesLocalization.servicePostpaidPaymentAdminFee.tr,
                                                    //     invoiceBody: int.parse("0").formatCurrencyRp,
                                                    //   ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : controller.savedCustomerId.length != 0
                                            ? Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    Localization.trxLatest.tr,
                                                    style: TextUI.subtitleBlack,
                                                  ),
                                                  SizedBox(
                                                    height: 16,
                                                  ),
                                                  ListView.separated(
                                                    shrinkWrap: true,
                                                    itemCount: controller.savedCustomerId.length,
                                                    itemBuilder: (_, i) {
                                                      return ItemLatestUsed(
                                                        serviceId: Services.servicesId.telephone,
                                                        customerId: controller.savedCustomerId[i],
                                                        onTap: () {
                                                          _customerIdController.clear();
                                                          _customerIdController.text =
                                                              controller.savedCustomerId[i];
                                                          controller
                                                              .validateCustomerId(_customerIdController.text);
                                                        },
                                                      );
                                                    },
                                                    separatorBuilder: (BuildContext context, int index) {
                                                      return Divider();
                                                    },
                                                  ),
                                                ],
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.only(top: 42.0, left: 8.0, right: 8.0),
                                                child: Center(child: EmptyLatest()),
                                              );
                                  })
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: GetBuilder<ServicesController>(builder: (controller) {
          return _customerIdController.text.isNotEmpty && controller.customerIdError == null
              ? ButtonBottom(
                  text: (ServicesController.to.inquiryResult == null)
                      ? QoinServicesLocalization.serviceInettvCheckBill.tr
                      : QoinServicesLocalization.servicePaymentPayNow.tr,
                  onPressed: () {
                    Functions.checkEmailConfirmedBeforeInquiry(
                      onInquiry: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (controller.inquiryResult == null) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          controller.providerProductCode = teleponCode;
                          controller.inquiryPpob(
                            _customerIdController.text,
                            isCallInqByGroup: false,
                            isPrototype: false,
                            onSuccess: () {},
                            onAlreadyPaid: () {
                              DialogUtils.showPopUp(type: DialogType.noBill);
                            },
                            onAlreadyBuy: (message, data) {
                              if (data != null) {
                                DialogUtils.showPopUp(
                                  type: DialogType.transactionExist,
                                  buttonFunction: () {
                                    Get.back();
                                    Get.to(() => TransactionDetailScreen(
                                          data: data,
                                        ));
                                  },
                                );
                              } else {
                                DialogUtils.showPopUp(
                                    type: DialogType.transactionExist,
                                    buttonFunction: () {
                                      Get.offAll(HomeScreen(
                                        toTransaction: true,
                                      ));
                                    },
                                    buttonText: Localization.showTransaction.tr);
                              }
                            },
                            onNotRegistered: () {
                              DialogUtils.showPopUp(
                                  type: DialogType.problem,
                                  description: QoinServicesLocalization.servicePostpaidNotRegistered.tr);
                            },
                            onFailed: (error) {
                              DialogUtils.showPopUp(type: DialogType.problem);
                            },
                            onOthersError: (error) {
                              DialogUtils.showPopUp(type: DialogType.problem, description: error);
                            },
                          );
                        } else {
                          Get.to(
                            () => PaymentScreen(
                              idService: Services.servicesId.telephone,
                              customerId: _customerIdController.text,
                              tabIndex: controller.tabIndex,
                              inquiryResult: controller.inquiryResult,
                              textTotal: QoinServicesLocalization.serviceMobileRechargeTotalPrice.tr,
                            ),
                            binding: PaymentBinding(),
                          );
                        }
                      },
                    );
                  },
                )
              : SizedBox();
        }),
      ),
    );
  }
}

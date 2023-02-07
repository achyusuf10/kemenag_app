import 'package:flutter/material.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/functions.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/screen/payment/controllers/payment_binding.dart';
import 'package:inisa_app/ui/screen/payment/payment_screen.dart';
import 'package:inisa_app/ui/screen/transaction/transaction_detail/transaction_detail_screen.dart';
import 'package:inisa_app/ui/widget/button_bottom.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:inisa_app/ui/widget/services/customer_ids_widget.dart';
import 'package:inisa_app/ui/widget/services/empty_latest.dart';
import 'package:inisa_app/ui/widget/services/invoice_tile_widget.dart';
import 'package:inisa_app/ui/widget/services/latests_used_item.dart';
import 'package:inisa_app/ui/widget/services/textfield_autocomplete.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:qoin_sdk/helpers/utils/intl_formats.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GasScreen extends StatefulWidget {
  const GasScreen({Key? key}) : super(key: key);

  @override
  _GasScreenState createState() => _GasScreenState();
}

class _GasScreenState extends State<GasScreen> {
  final GlobalKey _autocompleteKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customerIdController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    qoin.ServicesController.to.serviceId = qoin.Services.servicesId.gas;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: qoin.ServicesController.to.isLoadingMain.stream,
      child: Scaffold(
        appBar: AppBarWidget.light(
          title: QoinServicesLocalization.serviceGasTitle.tr,
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
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                        child: qoin.GetBuilder<qoin.ServicesController>(builder: (controller) {
                          // return MainTextField(
                          //   labelText: QoinServicesLocalization.serviceGasPaymentCustomerId.tr,
                          //   hintText: QoinServicesLocalization.serviceGasHintInputCustomerId.tr,
                          //   controller: _customerIdController,
                          //   focusNode: _focusNode,
                          //   suffix: IconButton(
                          //     icon: _customerIdController.text.isNotEmpty
                          //         ? Icon(Icons.close)
                          //         : SizedBox(),
                          //     onPressed: _customerIdController.text.isNotEmpty
                          //         ? () {
                          //             _customerIdController.clear();
                          //             controller.inquiryResult = null;
                          //             controller.validateCustomerId(_customerIdController.text);
                          //           }
                          //         : null,
                          //   ),
                          //   onChange: (val) {
                          //     controller.inquiryResult = null;
                          //     controller.validateCustomerId(val);
                          //   },
                          // );
                          return TextfieldAutocompleteWidget(
                            autoCompleteKey: _autocompleteKey,
                            textEditingController: _customerIdController,
                            focusNode: _focusNode,
                            listData: [],
                            onSelected: (value) {},
                            title: QoinServicesLocalization.serviceGasPaymentCustomerId.tr,
                            hintText: QoinServicesLocalization.serviceGasHintInputCustomerId.tr,
                            errorText: controller.customerIdError == "invalid"
                                ? QoinServicesLocalization.serviceGasErrorCustomerId.tr
                                : null,
                            suffix: IconButton(
                              icon: _customerIdController.text.isNotEmpty ? Icon(Icons.close) : SizedBox(),
                              onPressed: _customerIdController.text.isNotEmpty
                                  ? () {
                                      _customerIdController.clear();
                                      controller.inquiryResult = null;
                                      controller.validateCustomerId(_customerIdController.text);
                                    }
                                  : null,
                            ),
                            onChanged: (val) {
                              controller.inquiryResult = null;
                              controller.validateCustomerId(val);
                            },
                          );
                        })),
                  ),
                  Padding(
                      padding: EdgeInsets.all(16.w),
                      child: qoin.GetBuilder<qoin.ServicesController>(builder: (controller) {
                        return controller.inquiryResult != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    QoinServicesLocalization.servicePostpaidPaymentInvoiceDetail.tr,
                                    style: TextUI.title2Black,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 16.h, bottom: kBottomNavigationBarHeight * 2),
                                    child: Column(
                                      children: [
                                        InvoiceTile(
                                          invoiceTitle:
                                              QoinServicesLocalization.servicePaymentCustomerName.tr,
                                          invoiceBody: controller.inquiryResult?.namaPelanggan,
                                        ),
                                        InvoiceTile(
                                          invoiceTitle: QoinServicesLocalization.servicePaymentPeriods.tr,
                                          invoiceBody: Functions.convertPeriode(
                                            serviceId: 0,
                                            value: controller.inquiryResult?.periode,
                                          ),
                                        ),
                                        InvoiceTile(
                                          invoiceTitle:
                                              QoinServicesLocalization.servicePostpaidTotalCharge.tr,
                                          invoiceBody: int.parse(controller.inquiryResult?.nominal ?? "0")
                                              .formatCurrencyRp,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : controller.savedCustomerId.length != 0
                                ? CustomerIdsWidget(
                                    child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: controller.savedCustomerId.length,
                                    itemBuilder: (_, i) {
                                      return ItemLatestUsed(
                                        serviceId: qoin.Services.servicesId.gas,
                                        customerId: controller.savedCustomerId[i],
                                        onTap: () {
                                          _customerIdController.clear();
                                          _customerIdController.text = controller.savedCustomerId[i];
                                          controller.validateCustomerId(_customerIdController.text);
                                        },
                                      );
                                    },
                                    separatorBuilder: (BuildContext context, int index) {
                                      return Divider();
                                    },
                                  ))
                                : Padding(
                                    padding: const EdgeInsets.only(top: 42.0, left: 8.0, right: 8.0),
                                    child: Center(child: EmptyLatest()),
                                  );
                      })),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: qoin.GetBuilder<qoin.ServicesController>(
          builder: (controller) {
            return controller.phoneNumberInvalid == null && _customerIdController.text.isNotEmpty
                ? ButtonBottom(
                    onPressed: () {
                      Functions.checkEmailConfirmedBeforeInquiry(
                        onInquiry: () {
                          if (controller.inquiryResult == null) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            controller.providerProductCode = 'GAS';
                            controller.inquiryPpob(
                              _customerIdController.text,
                              isCallInqByGroup: false,
                              onSuccess: () {},
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
                            qoin.Get.to(
                              () => PaymentScreen(
                                idService: qoin.Services.servicesId.gas,
                                inquiryResult: controller.inquiryResult,
                                customerId: _customerIdController.text,
                                tabIndex: controller.tabIndex,
                                textTotal: QoinServicesLocalization.serviceMobileRechargeTotalPrice.tr,
                              ),
                              binding: PaymentBinding(),
                            );
                          }
                        },
                      );
                    },
                    text: controller.inquiryResult == null
                        ? QoinServicesLocalization.servicePostpaidCheckNow.tr
                        : QoinServicesLocalization.servicePostpaidPayNow.tr,
                  )
                : SizedBox();
          },
        ),
      ),
    );
  }
}

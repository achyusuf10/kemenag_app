import 'package:flutter/material.dart';
import 'package:inisa_app/helper/any_utils.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/functions.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/screen/payment/controllers/payment_binding.dart';
import 'package:inisa_app/ui/screen/payment/payment_screen.dart';
import 'package:inisa_app/ui/screen/services/constants/product_code.dart';
import 'package:inisa_app/ui/screen/transaction/transaction_detail/transaction_detail_screen.dart';
import 'package:inisa_app/ui/widget/button_bottom.dart';
import 'package:inisa_app/ui/widget/button_main.dart';
import 'package:inisa_app/ui/widget/modal_progress.dart';
import 'package:inisa_app/ui/widget/services/customer_ids_widget.dart';
import 'package:inisa_app/ui/widget/services/empty_latest.dart';
import 'package:inisa_app/ui/widget/services/latests_used_item.dart';
import 'package:inisa_app/ui/widget/services/textfield_autocomplete.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/services/invoice_tile_widget.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:qoin_sdk/helpers/utils/intl_formats.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../contact_page.dart';

class PostpaidScreen extends StatefulWidget {
  const PostpaidScreen({Key? key}) : super(key: key);

  @override
  _PostpaidScreenState createState() => _PostpaidScreenState();
}

class _PostpaidScreenState extends State<PostpaidScreen> {
  final TextEditingController _customerIdController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _autocompleteKey = GlobalKey();
  bool isPrototype = false;

  @override
  void initState() {
    super.initState();
    if (qoin.HiveData.userData!.phone!.startsWith('62')) {
      _customerIdController.text = '0' + AnyUtils.phoneNumberConvert(qoin.HiveData.userData!.phone!);
      qoin.ServicesController.to
          .checkProvider(_customerIdController.text, isPrepaid: false, isPrototype: isPrototype);
    }
    qoin.ServicesController.to.serviceId = qoin.Services.servicesId.postpaid;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: qoin.ServicesController.to.isLoadingMain.stream,
      child: Scaffold(
        appBar: AppBarWidget.light(
          title: QoinServicesLocalization.servicePostpaidTitle.tr,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xfff6f6f6),
                        width: 10,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: qoin.GetBuilder<qoin.ServicesController>(builder: (controller) {
                              return Padding(
                                padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 16),
                                child: TextfieldAutocompleteWidget(
                                  autoCompleteKey: _autocompleteKey,
                                  textEditingController: _customerIdController,
                                  focusNode: _focusNode,
                                  listData: [],
                                  onSelected: (value) {
                                    _customerIdController.text = value;
                                    controller.checkProvider(_customerIdController.text,
                                        isPrepaid: false, isPrototype: isPrototype);
                                  },
                                  title: QoinServicesLocalization.servicePostpaidPhoneNumber.tr,
                                  hintText: QoinServicesLocalization.serviceMobileRechargePhoneNumberHint.tr,
                                  errorText: controller.phoneNumberInvalid,
                                  suffix: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      if (controller.providerLogo != null)
                                        Image.asset(
                                          controller.providerLogo!,
                                          package: qoin.QoinSdk.packageName,
                                          height: 24,
                                          width: 24,
                                        ),
                                      _customerIdController.text.isNotEmpty
                                          ? IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                _customerIdController.clear();
                                                controller.inquiryResult = null;
                                                controller.checkProvider(_customerIdController.text,
                                                    isPrepaid: false, isPrototype: isPrototype);
                                              },
                                            )
                                          : IconButton(
                                              icon: Image.asset(
                                                Assets.bookIcon,
                                                height: 20,
                                                width: 20,
                                                color: Color(0xff969696),
                                              ),
                                              onPressed: () async {
                                                var data = await qoin.Get.to(() => ContactPage());
                                                if (data != null) {
                                                  // TODO: INI DI DISKUSIKAN DULU MUNGKIN?
                                                  _customerIdController.text = '0' +
                                                      AnyUtils.phoneNumberConvert(
                                                          qoin.HiveData.userData!.phone!);
                                                  controller.inquiryResult = null;
                                                  controller.checkProvider(_customerIdController.text,
                                                      isPrepaid: false, isPrototype: isPrototype);
                                                }
                                              },
                                            ),
                                    ],
                                  ),
                                  onChanged: (value) {
                                    controller.checkProvider(value,
                                        isPrepaid: false, isPrototype: isPrototype);
                                  },
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 24),
                  child: qoin.GetBuilder<qoin.ServicesController>(builder: (controller) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        controller.inquiryResult != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    QoinServicesLocalization.servicePostpaidPaymentInvoiceDetail.tr,
                                    style: TextUI.subtitleBlack,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 15, bottom: kBottomNavigationBarHeight * 2),
                                    child: Column(
                                      children: [
                                        InvoiceTile(
                                          invoiceTitle:
                                              QoinServicesLocalization.servicePaymentCustomerName.tr,
                                          invoiceBody: controller.inquiryResult?.namaPelanggan,
                                        ),
                                        InvoiceTile(
                                          invoiceTitle: QoinServicesLocalization.servicePaymentPeriods.tr,
                                          invoiceBody: (controller.inquiryResult?.periode != null &&
                                                  controller.inquiryResult!.periode!.isNotEmpty &&
                                                  controller.inquiryResult!.periode != '000000')
                                              ? Functions.convertPeriode(
                                                  serviceId: 0,
                                                  value: controller.inquiryResult?.periode,
                                                )
                                              : "-",
                                        ),
                                        InvoiceTile(
                                          invoiceTitle:
                                              QoinServicesLocalization.servicePostpaidTotalCharge.tr,
                                          invoiceBody: controller.inquiryResult?.totalPrice?.formatCurrencyRp,
                                          isLarge: true,
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
                                        serviceId: qoin.Services.servicesId.postpaid,
                                        customerId: controller.savedCustomerId[i],
                                        onTap: () {
                                          _customerIdController.text = controller.savedCustomerId[i];
                                          controller.checkProvider(_customerIdController.text,
                                              isPrepaid: false, isPrototype: isPrototype);
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
                                  )
                      ],
                    );
                  }),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
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

                            controller.providerProductCode = pulsaPascaBayar;

                            controller.inquiryPpob(
                              _customerIdController.text,
                              isCallInqByGroup: false,
                              isPrototype: isPrototype,
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
                                idService: qoin.Services.servicesId.postpaid,
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

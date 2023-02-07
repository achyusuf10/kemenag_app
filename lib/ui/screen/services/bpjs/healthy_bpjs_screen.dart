import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/helper/functions.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
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
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/ui/widget/services/textfield_autocomplete.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';

class HealthyBpjsScreen extends StatefulWidget {
  HealthyBpjsScreen({Key? key}) : super(key: key);

  @override
  State<HealthyBpjsScreen> createState() => _HealthyBpjsScreenState();
}

class _HealthyBpjsScreenState extends State<HealthyBpjsScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController _customerIdController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  final GlobalKey _autocompleteKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    ServicesController.to.serviceId = Services.servicesId.bpjsKesehatan;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgress(
      loadingStatus: ServicesController.to.isLoadingMain.stream,
      child: Scaffold(
          appBar: AppBarWidget.light(
            title: QoinServicesLocalization.serviceHealthyBpjsTitle.tr,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: formKey,
                    child: Container(
                      padding: EdgeInsets.only(
                          /* bottom: ServicesController.to.periodDates.isNotEmpty &&
                                  _customerIdController.text.isNotEmpty &&
                                  ServicesController.to.customerIdError == null
                              ? 100
                              : 16 */
                          ),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GetBuilder<ServicesController>(builder: (controller) {
                              return TextfieldAutocompleteWidget(
                                autoCompleteKey: _autocompleteKey,
                                textEditingController: _customerIdController,
                                focusNode: _focusNode,
                                listData: /* controller.savedCustomerId */ [],
                                onSelected: (value) {
                                  _customerIdController.text = value;
                                  controller.customerId = value;
                                  controller.inquiryResult = null;
                                  controller.validateCustomerId(_customerIdController.text);
                                },
                                title: QoinServicesLocalization.serviceHealthyBpjsNoVa.tr,
                                hintText: QoinServicesLocalization.serviceHealthyBpjsNoVaHint.tr,
                                errorText: controller.customerIdError != null
                                    ? "nomor pelanggan belum sesuai"
                                    : null,
                                maxLength: 20,
                                suffix: IconButton(
                                  icon: _customerIdController.text.isNotEmpty
                                      ? Icon(Icons.close)
                                      : Image.asset(
                                          Assets.logoMiniBpjs,
                                          height: 20,
                                          width: 20,
                                        ),
                                  onPressed: _customerIdController.text.isNotEmpty
                                      ? () {
                                          _customerIdController.clear();
                                          controller.customerId = _customerIdController.text;
                                          controller.inquiryResult = null;
                                          controller.validateCustomerId(_customerIdController.text);
                                        }
                                      : null,
                                ),
                                onChanged: (val) {
                                  controller.inquiryResult = null;
                                  controller.validateCustomerId(val);
                                  controller.customerId = val;
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  GetBuilder<ServicesController>(builder: (controller) {
                    return controller.customerId != ""
                        ? Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  QoinServicesLocalization.serviceHealthyBpjsPaymentPeriods.tr,
                                  style: TextUI.title2Black,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  QoinServicesLocalization.serviceHealthyBpjsPaymentPeriodsDesc.tr,
                                  style: TextUI.bodyTextBlack,
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                GridView.count(
                                  crossAxisCount: 3,
                                  childAspectRatio: MediaQuery.of(context).size.width /
                                      (MediaQuery.of(context).size.height / 3.5.h),
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: controller
                                      .periodMonthYear()
                                      .map(
                                        (e) => InkWell(
                                          onTap: () {
                                            var index = controller.periodMonthYear().indexOf(e);
                                            controller.addPeriods(index);
                                          },
                                          child: Card(
                                            color: Colors.white,
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                                border: Border.all(
                                                    color: controller.periodDates.any((element) =>
                                                            element ==
                                                            controller.periodMonthYear().indexOf(e))
                                                        ? ColorUI.secondary
                                                        : Colors.transparent,
                                                    width: 1),
                                                color: controller.periodDates.any((element) =>
                                                        element == controller.periodMonthYear().indexOf(e))
                                                    ? Color(0xfff9f3f2)
                                                    : Colors.white,
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "${DateFormat.MMMM().format(e)}",
                                                    style: TextUI.bodyTextBlack,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    "${e.year}",
                                                    style: TextUI.bodyTextBlack,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          )
                        : controller.savedCustomerId.length != 0
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: CustomerIdsWidget(
                                    child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: controller.savedCustomerId.length,
                                  itemBuilder: (_, i) {
                                    return ItemLatestUsed(
                                      serviceId: Services.servicesId.bpjsKesehatan,
                                      customerId: controller.savedCustomerId[i],
                                      onTap: () {
                                        _customerIdController.clear();
                                        _customerIdController.text = controller.savedCustomerId[i];
                                        controller.customerId = _customerIdController.text;
                                        controller.quotaType = null;
                                        controller.checkProvider(_customerIdController.text);
                                      },
                                    );
                                  },
                                  separatorBuilder: (BuildContext context, int index) {
                                    return Divider();
                                  },
                                )),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 42.0, left: 8.0, right: 8.0),
                                child: Center(child: EmptyLatest()),
                              );
                  }),
                ],
              ),
            ),
          ),
          bottomSheet: GetBuilder<ServicesController>(builder: (controller) {
            return controller.periodDates.isNotEmpty &&
                    _customerIdController.text.isNotEmpty &&
                    controller.customerIdError == null
                ? ButtonBottom(
                    onPressed: () {
                      Functions.checkEmailConfirmedBeforeInquiry(
                        onInquiry: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          controller.providerNameCode = asuransiGroupCode;
                          controller.providerProductCode = bpjsKesehatanCode;
                          controller.inquiryPpob(
                            _customerIdController.text,
                            periodes: controller.periodDates.length.toString(),
                            isCallInqByGroup: false,
                            onSuccess: () {
                              Get.to(
                                () => PaymentScreen(
                                  idService: Services.servicesId.bpjsKesehatan,
                                  inquiryResult: controller.inquiryResult,
                                  customerId: _customerIdController.text,
                                  tabIndex: controller.tabIndex,
                                  textTotal: QoinServicesLocalization.serviceMobileRechargeTotalPrice.tr,
                                ),
                                binding: PaymentBinding(),
                              );
                            },
                            onAlreadyPaid: () {
                              DialogUtils.showPopUp(type: DialogType.noBill);
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
                          );
                        },
                      );
                    },
                    text: QoinServicesLocalization.serviceHealthyBpjsPayNow.tr,
                  )
                : SizedBox();
          })),
    );
  }
}

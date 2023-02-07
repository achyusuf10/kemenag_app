import 'package:app_settings/app_settings.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/localization/qoin_services_localization.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/screen/services/peduli_lindungi/pl_scanner_page.dart';
import 'package:inisa_app/ui/screen/home/tooltips.dart';
import 'package:qoin_sdk/controllers/qoin_services/pl_controllers.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/ui_color.dart';
// import 'package:venturo_mobile/cms/screens/cms_home_screen.dart';

import 'controller/menu_services_controller.dart';
import 'models/service_data_model.dart';
import 'models/services_id_model.dart';
import 'package:location/location.dart' as loc;

class MenuServicesWidget extends StatelessWidget {
  final List<ServiceDataModel> services;
  final bool isFavorite;
  final bool isEdit;
  final GlobalKey? allServicesKey;

  const MenuServicesWidget({
    key,
    required this.services,
    this.isFavorite = false,
    this.isEdit = false,
    this.allServicesKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: services.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, childAspectRatio: 0.95),
      itemBuilder: (context, index) {
        return InkWell(
          onDoubleTap: () {
            // if (services[index].id == ServicesIdModel().civilRegistration) {
            //   qoin.Get.to(() => CmsHomeScreen());
            // }
          },
          onTap: isEdit
              ? () {
                  if (isFavorite) {
                    MenuServicesController.to.removeFavorite(services[index]);
                  } else {
                    MenuServicesController.to.addFavorite(services[index]);
                  }
                }
              : () async {
                  if (services[index].page != null) {
                    if (services[index].isActive) {
                      if (services[index].id ==
                              qoin.Services.servicesId.screeningCovid ||
                          services[index].id ==
                              qoin.Services.servicesId.onlineCommerce) {
                        // if (InterModule.userFullName == null ||
                        //     QoinServices.userNoHp == null ||
                        //     QoinServices.userEmail == null) {
                        //   widgets.QWDialogUtils.showCompleteProfileDrawer();
                        // } else {
                        //   Get.to(
                        //     services[index].page,
                        //     arguments: services[index].category,
                        //     binding: services[index].binding,
                        //   );
                        // }
                      } else if (services[index].id ==
                              qoin.Services.servicesId.ticketWisata ||
                          services[index].id ==
                              qoin.Services.servicesId.travel ||
                          services[index].id ==
                              qoin.Services.servicesId.otaquMembership) {
                        if ((qoin.AccountsController.instance.userData?.phone ??
                                    qoin.HiveData.userData?.phone) !=
                                null &&
                            (qoin.AccountsController.instance.userData?.email ??
                                    qoin.HiveData.userData?.email) !=
                                null &&
                            (qoin.AccountsController.instance.userData
                                        ?.fullname ??
                                    qoin.HiveData.userData?.fullname) !=
                                null) {
                          // if (services[index].id ==
                          //         qoin.Services.servicesId.otaquMembership &&
                          //     (qoin.AccountsController.instance.userData
                          //                 ?.nIKConfirmed ??
                          //             qoin.HiveData.userData?.nIKConfirmed) !=
                          //         true) {
                          //   DialogUtils.showMainPopup(
                          //       image: Assets.icAddKTP,
                          //       title:
                          //           DigitalIdLocalization.unverifiedKTPTitle.tr,
                          //       mainPopupButtonDirection:
                          //           MainPopupButtonDirection.Horizontal,
                          //       description:
                          //           'Harap verifikasi KTP anda terlebih dahulu sebelum menambahkan Komodo Membership',
                          //       secondaryButtonText: Localization.maybeLater.tr,
                          //       secondaryButtonFunction: () {
                          //         qoin.Get.back();
                          //       },
                          //       mainButtonText: DigitalIdLocalization
                          //           .unverifiedKTPButton.tr,
                          //       mainButtonFunction: () async {
                          //         qoin.Get.back();
                          //         qoin.Get.to(() => SelectIdTypeScreen());
                          //       });
                          //   return;
                          // }
                          qoin.Get.to(
                            services[index].page,
                            arguments: services[index].category,
                            binding: services[index].binding,
                          );
                        } else {
                          DialogUtils.showCompleteProfileDrawer();
                        }
                      } else if (services[index].id ==
                          ServicesIdModel().peduliLindungi) {
                        if (qoin.HiveData.plAuthToken == null) {
                          qoin.Get.to(
                            services[index].page,
                            arguments: services[index].category,
                            binding: services[index].binding,
                          );
                        } else {
                          qoin.Get.to(
                            PLScannerPage(),
                            arguments: services[index].category,
                            binding: PLBindings(),
                          );
                        }
                      } else if (services[index].id ==
                          ServicesIdModel().locationCenter) {
                        var _permissionStatus =
                            await qoin.Permission.location.status;
                        if (_permissionStatus.isDenied ||
                            _permissionStatus.isPermanentlyDenied) {
                          await qoin.Permission.location.request();
                          _permissionStatus =
                              await qoin.Permission.location.status;
                          if (_permissionStatus.isDenied ||
                              _permissionStatus.isPermanentlyDenied) {
                            DialogUtils.showMainPopup(
                                image: Assets.accesLocation,
                                title: QoinServicesLocalization.plAccessLoc.tr,
                                description:
                                    'Location access is required to displayed your position on the map, help you find nearby places you’ll love and check-in to places',
                                mainButtonFunction: () async {
                                  qoin.Get.back();
                                  await qoin.openAppSettings();
                                },
                                mainButtonText: 'App Setting',
                                secondaryButtonFunction: () async {
                                  qoin.Get.back();
                                },
                                secondaryButtonText:
                                    Localization.contactCancel.tr,
                                mainPopupButtonDirection:
                                    MainPopupButtonDirection.Horizontal);
                          }
                          return;
                        }
                        loc.Location location = new loc.Location();
                        var _serviceEnabled = await location.serviceEnabled();
                        if (!_serviceEnabled) {
                          await DialogUtils.showMainPopup(
                              image: Assets.accesLocation,
                              title: 'Enable Location Setting',
                              description:
                                  'Location setting is needed to displayed your position on the map, help you find nearby places you’ll love and check-in to places',
                              mainButtonFunction: () {
                                qoin.Get.back();
                                AppSettings.openLocationSettings();
                              },
                              mainButtonText: 'Enable',
                              secondaryButtonFunction: () {
                                qoin.Get.back();
                              },
                              secondaryButtonText:
                                  Localization.contactCancel.tr,
                              mainPopupButtonDirection:
                                  MainPopupButtonDirection.Horizontal);
                          if (!_serviceEnabled) {
                            return;
                          }
                        }
                        if (_serviceEnabled &&
                            !_permissionStatus.isDenied &&
                            !_permissionStatus.isPermanentlyDenied) {
                          qoin.Get.to(
                            services[index].page,
                            arguments: services[index].category,
                            binding: services[index].binding,
                          );
                        }
                      } else {
                        qoin.Get.to(
                          services[index].page,
                          arguments: services[index].category,
                          binding: services[index].binding,
                        );
                      }
                    } else {
                      DialogUtils.showComingSoonDrawer();
                    }
                  } else {
                    DialogUtils.showComingSoonDrawer();
                  }
                },
          child: Column(
            children: [
              Column(
                key: services[index].id == 0 ? allServicesKey : null,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 40.w,
                    width: 40.w,
                    child: Stack(
                      children: [
                        if (isEdit &&
                            !isFavorite &&
                            MenuServicesController.to.menuServicesFavorite.any(
                                (element) => element.id == services[index].id))
                          ColorFiltered(
                              colorFilter: ColorUI.greyscale,
                              child: Image.asset(services[index].imageAsset))
                        else
                          Center(
                              child: Image.asset(services[index].imageAsset)),
                        if (isEdit && isFavorite)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 8,
                              backgroundColor: Color(0xffeb4141),
                              child: Container(
                                width: 8,
                                height: 2,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1.125)),
                                  color: const Color(0xffffffff),
                                ),
                              ),
                            ),
                          ),
                        if (isEdit && !isFavorite)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 8,
                              backgroundColor: MenuServicesController
                                      .to.menuServicesFavorite
                                      .any((element) =>
                                          element.id == services[index].id)
                                  ? Colors.grey
                                  : ColorUI.blue,
                              child: Icon(
                                Icons.add,
                                color: Color(0xffffffff),
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.w,
                  ),
                  Flexible(
                    child: Text(services[index].name,
                        style: TextUI.bodyText2Black,
                        textAlign: TextAlign.center),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

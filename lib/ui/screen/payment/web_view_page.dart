import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:inisa_app/helper/constans.dart';
import 'package:inisa_app/helper/dialog_util.dart';
import 'package:inisa_app/helper/enums.dart';
import 'package:inisa_app/logic/controller/digitalid/digital_archive_ui_controller.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:qoin_sdk/helpers/services/environment.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

class WebViewPage extends StatefulWidget {
  final bool isPayment;
  final String title;
  final String url;
  final Function()? onBack;

  const WebViewPage(
      {required this.title,
      required this.url,
      this.onBack,
      this.isPayment = false});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> with WidgetsBindingObserver {
  InAppWebViewController? webView;
  String url = "";
  double progress = 0;
  String urlError = """<!DOCTYPE html>
  <html>
  <body>
  </body>
  </html>""";
  String errorMessage = "Someting went wrong, please try again later.";

  // OTAQU MEMBERSHIP
  bool activationUrl = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  bool canBackHome = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (canBackHome) {
        Get.back();
        // if (Platform.isIOS) {        
          // gets.Get.offAll(() => HomeScreen(), binding: OnloginBindings(), transition: Transition.leftToRight);
        // }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isPayment) {
          return false;
        } else {
          if (await webView!.canGoBack()) {
            webView!.goBack();
            return false;
          } else {
            Get.back();
            return false;
          }
        }
      },
      child: Scaffold(
        appBar: !widget.isPayment
            ? AppBarWidget.light(
                title: widget.title,
                onBack: () {
                  Get.back();
                  // if (Platform.isIOS) {
                    // gets.Get.offAll(() => HomeScreen(), binding: OnloginBindings(), transition: Transition.leftToRight);
                  // }
                },
              )
            : null,
        body: SafeArea(
          child: Column(
            children: [
              // if (!widget.isPayment)
              //   Row(
              //     children: [
              //       IconButton(
              //         icon: Icon(Icons.close),
              //         onPressed: () {
              //           Get.offAll(() => HomeScreen());
              //         },
              //       ),
              //       Text(
              //         widget.title,
              //         style: TextUI.subtitleBlack,
              //       ),
              //       Spacer(),
              //     ],
              //   ),
              Container(
                child: progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container(),
              ),
              Expanded(
                child: SafeArea(
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: Uri.parse(widget.url),
                      headers: {},
                    ),
                    initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          useShouldOverrideUrlLoading: true,
                        ),
                        android: AndroidInAppWebViewOptions(
                          useHybridComposition: true,
                        ),
                        ios: IOSInAppWebViewOptions(
                          allowsInlineMediaPlayback: true,
                        )),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;
                    },
                    onLoadStop: (controller, uri) async {
                      log('url: ${uri.toString()}');
                      // start membership otaqu
                      if (uri.toString() ==
                          '${EnvironmentConfig.baseUrlOtaquMembership()}/membership-signup/activation') {
                        activationUrl = true;
                      }
                      if (uri.toString() ==
                              '${EnvironmentConfig.baseUrlOtaquMembership()}/' &&
                          activationUrl) {
                        try {
                          DigitalIdController.instance
                              .checkDigitalId()
                              .then((value) {
                            DigitalArchiveUIController.to.joinAllCard();
                            activationUrl = false;
                          });
                        } catch (e) {}
                      }
                      // end membership otaqu

                      if ((uri
                                  .toString()
                                  .startsWith("https://dev-web.qoin.id") ||
                              uri
                                  .toString()
                                  .startsWith("https://staging-web.qoin.id")) &&
                          uri.toString().contains("?url=")) {
                        var linkAja = uri.toString().split('?url=').last;
                        debugPrint("Deep link? $linkAja");
                        canLaunch(uri.toString()).then((value) {
                          launch("qoinlinkaja://payment?https://kit.espay.id/index/order/?url=$linkAja",
                                  forceSafariVC: false, forceWebView: false)
                              .then((value) => canBackHome = true);
                        });
                      } else if (uri
                              .toString()
                              .startsWith("https://web.qoin.id") &&
                          uri.toString().contains("?url=")) {
                        var linkAja = uri.toString().split('?url=').last;
                        debugPrint("Deep link? $linkAja");
                        canLaunch(uri.toString()).then((value) {
                          launch("https://kit.espay.id/index/order/?url=$linkAja",
                                  forceSafariVC: false, forceWebView: false)
                              .then((value) => canBackHome = true);
                        });
                      }

                      //prod
                      // if (uri.toString().contains('?url=https://sandbox-kit.espay.id')) {
                      //   var linkAja = uri.toString().split('?url=').last;
                      //   debugPrint("Deep link? $linkAja");
                      //   canLaunch(uri.toString()).then((value) {
                      //     launch("https://kit.espay.id/index/order/?url=$linkAja",
                      //             forceSafariVC: false, forceWebView: false)
                      //         .then((value) => canBackHome = true);
                      //   });
                      // }
                      if (WebUrl.isBackToApp(uri.toString())) {
                        // Get.offNamedUntil("/", (route) => false);
                        // Navigator.pushNamedAndRemoveUntil(context, AppRoute.home, (route) => false);
                        // QoinServices.onSuccessPayment();
                        Get.offAll(() => HomeScreen(),
                            binding: OnloginBindings());
                      }
                    },
                    onProgressChanged:
                        (InAppWebViewController controller, int progress) {
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },
                    onReceivedServerTrustAuthRequest:
                        (InAppWebViewController controller,
                            URLAuthenticationChallenge challenge) async {
                      debugPrint('SSL Error');
                      return ServerTrustAuthResponse(
                          action: ServerTrustAuthResponseAction.PROCEED);
                    },
                    onLoadError: (controller, url, int i, String s) async {
                      debugPrint('CUSTOM_HANDLER: $i, $s');
                      webView!.loadData(data: urlError);
                      if (url.toString() == WebUrl.eci) {
                        return DialogUtils.showPopUp(type: DialogType.problem);
                      }
                      DialogUtils.showPopUp(type: DialogType.problem);
                    },
                    onLoadHttpError: (controller, url, int i, String s) async {
                      debugPrint('CUSTOM_HANDLER: $i, $s');
                      webView!.loadData(data: urlError);
                      if (url.toString() == WebUrl.eci) {
                        return DialogUtils.showPopUp(type: DialogType.problem);
                      }
                      DialogUtils.showPopUp(type: DialogType.problem);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

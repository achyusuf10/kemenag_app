import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/test_page.dart';
import 'package:inisa_app/ui/screen/home/home_screen.dart';
import 'package:inisa_app/ui/screen/onboarding/onboarding_screen.dart';
import 'package:inisa_app/ui/screen/services/peduli_lindungi/peduli_lindungi_screen.dart';
import 'package:qoin_sdk/controllers/controllers_export.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:safe_device/safe_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'inter_module.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool isJailBroken = false;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  Future<void> initPlatformState() async {
    if (!mounted) return;

    try {
      isJailBroken = await SafeDevice.isJailBroken;
    } catch (error) {
      isJailBroken = true;
    }

    setState(() {
      isJailBroken = isJailBroken;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ScreenUtilInit(
      designSize: Size(411, 869),
      // minTextAdapt: true,
      // splitScreenMode: true,
      builder: () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'INISA',
        builder: (context, child) {
          ScreenUtil.setContext(context);
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(data: data.copyWith(textScaleFactor: 1), child: child!);
        },
        navigatorKey: InterModule.navigatorKey,
        theme: InterModule.theme,
        translations: InterModule.translations,
        home: AccountsController.instance.userData == null ? OnboardingScreen() : HomeScreen(),
        // home: PeduliLindungiScreen(),
        locale: HiveData.language != null
            ? InterModule.supportedLang.firstWhere((element) => element.language == HiveData.language).locale
            : InterModule.translations!.locale,
        fallbackLocale: InterModule.translations!.fallbackLocale,
        navigatorObservers: (EnvironmentConfig.flavor == Flavor.Production) ? [observer] : [],
        onInit: () async {
          // await initPlatformState();
          // if (isJailBroken) {
          //   DialogUtils.showRootedPopup();
          // }
        },
      ),
    );
  }
}

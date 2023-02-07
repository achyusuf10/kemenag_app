import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inisa_app/config/app.dart';
import 'package:inisa_app/config/inter_module.dart';
import 'package:qoin_sdk/qoin_sdk.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  String? dsnSentry;

  WidgetsFlutterBinding.ensureInitialized();
  await InterModule.init(Flavor.Production);

  if (Platform.isAndroid) {
    dsnSentry = 'https://71f3df8020d54655986c7d98fd2f0f78@sentry01.loyalto.id/17';
  } else if (Platform.isIOS) {
    dsnSentry = 'https://1eb3e005b7884057a274e25f5963016c@sentry01.loyalto.id/18';
  }

  await SentryFlutter.init(
    (options) {
      options.dsn = (kDebugMode) ? '' : dsnSentry;
      options.tracesSampleRate = 0.2;
    },
    appRunner: () => runApp(App()),
  );
}

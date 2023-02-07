import 'package:flutter/material.dart';
import 'package:inisa_app/config/app.dart';
import 'package:inisa_app/config/inter_module.dart';
import 'package:qoin_sdk/qoin_sdk.dart';

import 'firebase_options.dart';
import 'helper/constans.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InterModule.init(Flavor.Development);
  runApp(App());
}

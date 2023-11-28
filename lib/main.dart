import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import 'app/app.dart';
import 'app/app_environment.dart';
import 'app/di/register_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppEnvironment.load();
  await registerDependencies(kDebugMode ? Environment.dev : Environment.prod);

  GoRouter.optionURLReflectsImperativeAPIs = true;

  runApp(const App());
}

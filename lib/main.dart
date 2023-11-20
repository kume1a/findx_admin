import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'app/app.dart';
import 'app/di/register_dependencies.dart';

void main() {
  registerDependencies(kDebugMode ? Environment.dev : Environment.prod);

  runApp(const App());
}

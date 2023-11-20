import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@module
abstract class AbstractComponentsModule {
  @lazySingleton
  Uuid get uuid => const Uuid();
}

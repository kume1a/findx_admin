import 'package:injectable/injectable.dart';

import 'after_sign_out.dart';

@LazySingleton(as: AfterSignOut)
class AfterSignOutImpl implements AfterSignOut {
  @override
  Future<void> call() async {
    // TODO clear auth data
  }
}

import 'package:findx_dart_client/app_client.dart';

import '../../../shared/ui/toast.dart';

void notifyAdminSignInErr(AdminSignInError f) {
  String msg = switch (f) {
    AdminSignInError.unknown => 'Unknown',
    AdminSignInError.emailOrPasswordInvalid => 'Email or password invalid',
    AdminSignInError.userEmailExists => 'User email exsits',
  };

  showToast(msg);
}

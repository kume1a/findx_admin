import 'package:findx_dart_client/app_client.dart';

import '../../../shared/ui/toast.dart';

void notifyAdminSignInFailure(AdminSignInFailure f) {
  String msg = switch (f) {
    AdminSignInFailure.unknown => 'Unknown',
    AdminSignInFailure.emailOrPasswordInvalid => 'Email or password invalid',
    AdminSignInFailure.userEmailExists => 'User email exsits',
  };

  showToast(msg);
}

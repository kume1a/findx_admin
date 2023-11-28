import 'package:common_models/common_models.dart';

import '../../../shared/ui/toast.dart';

void notifySimpleActionFailure(SimpleActionFailure f) {
  String msg = switch (f) {
    SimpleActionFailure.unknown => 'Unknown error',
    SimpleActionFailure.network => 'Network error',
  };

  showToast(msg);
}

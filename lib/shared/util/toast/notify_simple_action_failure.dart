import 'package:common_models/common_models.dart';

import '../../../shared/ui/toast.dart';

void notifyActionFailure(ActionFailure f) {
  final msg = switch (f) {
    ActionFailure.unknown => 'Unknown error',
    ActionFailure.network => 'Network error',
  };

  showToast(msg);
}

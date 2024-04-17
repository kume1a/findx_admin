import 'package:common_models/common_models.dart';

import '../../../shared/ui/toast.dart';

void notifyNetworkCallError(NetworkCallError f) {
  final msg = switch (f) {
    NetworkCallError.unknown => 'Unknown error',
    NetworkCallError.network => 'Network error',
  };

  showToast(msg);
}

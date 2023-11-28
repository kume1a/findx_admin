import 'package:common_models/common_models.dart';

import '../../../shared/ui/toast.dart';

void notifyFetchFailure(FetchFailure f) {
  String msg = switch (f) {
    FetchFailure.unknown => 'Unknown error',
    FetchFailure.network => 'Network error',
    FetchFailure.server => 'Server error',
  };

  showToast(msg);
}

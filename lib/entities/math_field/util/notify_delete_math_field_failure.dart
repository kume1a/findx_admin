import 'package:findx_dart_client/app_client.dart';

import '../../../shared/ui/toast.dart';

void notifyDeleteMathFieldFailure(DeleteMathFieldFailure f) {
  final msg = switch (f) {
    DeleteMathFieldFailure.unknown => 'Unknown error',
    DeleteMathFieldFailure.mathFieldNotFound => 'Math field not found',
    DeleteMathFieldFailure.mathFieldHasRelations => 'Math field has relations',
  };

  showToast(msg);
}

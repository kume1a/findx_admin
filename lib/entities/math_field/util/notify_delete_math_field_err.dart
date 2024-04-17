import 'package:findx_dart_client/app_client.dart';

import '../../../shared/ui/toast.dart';

void notifyDeleteMathFieldErr(DeleteMathFieldError f) {
  final msg = switch (f) {
    DeleteMathFieldError.unknown => 'Unknown error',
    DeleteMathFieldError.mathFieldNotFound => 'Math field not found',
    DeleteMathFieldError.mathFieldHasRelations => 'Math field has relations',
  };

  showToast(msg);
}

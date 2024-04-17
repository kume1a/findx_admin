import 'package:findx_dart_client/app_client.dart';

import '../../../shared/ui/toast.dart';

void notifyDeleteMathSubFieldErr(DeleteMathSubFieldError f) {
  final msg = switch (f) {
    DeleteMathSubFieldError.unknown => 'Unknown error',
    DeleteMathSubFieldError.mathSubFieldNotFound => 'Math sub field not found',
    DeleteMathSubFieldError.mathSubFieldHasRelations => 'Math sub field has relations',
  };

  showToast(msg);
}

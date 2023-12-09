import 'package:findx_dart_client/app_client.dart';

import '../../../shared/ui/toast.dart';

void notifyDeleteMathSubFieldFailure(DeleteMathSubFieldFailure f) {
  final msg = switch (f) {
    DeleteMathSubFieldFailure.unknown => 'Unknown error',
    DeleteMathSubFieldFailure.mathSubFieldNotFound => 'Math sub field not found',
    DeleteMathSubFieldFailure.mathSubFieldHasRelations => 'Math sub field has relations',
  };

  showToast(msg);
}

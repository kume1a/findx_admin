import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'answer_function_list_filter.freezed.dart';

@freezed
class AnswerFunctionListFilter with _$AnswerFunctionListFilter {
  const factory AnswerFunctionListFilter({
    NumberType? numberType,
    MathSubFieldPageItem? mathSubField,
    required SimpleDataState<DataPage<MathSubFieldPageItem>> mathSubFields,
  }) = _AnswerFunctionListFilter;

  factory AnswerFunctionListFilter.initial() => AnswerFunctionListFilter(
        mathSubFields: SimpleDataState.idle(),
      );
}

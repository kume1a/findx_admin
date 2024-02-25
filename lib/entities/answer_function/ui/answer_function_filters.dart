import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/ui/widgets/dopdown_field.dart';
import '../state/answer_function_list_state.dart';

class AnswerFunctionFilters extends StatelessWidget {
  const AnswerFunctionFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: const _MathSubFieldIdField(),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: context.answerFunctionListCubit.onClearFilter,
          child: const Text('Clear'),
        ),
      ],
    );
  }
}

class _MathSubFieldIdField extends StatelessWidget {
  const _MathSubFieldIdField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnswerFunctionListCubit, AnswerFunctionListState>(
      buildWhen: (prev, curr) => prev.filter != curr.filter,
      builder: (_, state) {
        return DropdownField<MathSubFieldPageItem>(
          hintText: 'Math sub field',
          validateForm: false,
          data: state.filter?.mathSubFields ?? SimpleDataState.idle(),
          currentValue: state.filter?.mathSubField,
          itemBuilder: (e) => DropdownMenuItem(value: e, child: Text(e.name)),
          onChanged: context.answerFunctionListCubit.onMathSubFieldChanged,
        );
      },
    );
  }
}

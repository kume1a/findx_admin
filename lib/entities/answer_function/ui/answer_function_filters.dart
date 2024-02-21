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
    return const Row(
      children: [
        _NumberTypeField(),
      ],
    );
  }
}

class _NumberTypeField extends StatelessWidget {
  const _NumberTypeField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnswerFunctionListCubit, AnswerFunctionListState>(
      buildWhen: (prev, curr) => prev.filter != curr.filter,
      builder: (_, state) {
        return DropdownField<NumberType>(
          hintText: 'Number type',
          validateForm: false,
          data: SimpleDataState.success(
            DataPage(
              items: [NumberType.INTEGER, NumberType.DECIMAL],
              count: 2,
            ),
          ),
          currentValue: state.filter?.numberType,
          itemBuilder: (e) => DropdownMenuItem(value: e, child: Text(e.name)),
          onChanged: context.answerFunctionListCubit.onNumberTypeChanged,
        );
      },
    );
  }
}

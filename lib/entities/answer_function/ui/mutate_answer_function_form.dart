import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/i18n/failure_i18n_extensions.dart';
import '../../../shared/ui/widgets/dopdown_field.dart';
import '../../../shared/ui/widgets/loading_text_button.dart';
import '../state/mutate_answer_function_form_state.dart';

class MutateAnswerFunctionForm extends StatelessWidget {
  const MutateAnswerFunctionForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MutateAnswerFunctionFormCubit, MutateAnswerFunctionFormState>(
      buildWhen: (previous, current) =>
          previous.validateForm != current.validateForm || previous.isSubmitting != current.isSubmitting,
      builder: (_, state) {
        return Form(
          autovalidateMode: state.validateForm ? AutovalidateMode.always : AutovalidateMode.disabled,
          child: ListView(
            children: [
              const _MathSubFieldIdField(),
              const SizedBox(height: 20),
              BlocBuilder<MutateAnswerFunctionFormCubit, MutateAnswerFunctionFormState>(
                buildWhen: (prev, curr) => prev.numberType != curr.numberType,
                builder: (_, dropdownState) {
                  return DropdownField<NumberType>(
                    hintText: 'Number type',
                    validateForm: state.validateForm,
                    data: SimpleDataState.success(
                      DataPage(
                        items: [NumberType.INTEGER, NumberType.DECIMAL],
                        count: 2,
                      ),
                    ),
                    currentValue: dropdownState.numberType,
                    itemBuilder: (e) => DropdownMenuItem(value: e, child: Text(e.name)),
                    onChanged: context.mutateAnswerFunctionFormCubit.onNumberTypeChanged,
                  );
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: context.mutateAnswerFunctionFormCubit.weightFieldController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Weight'),
                onChanged: context.mutateAnswerFunctionFormCubit.onWeightChanged,
                validator: (_) => context.mutateAnswerFunctionFormCubit.state.weight.translateFailure(),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: context.mutateAnswerFunctionFormCubit.funcFieldController,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(hintText: 'Func'),
                onChanged: context.mutateAnswerFunctionFormCubit.onFuncChanged,
                validator: (_) => context.mutateAnswerFunctionFormCubit.state.func.translateFailure(),
                minLines: 20,
                maxLines: 20,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: context.mutateAnswerFunctionFormCubit.conditionFieldController,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(hintText: 'Condition'),
                onChanged: context.mutateAnswerFunctionFormCubit.onConditionChanged,
                minLines: 10,
                maxLines: 20,
              ),
              const SizedBox(height: 32),
              LoadingTextButton(
                onPressed: context.mutateAnswerFunctionFormCubit.onSubmit,
                isLoading: state.isSubmitting,
                label: 'Submit',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MathSubFieldIdField extends StatelessWidget {
  const _MathSubFieldIdField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MutateAnswerFunctionFormCubit, MutateAnswerFunctionFormState>(
      buildWhen: (prev, curr) =>
          prev.mathSubFields != curr.mathSubFields ||
          prev.mathSubField != curr.mathSubField ||
          prev.validateForm != curr.validateForm,
      builder: (_, state) {
        return DropdownField(
          hintText: 'Math sub field id',
          validateForm: state.validateForm,
          data: state.mathSubFields,
          currentValue: state.mathSubField,
          itemBuilder: (e) => DropdownMenuItem(value: e, child: Text(e.name)),
          onChanged: context.mutateAnswerFunctionFormCubit.onMathSubFieldChanged,
        );
      },
    );
  }
}

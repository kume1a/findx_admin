import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../shared/ui/widgets/entity_table.dart';
import '../state/answer_function_list_state.dart';
import 'answer_function_filters.dart';

class AnswerFunctionTable extends StatelessWidget {
  const AnswerFunctionTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnswerFunctionListCubit, AnswerFunctionListState>(
      builder: (_, state) {
        return EntityTable(
          state.data,
          filters: const AnswerFunctionFilters(),
          onLoadMorePressed: context.answerFunctionListCubit.fetchNextPage,
          onUpdate: context.answerFunctionListCubit.onUpdatePressed,
          onDelete: context.answerFunctionListCubit.onDeletePressed,
          actionsPosition: ActionsPosition.start,
          columns: const [
            DataColumn(label: Text('Id')),
            DataColumn(label: Text('Math sub field')),
            DataColumn(label: Text('Weight')),
            DataColumn(label: Text('Func')),
            DataColumn(label: Text('Condition')),
            DataColumn(label: Text('Number Type')),
            DataColumn(label: Text('CreatedAt')),
          ],
          cellsBuilder: (e) {
            final weightNum = double.tryParse(e.weight);
            final formattedWeight = weightNum != null ? weightNum.toStringAsFixed(2) : e.weight;

            return [
              DataCell(Text(e.id)),
              DataCell(Text(e.mathSubField?.name ?? '-')),
              DataCell(Text(formattedWeight)),
              DataCell(Text(e.func)),
              DataCell(Text(e.condition ?? '-')),
              DataCell(Text(e.numberType.name)),
              DataCell(Text(DateFormat('MMM dd, yyyy HH:mm:ss').format(e.createdAt))),
            ];
          },
        );
      },
    );
  }
}

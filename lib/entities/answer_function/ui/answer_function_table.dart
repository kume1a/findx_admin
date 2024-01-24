import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../shared/ui/widgets/entity_table.dart';
import '../state/answer_function_list_state.dart';

class AnswerFunctionTable extends StatelessWidget {
  const AnswerFunctionTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnswerFunctionListCubit, AnswerFunctionListState>(
      builder: (_, state) {
        return EntityTable(
          state,
          onLoadMorePressed: context.answerFunctionListCubit.fetchNextPage,
          onUpdate: context.answerFunctionListCubit.onUpdatePressed,
          onDelete: context.answerFunctionListCubit.onDeletePressed,
          columns: const [
            DataColumn(label: Text('Id')),
            DataColumn(label: Text('CreatedAt')),
            DataColumn(label: Text('Func')),
            DataColumn(label: Text('Condition')),
            DataColumn(label: Text('Weight')),
          ],
          cellsBuilder: (e) => [
            DataCell(Text(e.id)),
            DataCell(Text(DateFormat('MMM dd, yyyy HH:mm:ss').format(e.createdAt))),
            DataCell(Text(e.func)),
            DataCell(Text(e.condition ?? '-')),
            DataCell(Text(e.weight)),
          ],
        );
      },
    );
  }
}

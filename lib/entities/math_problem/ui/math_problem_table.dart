import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../shared/ui/widgets/entity_table.dart';
import '../state/math_problem_list_state.dart';

class MathProblemTable extends StatelessWidget {
  const MathProblemTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MathProblemListCubit, MathProblemListState>(
      builder: (_, state) {
        return EntityTable(
          state,
          onLoadMorePressed: context.mathProblemListCubit.fetchNextPage,
          columns: const [
            DataColumn(label: Text('Id')),
            DataColumn(label: Text('Difficulty')),
            DataColumn(label: Text('Text')),
            DataColumn(label: Text('Tex')),
            DataColumn(label: Text('CreatedAt')),
          ],
          cellsBuilder: (e) => [
            DataCell(Text(e.id)),
            DataCell(Text(e.difficulty.toString())),
            DataCell(
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Text(e.text ?? '-'),
              ),
            ),
            DataCell(
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Text(e.tex ?? '-'),
              ),
            ),
            DataCell(Text(DateFormat('MMM dd, yyyy HH:mm:ss').format(e.createdAt))),
          ],
        );
      },
    );
  }
}

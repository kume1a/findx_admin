import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../shared/ui/widgets/entity_table.dart';
import '../../../shared/util/assemble_media_url.dart';
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
          onUpdate: context.mathProblemListCubit.onUpdatePressed,
          onDelete: context.mathProblemListCubit.onDeletePressed,
          columns: const [
            DataColumn(label: Text('Id')),
            DataColumn(label: Text('Difficulty')),
            DataColumn(label: Text('MathField')),
            DataColumn(label: Text('MathSubFIeld')),
            DataColumn(label: Text('CreatedAt')),
          ],
          cellsBuilder: (e) => [
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(e.id),
                  for (final image in e.images ?? [])
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: SafeImage(
                        width: 100,
                        height: 100,
                        borderRadius: BorderRadius.circular(4),
                        url: assembleResourceUrl(image.path),
                      ),
                    ),
                ],
              ),
            ),
            DataCell(Text(e.difficulty.toString())),
            DataCell(
              Text(e.mathField?.name ?? '-'),
            ),
            DataCell(
              Text(e.mathSubField?.name ?? '-'),
            ),
            DataCell(Text(DateFormat('MMM dd, yyyy HH:mm:ss').format(e.createdAt))),
          ],
        );
      },
    );
  }
}

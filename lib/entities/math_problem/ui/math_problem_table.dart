import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../shared/ui/widgets/entity_table.dart';
import '../../../shared/ui/widgets/expandable_image.dart';
import '../../../shared/ui/widgets/scrollable_tex.dart';
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
            DataColumn(label: Text('Tex')),
            DataColumn(label: Text('Batch name')),
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
                  const SizedBox(width: 10),
                  for (final image in e.images ?? [])
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ExpandableImage(
                        width: 80,
                        height: 80,
                        borderRadius: BorderRadius.circular(4),
                        url: assembleResourceUrl(image.path),
                      ),
                    ),
                ],
              ),
            ),
            DataCell(Text(e.difficulty.toString())),
            DataCell(
              e.tex != null
                  ? SizedBox(
                      height: 80,
                      width: 300,
                      child: ScrollableTex(
                        e.tex!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    )
                  : const Text('-'),
            ),
            DataCell(
              Text(e.generatedBatchName ?? '-'),
            ),
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

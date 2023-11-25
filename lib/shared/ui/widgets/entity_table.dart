import 'package:common_models/common_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/ui/color.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../../../shared/values/assets.dart';

typedef OnEntityAction<T> = void Function(T entity);
typedef EntityCellsBuilder<T> = List<DataCell> Function(T entity);

class EntityTable<T> extends StatelessWidget {
  const EntityTable(
    this.dataState, {
    super.key,
    required this.columns,
    required this.cellsBuilder,
    this.onView,
    this.onUpdate,
    this.onDelete,
  });

  final DataState<FetchFailure, DataPage<T>> dataState;

  final List<DataColumn> columns;
  final EntityCellsBuilder<T> cellsBuilder;

  final OnEntityAction? onView;
  final OnEntityAction? onUpdate;
  final OnEntityAction? onDelete;

  @override
  Widget build(BuildContext context) {
    return dataState.maybeWhen(
      success: (data) => _Success<T>(
        data.items,
        columns: columns,
        cellsBuilder: cellsBuilder,
        onView: onView,
        onUpdate: onUpdate,
        onDelete: onDelete,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _Success<T> extends StatelessWidget {
  const _Success(
    this.data, {
    required this.columns,
    required this.cellsBuilder,
    this.onView,
    this.onUpdate,
    this.onDelete,
  });

  final List<T> data;

  final List<DataColumn> columns;
  final EntityCellsBuilder<T> cellsBuilder;

  final OnEntityAction? onView;
  final OnEntityAction? onUpdate;
  final OnEntityAction? onDelete;

  bool get _isAnyActionAvailable => onView != null || onUpdate != null || onDelete != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: DataTable(
        dividerThickness: 0,
        headingTextStyle: TextStyle(
          color: theme.appThemeExtension?.elSecondary,
        ),
        dataRowMaxHeight: 80,
        horizontalMargin: 0,
        columns: [
          ...columns,
          if (_isAnyActionAvailable) const DataColumn(label: SizedBox.shrink()),
        ],
        rows: data.map((e) => _dataRow(e, context, theme)).toList(),
      ),
    );
  }

  DataRow _dataRow(
    T item,
    BuildContext context,
    ThemeData theme,
  ) {
    final rows = cellsBuilder(item);

    return DataRow(
      cells: [
        ...rows,
        if (_isAnyActionAvailable)
          DataCell(
            Row(
              children: [
                if (onView != null)
                  _ActionButton(
                    assetName: Assets.iconEye,
                    onPressed: () => onView!(item),
                  ),
                if (onUpdate != null)
                  _ActionButton(
                    assetName: Assets.iconPencil,
                    onPressed: () => onUpdate!(item),
                  ),
                if (onDelete != null)
                  _DeleteButton(
                    onPressed: () => onDelete!(item),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.assetName,
    required this.onPressed,
  });

  final String assetName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      color: theme.colorScheme.primary,
      icon: SvgPicture.asset(
        assetName,
        width: 18,
        height: 18,
        colorFilter: svgColor(theme.colorScheme.primary),
      ),
    );
  }
}

class _DeleteButton extends HookWidget {
  const _DeleteButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isMounted = useIsMounted();

    return _ActionButton(
      assetName: Assets.iconTrashCan,
      onPressed: () async {
        final bool didConfirm = await showDialog(
          anchorPoint: const Offset(0, .4),
          context: context,
          builder: (_) => const _ConfirmDeleteDialog(),
        );

        if (!isMounted() || !didConfirm) {
          return;
        }

        onPressed();
      },
    );
  }
}

class _ConfirmDeleteDialog extends StatelessWidget {
  const _ConfirmDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      actionsPadding: const EdgeInsets.all(20),
      content: const Text('Are you sure you want to delete?\nConfirm to delete the row'),
      actions: [
        ElevatedButton(
          onPressed: () => context.pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => context.pop(true),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

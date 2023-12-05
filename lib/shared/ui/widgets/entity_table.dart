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
    required this.onLoadMorePressed,
    this.onView,
    this.onUpdate,
    this.onDelete,
  });

  final DataState<FetchFailure, DataPage<T>> dataState;

  final List<DataColumn> columns;
  final EntityCellsBuilder<T> cellsBuilder;

  final VoidCallback onLoadMorePressed;

  final OnEntityAction<T>? onView;
  final OnEntityAction<T>? onUpdate;
  final OnEntityAction<T>? onDelete;

  @override
  Widget build(BuildContext context) {
    return dataState.maybeWhen(
      success: (data) => _Success<T>(
        data,
        columns: columns,
        cellsBuilder: cellsBuilder,
        onLoadMorePressed: onLoadMorePressed,
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
    required this.onLoadMorePressed,
    this.onView,
    this.onUpdate,
    this.onDelete,
  });

  final DataPage<T> data;

  final List<DataColumn> columns;
  final EntityCellsBuilder<T> cellsBuilder;

  final VoidCallback onLoadMorePressed;

  final OnEntityAction<T>? onView;
  final OnEntityAction<T>? onUpdate;
  final OnEntityAction<T>? onDelete;

  bool get _isAnyActionAvailable => onView != null || onUpdate != null || onDelete != null;

  bool get _canLoadMore => data.items.length < data.count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Total: ${data.count}',
              style: TextStyle(color: theme.appThemeExtension?.elSecondary),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
              rows: data.items.map((e) => _dataRow(e, context, theme)).toList(),
            ),
          ),
          if (_canLoadMore) _LoadMoreButton(onPressed: onLoadMorePressed)
        ],
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

class _LoadMoreButton extends StatelessWidget {
  const _LoadMoreButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          onPressed: onPressed,
          child: const Text('Load more'),
        ),
      ),
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
  const _ConfirmDeleteDialog();

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

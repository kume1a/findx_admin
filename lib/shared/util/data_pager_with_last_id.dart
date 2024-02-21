import 'package:common_models/common_models.dart';

typedef DataPageProvider<FAILURE, ITEM, FILTER> = Future<Either<FAILURE, DataPage<ITEM>>?> Function(
  String? lastId,
  FILTER? filter,
);

class DataPagerWithLastId<FAILURE, ITEM, FILTER> {
  DataPagerWithLastId({
    required this.dataPageProvider,
    required this.idSelector,
    required this.nullDataFailure,
  });

  DataPageProvider<FAILURE, ITEM, FILTER> dataPageProvider;
  String Function(ITEM item) idSelector;
  FAILURE nullDataFailure;

  bool _fetching = false;

  DataPage<ITEM> _data = DataPage<ITEM>.empty();

  void setData(DataPage<ITEM> data) {
    _data = data;
  }

  void refresh() {
    _data = DataPage<ITEM>.empty();
  }

  Stream<DataState<FAILURE, DataPage<ITEM>>> fetchNextPage(
    FILTER? filter,
  ) async* {
    if (_fetching) {
      return;
    }

    _fetching = true;

    if (_data.items.isEmpty) {
      yield DataState<FAILURE, DataPage<ITEM>>.loading();
    }

    final lastItem = _data.items.lastOrNull;
    final lastId = lastItem != null ? idSelector(lastItem) : null;
    final result = await dataPageProvider(lastId, filter);

    if (result == null) {
      _fetching = false;
      yield DataState.failure(nullDataFailure);
      return;
    }

    if (result.isLeft) {
      yield DataState<FAILURE, DataPage<ITEM>>.failure(result.leftOrThrow, _data);
    } else {
      final DataPage<ITEM> r = result.rightOrThrow;

      if (r.items.isNotEmpty) {
        r.items.insertAll(0, _data.items);

        _data = _data.copyWith(count: r.count, items: r.items);
      }

      yield DataState<FAILURE, DataPage<ITEM>>.success(_data);
    }

    _fetching = false;
  }
}

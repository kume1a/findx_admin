import 'package:common_models/common_models.dart';

class DataPagerWithLastId<F, T> {
  DataPagerWithLastId({
    required this.dataPageProvider,
    required this.idSelector,
    required this.nullDataFailure,
  });

  Future<Either<F, DataPage<T>>?> Function(String? lastId) dataPageProvider;
  String Function(T item) idSelector;
  F nullDataFailure;

  bool _fetching = false;

  DataPage<T> _data = DataPage<T>.empty();

  void setData(DataPage<T> data) {
    _data = data;
  }

  void refresh() {
    _data = DataPage<T>.empty();
  }

  Stream<DataState<F, DataPage<T>>> fetchNextPage() async* {
    if (_fetching) {
      return;
    }

    _fetching = true;

    if (_data.items.isEmpty) {
      yield DataState<F, DataPage<T>>.loading();
    }

    final lastItem = _data.items.lastOrNull;
    final lastId = lastItem != null ? idSelector(lastItem) : null;
    final result = await dataPageProvider(lastId);

    if (result == null) {
      _fetching = false;
      yield DataState.failure(nullDataFailure);
      return;
    }

    if (result.isLeft) {
      yield DataState<F, DataPage<T>>.failure(result.leftOrThrow, _data);
    } else {
      final DataPage<T> r = result.rightOrThrow;

      if (r.items.isNotEmpty) {
        r.items.insertAll(0, _data.items);

        _data = _data.copyWith(count: r.count, items: r.items);
      }

      yield DataState<F, DataPage<T>>.success(_data);
    }

    _fetching = false;
  }
}

import 'package:common_models/common_models.dart';

class DataPagerWithPage<F extends Object?, T extends Object?> {
  DataPagerWithPage({
    required this.dataPageProvider,
  });

  Future<Either<F, DataPage<T>>> Function(int page) dataPageProvider;

  int _page = 1;
  bool _fetching = false;

  DataPage<T> _data = DataPage<T>.empty();

  void setData(DataPage<T> data) {
    _data = data;
  }

  void refresh() {
    _page = 1;
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

    final Either<F, DataPage<T>> result = await dataPageProvider(_page);

    if (result.isLeft) {
      yield DataState<F, DataPage<T>>.failure(result.leftOrThrow, _data);
    } else {
      final DataPage<T> r = result.rightOrThrow;

      if (r.items.isNotEmpty) {
        r.items.insertAll(0, _data.items);

        _data = _data.copyWith(count: r.count, items: r.items);
      }

      _page++;

      yield DataState<F, DataPage<T>>.success(_data);
    }

    _fetching = false;
  }
}

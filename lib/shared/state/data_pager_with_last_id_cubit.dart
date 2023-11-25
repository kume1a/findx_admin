import 'package:common_models/common_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../util/data_pager_with_last_id.dart';

abstract base class DataPagerWithLastIdCubit<F, T> extends Cubit<DataState<F, DataPage<T>>> {
  DataPagerWithLastIdCubit() : super(DataState<F, DataPage<T>>.idle()) {
    _dataPager = DataPagerWithLastId<F, T>(
      dataPageProvider: provideDataPage,
      idSelector: idSelector,
    );
  }

  late final DataPagerWithLastId<F, T> _dataPager;

  @protected
  Future<Either<F, DataPage<T>>?> provideDataPage(String? lastId);

  @protected
  String idSelector(T item);

  @nonVirtual
  Future<void> fetchNextPage() async => _fetchNextPage();

  @mustCallSuper
  Future<void> onRefresh() async {
    _dataPager.refresh();

    return _fetchNextPage();
  }

  @override
  void emit(DataState<F, DataPage<T>> state) {
    final DataPage<T> data = state.maybeWhen(
      success: (data) => data,
      failure: (_, data) => data ?? DataPage.empty(),
      orElse: () => DataPage.empty(),
    );

    _dataPager.setData(data);

    if (!isClosed) {
      super.emit(state);
    }
  }

  @nonVirtual
  Future<void> _fetchNextPage() async {
    await for (final DataState<F, DataPage<T>> s in _dataPager.fetchNextPage()) {
      if (!isClosed) {
        super.emit(s);
      }
    }
  }
}

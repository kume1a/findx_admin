import 'package:common_models/common_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../util/data_pager_with_page.dart';

abstract base class DataPagerWithPageCubit<F, T> extends Cubit<DataState<F, DataPage<T>>> {
  DataPagerWithPageCubit() : super(DataState<F, DataPage<T>>.idle()) {
    _dataPager = DataPagerWithPage<F, T>(dataPageProvider: provideDataPage);
  }

  late final DataPagerWithPage<F, T> _dataPager;

  @protected
  Future<Either<F, DataPage<T>>> provideDataPage(int page);

  @mustCallSuper
  Future<void> init([Object? args]) async => _fetchNextPage();

  @nonVirtual
  Future<void> fetchNextPage() async => _fetchNextPage();

  @nonVirtual
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

    if (data == DataPage.empty()) {
      _dataPager.refresh();
    } else {
      _dataPager.setData(data);
    }

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

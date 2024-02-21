import 'package:common_models/common_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../util/data_pager_with_last_id.dart';

final class FilteredDataPageState<FAILURE, ITEM, FILTER> {
  FilteredDataPageState({
    required this.data,
    required this.filter,
  });

  factory FilteredDataPageState.initial() {
    return FilteredDataPageState(
      data: DataState.idle(),
      filter: null,
    );
  }

  final DataState<FAILURE, DataPage<ITEM>> data;
  final FILTER? filter;

  FilteredDataPageState<FAILURE, ITEM, FILTER> copyWith({
    DataState<FAILURE, DataPage<ITEM>>? data,
    FILTER? filter,
  }) {
    return FilteredDataPageState(
      data: data ?? this.data,
      filter: filter ?? this.filter,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is FilteredDataPageState<FAILURE, ITEM, FILTER> &&
        other.data == data &&
        other.filter == filter;
  }

  @override
  int get hashCode => Object.hashAll([data.hashCode ^ filter.hashCode]);
}

abstract base class FilteredDataPagerWithLastIdCubit<FAILURE, ITEM, FILTER>
    extends Cubit<FilteredDataPageState<FAILURE, ITEM, FILTER>> {
  FilteredDataPagerWithLastIdCubit({
    required FAILURE nullDataFailure,
  }) : super(FilteredDataPageState.initial()) {
    _dataPager = DataPagerWithLastId<FAILURE, ITEM, FILTER>(
      dataPageProvider: provideDataPage,
      idSelector: idSelector,
      nullDataFailure: nullDataFailure,
    );
  }

  late final DataPagerWithLastId<FAILURE, ITEM, FILTER> _dataPager;

  @protected
  Future<Either<FAILURE, DataPage<ITEM>>?> provideDataPage(
    String? lastId,
    FILTER? filter,
  );

  @protected
  String idSelector(ITEM item);

  @nonVirtual
  Future<void> fetchNextPage() async => _fetchNextPage();

  @mustCallSuper
  Future<void> onRefresh() async {
    _dataPager.refresh();

    return _fetchNextPage();
  }

  @override
  void emit(FilteredDataPageState<FAILURE, ITEM, FILTER> state) {
    final DataPage<ITEM> data = state.data.maybeWhen(
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
    await for (final DataState<FAILURE, DataPage<ITEM>> s in _dataPager.fetchNextPage(state.filter)) {
      if (!isClosed) {
        super.emit(state.copyWith(data: s));
      }
    }
  }
}

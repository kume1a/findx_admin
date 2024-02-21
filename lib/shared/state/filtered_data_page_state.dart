import 'package:common_models/common_models.dart';

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

  @override
  String toString() {
    return 'FilteredDataPageState(data: $data, filter: $filter)';
  }
}

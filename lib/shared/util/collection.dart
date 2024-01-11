class PartitionedList<T> {
  PartitionedList({
    required this.pass,
    required this.fail,
  });

  final List<T> pass;
  final List<T> fail;
}

extension ListX<T> on List<T> {
  PartitionedList<T> partition(
    bool Function(T item) predicate,
  ) {
    final pass = <T>[];
    final fail = <T>[];

    for (final item in this) {
      if (predicate(item)) {
        pass.add(item);
        continue;
      }

      fail.add(item);
    }

    return PartitionedList(pass: pass, fail: fail);
  }
}

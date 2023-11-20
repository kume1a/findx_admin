abstract interface class Provider<T> {
  T get();
}

abstract interface class AsyncProvider<T> {
  Future<T> get();
}

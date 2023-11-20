abstract interface class Factory<T> {
  T newInstance();
}

abstract interface class AsyncFactory<T> {
  Future<T> newInstance();
}
